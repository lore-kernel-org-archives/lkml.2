Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2ARFeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 00:34:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38865 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab2ARFem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 00:34:42 -0500
Message-ID: <4F1659ED.6030403@gmail.com>
Date: Tue, 17 Jan 2012 22:34:37 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: improve trace events of vmexit/mmio/ioport
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EE9B.9020901@linux.vnet.ibm.com> <4F13EFFB.90706@redhat.com> <4F14DCBB.3060207@linux.vnet.ibm.com> <20120117115558.GB17420@amt.cnet> <4F15B08D.5090000@gmail.com> <4F162F28.4010001@linux.vnet.ibm.com>
In-Reply-To: <4F162F28.4010001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 07:32 PM, Xiao Guangrong wrote:
>> There is an ongoing 'discussion' about modifying existing tracepoints
>> which your proposed patch violates. This is the start of it:
>>
> 
> 
> Hmm, i think we can still add completed tracepoints in the new version kernel,
> if old version kernel is used, we can fall back to use kvm_entry instead?

Yes, new ones are ok. I was referring to the tracepoints like kvm_pio
where you added the vcpu_id. And it is not really necessary: with
kvm_entry tracepoints it is easy to correlate vcpu to tid and even
without you still get thread base samples so events happening on a
thread are all the sample vcpu (even if you don't know whether that is
vcpu 0, 1, 2, etc).

> 
> And there is a exception for mmio read, in current code, the mmio read event is
> actually used to trace the time when then read emulation is completed, i think
> we can add a tracepoint like mmio_read_begin to trace the start time of mmio read.
> So:
> - for the new kernel, we use mmio_read_begion and kvm_mmio(READ...) to calculate
>   start time and end time.
> - for the old kernel, we use kvm_exit and kvm_mmio(READ...) to calculate start time
>   and end time.
> 
> Your idea?
> 

I did play around with it a bit more today.

My concern would be adding more events may make things more precise, but
it adds more overhead and I am not sure the precision is worth it. For
example on my laptop (Penryn Core 2; a lab server with a xeon E5560
processor is much faster):

0.000002 kvm_exit reason IO_INSTRUCTION rip 0x806d0e30 info 710048 0
0.000003     kvm_emulate_insn 0:806d0e30: e4 71
0.000001     kvm_pio pio_read at 0x71 size 1 count 1
0.000001     kvm_userspace_exit reason KVM_EXIT_IO (2)
0.000003     kvm_set_irq gsi 8 level 0 source 0
0.000001     kvm_pic_set_irq chip 1 pin 0 (edge|masked)
0.000001     kvm_ioapic_set_irq pin 8 dst 1 vec=209 (Fixed|logical|edge)
         total exit time: 0.000016

The first column is the delta-time between successive events for a vcpu.
Most of those events are in the rounded up microsecond range. Moving on
to the subsequent kvm_entry shows a total VMENTRY run time of 5 usecs:
ie., 16 usecs on a VMEXIT with 7 tracepoints and 5 usecs spent in a VMENTRY.

What I am getting at is that the cost of the tracepoints becomes a
significant overhead. If it costs 500nsec or 1usec to generate an event
and the time in a VMENTRY is only 5 usecs the tracepoint is a large part
of the time.

David
