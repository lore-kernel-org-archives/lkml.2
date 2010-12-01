Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0LAWL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 17:11:56 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62299 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0LAWLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 17:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=AOD93Nl5QMFMq/MtA2b7fNlvA2NmxOfOqxOED/2deJ0OJyKcj45duQwLeZgV4BMkNK
         7dAeN0z3Y1HBDYJiGnVMGCbkAzPI1uBG8JjOhn+UB4CB3kG8WJbBL24ZL/ZqfwRga46e
         o2AoE5/LkDuLbbSUCOpbvmB+ClsMKoCs86L9Q=
MIME-Version: 1.0
Date: Wed, 1 Dec 2010 22:11:53 +0000
Message-ID: <AANLkTi=kX8NraxuLn-f=s=nqja71Ayq2kYwgG6gq+7YF@mail.gmail.com>
Subject: [PATCH] include/linux/unaligned: Pack the whole struct rather than
 just the field.
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016364d286bc152210496609753
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364d286bc152210496609753
Content-Type: text/plain; charset=ISO-8859-1

The current packed struct implementation of unaligned access adds
the packed attribute only to the field within the unaligned struct
rather than to the struct as a whole. This is not sufficient to
enforce proper behaviour on architectures with a default struct
alignment of more than one byte.

For example, the current implementation of __get_unaligned_cpu16
when compiled for arm with gcc -O1 -mstructure-size-boundary=32
assumes the struct is on a 4 byte boundary so performs the load
of the 16bit packed field as if it were on a 4 byte boundary:

