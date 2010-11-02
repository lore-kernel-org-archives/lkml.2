Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0KBJOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 05:14:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab0KBJOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 05:14:35 -0400
Date: Tue, 2 Nov 2010 11:14:30 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 7/7] KVM: KVM: don't break vcpu 'halt' state due
 to apfs
Message-ID: <20101102091430.GD7881@redhat.com>
References: <4CCE8143.3090105@cn.fujitsu.com>
 <4CCE82BC.3090000@cn.fujitsu.com>
 <20101101125551.GD31722@redhat.com>
 <4CCF77B2.9080604@cn.fujitsu.com>
 <20101102065613.GA7881@redhat.com>
 <4CCFBE4E.3090804@cn.fujitsu.com>
 <20101102074545.GC7881@redhat.com>
 <4CCFD556.3070504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCFD556.3070504@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 05:09:42PM +0800, Xiao Guangrong wrote:
> On 11/02/2010 03:45 PM, Gleb Natapov wrote:
> 
> > kvm_event_needs_reinjection() checks for nmi/interrupts that
> > need reinjection (not injection).  Those are nmi/interrupts that
> > was injected but injection failed for some reason. For nmi, for
> > instance, kvm_arch_vcpu_runnable() checks vcpu->arch.nmi_pending,
> > but kvm_event_needs_reinjection() checks for vcpu->arch.nmi_injected.
> > NMI moves from nmi_pending to nmi_injected when it is injected into vcpu
> > for the first time. CPU cannot be halted in this state.
> > 
> 
> Yeah, nmi is handled like this way, but for interrupt:
> If interruption controller is in userspace (!irqchip_in_kernel(v->kvm)),
> kvm_arch_vcpu_runnable() checks vcpu->arch.interrupt.pending and
> kvm_event_needs_reinjection() also checks vcpu->arch.interrupt.pending.
> 
> Consider this case:
> 
> - Guest vcpu executes 'HLT'
> - wakeup the vcpu and inject interrupt and apfs is completed at this time
> - then the vcpu can't handle apf completion and .done list keeps nonempty.  
> 
> Can this case happen? Sorry if i missed it again.
> 
If irqchip is in userspace apf is disabled (see mmu.c:can_do_async_pf()).
The reason for this is that when irqchip_in_kernel(v->kvm) cpu sleeps in
userspace during halt, so all event that can cause it to be unhalted
should be generated in userspace too. This is also the reason you can't have
pit in kernel and irqchip in userpsace.

--
			Gleb.
