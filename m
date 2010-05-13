Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab0EMWUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:20:14 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:60062 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab0EMWUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:20:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PEv3dIHVMv/IueH/BNYjlmjfNSruALOwVz+x6H7ePGNQMdZ0Y50NnHLt6luq8JiBpA
         E4YYyESmv413p6mGq/G3K/XNUqzfWXlcaVQyKODD//dCHyDN5UBWPnR73aIsQo13JUpj
         LOMOFIjHvWHxbrsejA2SgMl/n9QJR02CSfkv4=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005131752160.1731-100000@iolanthe.rowland.org>
References: <AANLkTimW3wLEt-DIRirHic1ZN1Z0k1t3TavwaCxTh_QL@mail.gmail.com>
	 <Pine.LNX.4.44L0.1005131752160.1731-100000@iolanthe.rowland.org>
Date: Thu, 13 May 2010 15:20:07 -0700
Message-ID: <AANLkTimBxoCCeT_ns30JTIGKqgkiRIvKTf4LfE3mopkS@mail.gmail.com>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while 
	userspace is frozen?
From: Matt Reimer <mattjreimer@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
Content-Type: multipart/mixed; boundary=000e0cd598303cae1304868129f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd598303cae1304868129f0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, May 13, 2010 at 2:54 PM, Alan Stern <stern@rowland.harvard.edu> wro=
te:
> On Thu, 13 May 2010, Matt Reimer wrote:
>
>> So how does the attached patch look?
>>
>> Matt
>>
>>
>> From 20d8340471eb05aa54af1349f4ddccecd9c230c6 Mon Sep 17 00:00:00 2001
>> From: Matt Reimer <mreimer@sdgsystems.com>
>> Date: Thu, 13 May 2010 14:36:54 -0700
>> Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card pre=
sent
>>
>> Devices can come and go from the MMC/SD bus during suspend or resume,
>> when the writeback thread is frozen, resulting in a hang. So thaw the
>> writeback thread in del_gendisk() to prevent the hang.
>
> I don't see anything wrong with the patch itself, but I dislike the
> description. =A0Devices can come and go from any hotpluggable bus, not
> just MMC/SD. =A0That just happens to be the first place the problem was
> observed.

Good point. How about this?

Matt

>From 813bd223e5a2fa577b9e64ddf12654a93d0aab8b Mon Sep 17 00:00:00 2001
From: Matt Reimer <mreimer@sdgsystems.com>
Date: Thu, 13 May 2010 14:36:54 -0700
Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card presen=
t

Devices can come and go bus during suspend or resume, when the
writeback thread is frozen, resulting in a hang. Prevent the hang
by thawing the writeback thread in del_gendisk().

Signed-off-by: Matt Reimer <mreimer@sdgsystems.com>
---
 fs/partitions/check.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e238ab2..b303919 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -666,6 +666,8 @@ void del_gendisk(struct gendisk *disk)
        struct disk_part_iter piter;
        struct hd_struct *part;

+       thaw_process(disk->queue->backing_dev_info.wb.task);
+
        /* invalidate stuff */
        disk_part_iter_init(&piter, disk,
                             DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
--=20
1.7.0.4

--000e0cd598303cae1304868129f0
Content-Type: application/octet-stream; 
	name="0001-fs-prevent-hang-on-suspend-resume-when-MMC-SD-card-p.patch"
Content-Disposition: attachment; 
	filename="0001-fs-prevent-hang-on-suspend-resume-when-MMC-SD-card-p.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g965743o0

RnJvbSA4MTNiZDIyM2U1YTJmYTU3N2I5ZTY0ZGRmMTI2NTRhOTNkMGFhYjhiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXR0IFJlaW1lciA8bXJlaW1lckBzZGdzeXN0ZW1zLmNvbT4K
RGF0ZTogVGh1LCAxMyBNYXkgMjAxMCAxNDozNjo1NCAtMDcwMApTdWJqZWN0OiBbUEFUQ0hdIGZz
OiBwcmV2ZW50IGhhbmcgb24gc3VzcGVuZC9yZXN1bWUgd2hlbiBNTUMvU0QgY2FyZCBwcmVzZW50
CgpEZXZpY2VzIGNhbiBjb21lIGFuZCBnbyBidXMgZHVyaW5nIHN1c3BlbmQgb3IgcmVzdW1lLCB3
aGVuIHRoZQp3cml0ZWJhY2sgdGhyZWFkIGlzIGZyb3plbiwgcmVzdWx0aW5nIGluIGEgaGFuZy4g
UHJldmVudCB0aGUgaGFuZwpieSB0aGF3aW5nIHRoZSB3cml0ZWJhY2sgdGhyZWFkIGluIGRlbF9n
ZW5kaXNrKCkuCgpTaWduZWQtb2ZmLWJ5OiBNYXR0IFJlaW1lciA8bXJlaW1lckBzZGdzeXN0ZW1z
LmNvbT4KLS0tCiBmcy9wYXJ0aXRpb25zL2NoZWNrLmMgfCAgICAyICsrCiAxIGZpbGVzIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9wYXJ0
aXRpb25zL2NoZWNrLmMgYi9mcy9wYXJ0aXRpb25zL2NoZWNrLmMKaW5kZXggZTIzOGFiMi4uYjMw
MzkxOSAxMDA2NDQKLS0tIGEvZnMvcGFydGl0aW9ucy9jaGVjay5jCisrKyBiL2ZzL3BhcnRpdGlv
bnMvY2hlY2suYwpAQCAtNjY2LDYgKzY2Niw4IEBAIHZvaWQgZGVsX2dlbmRpc2soc3RydWN0IGdl
bmRpc2sgKmRpc2spCiAJc3RydWN0IGRpc2tfcGFydF9pdGVyIHBpdGVyOwogCXN0cnVjdCBoZF9z
dHJ1Y3QgKnBhcnQ7CiAKKwl0aGF3X3Byb2Nlc3MoZGlzay0+cXVldWUtPmJhY2tpbmdfZGV2X2lu
Zm8ud2IudGFzayk7CisKIAkvKiBpbnZhbGlkYXRlIHN0dWZmICovCiAJZGlza19wYXJ0X2l0ZXJf
aW5pdCgmcGl0ZXIsIGRpc2ssCiAJCQkgICAgIERJU0tfUElURVJfSU5DTF9FTVBUWSB8IERJU0tf
UElURVJfUkVWRVJTRSk7Ci0tIAoxLjcuMC40Cgo=
--000e0cd598303cae1304868129f0--
