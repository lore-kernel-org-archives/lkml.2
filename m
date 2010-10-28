Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438Ab0J1Sms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:42:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761423Ab0J1Smj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:42:39 -0400
Date: Thu, 28 Oct 2010 14:42:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, hch@lst.de
Subject: [PATCH] fix amiga and atari floppy driver compile warning
Message-ID: <20101028184223.GG30148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert, my crosstool don't produce warning below. I guess this has to do
something with compiler version.

- Geert noticed following warning during compilation.

  drivers/block/amiflop.c:1344: warning: ‘rq’ may be used uninitialized in
  this function
  drivers/block/ataflop.c:1402: warning: ‘rq’ may be used uninitialized in
  this function

- Initialize rq to NULL to fix the warning. If we can't find a suitable request
  to dispatch, this function should return NULL instead of a possibly garbage
  pointer.

- Cross compile tested only. Don't have hardware to test it.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/block/amiflop.c |    2 +-
 drivers/block/ataflop.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/block/amiflop.c
===================================================================
--- linux-2.6.orig/drivers/block/amiflop.c	2010-10-28 14:32:25.000000000 -0400
+++ linux-2.6/drivers/block/amiflop.c	2010-10-28 14:34:11.000000000 -0400
@@ -1341,7 +1341,7 @@ static struct request *set_next_request(
 {
 	struct request_queue *q;
 	int cnt = FD_MAX_UNITS;
-	struct request *rq;
+	struct request *rq = NULL;
 
 	/* Find next queue we can dispatch from */
 	fdc_queue = fdc_queue + 1;
Index: linux-2.6/drivers/block/ataflop.c
===================================================================
--- linux-2.6.orig/drivers/block/ataflop.c	2010-10-28 14:31:21.000000000 -0400
+++ linux-2.6/drivers/block/ataflop.c	2010-10-28 14:33:58.000000000 -0400
@@ -1399,7 +1399,7 @@ static struct request *set_next_request(
 {
 	struct request_queue *q;
 	int old_pos = fdc_queue;
-	struct request *rq;
+	struct request *rq = NULL;
 
 	do {
 		q = unit[fdc_queue].disk->queue;
