Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1IIEoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 00:44:06 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:43734 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1IIEoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 00:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+X1aCR6Rptj_7bKf7O7TJ8a9z7AH0vXL90XAgY=+054WegsgQ@mail.gmail.com>
References: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
	<1313768318-7960-2-git-send-email-maxim.patlasov@gmail.com>
	<CANejiEWadFK9GdXSwKgzNoj1Da_4QTUidTp-6FGkBtZwhbKvfw@mail.gmail.com>
	<CA+X1aCRSADrUB+YVJ9j5u+VgGn=8fKw7A1eVVzPtODg+hK-B-w@mail.gmail.com>
	<CANejiEX=S8tyPDhAjm84+9xBNt08Q0mjWHjqh-kFqL4H1ME-RA@mail.gmail.com>
	<CA+X1aCSMb9CTpoHWv=UiMg-mHkB2ssmKRACtbDofWG=QSxXOdg@mail.gmail.com>
	<CANejiEV7UfEHEMwokKwE+Pwqn_HRUT0_9wHakhOYj8r0roGYuw@mail.gmail.com>
	<CA+X1aCR6Rptj_7bKf7O7TJ8a9z7AH0vXL90XAgY=+054WegsgQ@mail.gmail.com>
Date: Fri, 9 Sep 2011 12:43:59 +0800
X-Google-Sender-Auth: pvtYeMRgvlQpv7UHufCVFkE2IXI
Message-ID: <CANejiEUTjZbxesiKFzGE4a9rs-GQfq1ekzaDAv34pMGrEQAUcg@mail.gmail.com>
Subject: Re: [PATCH 1/1] CFQ: fix handling 'deep' cfqq
From: Shaohua Li <shli@kernel.org>
To: Maxim Patlasov <maxim.patlasov@gmail.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0014853c907889be9f04ac7ad3f5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0014853c907889be9f04ac7ad3f5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/9/6 Maxim Patlasov <maxim.patlasov@gmail.com>:
> Shaohua,
>
>>> If the queue does dispatch > 4 requests in one jiffy, only
>>> cfq_disk_looks_fast is updated - that's right. But if the queue
>>> dispatches first 4 requests in *more* than one jiffy,
>>> cfq_disk_looks_slow is updated.
>> So the case is in first round, the queue dispatch > 4 requests in one ji=
ffy,
>> looks_fast gets updated. Later, if the queue always only dispatch < 4 re=
quests
>> or has < 4 requests queued, no looks_fast/looks_slow gets updated till
>> 10*HZ later.
>> CFQD_DISK_LOOKS_FAST() always returns true in the period. is this sane?
>
> Thanks a lot for feedback. I agree, a single accidental event should
> not affect the whole system for so long. What do you think about
> making positive decision only if some amount of events were gathered
> recently:
>
> #define CFQD_DISK_LOOKS_FAST(cfqd) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 =A0(cfqd->cfq_disk_looks_fast > cfqd->cfq_disk_looks_slow && =
=A0 \
> =A0 =A0 =A0 =A0 cfqd->cfq_disk_looks_fast + cfqd->cfq_disk_looks_slow > 1=
0)
I'm sorry a little later to reply.
that's better, but I'm still unsatisfied with the detection if a device is =
fast.

So the key problem here is how to detect if a device is fast. Doing
the detection
in the dispatch stage always can't give us correct result. A fast device re=
ally
should be requests can be finished in short time. So I have something attac=
hed.
In my environment, a hard disk is detected slow and a ssd is detected fast,=
 but
I haven't run any benchmark so far. How do you think about it?

Thanks,
Shaohua

--0014853c907889be9f04ac7ad3f5
Content-Type: text/x-patch; charset=US-ASCII; name="cfq-fast-device-detech.patch"
Content-Disposition: attachment; filename="cfq-fast-device-detech.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gscoocac0

