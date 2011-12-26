Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1LZLRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 06:17:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1LZLRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 06:17:44 -0500
Message-ID: <4EF857D3.8020304@redhat.com>
Date: Mon, 26 Dec 2011 13:17:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Liu Ping Fan <kernelfans@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com, mtosatti@redhat.com,
        jan.kiszka@web.de
Subject: Re: [PATCH v5] kvm: make vcpu life cycle separated from kvm instance
References: <1323657683-13934-1-git-send-email-kernelfans@gmail.com> <1324091975-20930-1-git-send-email-kernelfans@gmail.com> <20111226110943.GB2072@redhat.com>
In-Reply-To: <20111226110943.GB2072@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2011 01:09 PM, Gleb Natapov wrote:
> > +
> > +		idx = srcu_read_lock(&kvm->srcu_vcpus);
> > +		kvm_for_each_vcpu(vcpu, kvm) {
> > +			if (!pass && !firststart &&
> > +			    vcpu != kvm->last_boosted_vcpu &&
> > +			    kvm->last_boosted_vcpu != NULL) {
> > +				vcpu = kvm->last_boosted_vcpu;
> You access last_boosted_vcpu as if it is protected by srcu, but it
> isn't. kvm_vcpu_release() changes it after synchronize_srcu_expedited()
> call.
>
> I do not like this last_boosted_vcpu pointer much. May be we can rid of
> it by remembering last apic_id and searching for it each time we enter
> the function. I do not think this function is to performance sensitive.
> We enter here when vcpu is spinning anyway.

We aren't guaranteed to have an apic_id, so it has to be done using rcu,
or maybe vcpu_id.  I prefer using srcu, we can't run away from vcpu
pointers.


-- 
error compiling committee.c: too many arguments to function

