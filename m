Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2FKDzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:55:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:42469 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab2FKDzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:55:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="154548846"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] xen/mce: Add mutex lock and buffer to avoid sleep in
 atomic context
Thread-Topic: [PATCH] xen/mce: Add mutex lock and buffer to avoid sleep in
 atomic context
Thread-Index: Ac1FWkRWxEyD+XUzS/eqorQpXCRDrwCKowEg
Date: Mon, 11 Jun 2012 03:55:00 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335225796@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335221654@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335221654@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335225796SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335225796SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Liu, Jinsong wrote:
> From a9c5f29330a056291356b912816b5b2e0e061a30 Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Sat, 9 Jun 2012 00:56:46 +0800
> Subject: [PATCH] xen/mce: Add mutex lock and buffer to avoid sleep in
> atomic context=20
>=20

Sorry, I update the patch a little, for spinlock to avoid deadlock.

Thanks,
Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>From db6c0ac9372c6fbc3637ec4216830e7ee01b31aa Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Mon, 11 Jun 2012 19:21:24 +0800
Subject: [PATCH] xen/mce: Add mutex lock and buffer to avoid sleep in atomi=
c context

copy_to_user might sleep and print a stack trace if it is executed
in an atomic spinlock context. This patch add a mutex lock and a
buffer to avoid the issue.

This patch also change the manipulation of mcelog_lock from
spin_lock_irqsave to spin_trylock to avoid deadlock, since
mcelog_lock is used at normal process context and
mce context (which is async exception context that could
not protected by spin_lock_irqsave). When fail to get spinlock,
mc_info would be transferred by hypervisor next time.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/mcelog.c |   38 +++++++++++++++++++++++++++++++-------
 1 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
index 72e87d2..fac29e4 100644
--- a/drivers/xen/mcelog.c
+++ b/drivers/xen/mcelog.c
@@ -56,12 +56,14 @@ static struct mcinfo_logical_cpu *g_physinfo;
 static uint32_t ncpus;
=20
 static DEFINE_SPINLOCK(mcelog_lock);
+static DEFINE_MUTEX(xen_mce_chrdev_read_mutex);
=20
 static struct xen_mce_log xen_mcelog =3D {
 	.signature	=3D XEN_MCE_LOG_SIGNATURE,
 	.len		=3D XEN_MCE_LOG_LEN,
 	.recordlen	=3D sizeof(struct xen_mce),
 };
+static struct xen_mce_log xen_mcelog_u;
=20
 static DEFINE_SPINLOCK(xen_mce_chrdev_state_lock);
 static int xen_mce_chrdev_open_count;	/* #times opened */