ZGlmZiAtLWdpdCBhL2Jsb2NrL2NmcS1pb3NjaGVkLmMgYi9ibG9jay9jZnEtaW9zY2hlZC5jCmlu
ZGV4IGEzM2JkNDMuLjhjNDAzMWMgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2NmcS1pb3NjaGVkLmMKKysr
IGIvYmxvY2svY2ZxLWlvc2NoZWQuYwpAQCAtNTMsNiArNTMsOCBAQCBzdGF0aWMgY29uc3QgaW50
IGNmcV9oaXN0X2Rpdmlzb3IgPSA0OwogI2RlZmluZSBDRlFRX1NFQ1RfVEhSX05PTlJPVAkoc2Vj
dG9yX3QpKDIgKiAzMikKICNkZWZpbmUgQ0ZRUV9TRUVLWShjZnFxKQkoaHdlaWdodDMyKGNmcXEt
PnNlZWtfaGlzdG9yeSkgPiAzMi84KQogCisjZGVmaW5lIENGUURfRkFTVChjZnFkKQkJKGh3ZWln
aHQzMihjZnFkLT5zbG93X2RldmljZSkgPiAzMi84KQorCiAjZGVmaW5lIFJRX0NJQyhycSkJCVwK
IAkoKHN0cnVjdCBjZnFfaW9fY29udGV4dCAqKSAocnEpLT5lbGV2YXRvcl9wcml2YXRlWzBdKQog
I2RlZmluZSBSUV9DRlFRKHJxKQkJKHN0cnVjdCBjZnFfcXVldWUgKikgKChycSktPmVsZXZhdG9y
X3ByaXZhdGVbMV0pCkBAIC0xMzAsNiArMTMyLDggQEAgc3RydWN0IGNmcV9xdWV1ZSB7CiAJdW5z
aWduZWQgbG9uZyBzbGljZV9lbmQ7CiAJbG9uZyBzbGljZV9yZXNpZDsKIAorCXVuc2lnbmVkIGxv
bmcgc2Vla3lfZGlzcGF0Y2hfc3RhcnQ7CisKIAkvKiBwZW5kaW5nIG1ldGFkYXRhIHJlcXVlc3Rz
ICovCiAJaW50IG1ldGFfcGVuZGluZzsKIAkvKiBudW1iZXIgb2YgcmVxdWVzdHMgdGhhdCBhcmUg
b24gdGhlIGRpc3BhdGNoIGxpc3Qgb3IgaW5zaWRlIGRyaXZlciAqLwpAQCAtMzA1LDYgKzMwOSw4
IEBAIHN0cnVjdCBjZnFfZGF0YSB7CiAKIAkvKiBOdW1iZXIgb2YgZ3JvdXBzIHdoaWNoIGFyZSBv
biBibGtjZy0+YmxrZ19saXN0ICovCiAJdW5zaWduZWQgaW50IG5yX2Jsa2NnX2xpbmtlZF9ncnBz
OworCisJdTMyIHNsb3dfZGV2aWNlOwogfTsKIAogc3RhdGljIHN0cnVjdCBjZnFfZ3JvdXAgKmNm
cV9nZXRfbmV4dF9jZnFnKHN0cnVjdCBjZnFfZGF0YSAqY2ZxZCk7CkBAIC0yMDczLDYgKzIwNzks
OCBAQCBzdGF0aWMgdm9pZCBjZnFfZGlzcGF0Y2hfaW5zZXJ0KHN0cnVjdCByZXF1ZXN0X3F1ZXVl
ICpxLCBzdHJ1Y3QgcmVxdWVzdCAqcnEpCiAKIAljZnFxLT5uZXh0X3JxID0gY2ZxX2ZpbmRfbmV4
dF9ycShjZnFkLCBjZnFxLCBycSk7CiAJY2ZxX3JlbW92ZV9yZXF1ZXN0KHJxKTsKKwlpZiAoY2Zx
cS0+ZGlzcGF0Y2hlZCA9PSAwICYmIENGUVFfU0VFS1koY2ZxcSkpCisJCWNmcXEtPnNlZWt5X2Rp
c3BhdGNoX3N0YXJ0ID0gamlmZmllczsKIAljZnFxLT5kaXNwYXRjaGVkKys7CiAJKFJRX0NGUUco
cnEpKS0+ZGlzcGF0Y2hlZCsrOwogCWVsdl9kaXNwYXRjaF9zb3J0KHEsIHJxKTsKQEAgLTIzNzUs
MTcgKzIzODMsNiBAQCBzdGF0aWMgc3RydWN0IGNmcV9xdWV1ZSAqY2ZxX3NlbGVjdF9xdWV1ZShz
dHJ1Y3QgY2ZxX2RhdGEgKmNmcWQpCiAJCWdvdG8ga2VlcF9xdWV1ZTsKIAl9CiAKLQkvKgotCSAq
IFRoaXMgaXMgYSBkZWVwIHNlZWsgcXVldWUsIGJ1dCB0aGUgZGV2aWNlIGlzIG11Y2ggZmFzdGVy
IHRoYW4KLQkgKiB0aGUgcXVldWUgY2FuIGRlbGl2ZXIsIGRvbid0IGlkbGUKLQkgKiovCi0JaWYg
KENGUVFfU0VFS1koY2ZxcSkgJiYgY2ZxX2NmcXFfaWRsZV93aW5kb3coY2ZxcSkgJiYKLQkgICAg
KGNmcV9jZnFxX3NsaWNlX25ldyhjZnFxKSB8fAotCSAgICAoY2ZxcS0+c2xpY2VfZW5kIC0gamlm
ZmllcyA+IGppZmZpZXMgLSBjZnFxLT5zbGljZV9zdGFydCkpKSB7Ci0JCWNmcV9jbGVhcl9jZnFx
X2RlZXAoY2ZxcSk7Ci0JCWNmcV9jbGVhcl9jZnFxX2lkbGVfd2luZG93KGNmcXEpOwotCX0KLQog
CWlmIChjZnFxLT5kaXNwYXRjaGVkICYmIGNmcV9zaG91bGRfaWRsZShjZnFkLCBjZnFxKSkgewog
CQljZnFxID0gTlVMTDsKIAkJZ290byBrZWVwX3F1ZXVlOwpAQCAtMzI5OCw3ICszMjk1LDcgQEAg
Y2ZxX3VwZGF0ZV9pZGxlX3dpbmRvdyhzdHJ1Y3QgY2ZxX2RhdGEgKmNmcWQsIHN0cnVjdCBjZnFf
cXVldWUgKmNmcXEsCiAKIAllbmFibGVfaWRsZSA9IG9sZF9pZGxlID0gY2ZxX2NmcXFfaWRsZV93
aW5kb3coY2ZxcSk7CiAKLQlpZiAoY2ZxcS0+cXVldWVkWzBdICsgY2ZxcS0+cXVldWVkWzFdID49
IDQpCisJaWYgKGNmcXEtPnF1ZXVlZFswXSArIGNmcXEtPnF1ZXVlZFsxXSA+PSA0ICYmICFDRlFE
X0ZBU1QoY2ZxZCkpCiAJCWNmcV9tYXJrX2NmcXFfZGVlcChjZnFxKTsKIAogCWlmIChjZnFxLT5u
ZXh0X3JxICYmIChjZnFxLT5uZXh0X3JxLT5jbWRfZmxhZ3MgJiBSRVFfTk9JRExFKSkKQEAgLTM1
ODcsNiArMzU4NCwxNCBAQCBzdGF0aWMgdm9pZCBjZnFfY29tcGxldGVkX3JlcXVlc3Qoc3RydWN0
IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCByZXF1ZXN0ICpycSkKIAogCWNmcV91cGRhdGVfaHdf
dGFnKGNmcWQpOwogCisJaWYgKGNmcXEtPnNlZWt5X2Rpc3BhdGNoX3N0YXJ0KSB7CisJCWNmcWQt
PnNsb3dfZGV2aWNlIDw8PSAxOworCQlpZiAoamlmZmllcyAtIGNmcXEtPnNlZWt5X2Rpc3BhdGNo
X3N0YXJ0ID49CisJCQljZnFkLT5jZnFfc2xpY2VfaWRsZSAvIDIpCisJCQljZnFkLT5zbG93X2Rl
dmljZSB8PSAxOworCQljZnFxLT5zZWVreV9kaXNwYXRjaF9zdGFydCA9IDA7CisJfQorCiAJV0FS
Tl9PTighY2ZxZC0+cnFfaW5fZHJpdmVyKTsKIAlXQVJOX09OKCFjZnFxLT5kaXNwYXRjaGVkKTsK
IAljZnFkLT5ycV9pbl9kcml2ZXItLTsKQEAgLTQwODksNiArNDA5NCw3IEBAIHN0YXRpYyB2b2lk
ICpjZnFfaW5pdF9xdWV1ZShzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSkKIAljZnFkLT5jZnFfZ3Jv
dXBfaWRsZSA9IGNmcV9ncm91cF9pZGxlOwogCWNmcWQtPmNmcV9sYXRlbmN5ID0gMTsKIAljZnFk
LT5od190YWcgPSAtMTsKKwljZnFkLT5zbG93X2RldmljZSA9IC0xOwogCS8qCiAJICogd2Ugb3B0
aW1pc3RpY2FsbHkgc3RhcnQgYXNzdW1pbmcgc3luYyBvcHMgd2VyZW4ndCBkZWxheWVkIGluIGxh
c3QKIAkgKiBzZWNvbmQsIGluIG9yZGVyIHRvIGhhdmUgbGFyZ2VyIGRlcHRoIGZvciBhc3luYyBv
cGVyYXRpb25zLgo=
--0014853c907889be9f04ac7ad3f5--
