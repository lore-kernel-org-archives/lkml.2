Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2EMQDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:03:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab2EMQDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:03:36 -0400
Date: Sun, 13 May 2012 19:03:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, Rob Landley <rob@landley.net>,
        Glauber Costa <glommer@redhat.com>, Rik van Riel <riel@redhat.com>,
        Avi Kivity <avi@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: eoi msi documentation
Message-ID: <20120513160335.GA26928@redhat.com>
References: <20120513151321.GA25721@redhat.com>
 <20120513155622.GG15230@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120513155622.GG15230@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 06:56:23PM +0300, Gleb Natapov wrote:
> > +	However, hypervisor can set and clear this memory bit at any time:
> > +	therefore to make sure hypervisor does not interrupt the
> > +	guest and clear the least significant bit in the memory area
> > +	in the window between guest testing it to detect
> > +	whether it can skip EOI apic write and between guest
> > +	clearing it to signal EOI to the hypervisor,
> > +	guest must both read the least sgnificant bit in the memory area and
> > +	clear it using a single CPU instruction, such as test and clear, or
> > +	compare and exchange.
> > +
> Looks good, but everything below this is here by mistake.

Ugh. Right. Good catch,

> Are You still
> going to resend host side patch to address my other comment?

Yes, like this.
I'll give more people a chance to review first though.


diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 77e0244..c7e6ffb 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1490,6 +1490,7 @@ int kvm_pv_enable_apic_eoi(struct kvm_vcpu *vcpu, u64 data)
 	if (eoi_enabled(vcpu))
 		eoi_clr_pending(vcpu);
 	vcpu->arch.eoi.msr_val = data;
-	kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.eoi.data, addr);
-	return 0;
+	if (!eoi_enabled(vcpu))
+		return 0;
+	return kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.eoi.data, addr);
 }
