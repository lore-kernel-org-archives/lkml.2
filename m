Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0DNAqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:46:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25559 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0DNAqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:46:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=DnjJL98F4gOWRWRrxKoqChjI7Sbg6DcYttLhlwMwcv0NPh/S3CGa9eDqkbJWOGAMj
	R8hkpYA37TQxoSPhd7rcw==
MIME-Version: 1.0
Date: Tue, 13 Apr 2010 17:46:11 -0700
Message-ID: <m2gda824cf31004131746o15be77b1n7af6fac42ce25280@mail.gmail.com>
Subject: [PATCH] 2.6.34-rc3 Disable R_OK (Early ACK) on SII 3726/4726 PMP
From: Grant Grundler <grundler@google.com>
To: Linux IDE mailing list <linux-ide@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016361e7e82c9c97c048427b48f
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016361e7e82c9c97c048427b48f
Content-Type: text/plain; charset=UTF-8

In 2009, While running "cache read" performance test of drives behind
SII PMP we encountered a "all 5 drives" timeout on more than 30% of the
machines under test.  This patch reduces the rate by a factor of about 70.
Low enough that we didn't care to further investigate the issue.

Performance impact with any sort of "normal" use was ~2%+ CPU and less
than 1% throughput degradation.  Worst case impact (cached read) was
6% IOPS reduction. This is with NCQ off (q=1) but I believe FIS based
switching enabled in the SATA driver.

The patch disables "Early ACK" in the 3726/4726 port multiplier.
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

---
And my apologies in advance for using gmail. Patch appended below
is also attached since I expect gmail will mangle the inlined content.

diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 00305f4..69bb203 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -235,6 +235,8 @@ static int sata_pmp_configure(struct ata_device
*dev, int print_info)
 {
        struct ata_port *ap = dev->link->ap;
        u32 *gscr = dev->gscr;
+       u16 vendor = sata_pmp_gscr_vendor(gscr);
+       u16 devid = sata_pmp_gscr_devid(gscr);
        unsigned int err_mask = 0;
        const char *reason;
        int nr_ports, rc;
@@ -260,12 +262,28 @@ static int sata_pmp_configure(struct ata_device
*dev, int print_info)
                goto fail;
        }

