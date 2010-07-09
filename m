Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab0GIKdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:33:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48310 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab0GIKds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:33:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N9zzuWaoJ08OodCMciidwEHENaBNj+PKxpGPLKCo5muPmps5k26Lkxysga6PEA9gp3
         syjgFHWNbtWM/8ZysgGrl9fEbbiXsvqp+cDdsCMfZ12/5ozTXNcRhc0HhqgQQH5/Kyfo
         BDIX5QQCppe3McJ00fiQmcGLiOKke7QK8TO50=
MIME-Version: 1.0
In-Reply-To: <x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	<x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
	<x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 9 Jul 2010 12:33:36 +0200
Message-ID: <AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Content-Type: multipart/mixed; boundary=0016e659f3e61a5d22048af1f006
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e659f3e61a5d22048af1f006
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 7, 2010 at 10:06 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> On Wed, Jul 7, 2010 at 7:03 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>>
>>>> Hi Jens,
>>>> patch 8e55063 "cfq-iosched: fix corner cases in idling logic", is
>>>> suspected for some regressions on high end hardware.
>>>> The two patches from this series:
>>>> - [PATCH 1/2] cfq-iosched: fix tree-wide handling of rq_noidle
>>>> - [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
>>>> fix two issues that I have identified, related to how RQ_NOIDLE is
>>>> used by the upper layers.
>>>> First patch makes sure that a RQ_NOIDLE coming after a sequence of
>>>> possibly idling requests from the same queue on the no-idle tree will
>>>> clear the noidle_tree_requires_idle flag.
>>>> Second patch enables RQ_NOIDLE for queues in the idling tree,
>>>> restoring the behaviour pre-8e55063 patch.
>>>
>>> Hi, Corrado,
>>>
>>> I ran your kernel through my tests. =C2=A0Here are the results, up agai=
nst
>>> vanilla, deadline, and the blk_yield patch set:
>>>
>> Hi Jeff,
>> can you also add cfq with 8e55063 reverted to the testing mix?
>
> Sure, the results now look like this:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 just =C2=A0 =C2=
=A0just
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fs_mark =C2=A0fio =
=C2=A0 =C2=A0 =C2=A0 =C2=A0mixed
> -------------------------------+--------------
> deadline =C2=A0 =C2=A0 =C2=A0 =C2=A0529.44 =C2=A0 151.4 | 450.0 =C2=A0 =
=C2=A078.2
> vanilla cfq =C2=A0 =C2=A0 107.88 =C2=A0 164.4 | =C2=A0 6.6 =C2=A0 137.2
> blk_yield cfq =C2=A0 530.82 =C2=A0 158.7 | 113.2 =C2=A0 =C2=A078.6
> corrado cfq =C2=A0 =C2=A0 110.16 =C2=A0 220.6 | =C2=A0 7.0 =C2=A0 159.8
> 8e55063 revert =C2=A0559.66 =C2=A0 198.9 | =C2=A016.1 =C2=A0 153.3
>
> I had accidentally run your patch set (corrado cfq) on ext3, so the
> numbers were a bit off (everything else was run against ext4). =C2=A0The
> corrected numbers above reflect the performance on ext4, which is much
> better for the sequential reader, but still not great for the fs_mark
> run. =C2=A0Reverting 8e55063 definitely gets us into better shape. =C2=A0=
However,
> if we care about the mixed workload, then it won't be enough.

Wondering why deadline performs so well in the fs_mark workload. Is it
because it doesn't distinguish between sync and async writes?
Maybe we can achieve something similar by putting all sync writes
(that are marked as REQ_NOIDLE) in the noidle tree? This, coupled with
making jbd(2) perform sync writes, should make the yield automatic,
since they all live in the same tree for which we don't idle between
queues, and should be able to provide fairness compared to a
sequential reader (that lives in the other tree).

Can you test the attached patch, where I also added your changes to
make jbd(2) to perform sync writes?

Thanks,
Corrado

>
> It's worth noting that I can't explain that jump from 151MB/s for
> deadline vs 220MB/s for corrado cfq. =C2=A0I'm not sure how you can vary
> driving a single queue depth sequential read at all. =C2=A0Those are the
> averages of 5 runs and this storage should be solely accessible by me,
> so I am at a loss.
>
> Cheers,
> Jeff
>



--=20
__________________________________________________________________________

dott. Corrado Zoccolo=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 Tales of Power - C. Castaneda

--0016e659f3e61a5d22048af1f006
Content-Type: application/octet-stream; 
	name="0001-p.o.c.-fairness-between-seq-reader-and-sync-writers.patch"
Content-Disposition: attachment; 
	filename="0001-p.o.c.-fairness-between-seq-reader-and-sync-writers.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbevzksr0

RnJvbSA4OGU0YzI2YzM4MmU1ZWE4NDY2YjRiYWUzY2E2ZWZhZTMzZWVhYTkxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb3JyYWRvIFpvY2NvbG8gPGN6b2Njb2xvQGdtYWlsLmNvbT4K
RGF0ZTogRnJpLCA5IEp1bCAyMDEwIDEyOjI4OjAwICswMjAwClN1YmplY3Q6IFtQQVRDSF0gcC5v
LmMuOiBmYWlybmVzcyBiZXR3ZWVuIHNlcSByZWFkZXIgYW5kIHN5bmMgd3JpdGVycwoKRm9yY2Ug
YWxsIHF1ZXVlcyB0aGF0IGhhdmUgUkVRX05PSURMRSByZXF1ZXN0cyB0byBiZSBwdXQgaW4gdGhl
IG5vaWRsZQp0cmVlLiBUaGlzIGFsbG93cyBzZWFtbGVzcyBzd2l0Y2hpbmcgYmV0d2VlbiB0aGVt
LCBidXQgZW5zdXJlIGZhaXJuZXNzCndoZW4gY29tcGV0aW5nIHdpdGggc2VxdWVudGlhbCByZWFk
ZXJzLgotLS0KIGJsb2NrL2NmcS1pb3NjaGVkLmMgfCAgIDE4ICsrKystLS0tLS0tLS0tLS0tLQog
ZnMvamJkL2NvbW1pdC5jICAgICB8ICAgIDIgKy0KIGZzL2piZDIvY29tbWl0LmMgICAgfCAgICAy
ICstCiAzIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvYmxvY2svY2ZxLWlvc2NoZWQuYyBiL2Jsb2NrL2NmcS1pb3NjaGVkLmMKaW5k
ZXggZWI0MDg2Zi4uNDlkYWRhNCAxMDA2NDQKLS0tIGEvYmxvY2svY2ZxLWlvc2NoZWQuYworKysg
Yi9ibG9jay9jZnEtaW9zY2hlZC5jCkBAIC0yMTYsNyArMjE2LDYgQEAgc3RydWN0IGNmcV9kYXRh
IHsKIAllbnVtIHdsX3R5cGVfdCBzZXJ2aW5nX3R5cGU7CiAJdW5zaWduZWQgbG9uZyB3b3JrbG9h
ZF9leHBpcmVzOwogCXN0cnVjdCBjZnFfZ3JvdXAgKnNlcnZpbmdfZ3JvdXA7Ci0JYm9vbCBub2lk
bGVfdHJlZV9yZXF1aXJlc19pZGxlOwogCiAJLyoKIAkgKiBFYWNoIHByaW9yaXR5IHRyZWUgaXMg
c29ydGVkIGJ5IG5leHRfcmVxdWVzdCBwb3NpdGlvbi4gIFRoZXNlCkBAIC0yMTI2LDcgKzIxMjUs
NiBAQCBzdGF0aWMgdm9pZCBjaG9vc2Vfc2VydmljZV90cmVlKHN0cnVjdCBjZnFfZGF0YSAqY2Zx
ZCwgc3RydWN0IGNmcV9ncm91cCAqY2ZxZykKIAlzbGljZSA9IG1heF90KHVuc2lnbmVkLCBzbGlj
ZSwgQ0ZRX01JTl9UVCk7CiAJY2ZxX2xvZyhjZnFkLCAid29ya2xvYWQgc2xpY2U6JWQiLCBzbGlj
ZSk7CiAJY2ZxZC0+d29ya2xvYWRfZXhwaXJlcyA9IGppZmZpZXMgKyBzbGljZTsKLQljZnFkLT5u
b2lkbGVfdHJlZV9yZXF1aXJlc19pZGxlID0gZmFsc2U7CiB9CiAKIHN0YXRpYyBzdHJ1Y3QgY2Zx
X2dyb3VwICpjZnFfZ2V0X25leHRfY2ZxZyhzdHJ1Y3QgY2ZxX2RhdGEgKmNmcWQpCkBAIC0zMTA4
LDcgKzMxMDYsOSBAQCBjZnFfdXBkYXRlX2lkbGVfd2luZG93KHN0cnVjdCBjZnFfZGF0YSAqY2Zx
ZCwgc3RydWN0IGNmcV9xdWV1ZSAqY2ZxcSwKIAlpZiAoY2ZxcS0+cXVldWVkWzBdICsgY2ZxcS0+
cXVldWVkWzFdID49IDQpCiAJCWNmcV9tYXJrX2NmcXFfZGVlcChjZnFxKTsKIAotCWlmICghYXRv
bWljX3JlYWQoJmNpYy0+aW9jLT5ucl90YXNrcykgfHwgIWNmcWQtPmNmcV9zbGljZV9pZGxlIHx8
CisJaWYgKGNmcXEtPm5leHRfcnEgJiYgKGNmcXEtPm5leHRfcnEtPmNtZF9mbGFncyAmIFJFUV9O
T0lETEUpKQorCQllbmFibGVfaWRsZSA9IDA7CisJZWxzZSBpZiAoIWF0b21pY19yZWFkKCZjaWMt
PmlvYy0+bnJfdGFza3MpIHx8ICFjZnFkLT5jZnFfc2xpY2VfaWRsZSB8fAogCSAgICAoIWNmcV9j
ZnFxX2RlZXAoY2ZxcSkgJiYgQ0ZRUV9TRUVLWShjZnFxKSkpCiAJCWVuYWJsZV9pZGxlID0gMDsK
IAllbHNlIGlmIChzYW1wbGVfdmFsaWQoY2ljLT50dGltZV9zYW1wbGVzKSkgewpAQCAtMzQyMSwx
NyArMzQyMSw3IEBAIHN0YXRpYyB2b2lkIGNmcV9jb21wbGV0ZWRfcmVxdWVzdChzdHJ1Y3QgcmVx
dWVzdF9xdWV1ZSAqcSwgc3RydWN0IHJlcXVlc3QgKnJxKQogCQkJY2ZxX3NsaWNlX2V4cGlyZWQo
Y2ZxZCwgMSk7CiAJCWVsc2UgaWYgKHN5bmMgJiYgY2ZxcV9lbXB0eSAmJgogCQkJICFjZnFfY2xv
c2VfY29vcGVyYXRvcihjZnFkLCBjZnFxKSkgewotCQkJY2ZxZC0+bm9pZGxlX3RyZWVfcmVxdWly
ZXNfaWRsZSB8PQotCQkJCSEocnEtPmNtZF9mbGFncyAmIFJFUV9OT0lETEUpOwotCQkJLyoKLQkJ
CSAqIElkbGluZyBpcyBlbmFibGVkIGZvciBTWU5DX1dPUktMT0FELgotCQkJICogU1lOQ19OT0lE
TEVfV09SS0xPQUQgaWRsZXMgYXQgdGhlIGVuZCBvZiB0aGUgdHJlZQotCQkJICogb25seSBpZiB3
ZSBwcm9jZXNzZWQgYXQgbGVhc3Qgb25lICFSRVFfTk9JRExFIHJlcXVlc3QKLQkJCSAqLwotCQkJ
aWYgKGNmcWQtPnNlcnZpbmdfdHlwZSA9PSBTWU5DX1dPUktMT0FECi0JCQkgICAgfHwgY2ZxZC0+
bm9pZGxlX3RyZWVfcmVxdWlyZXNfaWRsZQotCQkJICAgIHx8IGNmcXEtPmNmcWctPm5yX2NmcXEg
PT0gMSkKLQkJCQljZnFfYXJtX3NsaWNlX3RpbWVyKGNmcWQpOworCQkJY2ZxX2FybV9zbGljZV90
aW1lcihjZnFkKTsKIAkJfQogCX0KIApkaWZmIC0tZ2l0IGEvZnMvamJkL2NvbW1pdC5jIGIvZnMv
amJkL2NvbW1pdC5jCmluZGV4IDI4YTlkZGEuLmQ5N2EwYzYgMTAwNjQ0Ci0tLSBhL2ZzL2piZC9j
b21taXQuYworKysgYi9mcy9qYmQvY29tbWl0LmMKQEAgLTMxNyw3ICszMTcsNyBAQCB2b2lkIGpv
dXJuYWxfY29tbWl0X3RyYW5zYWN0aW9uKGpvdXJuYWxfdCAqam91cm5hbCkKIAlpbnQgZmlyc3Rf
dGFnID0gMDsKIAlpbnQgdGFnX2ZsYWc7CiAJaW50IGk7Ci0JaW50IHdyaXRlX29wID0gV1JJVEU7
CisJaW50IHdyaXRlX29wID0gV1JJVEVfU1lOQzsKIAogCS8qCiAJICogRmlyc3Qgam9iOiBsb2Nr
IGRvd24gdGhlIGN1cnJlbnQgdHJhbnNhY3Rpb24gYW5kIHdhaXQgZm9yCmRpZmYgLS1naXQgYS9m
cy9qYmQyL2NvbW1pdC5jIGIvZnMvamJkMi9jb21taXQuYwppbmRleCA3NTcxNmQzLi5hMDc4NzQ0
IDEwMDY0NAotLS0gYS9mcy9qYmQyL2NvbW1pdC5jCisrKyBiL2ZzL2piZDIvY29tbWl0LmMKQEAg
LTM2OSw3ICszNjksNyBAQCB2b2lkIGpiZDJfam91cm5hbF9jb21taXRfdHJhbnNhY3Rpb24oam91
cm5hbF90ICpqb3VybmFsKQogCWludCB0YWdfYnl0ZXMgPSBqb3VybmFsX3RhZ19ieXRlcyhqb3Vy
bmFsKTsKIAlzdHJ1Y3QgYnVmZmVyX2hlYWQgKmNiaCA9IE5VTEw7IC8qIEZvciB0cmFuc2FjdGlv
bmFsIGNoZWNrc3VtcyAqLwogCV9fdTMyIGNyYzMyX3N1bSA9IH4wOwotCWludCB3cml0ZV9vcCA9
IFdSSVRFOworCWludCB3cml0ZV9vcCA9IFdSSVRFX1NZTkM7CiAKIAkvKgogCSAqIEZpcnN0IGpv
YjogbG9jayBkb3duIHRoZSBjdXJyZW50IHRyYW5zYWN0aW9uIGFuZCB3YWl0IGZvcgotLSAKMS42
LjQuNAoK
--0016e659f3e61a5d22048af1f006--
