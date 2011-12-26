Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1LZLV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 06:21:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab1LZLVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 06:21:54 -0500
Date: Mon, 26 Dec 2011 13:21:51 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Liu Ping Fan <kernelfans@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com, mtosatti@redhat.com,
        jan.kiszka@web.de
Subject: Re: [PATCH v5] kvm: make vcpu life cycle separated from kvm instance
Message-ID: <20111226112151.GC2072@redhat.com>
References: <1323657683-13934-1-git-send-email-kernelfans@gmail.com>
 <1324091975-20930-1-git-send-email-kernelfans@gmail.com>
 <20111226110943.GB2072@redhat.com>
 <4EF857D3.8020304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF857D3.8020304@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 01:17:39PM +0200, Avi Kivity wrote:
> On 12/26/2011 01:09 PM, Gleb Natapov wrote:
> > > +
> > > +		idx = srcu_read_lock(&kvm->srcu_vcpus);
> > > +		kvm_for_each_vcpu(vcpu, kvm) {
> > > +			if (!pass && !firststart &&
> > > +			    vcpu != kvm->last_boosted_vcpu &&
> > > +			    kvm->last_boosted_vcpu != NULL) {
> > > +				vcpu = kvm->last_boosted_vcpu;
> > You access last_boosted_vcpu as if it is protected by srcu, but it
> > isn't. kvm_vcpu_release() changes it after synchronize_srcu_expedited()
> > call.
> >
> > I do not like this last_boosted_vcpu pointer much. May be we can rid of
> > it by remembering last apic_id and searching for it each time we enter
> > the function. I do not think this function is to performance sensitive.
> > We enter here when vcpu is spinning anyway.
> 
> We aren't guaranteed to have an apic_id, so it has to be done using rcu,
> or maybe vcpu_id.  I prefer using srcu, we can't run away from vcpu
> pointers.
> 
Yeah, I meant vcpu_id (it is used as initial apic_id for x86, but this
code is not x86 specific).

--
			Gleb.
