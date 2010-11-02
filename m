Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab0KBJF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 05:05:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60983 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab0KBJFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 05:05:20 -0400
Message-ID: <4CCFD556.3070504@cn.fujitsu.com>
Date: Tue, 02 Nov 2010 17:09:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 7/7] KVM: KVM: don't break vcpu 'halt' state due
 to apfs
References: <4CCE8143.3090105@cn.fujitsu.com> <4CCE82BC.3090000@cn.fujitsu.com> <20101101125551.GD31722@redhat.com> <4CCF77B2.9080604@cn.fujitsu.com> <20101102065613.GA7881@redhat.com> <4CCFBE4E.3090804@cn.fujitsu.com> <20101102074545.GC7881@redhat.com>
In-Reply-To: <20101102074545.GC7881@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2010 03:45 PM, Gleb Natapov wrote:

> kvm_event_needs_reinjection() checks for nmi/interrupts that
> need reinjection (not injection).  Those are nmi/interrupts that
> was injected but injection failed for some reason. For nmi, for
> instance, kvm_arch_vcpu_runnable() checks vcpu->arch.nmi_pending,
> but kvm_event_needs_reinjection() checks for vcpu->arch.nmi_injected.
> NMI moves from nmi_pending to nmi_injected when it is injected into vcpu
> for the first time. CPU cannot be halted in this state.
> 

Yeah, nmi is handled like this way, but for interrupt:
If interruption controller is in userspace (!irqchip_in_kernel(v->kvm)),
kvm_arch_vcpu_runnable() checks vcpu->arch.interrupt.pending and
kvm_event_needs_reinjection() also checks vcpu->arch.interrupt.pending.

Consider this case:

- Guest vcpu executes 'HLT'
- wakeup the vcpu and inject interrupt and apfs is completed at this time
- then the vcpu can't handle apf completion and .done list keeps nonempty.  

Can this case happen? Sorry if i missed it again.

>> Also, the pv guest can only handle an apf completion at one time, it can not ensure
>> vcpu->async_pf.done is empty after kvm_check_async_pf_completion()
>>
> In case of PV guest it will be woken up by apf completion by
> kvm_arch_async_page_present() below.

......

>> As i know, exception can not let guest exit halt state, only NMI/interruption can do it, yes? :-)
> On physical HW exception cannot happen while cpu is in halt state, but
> with PV we define what guest can and cannot expect, so when guest
> explicitly enables apf it should be able to handle it during halt.
> 

Ah, i see, thanks your very much.
