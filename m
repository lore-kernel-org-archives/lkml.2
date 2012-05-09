Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab2EIGYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:24:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38832 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755938Ab2EIFxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:06 -0400
Message-Id: <20120509055035.925557033@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Baron <jbaron@redhat.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 045/167] Dont limit non-nested epoll paths
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/eventpoll.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -988,6 +988,10 @@ static int path_count[PATH_ARR_SIZE];
 
 static int path_count_inc(int nests)
 {
+	/* Allow an arbitrary number of depth 1 paths */
+	if (nests == 0)
+		return 0;
+
 	if (++path_count[nests] > path_limits[nests])
 		return -1;
 	return 0;


