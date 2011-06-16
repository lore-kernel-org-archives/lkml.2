Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1FPNIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:08:48 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:44350 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1FPNIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:08:47 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jun 2011 09:08:47 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=xKWZFc29syQe7x8XwAPxPKU6hy4gHvUtAbZeRPAJJ/hZV7JhEYab908tG7PfUYnGgC
         earOwrTcRaZIRbLygXhOmBT1K0ta82jjJg4/h1OwOCKSjQ+uxfolSPuAKPjtQ+1e2ZGv
         bO+z+rWucZQKOtp+c/gEOw5UkOX+w71XXqhzA=
MIME-Version: 1.0
Date: Thu, 16 Jun 2011 14:03:36 +0100
Message-ID: <BANLkTimG_oBX1bDTEVfZ81_uqXOahqR1ww@mail.gmail.com>
Subject: [PATCH] ring_buffer: Ensure that buffer page data is aligned.
From: Will Newton <will.newton@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd29cb4b5336004a5d3e5a7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd29cb4b5336004a5d3e5a7
Content-Type: text/plain; charset=ISO-8859-1

Explicitly align the start of the buffer page data array to the
required arch alignment. This is required for architectures that
require 8 byte alignment but do not have a 8 byte local_t.

Signed-off-by: Will Newton <will.newton@imgtec.com>
---
 kernel/trace/ring_buffer.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

I don't believe that any currently in-tree architecture is affected by
this, but it can be an issue on 32bit architectures that require an
8 byte aligment but only have a 32bit local_t. I think it's potentially
cleaner to make the alignment explicit anyway.

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0ef7b4b..36d5699 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -215,6 +215,8 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
 # define RB_ARCH_ALIGNMENT		8U
 #endif

+#define RB_ALIGN_DATA		__aligned(RB_ARCH_ALIGNMENT)
+
 /* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
 #define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX

@@ -363,7 +365,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 struct buffer_data_page {
 	u64		 time_stamp;	/* page time stamp */
 	local_t		 commit;	/* write committed index */
-	unsigned char	 data[];	/* data of buffer page */
+	unsigned char	 data[] RB_ALIGN_DATA;	/* data of buffer page */
 };

 /*
-- 
1.7.3.4

--000e0cd29cb4b5336004a5d3e5a7
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-ring_buffer-Ensure-that-buffer-page-data-is-aligned.patch"
Content-Disposition: attachment; 
	filename="0001-ring_buffer-Ensure-that-buffer-page-data-is-aligned.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gozpzd900

RnJvbSAzNTZmMTViODYxYzQxYTY1ZDQ1NTAzNThhYjM2OGZhMDFjMzZjNzdjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AaW1ndGVjLmNvbT4K
RGF0ZTogVGh1LCAxNiBKdW4gMjAxMSAxMzozODo1OSArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIHJp
bmdfYnVmZmVyOiBFbnN1cmUgdGhhdCBidWZmZXIgcGFnZSBkYXRhIGlzIGFsaWduZWQuCgpFeHBs
aWNpdGx5IGFsaWduIHRoZSBzdGFydCBvZiB0aGUgYnVmZmVyIHBhZ2UgZGF0YSBhcnJheSB0byB0
aGUKcmVxdWlyZWQgYXJjaCBhbGlnbm1lbnQuIFRoaXMgaXMgcmVxdWlyZWQgZm9yIGFyY2hpdGVj
dHVyZXMgdGhhdApyZXF1aXJlIDggYnl0ZSBhbGlnbm1lbnQgYnV0IGRvIG5vdCBoYXZlIGEgOCBi
eXRlIGxvY2FsX3QuCgpTaWduZWQtb2ZmLWJ5OiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AaW1n
dGVjLmNvbT4KLS0tCiBrZXJuZWwvdHJhY2UvcmluZ19idWZmZXIuYyB8ICAgIDQgKysrLQogMSBm
aWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEva2VybmVsL3RyYWNlL3JpbmdfYnVmZmVyLmMgYi9rZXJuZWwvdHJhY2UvcmluZ19idWZmZXIu
YwppbmRleCAwZWY3YjRiLi4zNmQ1Njk5IDEwMDY0NAotLS0gYS9rZXJuZWwvdHJhY2UvcmluZ19i
dWZmZXIuYworKysgYi9rZXJuZWwvdHJhY2UvcmluZ19idWZmZXIuYwpAQCAtMjE1LDYgKzIxNSw4
IEBAIEVYUE9SVF9TWU1CT0xfR1BMKHRyYWNpbmdfaXNfb24pOwogIyBkZWZpbmUgUkJfQVJDSF9B
TElHTk1FTlQJCThVCiAjZW5kaWYKIAorI2RlZmluZSBSQl9BTElHTl9EQVRBCQlfX2FsaWduZWQo
UkJfQVJDSF9BTElHTk1FTlQpCisKIC8qIGRlZmluZSBSSU5HQlVGX1RZUEVfREFUQSBmb3IgJ2Nh
c2UgUklOR0JVRl9UWVBFX0RBVEE6JyAqLwogI2RlZmluZSBSSU5HQlVGX1RZUEVfREFUQSAwIC4u
LiBSSU5HQlVGX1RZUEVfREFUQV9UWVBFX0xFTl9NQVgKIApAQCAtMzYzLDcgKzM2NSw3IEBAIEVY
UE9SVF9TWU1CT0xfR1BMKHJpbmdfYnVmZmVyX2V2ZW50X2RhdGEpOwogc3RydWN0IGJ1ZmZlcl9k
YXRhX3BhZ2UgewogCXU2NAkJIHRpbWVfc3RhbXA7CS8qIHBhZ2UgdGltZSBzdGFtcCAqLwogCWxv
Y2FsX3QJCSBjb21taXQ7CS8qIHdyaXRlIGNvbW1pdHRlZCBpbmRleCAqLwotCXVuc2lnbmVkIGNo
YXIJIGRhdGFbXTsJLyogZGF0YSBvZiBidWZmZXIgcGFnZSAqLworCXVuc2lnbmVkIGNoYXIJIGRh
dGFbXSBSQl9BTElHTl9EQVRBOwkvKiBkYXRhIG9mIGJ1ZmZlciBwYWdlICovCiB9OwogCiAvKgot
LSAKMS43LjMuNAoK
--000e0cd29cb4b5336004a5d3e5a7--
