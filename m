Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab2FGG1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 02:27:45 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54380 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab2FGG1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 02:27:44 -0400
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 23:27:43 -0700
Message-ID: <CAFR8ueeU0z69zAHxJULohZoJ3ONX-ku2mzmUiUatQ=n-V4Eq+w@mail.gmail.com>
Subject: [PATCH] block: In blk_execute_rq_nowait, init rq->end_io before
 checking for dead queue.
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae9cdc6bb3755df04c1dbfb60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9cdc6bb3755df04c1dbfb60
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Jun 6, 2012 at 11:16 PM, Tejun Heo <tj@kernel.org> wrote:
> Sorry to be nit-picky but Jens would appreciate proper subject and it
> would also be nice to mention the locking change (or even separate
> that into a separate patch).

No problem. Changed the subject and also added the info about queue
lock in the description. Please check.

-----------------------
blk-exec.c: In blk_execute_rq_nowait(), if the queue is dead, call to
done() routine is not made. That will result in blk_execute_rq() stuck
in wait_for_completion(). Avoid this by initializing rq->end_io to
done() routine before we check for dead queue.

Also, in case of dead queue, call the completion routine with queue->lock held.


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


------------------------------------







>
> Thanks.
>
> --
> tejun

--14dae9cdc6bb3755df04c1dbfb60
Content-Type: text/x-diff; charset=US-ASCII; 
	name="blk-exec-assign-endio-before-queue-dead-check.patch"
Content-Disposition: attachment; 
	filename="blk-exec-assign-endio-before-queue-dead-check.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h35g10qi0

LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KYmxrLWV4ZWMuYzogSW4gYmxrX2V4ZWN1dGVfcnFfbm93
YWl0KCksIGlmIHRoZSBxdWV1ZSBpcyBkZWFkLCBjYWxsIHRvIApkb25lKCkgcm91dGluZSBpcyBu
b3QgbWFkZS4gVGhhdCB3aWxsIHJlc3VsdCBpbiBibGtfZXhlY3V0ZV9ycSgpIHN0dWNrCmluIHdh
aXRfZm9yX2NvbXBsZXRpb24oKS4gQXZvaWQgdGhpcyBieSBpbml0aWFsaXppbmcgcnEtPmVuZF9p
byB0bwpkb25lKCkgcm91dGluZSBiZWZvcmUgd2UgY2hlY2sgZm9yIGRlYWQgcXVldWUuCgpBbHNv
LCBpbiBjYXNlIG9mIGRlYWQgcXVldWUsIGNhbGwgdGhlIGNvbXBsZXRpb24gcm91dGluZSB3aXRo
IHF1ZXVlLT5sb2NrIGhlbGQuCgoKU2lnbmVkLW9mZi1ieTogTXV0aHVrdW1hciBSYXR0eSA8bXV0
aHVyQGdtYWlsLmNvbT4KQ0M6IFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4KQ0M6IEplbnMgQXhi
b2UgPGF4Ym9lQGtlcm5lbC5kaz4KQ0M6IEphbWVzIEJvdHRvbWxleSA8SmFtZXMuQm90dG9tbGV5
QGhhbnNlbnBhcnRuZXJzaGlwLmNvbT4KCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpkaWZmIC0t
Z2l0IGEvYmxvY2svYmxrLWV4ZWMuYyBiL2Jsb2NrL2Jsay1leGVjLmMKaW5kZXggZmIyY2JkNS4u
Mjg0YmY1NiAxMDA2NDQKLS0tIGEvYmxvY2svYmxrLWV4ZWMuYworKysgYi9ibG9jay9ibGstZXhl
Yy5jCkBAIC01MywxNiArNTMsMTcgQEAgdm9pZCBibGtfZXhlY3V0ZV9ycV9ub3dhaXQoc3RydWN0
IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCBnZW5kaXNrICpiZF9kaXNrLAogCVdBUk5fT04oaXJx
c19kaXNhYmxlZCgpKTsKIAlzcGluX2xvY2tfaXJxKHEtPnF1ZXVlX2xvY2spOwogCisJcnEtPnJx
X2Rpc2sgPSBiZF9kaXNrOworCXJxLT5lbmRfaW8gPSBkb25lOworCiAJaWYgKHVubGlrZWx5KGJs
a19xdWV1ZV9kZWFkKHEpKSkgewotCQlzcGluX3VubG9ja19pcnEocS0+cXVldWVfbG9jayk7CiAJ
CXJxLT5lcnJvcnMgPSAtRU5YSU87CiAJCWlmIChycS0+ZW5kX2lvKQogCQkJcnEtPmVuZF9pbyhy
cSwgcnEtPmVycm9ycyk7CisJCXNwaW5fdW5sb2NrX2lycShxLT5xdWV1ZV9sb2NrKTsKIAkJcmV0
dXJuOwogCX0KIAotCXJxLT5ycV9kaXNrID0gYmRfZGlzazsKLQlycS0+ZW5kX2lvID0gZG9uZTsK
IAlfX2Vsdl9hZGRfcmVxdWVzdChxLCBycSwgd2hlcmUpOwogCV9fYmxrX3J1bl9xdWV1ZShxKTsK
IAkvKiB0aGUgcXVldWUgaXMgc3RvcHBlZCBzbyBpdCB3b24ndCBiZSBydW4gKi8K
--14dae9cdc6bb3755df04c1dbfb60--
