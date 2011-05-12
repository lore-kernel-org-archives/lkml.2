Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab1ELPTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:19:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61395 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1ELPTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c2wjn7yPX3QmzFlsHtYkdFqlC4qr/szORbVk5QxNlMrNQUyf6S2YWWUZ7HJdO2pYpZ
         rASlP/dgFSvJSyhRzmgZUgtHgYqFmc3DP8ySBrnuDAr4Aw6hmvPENirUGv9m6yUi1NcQ
         Z98pns26LG+HvRaNKy19OMDaW8/Jz7TeqBcyk=
MIME-Version: 1.0
In-Reply-To: <1305208426.14423.11.camel@localhost>
References: <BANLkTi=e1mUTX4X7ui+HVCGh=sZ=HLoNCw@mail.gmail.com>
	<20110511183322.da0739c9.akpm@linux-foundation.org>
	<BANLkTikrqzpU8qZ5FUgG4HaBgZAvmbOHrQ@mail.gmail.com>
	<BANLkTinGFDHj4s6nAXMiq8dYW_UO6W+YXg@mail.gmail.com>
	<BANLkTin5X7d+_b5+7N5g941bz12jc+zMZA@mail.gmail.com>
	<4DCB908C.80505@parrot.com>
	<BANLkTik37R8tSxc9_qmBT5a2m9mAA_2XKQ@mail.gmail.com>
	<1305208380.14423.10.camel@localhost>
	<1305208426.14423.11.camel@localhost>
Date: Thu, 12 May 2011 10:19:43 -0500
Message-ID: <BANLkTi=_Aw5zZY8PTX3RnBzGNLsTb-fqZA@mail.gmail.com>
Subject: Re: Bug in MTD NAND ONFI chipsize detection
From: Nitin Garg <nitingarg98@gmail.com>
To: dedekind1@gmail.com
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001636ed69f904106b04a315b880
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636ed69f904106b04a315b880
Content-Type: text/plain; charset=ISO-8859-1

I hope this is better and acceptable, pls review.

As per ONFI standard, the size of NAND Flash device is Number of
data bytes per page * Number of pages per block * Number of blocks
per logical unit * Number of logical units. The nand_flash_detect_onfi
function is missing the Number of logical units due to which the kernel
detects wrong size of Micron MT29F8G08ADADAH4 NAND Flash as
it has 2 logical units. This patch fixes this issue by multiplying
p->lun_count for chipsize.

Signed-off-by: Nitin Garg <nitingarg98@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index c54a4cb..cdf6015 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2892,7 +2892,7 @@ static int nand_flash_detect_onfi(struct
mtd_info *mtd, struct nand_chip *chip,
        mtd->writesize = le32_to_cpu(p->byte_per_page);
        mtd->erasesize = le32_to_cpu(p->pages_per_block) * mtd->writesize;
        mtd->oobsize = le16_to_cpu(p->spare_bytes_per_page);
-       chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) *
mtd->erasesize;
+       chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) *
le32_to_cpu(p->lun_count) * mtd->erasesize;
        busw = 0;
        if (le16_to_cpu(p->features) & 1)
                busw = NAND_BUSWIDTH_16;
--
1.5.5.6

--001636ed69f904106b04a315b880
Content-Type: application/octet-stream; 
	name="onfi_nand_flash_chipsize.patch"
Content-Disposition: attachment; filename="onfi_nand_flash_chipsize.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnlugjqr0

