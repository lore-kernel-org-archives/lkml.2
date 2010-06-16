Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0FPNW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:22:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab0FPNW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:22:28 -0400
Date: Wed, 16 Jun 2010 10:22:23 -0300
From: Glauber Costa <glommer@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Zachary Amsden <zamsden@redhat.com>, avi@redhat.com, mtosatti@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] Unify vendor TSC logic
Message-ID: <20100616132223.GI19104@mothafucka.localdomain>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
 <1276587259-32319-4-git-send-email-zamsden@redhat.com>
 <4C1886E2.2060509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1886E2.2060509@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 04:10:10PM +0800, Jason Wang wrote:
> Zachary Amsden wrote:
> >  
> >  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  {
> > +	kvm_x86_ops->vcpu_load(vcpu, cpu);
> >  	if (unlikely(vcpu->cpu != cpu)) {
> > +		/* Make sure TSC doesn't go backwards */
> > +		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 : 
> > +				native_read_tsc() - vcpu->arch.last_host_tsc;
> > +		if (tsc_delta < 0 || check_tsc_unstable())
> >   
> It's better to do the adjustment also when tsc_delta > 0
And why do you think so? Doing it on tsc_delta > 0 would force us to adjust
at every entry but the first. And I guess we want to adjust as few times as 
we can.

For example, we would adjust on every cpu bounce even for machines that has
a perfectly sync tsc. This could introduce an error not present before.

