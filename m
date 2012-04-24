Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab2DXWnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:43:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab2DXWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:38:37 -0400
Message-Id: <20120424223255.969718560@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Baron <jbaron@redhat.com>
Subject: [ 29/42] Dont limit non-nested epoll paths
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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


