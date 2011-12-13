Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1LMVpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 16:45:10 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25839 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab1LMVpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 16:45:07 -0500
Message-ID: <4EE7C74D.1020306@oracle.com>
Date: Tue, 13 Dec 2011 15:44:45 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: linux-aio@kvack.org
CC: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Andi Kleen <ak@linux.intel.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] AIO: Don't plug the I/O queue in do_io_submit()
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EE7C757.0015,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asynchronous I/O latency to a solid-state disk greatly increased
between the 2.6.32 and 3.0 kernels. By removing the plug from
do_io_submit(), we observed a 34% improvement in the I/O latency.

Unfortunately, at this level, we don't know if the request is to
a rotating disk or not.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-aio@kvack.org
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/aio.c b/fs/aio.c
index 78c514c..d131a2c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1696,7 +1696,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 	struct kioctx *ctx;
 	long ret = 0;
 	int i = 0;
-	struct blk_plug plug;
 	struct kiocb_batch batch;
 
 	if (unlikely(nr < 0))
@@ -1716,8 +1715,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 
 	kiocb_batch_init(&batch, nr);
 
-	blk_start_plug(&plug);
-
 	/*
 	 * AKPM: should this return a partial result if some of the IOs were
 	 * successfully submitted?
@@ -1740,7 +1737,6 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 		if (ret)
 			break;
 	}
-	blk_finish_plug(&plug);
 
 	kiocb_batch_free(&batch);
 	put_ioctx(ctx);
