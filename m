Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030228Ab2HWHgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:36:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:3858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030215Ab2HWHgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:36:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,299,1344236400"; 
   d="asc'?scan'208,223";a="184400689"
Message-ID: <1345707689.2848.203.camel@sauron.fi.intel.com>
Subject: Re: JFFS2 issue with v3.5.x and later on Atmel chips at least (was:
 Kernel oops since v3.5.x on Atmel chips)
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: "ludovic.desroches" <ludovic.desroches@atmel.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mtd@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Thu, 23 Aug 2012 10:41:29 +0300
In-Reply-To: <5034F3F8.9080802@atmel.com>
References: <5034B45A.5060107@atmel.com> <5034F3F8.9080802@atmel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-BPHXsA/Sa4cHsGCzuXbV"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BPHXsA/Sa4cHsGCzuXbV
Content-Type: multipart/mixed; boundary="=-aW7etfJgAUtW8B1UkdwX"


--=-aW7etfJgAUtW8B1UkdwX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Thu, 23 Aug 2012 10:10:07 +0300
Subject: [PATCH] JFFS2: fix unmount regression

This patch fixes regression introduced by
"8bdc81c jffs2: get rid of jffs2_sync_super". We submit a delayed work in o=
rder
to make sure the write-buffer is synchronized at some point. But we do not
flush it when we unmount, which causes an oops when we unmount the file-sys=
tem
and then the delayed work is executed.

This patch fixes the issue by adding a "cancel_delayed_work_sync()" infocat=
ion
in the '->sync_fs()' handler. This will make sure the delayed work is cance=
led
on sync, unmount and re-mount. And because VFS always callse 'sync_fs()' be=
fore
unmounting or remounting, this fixes the issue.

Reported-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: stable@vger.kernel.org [3.5+]
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

