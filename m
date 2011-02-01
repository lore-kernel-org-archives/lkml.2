Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1BAQEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:04:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1BAQEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:04:49 -0500
Subject: Re: [PATCH] release kvmclock page on reset
From: Glauber Costa <glommer@redhat.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
In-Reply-To: <4D43D658.7080605@web.de>
References: <1296244086-15081-1-git-send-email-glommer@redhat.com>
	 <4D433088.10308@web.de> <1296266847.3591.41.camel@mothafucka.localdomain>
	 <4D43D658.7080605@web.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 01 Feb 2011 14:04:25 -0200
Message-ID: <1296576265.5081.21.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-29 at 09:56 +0100, Jan Kiszka wrote:
> On 2011-01-29 03:07, Glauber Costa wrote:
> > On Fri, 2011-01-28 at 22:09 +0100, Jan Kiszka wrote:
> >> On 2011-01-28 20:48, Glauber Costa wrote:
> >>> Up to know, we were relying on guest cooperation to turn off kvmclock.
> >>> I just realized that even though this is fine and nice, a more robust
> >>> method is to (also) turn it off on vcpu_reset on the hypervisor side.
> >>> This will protect us against reboots, and we don't expect the guest
> >>> to reset its cpu during normal operation anyway.
> >>>
> >>> Signed-off-by: Glauber Costa <glommer@redhat.com>
> >>> ---
> >>>  arch/x86/kvm/x86.c |    5 +++++
> >>>  1 files changed, 5 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >>> index bcc0efc..38b55b3 100644
> >>> --- a/arch/x86/kvm/x86.c
> >>> +++ b/arch/x86/kvm/x86.c
> >>> @@ -5878,6 +5878,11 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
> >>>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> >>>  	vcpu->arch.apf.msr_val = 0;
> >>>  
> >>> +	if (vcpu->arch.time_page) {
> >>> +		kvm_release_page_dirty(vcpu->arch.time_page);
> >>> +		vcpu->arch.time_page = NULL;
> >>> +	}
> >>> +
> >>
> >> kvm_arch_vcpu_reset is only called on vcpu setup and when it receives a
> >> sipi (provided in-kernel irqchip is in use). If you want this page to be
> >> consistently reset on guest reboot, you have to trigger this from user
> >> space. But I thought we are doing this already in qemu, don't we?
> > 
> > Humm, you might as well be right regarding reboots.
> > But in the end, it doesn't affect correctness here. If we're resetting
> > the vcpu, we should not let that kind of data live.
> > 
> 
> Right, just checked that we reset other states like nmi_pending or
> async_pf here as well. So doing the same for the time_page looks
> appropriate.
> 
> But I think you should encapsulate the pattern above in a function and
> substitute other occurrences at this chance. Also, the changelog should
> clarify in which cases the code matters.

Fair. I will respin this today.

> Jan
> 


