Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2IGLNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:13:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48612 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab2IGLM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:12:29 -0400
Message-ID: <5049D698.1020405@canonical.com>
Date: Fri, 07 Sep 2012 13:12:24 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Konrad Rezeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] x86/mm: Limit 2/4M size calculation to x86_32
References: <5017AE48.5090108@redhat.com> <1346430699-19894-1-git-send-email-stefan.bader@canonical.com> <a6b71e0f-d2d3-44b5-a939-f909ea3fdccc@email.android.com>
In-Reply-To: <a6b71e0f-d2d3-44b5-a939-f909ea3fdccc@email.android.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigCE619EE5472A4044742E054D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCE619EE5472A4044742E054D
Content-Type: multipart/mixed;
 boundary="------------010202000805000903090102"

This is a multi-part message in MIME format.
--------------010202000805000903090102
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 31.08.2012 18:41, H. Peter Anvin wrote:
> I'm not saying we shouldn't patch the regression, but this house of car=
ds
> *needs* to be replaced with something robust and correct by constructio=
n.

Could that patch then get applied? Though I got some feedback, that the
description might be not really well written. So I am attaching a version=
 that
tries to do better. The code change itself is the same.

-Stefan

---

=46rom 737a5ebdd7ac1f4106cb0b0c53cc8f73b6ff1aca Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Fri, 13 Jul 2012 15:16:33 +0200
Subject: [PATCH] x86/mm: Limit extra padding calculation to x86_32

Starting with kernel v3.5 kexec based crash dumping was observed to fail
(without any apparent message) on x86_64 machines.  This was traced to
a lack of memory triggered by a substantial increase (several megabyes)
in the size of the initial page tables.

 After regression (on a VM with 2GB of memory):
 kernel direct mapping tables up to 0x7fffcfff @ [mem 0x1fbfd000-0x1fffff=
ff]
 size =3D 4206591 bytes

 With this patch applied:
 kernel direct mapping tables up to 0x7fffcfff @ [mem 0x1fffc000-0x1fffff=
ff]
 size =3D 16383 bytes

A bisection lead to the commit below:

commit 722bc6b (x86/mm: Fix the size calculation of mapping tables)

This change modified the extra space calculation to take into account
that the first 2/4M range of memory would be mapped as 4K pages as
suggested in chapter 11.11.9 of the Intel software developer's manual.

However this is currently only true for x86_32 (the reasons behind that
are unclear but apparently the whole page table setup needs to be re-
visited as it turns out to be very easy to break and has flaws in its
current form).

Until the logic can be revisited and combined, pair up the extra space
calculation with the logic which creates the extra mappings.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: stable@vger.kernel.org # v3.5+
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
---
 arch/x86/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bc4e9d8..636bbfd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -60,10 +60,11 @@ static void __init find_early_table_space(struct map_=
range
*mr, unsigned long en
 		extra =3D end - ((end>>PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
 		extra +=3D PMD_SIZE;
-#endif
+
 		/* The first 2/4M doesn't use large pages. */
 		if (mr->start < PMD_SIZE)
 			extra +=3D mr->end - mr->start;
+#endif

 		ptes =3D (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
--=20
1.7.9.5

--------------010202000805000903090102
Content-Type: text/x-diff;
 name="0001-x86-mm-Limit-2-4M-size-calculation-to-x86_32.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-x86-mm-Limit-2-4M-size-calculation-to-x86_32.patch"

=46rom 737a5ebdd7ac1f4106cb0b0c53cc8f73b6ff1aca Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Fri, 13 Jul 2012 15:16:33 +0200
Subject: [PATCH] x86/mm: Limit extra padding calculation to x86_32

Starting with kernel v3.5 kexec based crash dumping was observed to fail
(without any apparent message) on x86_64 machines.  This was traced to
a lack of memory triggered by a substantial increase (several megabyes)
in the size of the initial page tables.

 After regression (on a VM with 2GB of memory):
 kernel direct mapping tables up to 0x7fffcfff @ [mem 0x1fbfd000-0x1fffff=
ff]
 size =3D 4206591 bytes

 With this patch applied:
 kernel direct mapping tables up to 0x7fffcfff @ [mem 0x1fffc000-0x1fffff=
ff]
 size =3D 16383 bytes

A bisection lead to the commit below:

commit 722bc6b (x86/mm: Fix the size calculation of mapping tables)

This change modified the extra space calculation to take into account
that the first 2/4M range of memory would be mapped as 4K pages as
suggested in chapter 11.11.9 of the Intel software developer's manual.

However this is currently only true for x86_32 (the reasons behind that
are unclear but apparently the whole page table setup needs to be re-
visited as it turns out to be very easy to break and has flaws in its
current form).

Until the logic can be revisited and combined, pair up the extra space
calculation with the logic which creates the extra mappings.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: stable@vger.kernel.org # v3.5+
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
---
 arch/x86/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bc4e9d8..636bbfd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -60,10 +60,11 @@ static void __init find_early_table_space(struct map_=
range *mr, unsigned long en
 		extra =3D end - ((end>>PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
 		extra +=3D PMD_SIZE;
-#endif
+
 		/* The first 2/4M doesn't use large pages. */
 		if (mr->start < PMD_SIZE)
 			extra +=3D mr->end - mr->start;
+#endif
=20
 		ptes =3D (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
--=20
1.7.9.5


--------------010202000805000903090102--

--------------enigCE619EE5472A4044742E054D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBCgAGBQJQSdaYAAoJEOhnXe7L7s6jSY0P/27Bdlo2uurutNTpoxwPs9Xe
L1wAJJFbkc/enGK+AXNQ1hjBXJzcnGo2T7RYisar1ROVmRnQgANJlSPlc/Q1b1hW
GacPaPlZstA7GyohiM7/15o1B7iZZvjeZ8ZIofwu+5N9erVq9CjgHhKmHPQkxGUr
8VCvBifHFY1shLqArWa4w0i5B2F4o587F3DHpRotWfqaVo2u23GvjyTGd/k87UAl
pku5Und/RB91q0H7tCcsR2Rvvous6YIVuD04YU3NXO1tYNcl/osei7Knia3C+3st
DWvxJboOy/0MlU1lW1OCBjzmBdPs/iRbZ+VT5Pf/nQnjnoZQnzXmKzq7OWkoITfX
n0eIzTrpLCrxJLPkQ5e5ksd7jLZfcsS8/sQq5xrBFYBmn4fIlQ/hDi/KMEzOHH1a
jF5NxUkiQjJWmOwtS8oHnPDm3jJXdCQHNKr9PZWfQTSRLfsgI5NmsHkL3lgTg0/v
CHQvJOWJ8BhgPtwOlY2sUs1CyhThtf9LSSLSSAasGx31RazphZYDzh/G5vrlcWL9
CfR+W8v/DYaeAVpShU6goxaazqYDKDMY4tg0lph7HUCyaqfOzBlmk7QX/b4SkbFa
zqw8ZZlOxSQ1+JdAGihWCASgssT+H1pyNPGqzj1Z6EJvh3HMMEg5RzhRr4g95cDF
JodiL4kh0txROri+7rAA
=/0VE
-----END PGP SIGNATURE-----

--------------enigCE619EE5472A4044742E054D--