__get_unaligned_cpu16:
        ldrh    r0, [r0, #0]
        bx      lr

Moving the packed attribute to the struct rather than the field
causes the proper unaligned access code to be generated:

__get_unaligned_cpu16:
	ldrb	r3, [r0, #0]	@ zero_extendqisi2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	orr	r0, r3, r0, asl #8
	bx	lr

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 include/linux/unaligned/packed_struct.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/unaligned/packed_struct.h
b/include/linux/unaligned/packed_struct.h
index 2498bb9..c9a6abd 100644
--- a/include/linux/unaligned/packed_struct.h
+++ b/include/linux/unaligned/packed_struct.h
@@ -3,9 +3,9 @@

 #include <linux/kernel.h>

-struct __una_u16 { u16 x __attribute__((packed)); };
-struct __una_u32 { u32 x __attribute__((packed)); };
-struct __una_u64 { u64 x __attribute__((packed)); };
+struct __una_u16 { u16 x; } __attribute__((packed));
+struct __una_u32 { u32 x; } __attribute__((packed));
+struct __una_u64 { u64 x; } __attribute__((packed));

 static inline u16 __get_unaligned_cpu16(const void *p)
 {
-- 
1.7.0.4

--0016364d286bc152210496609753
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-include-linux-unaligned-Pack-the-whole-struct-rather.patch"
Content-Disposition: attachment; 
	filename="0001-include-linux-unaligned-Pack-the-whole-struct-rather.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh6rozur0

RnJvbSBiYzFhMTUwZDhlNzQ3YTUxNDM5MjI3OTQ2NjUxODQzMWMzMWM2MThmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBXZWQsIDEgRGVjIDIwMTAgMjE6NDU6MjQgKzAwMDAKU3ViamVjdDogW1BBVENIXSBpbmNs
dWRlL2xpbnV4L3VuYWxpZ25lZDogUGFjayB0aGUgd2hvbGUgc3RydWN0IHJhdGhlciB0aGFuIGp1
c3QgdGhlIGZpZWxkLgoKVGhlIGN1cnJlbnQgcGFja2VkIHN0cnVjdCBpbXBsZW1lbnRhdGlvbiBv
ZiB1bmFsaWduZWQgYWNjZXNzIGFkZHMKdGhlIHBhY2tlZCBhdHRyaWJ1dGUgb25seSB0byB0aGUg
ZmllbGQgd2l0aGluIHRoZSB1bmFsaWduZWQgc3RydWN0LApyYXRoZXIgdGhhbiB0byB0aGUgc3Ry
dWN0IGFzIGEgd2hvbGUuIFRoaXMgaXMgbm90IHN1ZmZpY2llbnQgdG8KZW5mb3JjZSBwcm9wZXIg
YmVoYXZpb3VyIG9uIGFyY2hpdGVjdHVyZXMgd2l0aCBhIGRlZmF1bHQgc3RydWN0CmFsaWdubWVu
dCBvZiBtb3JlIHRoYW4gb25lIGJ5dGUuCgpGb3IgZXhhbXBsZSwgdGhlIGN1cnJlbnQgaW1wbGVt
ZW50YXRpb24gb2YgX19nZXRfdW5hbGlnbmVkX2NwdTE2CndoZW4gY29tcGlsZWQgZm9yIGFybSB3
aXRoIGdjYyAtTzEgLW1zdHJ1Y3R1cmUtc2l6ZS1ib3VuZGFyeT0zMgphc3N1bWVzIHRoZSBzdHJ1
Y3QgaXMgb24gYSA0IGJ5dGUgYm91bmRhcnkgc28gcGVyZm9ybXMgdGhlIGxvYWQKb2YgdGhlIDE2
Yml0IHBhY2tlZCBmaWVsZCBhcyBpZiBpdCB3ZXJlIG9uIGEgNCBieXRlIGJvdW5kYXJ5OgoKX19n
ZXRfdW5hbGlnbmVkX2NwdTE2OgogICAgICAgIGxkcmggICAgcjAsIFtyMCwgIzBdCiAgICAgICAg
YnggICAgICBscgoKTW92aW5nIHRoZSBwYWNrZWQgYXR0cmlidXRlIHRvIHRoZSBzdHJ1Y3QgcmF0
aGVyIHRoYW4gdGhlIGZpZWxkCmNhdXNlcyB0aGUgcHJvcGVyIHVuYWxpZ25lZCBhY2Nlc3MgY29k
ZSB0byBiZSBnZW5lcmF0ZWQ6CgpfX2dldF91bmFsaWduZWRfY3B1MTY6CglsZHJiCXIzLCBbcjAs
ICMwXQlAIHplcm9fZXh0ZW5kcWlzaTIKCWxkcmIJcjAsIFtyMCwgIzFdCUAgemVyb19leHRlbmRx
aXNpMgoJb3JyCXIwLCByMywgcjAsIGFzbCAjOAoJYngJbHIKClNpZ25lZC1vZmYtYnk6IFdpbGwg
TmV3dG9uIDx3aWxsLm5ld3RvbkBnbWFpbC5jb20+Ci0tLQogaW5jbHVkZS9saW51eC91bmFsaWdu
ZWQvcGFja2VkX3N0cnVjdC5oIHwgICAgNiArKystLS0KIDEgZmlsZXMgY2hhbmdlZCwgMyBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvdW5h
bGlnbmVkL3BhY2tlZF9zdHJ1Y3QuaCBiL2luY2x1ZGUvbGludXgvdW5hbGlnbmVkL3BhY2tlZF9z
dHJ1Y3QuaAppbmRleCAyNDk4YmI5Li5jOWE2YWJkIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4
L3VuYWxpZ25lZC9wYWNrZWRfc3RydWN0LmgKKysrIGIvaW5jbHVkZS9saW51eC91bmFsaWduZWQv
cGFja2VkX3N0cnVjdC5oCkBAIC0zLDkgKzMsOSBAQAogCiAjaW5jbHVkZSA8bGludXgva2VybmVs
Lmg+CiAKLXN0cnVjdCBfX3VuYV91MTYgeyB1MTYgeCBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsg
fTsKLXN0cnVjdCBfX3VuYV91MzIgeyB1MzIgeCBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsgfTsK
LXN0cnVjdCBfX3VuYV91NjQgeyB1NjQgeCBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsgfTsKK3N0
cnVjdCBfX3VuYV91MTYgeyB1MTYgeDsgfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsKK3N0cnVj
dCBfX3VuYV91MzIgeyB1MzIgeDsgfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsKK3N0cnVjdCBf
X3VuYV91NjQgeyB1NjQgeDsgfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsKIAogc3RhdGljIGlu
bGluZSB1MTYgX19nZXRfdW5hbGlnbmVkX2NwdTE2KGNvbnN0IHZvaWQgKnApCiB7Ci0tIAoxLjcu
MC40Cgo=
--0016364d286bc152210496609753--
