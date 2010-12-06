Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0LFQJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:09:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942Ab0LFQI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:08:57 -0500
MIME-Version: 1.0
In-Reply-To: <4CFCB08F.4010509@jp.fujitsu.com>
References: <4CFCB08F.4010509@jp.fujitsu.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Dec 2010 08:08:06 -0800
Message-ID: <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com>
Subject: Re: [PATCH 1/2] Don't merge different partition's IOs
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: jaxboe@fusionio.com, vgoyal@redhat.com, jmarchan@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001485eba1e823a9db0496c019cb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001485eba1e823a9db0496c019cb
Content-Type: text/plain; charset=ISO-8859-1

2010/12/6 Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>:
>
> The problem is caused by merging different partition's I/Os. So the patch
> check whether a merging bio or request is a same partition as a request or not
> by using a partition's start sector and size.

I really think this is wrong.

We should just carry the partition information around in the req and
the bio, and just compare the pointers, rather than compare the range.
No need to even dereference the pointers, you should be able to just
do

   /* don't merge if not on the same partition */
   if (bio->part != req->part)
      return 0;

or something.

This is doubly true since the accounting already does that horrible
partition lookup: rather than look it up, we should just _set_ it in
__generic_make_request(), where I think we already know it since we do
that whole blk_partition_remap().

So just something like the appended (TOTALLY UNTESTED) perhaps?

Note that this should get it right even for overlapping partitions etc.

                     Linus

--001485eba1e823a9db0496c019cb
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghdk1p780

