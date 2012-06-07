Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab2FGGNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 02:13:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63332 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759971Ab2FGGND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 02:13:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAOS58YPAOYcHYkXu7hW-DeGRXkFqoF1cLarJFfh0eNfFaVHyBg@mail.gmail.com>
References: <CAFR8ueeUH-O8+jeZu2Aeyu4ZDHv255a2qqnt0_Af79oY2JGzTw@mail.gmail.com>
	<CAOS58YOf0m5WUcn3b2f_PGr=P+DH1-0EHBy_fHw3xmccHW+zRA@mail.gmail.com>
	<CAFR8uedYpEX+9RiK11G-KvcEU7mYrt58OAFWs4mgoUpLQMowTQ@mail.gmail.com>
	<CAOS58YPAOYcHYkXu7hW-DeGRXkFqoF1cLarJFfh0eNfFaVHyBg@mail.gmail.com>
Date: Wed, 6 Jun 2012 23:13:02 -0700
Message-ID: <CAFR8uedHZ81JpY2jb0j9FLE3Uxibc=mSDFp496ChQLzkQqQdMw@mail.gmail.com>
Subject: Re: [PATCH] blk-exec-assign-endio-before-queue-dead-check
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf307d059eb4f42204c1dbc635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf307d059eb4f42204c1dbc635
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Jun 6, 2012 at 10:53 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Thu, Jun 7, 2012 at 2:42 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
>>>> One more thing to consider is, the completion function is called from
>>>> the same calling context here. As far as my check, it looks ok. Let me
>>>> know if you think otherwise.
>>>
>>> Not sure what you mean.
>>
>> If there is no error, then the completion routine is called in a
>> different context - rq completion context. But here, we call the
>> completion routine in the same context of the caller.
>
> Ah, okay. I think the only problem there would be that the end_io
> callback is being called outside queue lock. Can you please take care
> of that too?
>

Revised patch (below as well as attached)

>> blk-exec.c: In blk_execute_rq_nowait(), if the queue is dead, call to
>> done() routine is not made. That will result in blk_execute_rq() stuck
>> in wait_for_completion(). Avoid this by initializing rq->end_io to
>> done() routine before we check for dead queue.
>
> Yeah, sounds about right.
>
> Thanks.
>
> --
> tejun


-----------------------
blk-exec.c: In blk_execute_rq_nowait(), if the queue is dead, call to
done() routine is not made. That will result in blk_execute_rq() stuck
in wait_for_completion(). Avoid this by initializing rq->end_io to
done() routine before we check for dead queue.

Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
CC: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>

-----------------------

diff --git a/block/blk-exec.c b/block/blk-exec.c
index fb2cbd5..284bf56 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -53,16 +53,17 @@ void blk_execute_rq_nowait(struct request_queue
*q, struct gendisk *bd_disk,
        WARN_ON(irqs_disabled());
        spin_lock_irq(q->queue_lock);

+       rq->rq_disk = bd_disk;
+       rq->end_io = done;
+
        if (unlikely(blk_queue_dead(q))) {
-               spin_unlock_irq(q->queue_lock);
                rq->errors = -ENXIO;
                if (rq->end_io)
                        rq->end_io(rq, rq->errors);
+               spin_unlock_irq(q->queue_lock);
                return;
        }

-       rq->rq_disk = bd_disk;
-       rq->end_io = done;
        __elv_add_request(q, rq, where);
        __blk_run_queue(q);
        /* the queue is stopped so it won't be run */

--20cf307d059eb4f42204c1dbc635
Content-Type: text/x-diff; charset=US-ASCII; 
	name="blk-exec-assign-endio-before-queue-dead-check.patch"
Content-Disposition: attachment; 
	filename="blk-exec-assign-endio-before-queue-dead-check.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h35fiq0z0

LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KYmxrLWV4ZWMuYzogSW4gYmxrX2V4ZWN1dGVfcnFfbm93
YWl0KCksIGlmIHRoZSBxdWV1ZSBpcyBkZWFkLCBjYWxsIHRvIApkb25lKCkgcm91dGluZSBpcyBu
b3QgbWFkZS4gVGhhdCB3aWxsIHJlc3VsdCBpbiBibGtfZXhlY3V0ZV9ycSgpIHN0dWNrCmluIHdh
aXRfZm9yX2NvbXBsZXRpb24oKS4gQXZvaWQgdGhpcyBieSBpbml0aWFsaXppbmcgcnEtPmVuZF9p
byB0bwpkb25lKCkgcm91dGluZSBiZWZvcmUgd2UgY2hlY2sgZm9yIGRlYWQgcXVldWUuCgpTaWdu
ZWQtb2ZmLWJ5OiBNdXRodWt1bWFyIFJhdHR5IDxtdXRodXJAZ21haWwuY29tPgpDQzogVGVqdW4g
SGVvIDx0akBrZXJuZWwub3JnPgpDQzogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgpDQzog
SmFtZXMgQm90dG9tbGV5IDxKYW1lcy5Cb3R0b21sZXlAaGFuc2VucGFydG5lcnNoaXAuY29tPgoK
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCmRpZmYgLS1naXQgYS9ibG9jay9ibGstZXhlYy5jIGIv
YmxvY2svYmxrLWV4ZWMuYwppbmRleCBmYjJjYmQ1Li4yODRiZjU2IDEwMDY0NAotLS0gYS9ibG9j
ay9ibGstZXhlYy5jCisrKyBiL2Jsb2NrL2Jsay1leGVjLmMKQEAgLTUzLDE2ICs1MywxNyBAQCB2
b2lkIGJsa19leGVjdXRlX3JxX25vd2FpdChzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0
IGdlbmRpc2sgKmJkX2Rpc2ssCiAJV0FSTl9PTihpcnFzX2Rpc2FibGVkKCkpOwogCXNwaW5fbG9j
a19pcnEocS0+cXVldWVfbG9jayk7CiAKKwlycS0+cnFfZGlzayA9IGJkX2Rpc2s7CisJcnEtPmVu
ZF9pbyA9IGRvbmU7CisKIAlpZiAodW5saWtlbHkoYmxrX3F1ZXVlX2RlYWQocSkpKSB7Ci0JCXNw
aW5fdW5sb2NrX2lycShxLT5xdWV1ZV9sb2NrKTsKIAkJcnEtPmVycm9ycyA9IC1FTlhJTzsKIAkJ
aWYgKHJxLT5lbmRfaW8pCiAJCQlycS0+ZW5kX2lvKHJxLCBycS0+ZXJyb3JzKTsKKwkJc3Bpbl91
bmxvY2tfaXJxKHEtPnF1ZXVlX2xvY2spOwogCQlyZXR1cm47CiAJfQogCi0JcnEtPnJxX2Rpc2sg
PSBiZF9kaXNrOwotCXJxLT5lbmRfaW8gPSBkb25lOwogCV9fZWx2X2FkZF9yZXF1ZXN0KHEsIHJx
LCB3aGVyZSk7CiAJX19ibGtfcnVuX3F1ZXVlKHEpOwogCS8qIHRoZSBxdWV1ZSBpcyBzdG9wcGVk
IHNvIGl0IHdvbid0IGJlIHJ1biAqLwo=
--20cf307d059eb4f42204c1dbc635--
