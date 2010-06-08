Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0FHO2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 10:28:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46322 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab0FHO2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 10:28:53 -0400
To: jens.axboe@oracle.com
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pipe: fix pipe buffer resizing
Message-Id: <E1OLznJ-0003rR-OZ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 08 Jun 2010 16:28:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

pipe_set_size() needs to copy pipe bufs from the old circular buffer
to the new.

The current code gets this wrong in multiple ways, resulting in oops.

Test program is available here:
  http://www.kernel.org/pub/linux/kernel/people/mszeredi/piperesize/

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/pipe.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux.git/fs/pipe.c
===================================================================
--- linux.git.orig/fs/pipe.c	2010-06-08 15:02:16.000000000 +0200
+++ linux.git/fs/pipe.c	2010-06-08 15:50:07.000000000 +0200
@@ -1145,13 +1145,20 @@ static long pipe_set_size(struct pipe_in
 	 * and adjust the indexes.
 	 */
 	if (pipe->nrbufs) {
-		const unsigned int tail = pipe->nrbufs & (pipe->buffers - 1);
-		const unsigned int head = pipe->nrbufs - tail;
+		unsigned int tail;
+		unsigned int head;
 
+		tail = pipe->curbuf + pipe->nrbufs;
+		if (tail < pipe->buffers)
+			tail = 0;
+		else
+			tail &= (pipe->buffers - 1);
+
+		head = pipe->nrbufs - tail;
 		if (head)
 			memcpy(bufs, pipe->bufs + pipe->curbuf, head * sizeof(struct pipe_buffer));
 		if (tail)
-			memcpy(bufs + head, pipe->bufs + pipe->curbuf, tail * sizeof(struct pipe_buffer));
+			memcpy(bufs + head, pipe->bufs, tail * sizeof(struct pipe_buffer));
 	}
 
 	pipe->curbuf = 0;
