Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1BBSbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:31:20 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:13110 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab1BBSbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:31:19 -0500
X-IronPort-AV: E=Sophos;i="4.60,415,1291593600"; 
   d="scan'208";a="4119572"
Date: Wed, 2 Feb 2011 18:32:59 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "konrad@kernel.org" <konrad@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 11/11] xen/m2p: Check whether the MFN
 has IDENTITY_FRAME bit set..
In-Reply-To: <20110202164307.GB14834@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1102021812210.7277@kaball-desktop>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com> <1296513876-31415-12-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.00.1102011513190.7277@kaball-desktop> <20110201202923.GC18656@dumpdata.com> <alpine.DEB.2.00.1102021128350.7277@kaball-desktop>
 <20110202164307.GB14834@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, Konrad Rzeszutek Wilk wrote:
> > in which the same mfn can correspond to a normal mapping, a 1:1 mapping
> > or even a granted page, it is a good idea to check the m2p_override
> > *before* checking if the mfn is an identity mfn.
> > So that if there are two identical mfns, one granted and the other
> > one belonging to an identity mapping, we would return the pfn
> 
> How can you have that? Are you passing through a PCI device to
> a PV domain, making the PV domain have the netback/blkback device,
> and then granting those pages to another domain?

it is an hypothetical scenario: we have two domUs dA and dB; dA grants a
page P (the corresponding mfn will be called mfn_P) to dB.  mfn_P
happens to be normal valid ram in dA but in dB another mfn called mfn_Q
belonging to a 1:1 region exists so that mfn_P == mfn_Q.
I think this scenario is possible, we just need two domU with different
e820's.


> > let's suppose that pfn is garbage (0xFFFFF.. or 0x55555..), in this case
> 
> 0xFFFF or 0x5555 are not garbage. They are valid values. Garbage is the
> value zero. 0xFFFF.. has two meanings: It is a missing page that can be
> balloon-ed in, or it belongs to the DOMID_IO. The 0x5555.. means it is
> a shared DOMID_IO page.

I see, this is interesting.


> > ret = __get_user(pfn, &machine_to_phys_mapping[mfn]); /* ret is >= 0 and
> >                                                        pfn is 0x55555.. */
> > get_phys_to_machine(0x55555) != mfn /* true, I am assuming there are no
> >                                      valid p2m mappings at 0x55555.. */
> 
> > pfn = m2p_find_override_pfn(mfn, ~0); /* the m2p_ovverride doesn't find
> >                                          anything so it returns ~0 (the
> >                                          second argument), pfn == ~0 now */
> > if (pfn == ~0 && /* true */
> > 
> > 
> > maybe I should add a comment (and drink less caffeine)?
> 
> The first time I saw the patch I missed that you passed in 'mfn' to
> the second get_phys_to_machine .. Comments are good here I think.

I'll do.


> > 
> > 
> > > > +			get_phys_to_machine(mfn) == IDENTITY_FRAME(mfn))
> > > > +		pfn = mfn;
> > > 
> > > So for identity type mfns we end up calling 'get_phys_to_machine(mfn)' twice
> > > I think?
> > > 
> > > Would it make sense to save the result of 'get_phys_to_machine(mfn)'
> > > the first call?
> > 
> > the first call is get_phys_to_machine(pfn), with pfn potentially
> > garbage; this call is get_phys_to_machine(mfn).
> 
> I think what you are telling me is that it is pointless to check for
> the IDENTITY_FRAME b/c it won't happen often or at all.
> 
> So moving the code so that we do the hot-paths first makes more
> sense and we should structure the code as so, right?
> 

Yes.
My point is that it makes sense to check the m2p_override first
because it is more likely to get a valid result than checking for an
identity mapping.
Besides if both are available for the same mfn (case described above) we
want to return the m2p_override result here.


> I agree with that sentiment, do you want to prep another patch that
> has this patch and also some more comments?

yes, appended.

---


diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index be118d8..16ba2a8 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -81,6 +81,7 @@ static inline int phys_to_machine_mapping_valid(unsigned long pfn)
 static inline unsigned long mfn_to_pfn(unsigned long mfn)
 {
 	unsigned long pfn;
+	int ret = 0;
 
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return mfn;
@@ -95,15 +96,29 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 	 * In such cases it doesn't matter what we return (we return garbage),
 	 * but we must handle the fault without crashing!
 	 */
-	__get_user(pfn, &machine_to_phys_mapping[mfn]);
+	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
 try_override:
-	/*
-	 * If this appears to be a foreign mfn (because the pfn
-	 * doesn't map back to the mfn), then check the local override
-	 * table to see if there's a better pfn to use.
+	/* ret might be < 0 if there are no entries in the m2p for mfn */
+	if (ret < 0)
+		pfn = ~0;
+	else if (get_phys_to_machine(pfn) != mfn)
+		/*
+		 * If this appears to be a foreign mfn (because the pfn
+		 * doesn't map back to the mfn), then check the local override
+		 * table to see if there's a better pfn to use.
+		 *
+		 * m2p_find_override_pfn returns ~0 if it doesn't find anything.
+		 */
+		pfn = m2p_find_override_pfn(mfn, ~0);
+
+	/* 
+	 * pfn is ~0 if there are no entries in the m2p for mfn or if the
+	 * entry doesn't map back to the mfn and m2p_override doesn't have a
+	 * valid entry for it.
 	 */
-	if (get_phys_to_machine(pfn) != mfn)
-		pfn = m2p_find_override_pfn(mfn, pfn);
+	if (pfn == ~0 &&
+			get_phys_to_machine(mfn) == IDENTITY_FRAME(mfn))
+		pfn = mfn;
 
 	return pfn;
 }
