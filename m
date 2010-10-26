Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab0JZMPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:15:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:51706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478Ab0JZMPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:15:01 -0400
Message-ID: <4CC6C62F.1000804@kernel.org>
Date: Tue, 26 Oct 2010 14:14:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] MN10300: Fix the PERCPU() alignment to allow for workqueues
References: <4CC69B22.2050708@kernel.org> <20101025224111.7798.38960.stgit@warthog.procyon.org.uk> <12101.1288088542@redhat.com>
In-Reply-To: <12101.1288088542@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 12:14:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/26/2010 12:22 PM, David Howells wrote:
>> Can you please double check the bug doesn't trigger with the section
>> alignment updated?
> 
> It can be made to trigger consistently without the change, and simply updating
> that alignment makes it go away.  It seems unlikely that it's affecting
> subsequent stuff in the final link since the PERCPU() is immediately followed
> by an alignment to PAGE_SIZE:
> 
> 	PERCPU(PAGE_SIZE)
> 	. = ALIGN(PAGE_SIZE);
> 
> I've attached the kernel log below.  CPUID is 0 indicating this happened on
> CPU 0 (the boot CPU).

Ah, I see now.  The actual areas are properly aligned but the percpu
address is determined as offset from the percpu output section base so
the percpu pointers in the percpu address space end up misaligned with
the actual kernel addresses and the code in workqueue checks the
address in percpu AS, so, yeap, it's caused by the misalignment of the
percpu section.  Except for triggering BUG_ON(), it shouldn't cause a
real issue tho as work_data points to the translated addresses in the
kernel AS for specific CPU.  Needs to be fixed anyways.

>> That said, I think it might be better to just remove the alignment parameter
>> from the macro and force align to PAGE_SIZE.
> 
> That's not necessarily good.  Two arches to note:
> 
> 	arch/x86/kernel/vmlinux.lds.S:  PERCPU(THREAD_SIZE)

I don't think the current percpu allocator honors alignment larger
than PAGE_SIZE no matter how large the alignment for the percpu output
section is.  I'll look into it deeper but I think we might just have
been lucky and the alignment somehow didn't bite us yet.  The only
user of THREAD_SIZE mask at this point seems to be cpu_init().  Maybe
we can remove this requirement.  I'll look into it.

> which may be bigger than PAGE_SIZE and:
> 
> 	arch/frv/kernel/vmlinux.lds.S:  PERCPU(4096)
> 
> FRV's page size is 16KB, so on that we really don't want it to be PAGE_SIZE.

Why not?  It's in the init section which will be freed anyway and with
the kernel image compression it's not even gonna add any noticeable
amount to the kernel image size.  There isn't any benefit in using
anything smaller than PAGE_SIZE for alignment.  Also, percpu allocator
guarantees alignment requirement upto PAGE_SIZE is honored.  If the
output section uses smaller alignment, the percpu AS will end up being
misaligned.

Thanks.

-- 
tejun