RnJvbSAyOGQ5MjlkNjY5NWZkNjI5YzZmNmVjZDcwMDA0NGNhNzVlY2VmMDBmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaXRpbiBHYXJnIDxuaXRpbmdhcmc5OEBnbWFpbC5jb20+CkRh
dGU6IFRodSwgMTIgTWF5IDIwMTEgMTA6MDA6MDQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBBcyBw
ZXIgT05GSSBzdGFuZGFyZCwgdGhlIHNpemUgb2YgTkFORCBGbGFzaCBkZXZpY2UgaXMgTnVtYmVy
IG9mIGRhdGEgYnl0ZXMgcGVyIHBhZ2UgKiBOdW1iZXIgb2YgcGFnZXMgcGVyIGJsb2NrICogTnVt
YmVyIG9mIGJsb2NrcyBwZXIgbG9naWNhbCB1bml0ICogTnVtYmVyIG9mIGxvZ2ljYWwgdW5pdHMu
IFRoZSBuYW5kX2ZsYXNoX2RldGVjdF9vbmZpIGZ1bmN0aW9uIGlzIG1pc3NpbmcgdGhlIE51bWJl
ciBvZiBsb2dpY2FsIHVuaXRzIGR1ZSB0byB3aGljaCB0aGUga2VybmVsIGRldGVjdHMgd3Jvbmcg
c2l6ZSBvZiBNaWNyb24gTVQyOUY4RzA4QURBREFINCBOQU5EIEZsYXNoIGFzIGl0IGhhcyAyIGxv
Z2ljYWwgdW5pdHMuIFRoaXMgcGF0Y2ggZml4ZXMgdGhpcyBpc3N1ZSBieSBtdWx0aXBseWluZyBw
LT5sdW5fY291bnQgZm9yIGNoaXBzaXplLgoKClNpZ25lZC1vZmYtYnk6IE5pdGluIEdhcmcgPG5p
dGluZ2FyZzk4QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL210ZC9uYW5kL25hbmRfYmFzZS5jIHwg
ICAgMiArLQogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tdGQvbmFuZC9uYW5kX2Jhc2UuYyBiL2RyaXZlcnMvbXRk
L25hbmQvbmFuZF9iYXNlLmMKaW5kZXggYzU0YTRjYi4uY2RmNjAxNSAxMDA2NDQKLS0tIGEvZHJp
dmVycy9tdGQvbmFuZC9uYW5kX2Jhc2UuYworKysgYi9kcml2ZXJzL210ZC9uYW5kL25hbmRfYmFz
ZS5jCkBAIC0yODkyLDcgKzI4OTIsNyBAQCBzdGF0aWMgaW50IG5hbmRfZmxhc2hfZGV0ZWN0X29u
Zmkoc3RydWN0IG10ZF9pbmZvICptdGQsIHN0cnVjdCBuYW5kX2NoaXAgKmNoaXAsCiAJbXRkLT53
cml0ZXNpemUgPSBsZTMyX3RvX2NwdShwLT5ieXRlX3Blcl9wYWdlKTsKIAltdGQtPmVyYXNlc2l6
ZSA9IGxlMzJfdG9fY3B1KHAtPnBhZ2VzX3Blcl9ibG9jaykgKiBtdGQtPndyaXRlc2l6ZTsKIAlt
dGQtPm9vYnNpemUgPSBsZTE2X3RvX2NwdShwLT5zcGFyZV9ieXRlc19wZXJfcGFnZSk7Ci0JY2hp
cC0+Y2hpcHNpemUgPSAodWludDY0X3QpbGUzMl90b19jcHUocC0+YmxvY2tzX3Blcl9sdW4pICog
bXRkLT5lcmFzZXNpemU7CisJY2hpcC0+Y2hpcHNpemUgPSAodWludDY0X3QpbGUzMl90b19jcHUo
cC0+YmxvY2tzX3Blcl9sdW4pICogbGUzMl90b19jcHUocC0+bHVuX2NvdW50KSAqIG10ZC0+ZXJh
c2VzaXplOwogCWJ1c3cgPSAwOwogCWlmIChsZTE2X3RvX2NwdShwLT5mZWF0dXJlcykgJiAxKQog
CQlidXN3ID0gTkFORF9CVVNXSURUSF8xNjsKLS0gCjEuNS41LjYKCg==
--001636ed69f904106b04a315b880--
