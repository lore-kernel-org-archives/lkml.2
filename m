Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab1CZAGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:06:31 -0400
Received: from kroah.org ([198.145.64.141]:35848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271Ab1CZAGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:57 2011
Message-Id: <20110326000456.974450742@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:03:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>
Subject: [11/35] aio: wake all waiters when destroying ctx
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -511,7 +511,7 @@ static inline void really_put_req(struct
 	ctx->reqs_active--;
 
 	if (unlikely(!ctx->reqs_active && ctx->dead))
-		wake_up(&ctx->wait);
+		wake_up_all(&ctx->wait);
 }
 
 static void aio_fput_routine(struct work_struct *data)
@@ -1224,7 +1224,7 @@ static void io_destroy(struct kioctx *io
 	 * by other CPUs at this point.  Right now, we rely on the
 	 * locking done by the above calls to ensure this consistency.
 	 */
-	wake_up(&ioctx->wait);
+	wake_up_all(&ioctx->wait);
 	put_ioctx(ioctx);	/* once for the lookup */
 }
 


