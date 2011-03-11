Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab1CKFz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 00:55:56 -0500
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:60155 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751358Ab1CKFzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 00:55:55 -0500
From: Roland Dreier <roland@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] aio: Wake all waiters when destroying ctx
Date: Thu, 10 Mar 2011 21:55:37 -0800
Message-Id: <1299822937-6522-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

The test program below will hang because io_getevents() uses
add_wait_queue_exclusive(), which means the wake_up() in io_destroy()
only wakes up one of the threads.  Fix this by using wake_up_all() in
the aio code paths where we want to make sure no one gets stuck.

	// t.c -- compile with gcc -lpthread -laio t.c

	#include <libaio.h>
	#include <pthread.h>
	#include <stdio.h>
	#include <unistd.h>

	static const int nthr = 2;

	void *getev(void *ctx)
	{
		struct io_event ev;
		io_getevents(ctx, 1, 1, &ev, NULL);
		printf("io_getevents returned\n");
		return NULL;
	}

	int main(int argc, char *argv[])
	{
		io_context_t ctx = 0;
		pthread_t thread[nthr];
		int i;

		io_setup(1024, &ctx);

		for (i = 0; i < nthr; ++i)
			pthread_create(&thread[i], NULL, getev, ctx);

		sleep(1);

		io_destroy(ctx);

		for (i = 0; i < nthr; ++i)
			pthread_join(thread[i], NULL);

		return 0;
	}

Cc: <stable@kernel.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 fs/aio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 26869cd..88f0ed5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -520,7 +520,7 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 	ctx->reqs_active--;
 
 	if (unlikely(!ctx->reqs_active && ctx->dead))
-		wake_up(&ctx->wait);
+		wake_up_all(&ctx->wait);
 }
 
 static void aio_fput_routine(struct work_struct *data)
@@ -1229,7 +1229,7 @@ static void io_destroy(struct kioctx *ioctx)
 	 * by other CPUs at this point.  Right now, we rely on the
 	 * locking done by the above calls to ensure this consistency.
 	 */
-	wake_up(&ioctx->wait);
+	wake_up_all(&ioctx->wait);
 	put_ioctx(ioctx);	/* once for the lookup */
 }
 
