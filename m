Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab1JHLC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 07:02:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63572 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1JHLC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 07:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
References: <1317397918.27140.15.camel@localhost>
	<x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	<1317729761.25998.4.camel@localhost>
	<x49bottoq57.fsf@segfault.boston.devel.redhat.com>
Date: Sat, 8 Oct 2011 19:02:25 +0800
X-Google-Sender-Auth: Nz0WGF2tUKiWiNIiK2lhFoTK9eM
Message-ID: <CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
Subject: Re: [dm-devel] Block regression since 3.1-rc3
From: Shaohua Li <shli@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christophe Saout <christophe@saout.de>,
        device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Content-Type: multipart/mixed; boundary=20cf3005dd103b164204aec77eb7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3005dd103b164204aec77eb7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/10/7 Jeff Moyer <jmoyer@redhat.com>:
> Christophe Saout <christophe@saout.de> writes:
>
>> Hi Jeff,
>>
>>> Anyway, it would help a great deal if you could retrigger the failure
>>> and provide the full failure output. =A0You can get that by issuing the
>>> 'dmesg' command and redirecting it to a file.
>>
>> Oh, sorry, yes, there's a line missing.
>>
>> Line 323 is this one: BUG_ON(!rq->bio || rq->bio !=3D rq->biotail);
>
> OK, it turns out my testing was incomplete. =A0I only tested targets that
> had a write-through cache, so I didn't hit this problem. =A0It reproduces
> pretty easily with just multipath involved (no linear target on top) when
> running against the right storage.
>
> So, here's a patch, but I don't have a full explanation for it just yet.
> What I observed was that, on fsync, blkdev_issue_flush was called.
> Eventually, the flush request gets cloned, and blk_insert_cloned_request
> is called. =A0This cloned request never actually gets issued to the
> q->requst_fn (scsi_request_fn in my case). =A0So, it may be that there is
> no plug list for this, so the queue isn't goosed? =A0I'll try to come up
> with a better explanation, or Tejun may just know off the top of his
> head what's going on.
>
> So, the patch works for me, but is very much just an RFC.
>
> Cheers,
> Jeff
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 491eb30..7aa4736 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -320,7 +320,7 @@ void blk_insert_flush(struct request *rq)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 BUG_ON(!rq->bio || rq->bio !=3D rq->biotail);
> + =A0 =A0 =A0 BUG_ON(rq->bio && rq->bio !=3D rq->biotail);
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * If there's data but flush is not necessary, the request=
 can be
> @@ -345,6 +345,12 @@ void blk_insert_flush(struct request *rq)
> =A0 =A0 =A0 =A0rq->end_io =3D flush_data_end_io;
>
> =A0 =A0 =A0 =A0blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* A cloned empty flush needs a queue kick to make progre=
ss.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!rq->bio)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_run_queue_async(q);
> =A0}
Looks the dm request based flush logic is broken.

saved_make_request_fn
  __make_request
    blk_insert_flush
but blk_insert_flush doesn't put the original request to list, instead, the
q->flush_rq is in list.
then
dm_request_fn
  blk_peek_request
    dm_prep_fn
      clone_rq
  map_request
    blk_insert_cloned_request
so q->flush_rq is cloned, and get dispatched. but we can't clone q->flush_r=
q
and use it to do flush. map_request even could assign a different blockdev =
to
the cloned request.

Clone q->flush_rq is absolutely wrong. we can clear ogirinal request's flus=
h bit
and set cloned request flush bit, so we can skip the blk_insert_flush logic=
 for
original request.

can you please try this patch. Only compilation tested.

Thanks,
Shaohua

--20cf3005dd103b164204aec77eb7
Content-Type: text/x-patch; charset=US-ASCII; name="block-cloned-request-flush.patch"
Content-Disposition: attachment; filename="block-cloned-request-flush.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtii0fna0

