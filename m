Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1KNDYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 22:24:34 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:56205 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1KNDYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 22:24:31 -0500
Date: Mon, 14 Nov 2011 14:24:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: build failure after merge of the final tree (pm tree
 related)
Message-Id: <20111114142423.fe126b8c8cfd275d7dd138cc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_Nov_2011_14_24_23_+1100_LO64QX1OFK27VPD+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Nov_2011_14_24_23_+1100_LO64QX1OFK27VPD+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

mm/oom_kill.c: In function 'select_bad_process':
mm/oom_kill.c:326:5: error: implicit declaration of function '__thaw_task' =
[-Werror=3Dimplicit-function-declaration]

Caused by commit 23527e313ca5 ("PM / Freezer: Fix fallout of thaw_process()
-> __thaw_task() rename").  __thaw_task() is only declared id
CONFIG_FREEZER is set.  Commit 944e192db53c ("freezer: rename thaw_process()
to __thaw_task() and simplify the implementation") removed the second
declaration of thaw_process() without replacing it ...

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 14 Nov 2011 14:19:32 +1100
Subject: [PATCH] freezer: fix more fallout from the thaw_process rename

Commit 944e192db53c "freezer: rename thaw_process() to __thaw_task()
and simplify the implementation" did not create a !CONFIG_FREEZER version
of __thaw_task().

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/freezer.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index cc779bb..a9dccc6 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -166,6 +166,7 @@ static inline bool set_freezable_with_signal(void)
 #else /* !CONFIG_FREEZER */
 static inline bool frozen(struct task_struct *p) { return false; }
 static inline bool freezing(struct task_struct *p) { return false; }
+static inline void __thaw_task(struct task_struct *t) {}
=20
 static inline bool __refrigerator(bool check_kthr_stop) { return false; }
 static inline int freeze_processes(void) { return -ENOSYS; }
--=20
1.7.7.2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Nov_2011_14_24_23_+1100_LO64QX1OFK27VPD+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOwInnAAoJEECxmPOUX5FEP6EP/0jDKhj/GKJi2SmY+wblzG0z
NFLYNOQBhXTHCdhDvCQG1uTewXzLtEVI8mJ5DiM+Xrde9srj8cIsoXlode2FvJyg
e40oSFB0KxQOXbD9PK67KvDhbcKo2sEBMXZmgciEKmBvkMxXzkvXdIKsTQA6WOnJ
iwdcn4XeNKu73isN8WkDssVuGm5qTTJVOh9PA6tEvK99DxfvSVo5VZVUN60xvdrk
YvdG7bPkyGGwulSsEQ44cxC73GEY9rZCXGIwJJpKYJPeb2oTyZ4TYhhxPSfWYNZi
Xhe7SegL9F0W6mImRGmgepQ4Q4krTFAkVDC6I02vvuD6fDuv89Qw6OHCksZ0YFMG
tQjbAaHF1sSYN5untaKBdxrcuEIeWqaj5rYWUWh6dN09fHrHyFMF0fYwNZIsnvBt
KZ+9pSecD3tm1nWzEWsiotFpMp1AeiIr5eLPsCEDl1FZViGEKu8sBQWFytAwHvpJ
rV4sB5abxjfrB76BJpJUx9uQljshd6NAA4uF52B7nk5W9W+RRFLHIu8j9sHy7kE/
J/gsz6Ytu7pMXi8E8VNmrmYK5o1GiGeCVNrokRbAdnSbQfElz06rdYyL9LtnjB2J
W66PPtdf9o75yJCsm9Bfe3RO0w/V/LGrDIkwgcbSzWvHBv6avAzNciUZ6KwS+5hV
R6ODtT63/PQ+2QTTTv4X
=CT5y
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Nov_2011_14_24_23_+1100_LO64QX1OFK27VPD+--
