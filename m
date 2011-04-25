Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab1DYUY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:58 -0400
Received: from 1wt.eu ([62.212.114.60]:34255 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239Ab1DYUYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:41 -0400
Message-Id: <20110425200237.425356020@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 102/173] aio: wake all waiters when destroying ctx
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit e91f90bb0bb10be9cc8efd09a3cf4ecffcad0db1 upstream.

The test program below will hang because io_getevents() uses
add_wait_queue_exclusive(), which means the wake_up() in io_destroy() only
wakes up one of the threads.  Fix this by using wake_up_all() in the aio
code paths where we want to make sure no one gets stuck.

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

Signed-off-by: Roland Dreier <roland@purestorage.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/aio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -497,7 +497,7 @@ static inline void really_put_req(struct
 	ctx->reqs_active--;
 
 	if (unlikely(!ctx->reqs_active && ctx->dead))
-		wake_up(&ctx->wait);
+		wake_up_all(&ctx->wait);
 }
 
 static void aio_fput_routine(struct work_struct *data)
@@ -1219,7 +1219,7 @@ static void io_destroy(struct kioctx *io
 	 * by other CPUs at this point.  Right now, we rely on the
 	 * locking done by the above calls to ensure this consistency.
 	 */
-	wake_up(&ioctx->wait);
+	wake_up_all(&ioctx->wait);
 	put_ioctx(ioctx);	/* once for the lookup */
 }
 


