Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921Ab2JAXUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:20:49 -0400
Received: from 1wt.eu ([62.212.114.60]:35391 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957Ab2JAXBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:35 -0400
Message-Id: <20121001225204.054639192@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jason Baron <jbaron@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 152/180] Dont limit non-nested epoll paths
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Baron <jbaron@redhat.com>

commit 93dc6107a76daed81c07f50215fa6ae77691634f upstream.

Commit 28d82dc1c4ed ("epoll: limit paths") that I did to limit the
number of possible wakeup paths in epoll is causing a few applications
to longer work (dovecot for one).

The original patch is really about limiting the amount of epoll nesting
(since epoll fds can be attached to other fds). Thus, we probably can
allow an unlimited number of paths of depth 1. My current patch limits
it at 1000. And enforce the limits on paths that have a greater depth.

This is captured in: https://bugzilla.redhat.com/show_bug.cgi?id=681578

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/eventpoll.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8da83d8..802b28d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -975,6 +975,10 @@ static int path_count[PATH_ARR_SIZE];
 
 static int path_count_inc(int nests)
 {
+	/* Allow an arbitrary number of depth 1 paths */
+	if (nests == 0)
+		return 0;
+
 	if (++path_count[nests] > path_limits[nests])
 		return -1;
 	return 0;
-- 
1.7.2.1.45.g54fbc



