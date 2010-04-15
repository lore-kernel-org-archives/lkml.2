Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0DOBnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 21:43:41 -0400
Received: from smtp-out.google.com ([74.125.121.35]:1499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab0DOBnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 21:43:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=F4FkBEFozW07LXBsdENz59XzcfXZudKEkHd8QWtpvCr4DYIs2TU2EjCKiYzluTGpK
	llnBPrnbknRTbIr5MG5rQ==
MIME-Version: 1.0
Date: Wed, 14 Apr 2010 18:43:32 -0700
Message-ID: <g2ida824cf31004141843p41f7b21fz25927e3c6faeeed7@mail.gmail.com>
Subject: [PATCH] 2.6.34-rc3 v2 Disable R_OK (Early ACK) on SII 3726 PMP
From: Grant Grundler <grundler@google.com>
To: Linux IDE mailing list <linux-ide@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e640d17482202504843c9f45
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e640d17482202504843c9f45
Content-Type: text/plain; charset=UTF-8

In 2009, While running "cache read" performance test of drives behind
SII PMP we encountered a "all 5 drives" timeout on more than 30% of the
machines under test.  This patch reduces the rate by a factor of about 70.
Low enough that we didn't care to further investigate the issue.

Performance impact with any sort of "normal" use was ~2%+ CPU and less
than 1% throughput degradation.  Worst case impact (cached read) was
6% IOPS reduction. This is with NCQ off (q=1) but I believe FIS based
switching enabled in the SATA driver.

The patch disables "Early ACK" in the 3726 port multiplier.
"Early ACK" is issued when device sends a FIS to the host (via PMP)
and the PMP sends an ACK immediately back to the device - well before
the host gets the response. Under worst case IOPs load (cached read
test) and more than 2 PMPs connected to a 4-port SATA controller,
I suspect the time to service all of the PMPs is exceeding the PMPs
ability to keep track of outstanding FIS it owes the Host. Reducing
the number of PMPs to 2 (or 1) reduces the frequency by several orders
of magnitude. Kudos to Gwendal for initial debugging of this issue.
[Any errors in the description are mine, not his.]

Patch is currently in production on Google servers.

Signed-off-by: Grant Grundler <grundler@google.com>
Signed-off-by: Gwendal Grignou <gwendal@google.com>
Acked-by: Tejun Heo <tj@kernel.org>

---

v2: dropped references to 4726 since I didn't test 4726,
    moved register definition directly into libata-pmp.c, and
    expanded the comment in the code to summarize the above description.

Code below is white space mangled. Please use attached file.

diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 00305f4..487227a 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -231,10 +231,14 @@ static const char *sata_pmp_spec_rev_str(const u32 *gscr)
        return "<unknown>";
 }

+#define PMP_GSCR_SII_POL 129
+
 static int sata_pmp_configure(struct ata_device *dev, int print_info)
 {
        struct ata_port *ap = dev->link->ap;
        u32 *gscr = dev->gscr;
+       u16 vendor = sata_pmp_gscr_vendor(gscr);
+       u16 devid = sata_pmp_gscr_devid(gscr);
        unsigned int err_mask = 0;
        const char *reason;
        int nr_ports, rc;
@@ -260,12 +264,34 @@ static int sata_pmp_configure(struct ata_device
*dev, int print_info)
                goto fail;
        }

