Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1A2CHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 21:07:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab1A2CHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 21:07:38 -0500
Subject: Re: [PATCH] release kvmclock page on reset
From: Glauber Costa <glommer@redhat.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
In-Reply-To: <4D433088.10308@web.de>
References: <1296244086-15081-1-git-send-email-glommer@redhat.com>
	 <4D433088.10308@web.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Sat, 29 Jan 2011 00:07:27 -0200
Message-ID: <1296266847.3591.41.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 22:09 +0100, Jan Kiszka wrote:
> On 2011-01-28 20:48, Glauber Costa wrote:
> > Up to know, we were relying on guest cooperation to turn off kvmclock.
> > I just realized that even though this is fine and nice, a more robust
> > method is to (also) turn it off on vcpu_reset on the hypervisor side.
> > This will protect us against reboots, and we don't expect the guest
> > to reset its cpu during normal operation anyway.
> > 
> > Signed-off-by: Glauber Costa <glommer@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index bcc0efc..38b55b3 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5878,6 +5878,11 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
> >  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> >  	vcpu->arch.apf.msr_val = 0;
> >  
> > +	if (vcpu->arch.time_page) {
> > +		kvm_release_page_dirty(vcpu->arch.time_page);
> > +		vcpu->arch.time_page = NULL;
> > +	}
> > +
> 
> kvm_arch_vcpu_reset is only called on vcpu setup and when it receives a
> sipi (provided in-kernel irqchip is in use). If you want this page to be
> consistently reset on guest reboot, you have to trigger this from user
> space. But I thought we are doing this already in qemu, don't we?

Humm, you might as well be right regarding reboots.
But in the end, it doesn't affect correctness here. If we're resetting
the vcpu, we should not let that kind of data live.