Ludovic, would you please give this patch a test? Also attached.

 fs/jffs2/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 61ea413..e385fa3 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -100,6 +100,9 @@ static int jffs2_sync_fs(struct super_block *sb, int wa=
it)
 {
 	struct jffs2_sb_info *c =3D JFFS2_SB_INFO(sb);
=20
+	if (IS_ENABLED(CONFIG_JFFS2_FS_WRITEBUFFER))
+		cancel_delayed_work_sync(&c->wbuf_dwork);
+
 	mutex_lock(&c->alloc_sem);
 	jffs2_flush_wbuf_pad(c);
 	mutex_unlock(&c->alloc_sem);
--=20
1.7.10.4

--=-aW7etfJgAUtW8B1UkdwX
Content-Disposition: attachment; filename="0001-JFFS2-fix-unmount-regression.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="0001-JFFS2-fix-unmount-regression.patch";
	charset="UTF-8"

RnJvbSAyZjE1NTRkMDFmN2RiNTg2MzFmOWRhN2RkMTlhNzI1NGQxMDk2ZmViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogQXJ0ZW0gQml0eXV0c2tpeSA8YXJ0ZW0uYml0eXV0c2tpeUBs
aW51eC5pbnRlbC5jb20+DQpEYXRlOiBUaHUsIDIzIEF1ZyAyMDEyIDEwOjEwOjA3ICswMzAwDQpT
dWJqZWN0OiBbUEFUQ0hdIEpGRlMyOiBmaXggdW5tb3VudCByZWdyZXNzaW9uDQoNClRoaXMgcGF0
Y2ggZml4ZXMgcmVncmVzc2lvbiBpbnRyb2R1Y2VkIGJ5DQoiOGJkYzgxYyBqZmZzMjogZ2V0IHJp
ZCBvZiBqZmZzMl9zeW5jX3N1cGVyIi4gV2Ugc3VibWl0IGEgZGVsYXllZCB3b3JrIGluIG9yZGVy
DQp0byBtYWtlIHN1cmUgdGhlIHdyaXRlLWJ1ZmZlciBpcyBzeW5jaHJvbml6ZWQgYXQgc29tZSBw
b2ludC4gQnV0IHdlIGRvIG5vdA0KZmx1c2ggaXQgd2hlbiB3ZSB1bm1vdW50LCB3aGljaCBjYXVz
ZXMgYW4gb29wcyB3aGVuIHdlIHVubW91bnQgdGhlIGZpbGUtc3lzdGVtDQphbmQgdGhlbiB0aGUg
ZGVsYXllZCB3b3JrIGlzIGV4ZWN1dGVkLg0KDQpUaGlzIHBhdGNoIGZpeGVzIHRoZSBpc3N1ZSBi
eSBhZGRpbmcgYSAiY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCkiIGluZm9jYXRpb24NCmluIHRo
ZSAnLT5zeW5jX2ZzKCknIGhhbmRsZXIuIFRoaXMgd2lsbCBtYWtlIHN1cmUgdGhlIGRlbGF5ZWQg
d29yayBpcyBjYW5jZWxlZA0Kb24gc3luYywgdW5tb3VudCBhbmQgcmUtbW91bnQuIEFuZCBiZWNh
dXNlIFZGUyBhbHdheXMgY2FsbHNlICdzeW5jX2ZzKCknIGJlZm9yZQ0KdW5tb3VudGluZyBvciBy
ZW1vdW50aW5nLCB0aGlzIGZpeGVzIHRoZSBpc3N1ZS4NCg0KUmVwb3J0ZWQtYnk6IEx1ZG92aWMg
RGVzcm9jaGVzIDxsdWRvdmljLmRlc3JvY2hlc0BhdG1lbC5jb20+DQpDYzogc3RhYmxlQHZnZXIu
a2VybmVsLm9yZyBbMy41K10NClNpZ25lZC1vZmYtYnk6IEFydGVtIEJpdHl1dHNraXkgPGFydGVt
LmJpdHl1dHNraXlAbGludXguaW50ZWwuY29tPg0KLS0tDQogZnMvamZmczIvc3VwZXIuYyB8ICAg
IDMgKysrDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEv
ZnMvamZmczIvc3VwZXIuYyBiL2ZzL2pmZnMyL3N1cGVyLmMNCmluZGV4IDYxZWE0MTMuLmUzODVm
YTMgMTAwNjQ0DQotLS0gYS9mcy9qZmZzMi9zdXBlci5jDQorKysgYi9mcy9qZmZzMi9zdXBlci5j
DQpAQCAtMTAwLDYgKzEwMCw5IEBAIHN0YXRpYyBpbnQgamZmczJfc3luY19mcyhzdHJ1Y3Qgc3Vw
ZXJfYmxvY2sgKnNiLCBpbnQgd2FpdCkNCiB7DQogCXN0cnVjdCBqZmZzMl9zYl9pbmZvICpjID0g
SkZGUzJfU0JfSU5GTyhzYik7DQogDQorCWlmIChJU19FTkFCTEVEKENPTkZJR19KRkZTMl9GU19X
UklURUJVRkZFUikpDQorCQljYW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJmMtPndidWZfZHdvcmsp
Ow0KKw0KIAltdXRleF9sb2NrKCZjLT5hbGxvY19zZW0pOw0KIAlqZmZzMl9mbHVzaF93YnVmX3Bh
ZChjKTsNCiAJbXV0ZXhfdW5sb2NrKCZjLT5hbGxvY19zZW0pOw0KLS0gDQoxLjcuMTAuNA0KDQo=


--=-aW7etfJgAUtW8B1UkdwX--

--=-BPHXsA/Sa4cHsGCzuXbV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQNd6pAAoJECmIfjd9wqK0tXwP/RtxVKS+XBwtlT3vCS+R9+nl
ZuTLlujkgMrRWrbHGfOljxhWUra3g9XbZZLrd9LK4krBrA4XqIivjcaMTdte/bmZ
3NaL8BPhq3XuhbSWZiG+wyulhzzvfL4JvzJKDlZkG4QpV6+ZDEc9eg2Is6djET2Z
Q6E3q/sVfmEi4X7UIYjABL2fjISglcCwrFKTV3eiM5aNjXTL3jzML7kr+H+NjULG
5iRYEzVCjWP4z0rHsxtaAVm83YEfF0qKMvl/6H8zjphj2HpLQYHjlDZJ4B1Pge+N
BOGNe7D4IDvgMvDfvg020IY2OYxYlWoaJsJ298DO0FTwKICZCbs2TnLkyNIlekDe
8TtaLa8W15nsCmxCJkwplFS3z8GZv0a6pmh+iwWIJzvgAIgYRwoHVHYlS97n+smA
Wl2K5hJtD7xLJgc6CwnMs/6fB7KSv5rHg+TPJiNs3AaQz9kRs23BSSr/95w0W7vU
s9tnvpXptw73AoPXX37WnDWU5x5nqZKu+ssHangJ5En0JFjyMx6ys5ARPfaNeHxV
3MaXq+s0cmRXPkswXLDSScxny0t32gVYIgnsByX4LhgPMBQPas7fYiXbVEYY0h57
rZuEOO5C3mOUHwLbn3p5r3LlAGnUfwKRk9rjq30lv1BtNI6WFK2VgCjDWp1OVhD7
zgax5sZ2KxIXL5MKbK2C
=c/GY
-----END PGP SIGNATURE-----

--=-BPHXsA/Sa4cHsGCzuXbV--