+       /* Disable sending Early R_OK.
+        * With "cached read" HDD testing and multiple ports busy on a SATA
+        * host controller, 3726 PMP will very rarely drop a deferred
+        * R_OK that was intended for the host. Symptom will be all
+        * 5 drives under test will timeout, get reset, and recover.
+        */
+       if (vendor == 0x1095 && devid == 0x3726) {
+               u32 reg;
+
+               err_mask = sata_pmp_read(&ap->link, PMP_GSCR_SII_POL, &reg);
+               if (err_mask) {
+                       rc = -EIO;
+                       reason = "failed to read Sil3726 Private Register";
+                       goto fail;
+               }
+               reg &= ~0x1;
+               err_mask = sata_pmp_write(&ap->link, PMP_GSCR_SII_POL, reg);
+               if (err_mask) {
+                       rc = -EIO;
+                       reason = "failed to write Sil3726 Private Register";
+                       goto fail;
+               }
+       }
+
        if (print_info) {
                ata_dev_printk(dev, KERN_INFO, "Port Multiplier %s, "
                               "0x%04x:0x%04x r%d, %d ports, feat 0x%x/0x%x\n",
-                              sata_pmp_spec_rev_str(gscr),
-                              sata_pmp_gscr_vendor(gscr),
-                              sata_pmp_gscr_devid(gscr),
+                              sata_pmp_spec_rev_str(gscr), vendor, devid,
                               sata_pmp_gscr_rev(gscr),
                               nr_ports, gscr[SATA_PMP_GSCR_FEAT_EN],
                               gscr[SATA_PMP_GSCR_FEAT]);

--0016e640d17482202504843c9f45
Content-Type: application/octet-stream; 
	name="2.6.34-rc3-libata_pmp-disable_ImdAck-04"
Content-Disposition: attachment; 
	filename="2.6.34-rc3-libata_pmp-disable_ImdAck-04"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g80wdrpm1

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2xpYmF0YS1wbXAuYyBiL2RyaXZlcnMvYXRhL2xpYmF0
YS1wbXAuYwppbmRleCAwMDMwNWY0Li40ODcyMjdhIDEwMDY0NAotLS0gYS9kcml2ZXJzL2F0YS9s
aWJhdGEtcG1wLmMKKysrIGIvZHJpdmVycy9hdGEvbGliYXRhLXBtcC5jCkBAIC0yMzEsMTAgKzIz
MSwxNCBAQCBzdGF0aWMgY29uc3QgY2hhciAqc2F0YV9wbXBfc3BlY19yZXZfc3RyKGNvbnN0IHUz
MiAqZ3NjcikKIAlyZXR1cm4gIjx1bmtub3duPiI7CiB9CiAKKyNkZWZpbmUgUE1QX0dTQ1JfU0lJ
X1BPTCAxMjkKKwogc3RhdGljIGludCBzYXRhX3BtcF9jb25maWd1cmUoc3RydWN0IGF0YV9kZXZp
Y2UgKmRldiwgaW50IHByaW50X2luZm8pCiB7CiAJc3RydWN0IGF0YV9wb3J0ICphcCA9IGRldi0+
bGluay0+YXA7CiAJdTMyICpnc2NyID0gZGV2LT5nc2NyOworCXUxNiB2ZW5kb3IgPSBzYXRhX3Bt
cF9nc2NyX3ZlbmRvcihnc2NyKTsKKwl1MTYgZGV2aWQgPSBzYXRhX3BtcF9nc2NyX2RldmlkKGdz
Y3IpOwogCXVuc2lnbmVkIGludCBlcnJfbWFzayA9IDA7CiAJY29uc3QgY2hhciAqcmVhc29uOwog
CWludCBucl9wb3J0cywgcmM7CkBAIC0yNjAsMTIgKzI2NCwzNCBAQCBzdGF0aWMgaW50IHNhdGFf
cG1wX2NvbmZpZ3VyZShzdHJ1Y3QgYXRhX2RldmljZSAqZGV2LCBpbnQgcHJpbnRfaW5mbykKIAkJ
Z290byBmYWlsOwogCX0KIAorCS8qIERpc2FibGUgc2VuZGluZyBFYXJseSBSX09LLgorCSAqIFdp
dGggImNhY2hlZCByZWFkIiBIREQgdGVzdGluZyBhbmQgbXVsdGlwbGUgcG9ydHMgYnVzeSBvbiBh
IFNBVEEKKwkgKiBob3N0IGNvbnRyb2xsZXIsIDM3MjYgUE1QIHdpbGwgdmVyeSByYXJlbHkgZHJv
cCBhIGRlZmVycmVkCisJICogUl9PSyB0aGF0IHdhcyBpbnRlbmRlZCBmb3IgdGhlIGhvc3QuIFN5
bXB0b20gd2lsbCBiZSBhbGwKKwkgKiA1IGRyaXZlcyB1bmRlciB0ZXN0IHdpbGwgdGltZW91dCwg
Z2V0IHJlc2V0LCBhbmQgcmVjb3Zlci4KKwkgKi8KKwlpZiAodmVuZG9yID09IDB4MTA5NSAmJiBk
ZXZpZCA9PSAweDM3MjYpIHsKKwkJdTMyIHJlZzsKKworCQllcnJfbWFzayA9IHNhdGFfcG1wX3Jl
YWQoJmFwLT5saW5rLCBQTVBfR1NDUl9TSUlfUE9MLCAmcmVnKTsKKwkJaWYgKGVycl9tYXNrKSB7
CisJCQlyYyA9IC1FSU87CisJCQlyZWFzb24gPSAiZmFpbGVkIHRvIHJlYWQgU2lsMzcyNiBQcml2
YXRlIFJlZ2lzdGVyIjsKKwkJCWdvdG8gZmFpbDsKKwkJfQorCQlyZWcgJj0gfjB4MTsKKwkJZXJy
X21hc2sgPSBzYXRhX3BtcF93cml0ZSgmYXAtPmxpbmssIFBNUF9HU0NSX1NJSV9QT0wsIHJlZyk7
CisJCWlmIChlcnJfbWFzaykgeworCQkJcmMgPSAtRUlPOworCQkJcmVhc29uID0gImZhaWxlZCB0
byB3cml0ZSBTaWwzNzI2IFByaXZhdGUgUmVnaXN0ZXIiOworCQkJZ290byBmYWlsOworCQl9CisJ
fQorCiAJaWYgKHByaW50X2luZm8pIHsKIAkJYXRhX2Rldl9wcmludGsoZGV2LCBLRVJOX0lORk8s
ICJQb3J0IE11bHRpcGxpZXIgJXMsICIKIAkJCSAgICAgICAiMHglMDR4OjB4JTA0eCByJWQsICVk
IHBvcnRzLCBmZWF0IDB4JXgvMHgleFxuIiwKLQkJCSAgICAgICBzYXRhX3BtcF9zcGVjX3Jldl9z
dHIoZ3NjciksCi0JCQkgICAgICAgc2F0YV9wbXBfZ3Njcl92ZW5kb3IoZ3NjciksCi0JCQkgICAg
ICAgc2F0YV9wbXBfZ3Njcl9kZXZpZChnc2NyKSwKKwkJCSAgICAgICBzYXRhX3BtcF9zcGVjX3Jl
dl9zdHIoZ3NjciksIHZlbmRvciwgZGV2aWQsCiAJCQkgICAgICAgc2F0YV9wbXBfZ3Njcl9yZXYo
Z3NjciksCiAJCQkgICAgICAgbnJfcG9ydHMsIGdzY3JbU0FUQV9QTVBfR1NDUl9GRUFUX0VOXSwK
IAkJCSAgICAgICBnc2NyW1NBVEFfUE1QX0dTQ1JfRkVBVF0pOwo=
--0016e640d17482202504843c9f45--
