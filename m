Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2FSILd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:11:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab2FSILa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:11:30 -0400
Message-ID: <4FE0342E.3070004@redhat.com>
Date: Tue, 19 Jun 2012 11:11:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] KVM: introduce readonly memslot
References: <4FD6ADA6.40008@linux.vnet.ibm.com> <4FD6AE3B.9020508@linux.vnet.ibm.com> <20120616021150.GA3870@amt.cnet> <4FDEF9D2.3000909@redhat.com> <20120618202505.GA3650@amt.cnet>
In-Reply-To: <20120618202505.GA3650@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 11:25 PM, Marcelo Tosatti wrote:
> On Mon, Jun 18, 2012 at 12:50:10PM +0300, Avi Kivity wrote:
>> On 06/16/2012 05:11 AM, Marcelo Tosatti wrote:
>> > 
>> > Can you introduce a separate exit reason, say KVM_EXIT_READ_FAULT, with
>> > information about the fault?
>> 
>> I think you mean WRITE_FAULT.  
> 
> Yes.
> 
>> But what's wrong with the normal mmio exit?
> 
> It is necessary to perform an address->mmio region lookup, to verify
> whether the mmio exit is due to an actual mmio (no memory slot) or from
> a write access to a write protected slot. That information is readily
> available in the kernel but is lost if the mmio exit is used to transmit 
> the information.

For qemu it doesn't matter, but other userspaces might need it.  Can we
add it to the mmio exit reason as extra data?  Only present if the CAP
is available.

> Moreover, i'd argue the uses are different: one is an mmio emulation
> exit, the other is more like handling a pagefault in qemu.

It is not.  A pagefault is handled by fixing and retrying (fault).  MMIO
emulation is done by userspace instead of the kernel or guest (trap).
Here we're not fixing anything (say by marking the page writeable; the
slot is readonly, not the page (as is the case with ksm).

Qemu's ROM and ROMD behaviour follow this (discard access for ROM,
emualte for ROMD).

There might be value in implementing user visible write protection, for
example to implement distributed shared memory or postcopy migration.
But as long as per page protection requires separate VMAs it is not
practical (and is unlikely to perform well anyway).

> 
>> > Then perform this exit only if userspace allows it by explicit enable, 
>> > and by default have the exit_read_fault handler jump to the mmio
>> > handler. 
>> 
>> 
>> I don't get this.
> 
> 
> CAN USERSPACE HANDLE WRITE FAULT EXITS?
> YES: WRITE FAULT EXIT.
> NO: MMIO EXIT.
> 
> But then again userspace won't set read-only slots if it does not know
> about them. So it is not necessary.
> 

Okay, okay, don't shout.

-- 
error compiling committee.c: too many arguments to function


