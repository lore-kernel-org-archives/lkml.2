Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab1ANSbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:31:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab1ANSbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:31:11 -0500
Date: Fri, 14 Jan 2011 19:30:58 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-arch@vger.kernel.org
Subject: Re: ia64 broken by transparent huge pages - other arches too?
Message-ID: <20110114183058.GN9506@random.random>
References: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="raC6veAxrt5nqIoY"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--raC6veAxrt5nqIoY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jan 14, 2011 at 09:50:45AM -0800, Luck, Tony wrote:
> In file included from /home/aegl/generic-smp/arch/ia64/include/asm/pgtable.h:611,
>                  from include/linux/mm.h:41,
>                  from /home/aegl/generic-smp/arch/ia64/include/asm/uaccess.h:39,
>                  from include/linux/poll.h:14,
>                  from include/linux/rtc.h:117,
>                  from include/linux/efi.h:19,
>                  from /home/aegl/generic-smp/arch/ia64/include/asm/sal.h:40,
>                  from /home/aegl/generic-smp/arch/ia64/include/asm/mca.h:20,
>                  from arch/ia64/kernel/asm-offsets.c:17:
> include/asm-generic/pgtable.h: In function ‘pmdp_get_and_clear’:
> include/asm-generic/pgtable.h:96: error: implicit declaration of function ‘__pmd’
> include/asm-generic/pgtable.h:96: error: incompatible types in return
> make[1]: *** [arch/ia64/kernel/asm-offsets.s] Error 1
> 
> 
> Looks like arch/*/include/pgtable.h needs to define __pmd() but only x86
> was blessed with it.

So I fixed powerpc build and sparc but broke ia64 with this change
sorry, hard to make all archs build consistent. See the attached mails.

Would you be willing to implement __pmd for ia64 to fix this? Can you
check if this works?

Thanks a lot,
Andrea

========
Subject: fix ia64 build failure in pmdp_get_and_clear

From: Andrea Arcangeli <aarcange@redhat.com>

Implement __pmd macro for ia64 too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/arch/ia64/include/asm/page.h b/arch/ia64/include/asm/page.h
index 41b6d31..961a16f 100644
--- a/arch/ia64/include/asm/page.h
+++ b/arch/ia64/include/asm/page.h
@@ -189,6 +189,7 @@ get_order (unsigned long size)
 # define pgprot_val(x)	((x).pgprot)
 
 # define __pte(x)	((pte_t) { (x) } )
+# define __pmd(x)	((pmd_t) { (x) } )
 # define __pgprot(x)	((pgprot_t) { (x) } )
 
 #else /* !STRICT_MM_TYPECHECKS */

--raC6veAxrt5nqIoY
Content-Type: message/rfc822
Content-Disposition: inline

Date: Mon, 10 Jan 2011 19:04:25 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH -mm] fix powerpc/sparc build
Message-ID: <20110110180425.GK9506@random.random>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
 <20110108104208.ca085298.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110108104208.ca085298.sfr@canb.auug.org.au>

This would become
thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um-2.patch

=====
Subject: thp: build fix for pmdp_get_and_clear

From: Andrea Arcangeli <aarcange@redhat.com>

__pmd should return a valid pmd_t for every arch.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---


diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -93,7 +93,7 @@ static inline pmd_t pmdp_get_and_clear(s
 				       pmd_t *pmdp)
 {
 	BUG();
-	return (pmd_t){ 0 };
+	return __pmd(0);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif


--raC6veAxrt5nqIoY
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: sfr@canb.auug.org.au
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on v2.random
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,MY_LINUX,
	UNPARSEABLE_RELAY autolearn=ham version=3.3.1
Received: from mail.corp.redhat.com [10.5.5.52]
	by v2.random with IMAP (fetchmail-6.3.17)
	for <andrea@localhost> (single-drop); Sat, 08 Jan 2011 00:42:27 +0100 (CET)
Received: from zmta02.collab.prod.int.phx2.redhat.com (LHLO
 zmta02.collab.prod.int.phx2.redhat.com) (10.5.5.32) by
 mail04.corp.redhat.com with LMTP; Fri, 7 Jan 2011 18:42:26 -0500 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta02.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id C5DEC9D682
	for <aarcange@redhat.com>; Fri,  7 Jan 2011 18:42:26 -0500 (EST)
Received: from zmta02.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta02.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nEkjKrzlwVxm for <aarcange@redhat.com>;
	Fri,  7 Jan 2011 18:42:26 -0500 (EST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by zmta02.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id B1D9C9D655
	for <aarcange@mail.corp.redhat.com>; Fri,  7 Jan 2011 18:42:26 -0500 (EST)
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com [10.5.110.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p07NgQKg003043
	for <aarcange@redhat.com>; Fri, 7 Jan 2011 18:42:26 -0500
Received: from smtps.tip.net.au (chilli.pcug.org.au [203.10.76.44])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p07NgHGW016427
	for <aarcange@redhat.com>; Fri, 7 Jan 2011 18:42:18 -0500
Received: from canb.auug.org.au (ta-1-1.tip.net.au [203.11.71.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtps.tip.net.au (Postfix) with ESMTPSA id D5AFC144B71;
	Sat,  8 Jan 2011 10:42:13 +1100 (EST)
Date: Sat, 8 Jan 2011 10:42:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli
 <aarcange@redhat.com>
Subject: Re: mmotm 2011-01-06-15-41 uploaded
Message-Id: <20110108104208.ca085298.sfr@canb.auug.org.au>
In-Reply-To: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__8_Jan_2011_10_42_08_+1100_eRk2QF3kFcTaDAx="
X-RedHat-Spam-Score: 0  ()
X-Scanned-By: MIMEDefang 2.67 on 10.5.11.11
X-Scanned-By: MIMEDefang 2.67 on 10.5.110.10

--Signature=_Sat__8_Jan_2011_10_42_08_+1100_eRk2QF3kFcTaDAx=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 06 Jan 2011 15:41:14 -0800 akpm@linux-foundation.org wrote:
>
> The mm-of-the-moment snapshot 2011-01-06-15-41 has been uploaded to
>=20
>    http://userweb.kernel.org/~akpm/mmotm/

Build results here: http://kisskb.ellerman.id.au/kisskb/head/3605/

Notably:

powerpc pmac32_defconfig:

In file included from arch/powerpc/include/asm/pgtable.h:200,
                 from include/linux/mm.h:41,
                 from include/linux/mman.h:14,
                 from arch/powerpc/kernel/asm-offsets.c:22:
include/asm-generic/pgtable.h: In function 'pmdp_get_and_clear':
include/asm-generic/pgtable.h:96: warning: missing braces around initializer
include/asm-generic/pgtable.h:96: warning: (near initialization for '(anony=
mous).pud')

sparc defconfig:

In file included from arch/sparc/include/asm/pgtable_32.h:456,
                 from arch/sparc/include/asm/pgtable.h:7,
                 from include/linux/mm.h:42,
                 from arch/sparc/kernel/sys_sparc_32.c:12:
include/asm-generic/pgtable.h: In function 'pmdp_get_and_clear':
include/asm-generic/pgtable.h:96: error: missing braces around initializer
include/asm-generic/pgtable.h:96: error: (near initialization for '(anonymo=
us).pmdv')

Probably a side effect of
thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um.patch.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__8_Jan_2011_10_42_08_+1100_eRk2QF3kFcTaDAx=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNJ6TQAAoJEDMEi1NhKgbs45UH/0hT/IP5It4HDHPot2apZczn
gVdG13HzudAts6bATYv5xG5afFFomUXqaaaId+xBUHdxdyEv8lNqBuTFQppyqzbf
dsW2JjQT1sB6Spm4k0wn0sLWSu6pyVRP0AaC0X6UreFEulkhcCMLAzYq4cFEhaOj
N9Ho2w+8X9Gp0BEZ9OtJpRzSEOBEOCHRaDQ4pDLHP1FQmzQHxWSf1V4mXfi+I8Is
PDFFkQFuNT2jEJZ8aJJiZx/bUilos8KhPIqt5sKYdi9E6QGH2f/qsouz6vF9U4Rx
kabXk0c0f7Y0znUsp+e8mxBGAyoK3pUeDNxeNNGmAZrAd7tdzHQN735dJpz9wNE=
=ZsXa
-----END PGP SIGNATURE-----

--Signature=_Sat__8_Jan_2011_10_42_08_+1100_eRk2QF3kFcTaDAx=--


--raC6veAxrt5nqIoY--
