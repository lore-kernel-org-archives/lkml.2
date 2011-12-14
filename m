Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab1LNQEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:04:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45832 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab1LNQD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:03:59 -0500
Message-ID: <4EE8C8EA.9070207@kernel.dk>
Date: Wed, 14 Dec 2011 17:03:54 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Nate Custer <nate@cpanel.net>,
        kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: kvm deadlock
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net> <20111214122511.GD18317@amt.cnet> <4EE8A7ED.7060703@redhat.com>
In-Reply-To: <4EE8A7ED.7060703@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-14 14:43, Avi Kivity wrote:
> On 12/14/2011 02:25 PM, Marcelo Tosatti wrote:
>> On Mon, Dec 05, 2011 at 04:48:16PM -0600, Nate Custer wrote:
>>> Hello,
>>>
>>> I am struggling with repeatable full hardware locks when running 8-12 KVM vms. At some point before the hard lock I get a inconsistent lock state warning. An example of this can be found here:
>>>
>>> http://pastebin.com/8wKhgE2C
>>>
>>> After that the server continues to run for a while and then starts its death spiral. When it reaches that point it fails to log anything further to the disk, but by attaching a console I have been able to get a stack trace documenting the final implosion:
>>>
>>> http://pastebin.com/PbcN76bd
>>>
>>> All of the cores end up hung and the server stops responding to all input, including SysRq commands. 
>>>
>>> I have seen this behavior on two machines (dual E5606 running Fedora 16) both passed cpuburnin testing and memtest86 scans without error. 
>>>
>>> I have reproduced the crash and stack traces from a Fedora debugging kernel - 3.1.2-1 and with a vanilla 3.1.4 kernel.
>>
>> Busted hardware, apparently. Can you reproduce these issues with the
>> same workload on different hardware?
> 
> I don't think it's hardware related.  The second trace (in the first
> paste) is called during swap, so GFP_FS is set.  The first one is not,
> so GFP_FS is clear.  Lockdep is worried about the following scenario:
> 
>   acpi_early_init() is called
>   calls pcpu_alloc(), which takes pcpu_alloc_mutex
>   eventually, calls kmalloc(), or some other allocation function
>   no memory, so swap
>   call try_to_free_pages()
>   submit_bio()
>   blk_throtl_bio()
>   blkio_alloc_blkg_stats()
>   alloc_percpu()
>   pcpu_alloc(), which takes pcpu_alloc_mutex
>   deadlock
> 
> It's a little unlikely that acpi_early_init() will OOM, but lockdep
> doesn't know that.  Other callers of pcpu_alloc() could trigger the same
> thing.
> 
> When lockdep says
> 
> [ 5839.924953] other info that might help us debug this:
> [ 5839.925396]  Possible unsafe locking scenario:
> [ 5839.925397]
> [ 5839.925840]        CPU0
> [ 5839.926063]        ----
> [ 5839.926287]   lock(pcpu_alloc_mutex);
> [ 5839.926533]   <Interrupt>
> [ 5839.926756]     lock(pcpu_alloc_mutex);
> [ 5839.926986]
> 
> It really means
> 
>    <swap, set GFP_FS>
> 
> GFP_FS simply marks the beginning of a nested, unrelated context that
> uses the same thread, just like an interrupt.  Kudos to lockdep for
> catching that.
> 
> I think the allocation in blkio_alloc_blkg_stats() should be moved out
> of the I/O path into some init function. Copying Jens.

That's completely buggy, basically you end up with a GFP_KERNEL
allocation from the IO submit path. Vivek, per_cpu data needs to be set
up at init time. You can't allocate it dynamically off the IO path.

-- 
Jens Axboe