+       /* For Sil3726, disable sending Early R_OK */
+       if (vendor == 0x1095 && devid == 0x3726) {
+               u32 reg;
+               err_mask = sata_pmp_read(&ap->link,
SATA_PMP_GSCR_SII_POL, &reg);
+               if (err_mask) {
+                       rc = -EIO;
+                       reason = "failed to read Sil3726 Private Register";
+                       goto fail;
+               }
+               reg &= ~0x1;
+               err_mask = sata_pmp_write(&ap->link,
SATA_PMP_GSCR_SII_POL, reg);
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
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 700c5b9..18fc208 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -386,6 +386,7 @@ enum {
        SATA_PMP_GSCR_ERROR_EN  = 33,
        SATA_PMP_GSCR_FEAT      = 64,
        SATA_PMP_GSCR_FEAT_EN   = 96,
+       SATA_PMP_GSCR_SII_POL   = 129,  /* VENDOR : Silicon Image 3726/4726 */

        SATA_PMP_PSCR_STATUS    = 0,
        SATA_PMP_PSCR_ERROR     = 1,

--0016361e7e82c9c97c048427b48f
Content-Type: application/octet-stream; 
	name="2.6.18-mv_sata-measure_port_handler-03"
Content-Disposition: attachment; 
	filename="2.6.18-mv_sata-measure_port_handler-03"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g7zezu5r0

PT09PSAvL2RlcG90L2dvb2dsZV92ZW5kb3Jfc3JjX2JyYW5jaC9wcm9ka2VybmVsLzIuNi4xOC9k
cml2ZXJzL3Njc2kvbXZfc2F0YS9tdklBTENvbW1vblV0aWxzLmMjNiAtIC91c3IvbG9jYWwvZ29v
Z2xlL2dnZy0yLjYuMTgvMi42LjE4L2RyaXZlcnMvc2NzaS9tdl9zYXRhL212SUFMQ29tbW9uVXRp
bHMuYyA9PT09Ci0tLSAvdG1wL2c0LTI0NzE5L2NhY2hlL2RlcG90L2dvb2dsZV92ZW5kb3Jfc3Jj
X2JyYW5jaC9wcm9ka2VybmVsLzIuNi4xOC9kcml2ZXJzL3Njc2kvbXZfc2F0YS9tdklBTENvbW1v
blV0aWxzLmMjNgkyMDA5LTA3LTEwIDEyOjA4OjQ1LjAwMDAwMDAwMCAtMDcwMAorKysgL3Vzci9s
b2NhbC9nb29nbGUvZ2dnLTIuNi4xOC8yLjYuMTgvZHJpdmVycy9zY3NpL212X3NhdGEvbXZJQUxD
b21tb25VdGlscy5jCTIwMDktMDctMTAgMTI6MDg6MzQuMDAwMDAwMDAwIC0wNzAwCkBAIC05NjYs
NiArOTY2LDcgQEAgTVZfQk9PTEVBTiAgbXZHZXRQTURldmljZUluZm8oTVZfU0FUQV9BRAogICAg
IGlmIChwUE1EZXZpY2VJbmZvLT52ZW5kb3JJZCA9PSAweDEwOTUgJiYKIAkocFBNRGV2aWNlSW5m
by0+ZGV2aWNlSWQgPT0gMHgzNzI2IHx8CiAJIHBQTURldmljZUluZm8tPmRldmljZUlkID09IDB4
NDcyNikpIHsKKyNpZiAwCiAgICAgICAvKgogICAgICAgICogQnVnIDE0MTEzNDE6ICJDb21tYW5k
QWJvcnQgaW4gbXZfc2F0YSBkdXJpbmcgUEhZIHN0cmVzcyB0ZXN0IgogICAgICAgICogQ2xlYXIg
IkltbWVkaWF0ZSBBQ0sgZW5hYmxlIiBiaXQgc28gZnJhbWUgQUNLcyBhcmUgcmV0dXJuZWQKQEAg
LTk3Nyw2ICs5NzgsNyBAQCBNVl9CT09MRUFOICBtdkdldFBNRGV2aWNlSW5mbyhNVl9TQVRBX0FE
CiAgICAgICByZWdWYWwgJj0gfk1WX0JJVDA7CiAgICAgICBtdlBNRGV2V3JpdGVSZWcocFNhdGFB
ZGFwdGVyLCBjaGFubmVsSW5kZXgsIE1WX1NBVEFfUE1fQ09OVFJPTF9QT1JULAogICAgICAgICAg
ICAgICAgICAgICAgIDEyOSwgcmVnVmFsLCBOVUxMKTsKKyNlbmRpZgogCiAgICAgICByZWdWYWwg
PSA1OwogICAgICAgcG1fZ3Bpb19yZWcgPSBQTV9HU0NSX1NJTF9HUElPOwo9PT09IC8vZGVwb3Qv
Z29vZ2xlX3ZlbmRvcl9zcmNfYnJhbmNoL3Byb2RrZXJuZWwvMi42LjE4L2RyaXZlcnMvc2NzaS9t
dl9zYXRhL212U2F0YS5jIzE5IC0gL3Vzci9sb2NhbC9nb29nbGUvZ2dnLTIuNi4xOC8yLjYuMTgv
ZHJpdmVycy9zY3NpL212X3NhdGEvbXZTYXRhLmMgPT09PQotLS0gL3RtcC9nNC0yNDcxOS9jYWNo
ZS9kZXBvdC9nb29nbGVfdmVuZG9yX3NyY19icmFuY2gvcHJvZGtlcm5lbC8yLjYuMTgvZHJpdmVy
cy9zY3NpL212X3NhdGEvbXZTYXRhLmMjMTkJMjAwOS0wNy0xMCAxMDoyNTozNC4wMDAwMDAwMDAg
LTA3MDAKKysrIC91c3IvbG9jYWwvZ29vZ2xlL2dnZy0yLjYuMTgvMi42LjE4L2RyaXZlcnMvc2Nz
aS9tdl9zYXRhL212U2F0YS5jCTIwMDktMDctMTYgMjI6MTI6NTcuMDAwMDAwMDAwIC0wNzAwCkBA
IC03Nzc5LDYgKzc3NzksMTEgQEAgTVZfQk9PTEVBTiBtdlNhdGFDaGVja1BlbmRpbmdJbnRlcnJ1
cHQoTQogICAgIC8qYm9ndXMgaW50ZXJydXB0Ki8KICAgICByZXR1cm4gTVZfRkFMU0U7CiB9CisK
KyNpZiAxCisjZGVmaW5lIENQVV9NSFogMjIwMAkvKiBBcmdvLUJhcmNlbG9uYSAqLworI2VuZGlm
CisKIC8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqCiAqIG12U2F0YUludGVycnVwdFNlcnZpY2VSb3V0
aW5lIC0gSW50ZXJydXB0IHNlcnZpY2Ugcm91dGluZQogKgpAQCAtNzgwMCw3ICs3ODA1LDExIEBA
IE1WX0JPT0xFQU4gbXZTYXRhSW50ZXJydXB0U2VydmljZVJvdXRpbmUKIHsKICAgICBNVl9VOCAg
c2F0YVVuaXQ7CiAgICAgTVZfQlVTX0FERFJfVCBpb0Jhc2VBZGRyID0gcEFkYXB0ZXItPmFkYXB0
ZXJJb0Jhc2VBZGRyZXNzOwotCisjaWYgMQorICAgIGN5Y2xlc190IG12X2dhcCwgbXZfc3RhbXBb
NV07CisgICAgc3RhdGljIGN5Y2xlc190IG12X21heFs1XTsKKyAgICB1bnNpZ25lZCBjaGFyIG12
X2Z1bmNbNV07CisjZW5kaWYKICAgICBtdk9zU2VtVGFrZSgmcEFkYXB0ZXItPnNlbWFwaG9yZSk7
CiAKICAgICAvKiBQcmV2ZW50IGFueSBuZXcgaW50ZXJydXB0cyB1bnRpbCB3ZSBhcmUgZG9uZSBw
cm9jZXNzaW5nIGN1cnJlbnQgb25lLgpAQCAtNzgxNyw3ICs3ODI2LDE3IEBAIE1WX0JPT0xFQU4g
bXZTYXRhSW50ZXJydXB0U2VydmljZVJvdXRpbmUKIAkJCU1WX1NBVEFfSUlfQUxMX1BPUlRTX0lO
VF9DQVVTRV9SRUdfT0ZGU0VULCAwKTsKICAgICB9CiAKKyNpZiAxCittdl9zdGFtcFswXSA9IGdl
dF9jeWNsZXNfc3luYygpOworbXZfZnVuY1swXSA9IDA7Cittdl9mdW5jWzFdID0gMDsKK212X2Z1
bmNbMl0gPSAwOworbXZfZnVuY1szXSA9IDA7Cittdl9mdW5jWzRdID0gMDsKK3NhdGFVbml0ID0g
MDsKKyNlbHNlCiAgICAgZm9yIChzYXRhVW5pdCA9IDA7IHNhdGFVbml0IDwgcEFkYXB0ZXItPm51
bWJlck9mVW5pdHM7IHNhdGFVbml0KyspCisjZW5kaWYKICAgICB7CiAJTVZfVTMyIHVuaXRDYXVz
ZTsKIAlNVl9VMzIgdW5pdE1hc2sgPSBwQWRhcHRlci0+bWFpbk1hc2s7CkBAIC03ODM4LDcgKzc4
NTcsNyBAQCBNVl9CT09MRUFOIG12U2F0YUludGVycnVwdFNlcnZpY2VSb3V0aW5lCiAJICogKFRo
aXMgYWxzbyBmbHVzaGVzIHRoZSBwcmV2aW91cyBNTUlPIHdyaXRlLikgKi8KIAl1bml0Q2F1c2Ug
PSBNVl9SRUdfUkVBRF9EV09SRChpb0Jhc2VBZGRyLCB1bml0Q2F1c2VBZGRyKTsKIAotCS8qIGRl
cml2ZSBTQVRBSEMwIEludHIgQ2F1c2UgbWFzayBmcm9tIG1haW5NYXNrLgorCS8qIERlcml2ZSBT
QVRBSEMwIEludHIgQ2F1c2UgbWFzayBmcm9tIG1haW5NYXNrLgogCSAqIHR5cGljYWwgdmFsdWUg
b2YgbWFpbk1hc2sgaXMgMHgwMDA2YWI1NSAuCiAJICogRklYTUUgLSBtb3ZlIHRoaXMgb3V0IG9m
IGxpbmUgdG8gc2FtZSBwbGFjZXMgbWFpbk1hc2sgaXMgc2V0LgogCSAqLwpAQCAtNzg4NSw2ICs3
OTA0LDkgQEAgTVZfQk9PTEVBTiBtdlNhdGFJbnRlcnJ1cHRTZXJ2aWNlUm91dGluZQogCQlNVl9V
MzIgQVRBX2ludHIgPSAodW5pdENhdXNlID4+IDgpICYgcG9ydE1hc2s7CiAKICAgICAgICAgICAg
ICAgICBpZiAocmVzcG9uc2VEb25lKSB7CisjaWYgMQorCQkgICAgbXZfZnVuY1twb3J0XSB8PSAw
eDEwOworI2VuZGlmCiAgICAgICAgICAgICAgICAgICAgIGhhbmRsZUVkbWFJbnRlcnJ1cHQocEFk
YXB0ZXIsIHNhdGFVbml0LCBwb3J0LAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIChNVl9VOCkodW5pdFJzcEluUHRyKSwKICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICByZXNwb25zZURvbmUpOwpAQCAtNzkwMSwxNCArNzkyMyw1MiBAQCBNVl9C
T09MRUFOIG12U2F0YUludGVycnVwdFNlcnZpY2VSb3V0aW5lCiAKIAkJCWlmIChtYWluQ2F1c2Ug
JiAoMTw8KHBvcnQgKiAyKSkpIHsKIAkJCQloYW5kbGVFZG1hRXJyb3IocEFkYXB0ZXIsIE1WX0NI
QU5ORUxfSU5ERVgoc2F0YVVuaXQsIHBvcnQpKTsKKyNpZiAxCisJCQkJbXZfZnVuY1twb3J0XSB8
PSAweDI7CisjZW5kaWYKIAkJCX0gZWxzZSB7CiAJCQkJaGFuZGxlRGV2aWNlSW50ZXJydXB0KHBB
ZGFwdGVyLCBzYXRhVW5pdCwgcG9ydCk7CisjaWYgMQorCQkJCW12X2Z1bmNbcG9ydF0gfD0gMHg0
OworI2VuZGlmCiAJCQl9CiAgICAgICAgICAgICAgICAgfQogCiAgICAgICAgICAgICAgICAgdW5p
dFJzcEluUHRyID4+PSA4OworCisjaWYgMQorLyogcG9ydCsxID09IGVuZCB0aW1lLiBwb3J0ID09
IHN0YXJ0IHRpbWUuICovCittdl9zdGFtcFtwb3J0KzFdID0gZ2V0X2N5Y2xlc19zeW5jKCk7Cisj
ZW5kaWYKKyAgICAgICAgICAgIH0KKworI2lmIDEKKy8qIERlZmVyIHByaW50aW5nIHN0dWZmIHVu
dGlsIHdlJ3ZlIGhhbmRsZWQgZXZlcnl0aGluZy4gKi8KK2ZvciAocG9ydCA9IDA7IHBvcnQgPCBw
QWRhcHRlci0+cG9ydHNQZXJVbml0OyBwb3J0KyspCisgICB7CisJY3ljbGVzX3QgbXZfZ2FwID0g
bXZfc3RhbXBbcG9ydCsxXS1tdl9zdGFtcFtwb3J0XTsKKwlpZiAoIG12X2dhcCA+IG12X21heFtw
b3J0XSkgeworCQltdl9tYXhbcG9ydF0gPSBtdl9nYXA7CisJCXByaW50ayhLRVJOX0VSUiAibXZf
c2F0YTogU0FUQSVkLiVkICVsbHUgbWljcm9zZWMgKDB4JWxseCBjeWNsZXMpIDB4JXhcbiIsCisJ
CQlnZXRfc2F0YV9kZXZpY2VudW0ocEFkYXB0ZXIpLCBwb3J0LCBtdl9nYXAvQ1BVX01IWiwKKwkJ
CW12X2dhcCwgbXZfZnVuY1twb3J0XSk7CiAgICAgICAgICAgICB9CiAgICAgICAgIH0KKworLyog
QWdncmVnYXRlIHRpbWUgOiBlbmQgdGltZSBvZiBsYXN0IHBvcnQgLSBzdGFydCB0aW1lIG9mIGZp
cnN0IHBvcnQgKi8KK212X2dhcCA9IG12X3N0YW1wW3BvcnRdIC0gbXZfc3RhbXBbMF07CitpZiAo
IG12X2dhcCA+IG12X21heFtwb3J0XSkgeworCW12X21heFtwb3J0XSA9IG12X2dhcDsKKwlwcmlu
dGsoS0VSTl9FUlIgIm12X3NhdGE6IFNBVEElZCAlbGx1IG1pY3Jvc2VjICgweCVsbHggY3ljbGVz
KSIKKwkJIiAweCV4IDB4JXggMHgleCAweCV4XG4iLAorCQlnZXRfc2F0YV9kZXZpY2VudW0ocEFk
YXB0ZXIpLAorCQltdl9nYXAvQ1BVX01IWiwgbXZfZ2FwLAorCQltdl9mdW5jWzBdLCBtdl9mdW5j
WzFdLCBtdl9mdW5jWzJdLCBtdl9mdW5jWzNdCisJCSk7Cit9CisjZW5kaWYKKworICAgICAgICB9
CiAgICAgICAgIGVsc2UKICAgICAgICAgewogCSAgICBNVl9VMzIgIGVkbWFFcnJvcjsKQEAgLTc5
NzYsNiArODAzNiw3IEBAIE1WX0JPT0xFQU4gbXZTYXRhSW50ZXJydXB0U2VydmljZVJvdXRpbmUK
IAkgICAgfQogI2VuZGlmCiAgICAgICAgIH0KKwogICAgIH0KIAogICAgIC8qIHJlc3RvcmUgTUFJ
TiBJbnRlcnJ1cHQgQ2F1c2UgTWFzayByZWdpc3RlciAqLwo=
--0016361e7e82c9c97c048427b48f--