U2lnbmVkLW9mZi1ieTogU2hhb2h1YSBMaSA8c2hhb2h1YS5saUBpbnRlbC5jb20+CgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9tZC9kbS5jIGIvZHJpdmVycy9tZC9kbS5jCmluZGV4IDUyYjM5ZjMuLjA3
YTkzMGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvZG0uYworKysgYi9kcml2ZXJzL21kL2RtLmMK
QEAgLTE0MjQsNiArMTQyNCwxMyBAQCBzdGF0aWMgaW50IGRtX21ha2VfcmVxdWVzdChzdHJ1Y3Qg
cmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IGJpbyAqYmlvKQogewogCXN0cnVjdCBtYXBwZWRfZGV2
aWNlICptZCA9IHEtPnF1ZXVlZGF0YTsKIAorCWlmIChiaW8tPmJpX3J3ICYgKFJFUV9GTFVTSCB8
IFJFUV9GVUEpKSB7CisJCWlmIChiaW8tPmJpX3J3ICYgUkVRX0ZMVVNIKQorCQkJYmlvLT5iaV9y
dyB8PSBSRVFfQ0xPTkVEX0ZMVVNIOworCQlpZiAoYmlvLT5iaV9ydyAmIFJFUV9GVUEpCisJCQli
aW8tPmJpX3J3IHw9IFJFUV9DTE9ORURfRlVBOworCQliaW8tPmJpX3J3ICY9IH4oUkVRX0ZMVVNI
fFJFUV9GVUEpOworCX0KIAlyZXR1cm4gbWQtPnNhdmVkX21ha2VfcmVxdWVzdF9mbihxLCBiaW8p
OyAvKiBjYWxsIF9fbWFrZV9yZXF1ZXN0KCkgKi8KIH0KIApAQCAtMTU0Nyw2ICsxNTU0LDE0IEBA
IHN0YXRpYyBpbnQgZG1fcHJlcF9mbihzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHJl
cXVlc3QgKnJxKQogCWlmICghY2xvbmUpCiAJCXJldHVybiBCTEtQUkVQX0RFRkVSOwogCisJaWYg
KHJxLT5jbWRfZmxhZ3MgJiBSRVFfQ0xPTkVEX0ZMVVNIKQorCQljbG9uZS0+Y21kX2ZsYWdzIHw9
IFJFUV9GTFVTSDsKKwlpZiAocnEtPmNtZF9mbGFncyAmIFJFUV9DTE9ORURfRlVBKQorCQljbG9u
ZS0+Y21kX2ZsYWdzIHw9IFJFUV9GVUE7CisKKwlycS0+Y21kX2ZsYWdzICY9ICB+KFJFUV9GTFVT
SHxSRVFfRlVBKTsKKwljbG9uZS0+Y21kX2ZsYWdzICY9ICB+KFJFUV9GTFVTSHxSRVFfRlVBKTsK
KwogCXJxLT5zcGVjaWFsID0gY2xvbmU7CiAJcnEtPmNtZF9mbGFncyB8PSBSRVFfRE9OVFBSRVA7
CiAKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYmxrX3R5cGVzLmggYi9pbmNsdWRlL2xpbnV4
L2Jsa190eXBlcy5oCmluZGV4IDcxZmM1M2IuLjZlZjVkYzMgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUv
bGludXgvYmxrX3R5cGVzLmgKKysrIGIvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaApAQCAtMTUz
LDYgKzE1Myw4IEBAIGVudW0gcnFfZmxhZ19iaXRzIHsKIAlfX1JFUV9GTFVTSF9TRVEsCS8qIHJl
cXVlc3QgZm9yIGZsdXNoIHNlcXVlbmNlICovCiAJX19SRVFfSU9fU1RBVCwJCS8qIGFjY291bnQg
SS9PIHN0YXQgKi8KIAlfX1JFUV9NSVhFRF9NRVJHRSwJLyogbWVyZ2Ugb2YgZGlmZmVyZW50IHR5
cGVzLCBmYWlsIHNlcGFyYXRlbHkgKi8KKwlfX1JFUV9DTE9ORURfRkxVU0gsCisJX19SRVFfQ0xP
TkVEX0ZVQSwKIAlfX1JFUV9OUl9CSVRTLAkJLyogc3RvcHMgaGVyZSAqLwogfTsKIApAQCAtMTcw
LDcgKzE3Miw3IEBAIGVudW0gcnFfZmxhZ19iaXRzIHsKIAkoUkVRX0ZBSUxGQVNUX0RFViB8IFJF
UV9GQUlMRkFTVF9UUkFOU1BPUlQgfCBSRVFfRkFJTEZBU1RfRFJJVkVSKQogI2RlZmluZSBSRVFf
Q09NTU9OX01BU0sgXAogCShSRVFfV1JJVEUgfCBSRVFfRkFJTEZBU1RfTUFTSyB8IFJFUV9TWU5D
IHwgUkVRX01FVEEgfCBSRVFfUFJJTyB8IFwKLQkgUkVRX0RJU0NBUkQgfCBSRVFfTk9JRExFIHwg
UkVRX0ZMVVNIIHwgUkVRX0ZVQSB8IFJFUV9TRUNVUkUpCisJIFJFUV9ESVNDQVJEIHwgUkVRX05P
SURMRSB8IFJFUV9GTFVTSCB8IFJFUV9GVUEgfCBSRVFfU0VDVVJFIHwgUkVRX0NMT05FRF9GTFVT
SCB8IFJFUV9DTE9ORURfRlVBKQogI2RlZmluZSBSRVFfQ0xPTkVfTUFTSwkJUkVRX0NPTU1PTl9N
QVNLCiAKICNkZWZpbmUgUkVRX1JBSEVBRAkJKDEgPDwgX19SRVFfUkFIRUFEKQpAQCAtMTk0LDUg
KzE5Niw3IEBAIGVudW0gcnFfZmxhZ19iaXRzIHsKICNkZWZpbmUgUkVRX0lPX1NUQVQJCSgxIDw8
IF9fUkVRX0lPX1NUQVQpCiAjZGVmaW5lIFJFUV9NSVhFRF9NRVJHRQkJKDEgPDwgX19SRVFfTUlY
RURfTUVSR0UpCiAjZGVmaW5lIFJFUV9TRUNVUkUJCSgxIDw8IF9fUkVRX1NFQ1VSRSkKKyNkZWZp
bmUgUkVRX0NMT05FRF9GTFVTSAkoMSA8PCBfX1JFUV9DTE9ORURfRkxVU0gpCisjZGVmaW5lIFJF
UV9DTE9ORURfRlVBCQkoMSA8PCBfX1JFUV9DTE9ORURfRlVBKQogCiAjZW5kaWYgLyogX19MSU5V
WF9CTEtfVFlQRVNfSCAqLwo=
--20cf3005dd103b164204aec77eb7--
