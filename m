Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1EBX5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:57:42 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47581 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1EBX5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:57:40 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: mmotm 2011-04-29 - wonky VmRSS and VmHWM values after swapping
In-Reply-To: Your message of "Mon, 02 May 2011 16:44:30 PDT."
             <20110502164430.eb7d451d.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201104300002.p3U02Ma2026266@imap1.linux-foundation.org> <49683.1304296014@localhost> <8185.1304347042@localhost>
            <20110502164430.eb7d451d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304380652_5156P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 May 2011 19:57:32 -0400
Message-ID: <51961.1304380652@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4DBF44ED.009B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304380652_5156P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 May 2011 16:44:30 PDT, Andrew Morton said:

> hm, me too.  After boot, hald has a get_mm_counter(mm, MM_ANONPAGES) of
> 0xffffffffffff3c27.  Bisected to Pater's
> mm-extended-batches-for-generic-mmu_gather.patch, can't see how it did
> that.

Looking at it:
@@ -177,15 +205,24 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
  */
 static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
+       struct mmu_gather_batch *batch;
+
        tlb->need_flush = 1;
+
        if (tlb_fast_mode(tlb)) {
                free_page_and_swap_cache(page);
                return 1; /* avoid calling tlb_flush_mmu() */
        }
-       tlb->pages[tlb->nr++] = page;
-       VM_BUG_ON(tlb->nr > tlb->max);

-       return tlb->max - tlb->nr;
+       batch = tlb->active;
+       batch->pages[batch->nr++] = page;
+       VM_BUG_ON(batch->nr > batch->max);
+       if (batch->nr == batch->max) {
+               if (!tlb_next_batch(tlb))
+                       return 0;
+       }
+
+       return batch->max - batch->nr;
 }

Who's intializing/setting batch->max?  Perhaps whoever set up tlb->active
failed to do so?



--==_Exmh_1304380652_5156P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNv0TscC3lWbTT17ARAnL3AJ9mTDyrWh6ZIkzcyX2o3v4QygwktQCfbzP4
Rk4oeQjHDGys3zlM1mOVXjU=
=9+8J
-----END PGP SIGNATURE-----

--==_Exmh_1304380652_5156P--