@@ -106,9 +108,19 @@ static ssize_t xen_mce_chrdev_read(struct file *filp, =
char __user *ubuf,
 	unsigned num;
 	int i, err;
=20
+	/*
+	 * copy_to_user might sleep and print a stack trace
+	 * if it is executed in an atomic spinlock context
+	 */
+	mutex_lock(&xen_mce_chrdev_read_mutex);
+
 	spin_lock(&mcelog_lock);
+	memcpy(&xen_mcelog_u, &xen_mcelog, sizeof(struct xen_mce_log));
=20
 	num =3D xen_mcelog.next;
+	memset(xen_mcelog.entry, 0, num * sizeof(struct xen_mce));
+	xen_mcelog.next =3D 0;
+	spin_unlock(&mcelog_lock);
=20
 	/* Only supports full reads right now */
 	err =3D -EINVAL;
@@ -117,20 +129,20 @@ static ssize_t xen_mce_chrdev_read(struct file *filp,=
 char __user *ubuf,
=20
 	err =3D 0;
 	for (i =3D 0; i < num; i++) {
-		struct xen_mce *m =3D &xen_mcelog.entry[i];
+		struct xen_mce *m =3D &xen_mcelog_u.entry[i];
=20
 		err |=3D copy_to_user(buf, m, sizeof(*m));
 		buf +=3D sizeof(*m);
 	}
=20
-	memset(xen_mcelog.entry, 0, num * sizeof(struct xen_mce));
-	xen_mcelog.next =3D 0;
+	memset(xen_mcelog_u.entry, 0, num * sizeof(struct xen_mce));
+	xen_mcelog_u.next =3D 0;
=20
 	if (err)
 		err =3D -EFAULT;
=20
 out:
-	spin_unlock(&mcelog_lock);
+	mutex_unlock(&xen_mce_chrdev_read_mutex);
=20
 	return err ? err : buf - ubuf;
 }
@@ -313,9 +325,21 @@ static int mc_queue_handle(uint32_t flags)
 static irqreturn_t xen_mce_interrupt(int irq, void *dev_id)
 {
 	int err;
-	unsigned long tmp;
=20
-	spin_lock_irqsave(&mcelog_lock, tmp);
+	/*
+	 * mcelog_lock is used at normal process context and
+	 * mce context (which is async exception context that could
+	 * not protected by spin_lock_irqsave).
+	 *
+	 * use spin_trylock to avoid deadlock. When fail to get spinlock,
+	 * mc_info would be transferred by hypervisor next time.
+	 */
+	if (unlikely(!spin_trylock(&mcelog_lock))) {
+		pr_err(XEN_MCELOG
+		       "Failed to get mcelog_lock, mc_info would "
+		       "be transferred by hypervisor next time.\n");
+		return IRQ_NONE;
+	}
=20
 	/* urgent mc_info */
 	err =3D mc_queue_handle(XEN_MC_URGENT);
@@ -330,7 +354,7 @@ static irqreturn_t xen_mce_interrupt(int irq, void *dev=
_id)
 		pr_err(XEN_MCELOG
 		       "Failed to handle nonurgent mc_info queue.\n");
=20
-	spin_unlock_irqrestore(&mcelog_lock, tmp);
+	spin_unlock(&mcelog_lock);
=20
 	return IRQ_HANDLED;
 }
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC8292335225796SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-xen-mce-Add-mutex-lock-and-buffer-to-avoid-sleep-in-.patch"
Content-Description: 0001-xen-mce-Add-mutex-lock-and-buffer-to-avoid-sleep-in-.patch
Content-Disposition: attachment;
	filename="0001-xen-mce-Add-mutex-lock-and-buffer-to-avoid-sleep-in-.patch";
	size=3858; creation-date="Mon, 11 Jun 2012 03:45:27 GMT";
	modification-date="Mon, 11 Jun 2012 11:39:54 GMT"
Content-Transfer-Encoding: base64

RnJvbSBkYjZjMGFjOTM3MmM2ZmJjMzYzN2VjNDIxNjgzMGU3ZWUwMWIzMWFhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogTW9uLCAxMSBKdW4gMjAxMiAxOToyMToyNCArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHhl
bi9tY2U6IEFkZCBtdXRleCBsb2NrIGFuZCBidWZmZXIgdG8gYXZvaWQgc2xlZXAgaW4gYXRvbWlj
IGNvbnRleHQKCmNvcHlfdG9fdXNlciBtaWdodCBzbGVlcCBhbmQgcHJpbnQgYSBzdGFjayB0cmFj
ZSBpZiBpdCBpcyBleGVjdXRlZAppbiBhbiBhdG9taWMgc3BpbmxvY2sgY29udGV4dC4gVGhpcyBw
YXRjaCBhZGQgYSBtdXRleCBsb2NrIGFuZCBhCmJ1ZmZlciB0byBhdm9pZCB0aGUgaXNzdWUuCgpU
aGlzIHBhdGNoIGFsc28gY2hhbmdlIHRoZSBtYW5pcHVsYXRpb24gb2YgbWNlbG9nX2xvY2sgZnJv
bQpzcGluX2xvY2tfaXJxc2F2ZSB0byBzcGluX3RyeWxvY2sgdG8gYXZvaWQgZGVhZGxvY2ssIHNp
bmNlCm1jZWxvZ19sb2NrIGlzIHVzZWQgYXQgbm9ybWFsIHByb2Nlc3MgY29udGV4dCBhbmQKbWNl
IGNvbnRleHQgKHdoaWNoIGlzIGFzeW5jIGV4Y2VwdGlvbiBjb250ZXh0IHRoYXQgY291bGQKbm90
IHByb3RlY3RlZCBieSBzcGluX2xvY2tfaXJxc2F2ZSkuIFdoZW4gZmFpbCB0byBnZXQgc3Bpbmxv
Y2ssCm1jX2luZm8gd291bGQgYmUgdHJhbnNmZXJyZWQgYnkgaHlwZXJ2aXNvciBuZXh0IHRpbWUu
CgpSZXBvcnRlZC1ieTogS29ucmFkIFJ6ZXN6dXRlayBXaWxrIDxrb25yYWQud2lsa0BvcmFjbGUu
Y29tPgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
LS0tCiBkcml2ZXJzL3hlbi9tY2Vsb2cuYyB8ICAgMzggKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgMzEgaW5zZXJ0aW9ucygrKSwgNyBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9tY2Vsb2cuYyBiL2RyaXZlcnMveGVu
L21jZWxvZy5jCmluZGV4IDcyZTg3ZDIuLmZhYzI5ZTQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMveGVu
L21jZWxvZy5jCisrKyBiL2RyaXZlcnMveGVuL21jZWxvZy5jCkBAIC01NiwxMiArNTYsMTQgQEAg
c3RhdGljIHN0cnVjdCBtY2luZm9fbG9naWNhbF9jcHUgKmdfcGh5c2luZm87CiBzdGF0aWMgdWlu
dDMyX3QgbmNwdXM7CiAKIHN0YXRpYyBERUZJTkVfU1BJTkxPQ0sobWNlbG9nX2xvY2spOworc3Rh
dGljIERFRklORV9NVVRFWCh4ZW5fbWNlX2NocmRldl9yZWFkX211dGV4KTsKIAogc3RhdGljIHN0
cnVjdCB4ZW5fbWNlX2xvZyB4ZW5fbWNlbG9nID0gewogCS5zaWduYXR1cmUJPSBYRU5fTUNFX0xP
R19TSUdOQVRVUkUsCiAJLmxlbgkJPSBYRU5fTUNFX0xPR19MRU4sCiAJLnJlY29yZGxlbgk9IHNp
emVvZihzdHJ1Y3QgeGVuX21jZSksCiB9Oworc3RhdGljIHN0cnVjdCB4ZW5fbWNlX2xvZyB4ZW5f
bWNlbG9nX3U7CiAKIHN0YXRpYyBERUZJTkVfU1BJTkxPQ0soeGVuX21jZV9jaHJkZXZfc3RhdGVf
bG9jayk7CiBzdGF0aWMgaW50IHhlbl9tY2VfY2hyZGV2X29wZW5fY291bnQ7CS8qICN0aW1lcyBv
cGVuZWQgKi8KQEAgLTEwNiw5ICsxMDgsMTkgQEAgc3RhdGljIHNzaXplX3QgeGVuX21jZV9jaHJk
ZXZfcmVhZChzdHJ1Y3QgZmlsZSAqZmlscCwgY2hhciBfX3VzZXIgKnVidWYsCiAJdW5zaWduZWQg
bnVtOwogCWludCBpLCBlcnI7CiAKKwkvKgorCSAqIGNvcHlfdG9fdXNlciBtaWdodCBzbGVlcCBh
bmQgcHJpbnQgYSBzdGFjayB0cmFjZQorCSAqIGlmIGl0IGlzIGV4ZWN1dGVkIGluIGFuIGF0b21p
YyBzcGlubG9jayBjb250ZXh0CisJICovCisJbXV0ZXhfbG9jaygmeGVuX21jZV9jaHJkZXZfcmVh
ZF9tdXRleCk7CisKIAlzcGluX2xvY2soJm1jZWxvZ19sb2NrKTsKKwltZW1jcHkoJnhlbl9tY2Vs
b2dfdSwgJnhlbl9tY2Vsb2csIHNpemVvZihzdHJ1Y3QgeGVuX21jZV9sb2cpKTsKIAogCW51bSA9
IHhlbl9tY2Vsb2cubmV4dDsKKwltZW1zZXQoeGVuX21jZWxvZy5lbnRyeSwgMCwgbnVtICogc2l6
ZW9mKHN0cnVjdCB4ZW5fbWNlKSk7CisJeGVuX21jZWxvZy5uZXh0ID0gMDsKKwlzcGluX3VubG9j
aygmbWNlbG9nX2xvY2spOwogCiAJLyogT25seSBzdXBwb3J0cyBmdWxsIHJlYWRzIHJpZ2h0IG5v
dyAqLwogCWVyciA9IC1FSU5WQUw7CkBAIC0xMTcsMjAgKzEyOSwyMCBAQCBzdGF0aWMgc3NpemVf
dCB4ZW5fbWNlX2NocmRldl9yZWFkKHN0cnVjdCBmaWxlICpmaWxwLCBjaGFyIF9fdXNlciAqdWJ1
ZiwKIAogCWVyciA9IDA7CiAJZm9yIChpID0gMDsgaSA8IG51bTsgaSsrKSB7Ci0JCXN0cnVjdCB4
ZW5fbWNlICptID0gJnhlbl9tY2Vsb2cuZW50cnlbaV07CisJCXN0cnVjdCB4ZW5fbWNlICptID0g
Jnhlbl9tY2Vsb2dfdS5lbnRyeVtpXTsKIAogCQllcnIgfD0gY29weV90b191c2VyKGJ1ZiwgbSwg
c2l6ZW9mKCptKSk7CiAJCWJ1ZiArPSBzaXplb2YoKm0pOwogCX0KIAotCW1lbXNldCh4ZW5fbWNl
bG9nLmVudHJ5LCAwLCBudW0gKiBzaXplb2Yoc3RydWN0IHhlbl9tY2UpKTsKLQl4ZW5fbWNlbG9n
Lm5leHQgPSAwOworCW1lbXNldCh4ZW5fbWNlbG9nX3UuZW50cnksIDAsIG51bSAqIHNpemVvZihz
dHJ1Y3QgeGVuX21jZSkpOworCXhlbl9tY2Vsb2dfdS5uZXh0ID0gMDsKIAogCWlmIChlcnIpCiAJ
CWVyciA9IC1FRkFVTFQ7CiAKIG91dDoKLQlzcGluX3VubG9jaygmbWNlbG9nX2xvY2spOworCW11
dGV4X3VubG9jaygmeGVuX21jZV9jaHJkZXZfcmVhZF9tdXRleCk7CiAKIAlyZXR1cm4gZXJyID8g
ZXJyIDogYnVmIC0gdWJ1ZjsKIH0KQEAgLTMxMyw5ICszMjUsMjEgQEAgc3RhdGljIGludCBtY19x
dWV1ZV9oYW5kbGUodWludDMyX3QgZmxhZ3MpCiBzdGF0aWMgaXJxcmV0dXJuX3QgeGVuX21jZV9p
bnRlcnJ1cHQoaW50IGlycSwgdm9pZCAqZGV2X2lkKQogewogCWludCBlcnI7Ci0JdW5zaWduZWQg
bG9uZyB0bXA7CiAKLQlzcGluX2xvY2tfaXJxc2F2ZSgmbWNlbG9nX2xvY2ssIHRtcCk7CisJLyoK
KwkgKiBtY2Vsb2dfbG9jayBpcyB1c2VkIGF0IG5vcm1hbCBwcm9jZXNzIGNvbnRleHQgYW5kCisJ
ICogbWNlIGNvbnRleHQgKHdoaWNoIGlzIGFzeW5jIGV4Y2VwdGlvbiBjb250ZXh0IHRoYXQgY291
bGQKKwkgKiBub3QgcHJvdGVjdGVkIGJ5IHNwaW5fbG9ja19pcnFzYXZlKS4KKwkgKgorCSAqIHVz
ZSBzcGluX3RyeWxvY2sgdG8gYXZvaWQgZGVhZGxvY2suIFdoZW4gZmFpbCB0byBnZXQgc3Bpbmxv
Y2ssCisJICogbWNfaW5mbyB3b3VsZCBiZSB0cmFuc2ZlcnJlZCBieSBoeXBlcnZpc29yIG5leHQg
dGltZS4KKwkgKi8KKwlpZiAodW5saWtlbHkoIXNwaW5fdHJ5bG9jaygmbWNlbG9nX2xvY2spKSkg
eworCQlwcl9lcnIoWEVOX01DRUxPRworCQkgICAgICAgIkZhaWxlZCB0byBnZXQgbWNlbG9nX2xv
Y2ssIG1jX2luZm8gd291bGQgIgorCQkgICAgICAgImJlIHRyYW5zZmVycmVkIGJ5IGh5cGVydmlz
b3IgbmV4dCB0aW1lLlxuIik7CisJCXJldHVybiBJUlFfTk9ORTsKKwl9CiAKIAkvKiB1cmdlbnQg
bWNfaW5mbyAqLwogCWVyciA9IG1jX3F1ZXVlX2hhbmRsZShYRU5fTUNfVVJHRU5UKTsKQEAgLTMz
MCw3ICszNTQsNyBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgeGVuX21jZV9pbnRlcnJ1cHQoaW50IGly
cSwgdm9pZCAqZGV2X2lkKQogCQlwcl9lcnIoWEVOX01DRUxPRwogCQkgICAgICAgIkZhaWxlZCB0
byBoYW5kbGUgbm9udXJnZW50IG1jX2luZm8gcXVldWUuXG4iKTsKIAotCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJm1jZWxvZ19sb2NrLCB0bXApOworCXNwaW5fdW5sb2NrKCZtY2Vsb2dfbG9jayk7
CiAKIAlyZXR1cm4gSVJRX0hBTkRMRUQ7CiB9Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC8292335225796SHSMSX101ccrcorpi_--
