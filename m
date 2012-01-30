Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2A3PLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:11:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab2A3PLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:11:40 -0500
Message-ID: <4F26B31D.3070407@redhat.com>
Date: Mon, 30 Jan 2012 17:11:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 V10] Add ioctl for KVMCLOCK_GUEST_STOPPED
References: <1326825641-15765-1-git-send-email-emunson@mgebm.net> <1326825641-15765-4-git-send-email-emunson@mgebm.net> <4F26B220.9050101@redhat.com>
In-Reply-To: <4F26B220.9050101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 05:07 PM, Avi Kivity wrote:
> > +Parameters: None
> > +Returns: 0 on success, -1 on error
> > +
> > +This signals to the host kernel that the specified guest is being paused by
> > +userspace.  The host will set a flag in the pvclock structure that is checked
> > +from the soft lockup watchdog.  This ioctl can be called during pause or
> > +unpause.
> > +
> >  5. The kvm_run structure
> >  
> >  
> > +/*
> > + * kvm_set_guest_paused() indicates to the guest kernel that it has been
> > + * stopped by the hypervisor.  This function will be called from the host only.
> > + */
> > +static int kvm_set_guest_paused(struct kvm *kvm)
> > +{
> > +	struct kvm_vcpu *vcpu;
> > +	struct pvclock_vcpu_time_info *src;
> > +	int i;
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		if (!vcpu->arch.time_page)
> > +			continue;
> > +		src = &vcpu->arch.hv_clock;
> > +		src->flags |= PVCLOCK_GUEST_STOPPED;
>
> This looks racy.  The vcpu can remove its kvmclock concurrently with
> this access, and src will be NULL.
>
> Can you point me to the discussion that moved this to be a vm ioctl?  In
> general vm ioctls that do things for all vcpus are racy, like here. 
> You're accessing variables that are protected by the vcpu mutex, and not
> taking the mutex (nor can you, since it is held while the guest is
> running, unlike most kernel mutexes).
>

Note, the standard way to fix this race is to
kvm_make_request(KVM_REQ_KVMCLOCK_STOP) and kvm_vcpu_kick(vcpu), and do
the update in vcpu_enter_guest().  But I think this is needless
complexity and want to understand what motivated the move to a vm ioctl.

-- 
error compiling committee.c: too many arguments to function