IGJsb2NrL2Jsay1jb3JlLmMgICAgICAgICAgfCAgICAyICsrCiBibG9jay9ibGstbWVyZ2UuYyAg
ICAgICAgIHwgICAgOSArKysrKysrKysKIGluY2x1ZGUvbGludXgvYmxrX3R5cGVzLmggfCAgICAy
ICstCiBpbmNsdWRlL2xpbnV4L2Jsa2Rldi5oICAgIHwgICAgMSArCiA0IGZpbGVzIGNoYW5nZWQs
IDEzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svYmxr
LWNvcmUuYyBiL2Jsb2NrL2Jsay1jb3JlLmMKaW5kZXggNGNlOTUzZi4uYTBjMTNhOSAxMDA2NDQK
LS0tIGEvYmxvY2svYmxrLWNvcmUuYworKysgYi9ibG9jay9ibGstY29yZS5jCkBAIC0xMzIzLDYg
KzEzMjMsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgYmxrX3BhcnRpdGlvbl9yZW1hcChzdHJ1Y3Qg
YmlvICpiaW8pCiB7CiAJc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiA9IGJpby0+YmlfYmRldjsK
IAorCWJpby0+YmlfcGFydCA9IGJkZXY7CiAJaWYgKGJpb19zZWN0b3JzKGJpbykgJiYgYmRldiAh
PSBiZGV2LT5iZF9jb250YWlucykgewogCQlzdHJ1Y3QgaGRfc3RydWN0ICpwID0gYmRldi0+YmRf
cGFydDsKIApAQCAtMjQzNyw2ICsyNDM4LDcgQEAgdm9pZCBibGtfcnFfYmlvX3ByZXAoc3RydWN0
IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCByZXF1ZXN0ICpycSwKIAlycS0+X19kYXRhX2xlbiA9
IGJpby0+Ymlfc2l6ZTsKIAlycS0+YmlvID0gcnEtPmJpb3RhaWwgPSBiaW87CiAKKwlycS0+cnFf
cGFydCA9IGJpby0+YmlfcGFydDsKIAlpZiAoYmlvLT5iaV9iZGV2KQogCQlycS0+cnFfZGlzayA9
IGJpby0+YmlfYmRldi0+YmRfZGlzazsKIH0KZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1tZXJnZS5j
IGIvYmxvY2svYmxrLW1lcmdlLmMKaW5kZXggNzdiN2MyNi4uMzkxM2Y1ZiAxMDA2NDQKLS0tIGEv
YmxvY2svYmxrLW1lcmdlLmMKKysrIGIvYmxvY2svYmxrLW1lcmdlLmMKQEAgLTIzMCw2ICsyMzAs
OSBAQCBpbnQgbGxfYmFja19tZXJnZV9mbihzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0
IHJlcXVlc3QgKnJlcSwKIHsKIAl1bnNpZ25lZCBzaG9ydCBtYXhfc2VjdG9yczsKIAorCWlmIChy
ZXEtPnJxX3BhcnQgIT0gYmlvLT5iaV9wYXJ0KQorCQlyZXR1cm4gMDsKKwogCWlmICh1bmxpa2Vs
eShyZXEtPmNtZF90eXBlID09IFJFUV9UWVBFX0JMT0NLX1BDKSkKIAkJbWF4X3NlY3RvcnMgPSBx
dWV1ZV9tYXhfaHdfc2VjdG9ycyhxKTsKIAllbHNlCkBAIC0yNTQsNiArMjU3LDkgQEAgaW50IGxs
X2Zyb250X21lcmdlX2ZuKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgcmVxdWVzdCAq
cmVxLAogewogCXVuc2lnbmVkIHNob3J0IG1heF9zZWN0b3JzOwogCisJaWYgKGJpby0+YmlfcGFy
dCAhPSByZXEtPnJxX3BhcnQpCisJCXJldHVybiAwOworCiAJaWYgKHVubGlrZWx5KHJlcS0+Y21k
X3R5cGUgPT0gUkVRX1RZUEVfQkxPQ0tfUEMpKQogCQltYXhfc2VjdG9ycyA9IHF1ZXVlX21heF9o
d19zZWN0b3JzKHEpOwogCWVsc2UKQEAgLTM5Miw2ICszOTgsOSBAQCBzdGF0aWMgaW50IGF0dGVt
cHRfbWVyZ2Uoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCByZXF1ZXN0ICpyZXEsCiAJ
ICAgIHx8IG5leHQtPnNwZWNpYWwpCiAJCXJldHVybiAwOwogCisJaWYgKHJlcS0+cnFfcGFydCAh
PSBuZXh0LT5ycV9wYXJ0KQorCQlyZXR1cm4gMDsKKwogCS8qCiAJICogSWYgd2UgYXJlIGFsbG93
ZWQgdG8gbWVyZ2UsIHRoZW4gYXBwZW5kIGJpbyBsaXN0CiAJICogZnJvbSBuZXh0IHRvIHJxIGFu
ZCByZWxlYXNlIG5leHQuIG1lcmdlX3JlcXVlc3RzX2ZuCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L2Jsa190eXBlcy5oIGIvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaAppbmRleCA0NmFkNTE5
Li4wOTQwNDgwIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oCisrKyBiL2lu
Y2x1ZGUvbGludXgvYmxrX3R5cGVzLmgKQEAgLTM0LDcgKzM0LDcgQEAgc3RydWN0IGJpbyB7CiAJ
c2VjdG9yX3QJCWJpX3NlY3RvcjsJLyogZGV2aWNlIGFkZHJlc3MgaW4gNTEyIGJ5dGUKIAkJCQkJ
CSAgIHNlY3RvcnMgKi8KIAlzdHJ1Y3QgYmlvCQkqYmlfbmV4dDsJLyogcmVxdWVzdCBxdWV1ZSBs
aW5rICovCi0Jc3RydWN0IGJsb2NrX2RldmljZQkqYmlfYmRldjsKKwlzdHJ1Y3QgYmxvY2tfZGV2
aWNlCSpiaV9iZGV2LCAqYmlfcGFydDsKIAl1bnNpZ25lZCBsb25nCQliaV9mbGFnczsJLyogc3Rh
dHVzLCBjb21tYW5kLCBldGMgKi8KIAl1bnNpZ25lZCBsb25nCQliaV9ydzsJCS8qIGJvdHRvbSBi
aXRzIFJFQUQvV1JJVEUsCiAJCQkJCQkgKiB0b3AgYml0cyBwcmlvcml0eQpkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9ibGtkZXYuaCBiL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKaW5kZXggYWFl
ODZmZC4uZjMxYmQ0ZiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9ibGtkZXYuaAorKysgYi9p
bmNsdWRlL2xpbnV4L2Jsa2Rldi5oCkBAIC0xMTQsNiArMTE0LDcgQEAgc3RydWN0IHJlcXVlc3Qg
ewogCXZvaWQgKmVsZXZhdG9yX3ByaXZhdGUyOwogCXZvaWQgKmVsZXZhdG9yX3ByaXZhdGUzOwog
CisJc3RydWN0IGJsb2NrX2RldmljZSAqcnFfcGFydDsKIAlzdHJ1Y3QgZ2VuZGlzayAqcnFfZGlz
azsKIAl1bnNpZ25lZCBsb25nIHN0YXJ0X3RpbWU7CiAjaWZkZWYgQ09ORklHX0JMS19DR1JPVVAK
--001485eba1e823a9db0496c019cb--
