Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab0JBLlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 07:41:00 -0400
Received: from relay2.sgi.com ([192.48.179.30]:49777 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752939Ab0JBLk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 07:40:59 -0400
Message-Id: <20101002114057.776282935@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Sat, 02 Oct 2010 06:40:52 -0500
From: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [Patch] Limit max_user_watches to prevent integer overflow.
References: <20101002114051.090084116@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=max_user_watches_overflow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [Patch] Limit max_user_watches to prevent integer overflow.

On a 16TB machine, max_user_watches has an integer overflow.  Limit it
to INT_MAX.

Signed-off-by: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
To: Davide Libenzi <davidel@xmailserver.org>
To: linux-kernel@vger.kernel.org
To: Pekka Enberg <penberg@cs.helsinki.fi>

---

 fs/eventpoll.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: pv1010933/fs/eventpoll.c
===================================================================
--- pv1010933.orig/fs/eventpoll.c	2010-10-02 06:35:37.000000000 -0500
+++ pv1010933/fs/eventpoll.c	2010-10-02 06:38:06.479823590 -0500
@@ -1415,13 +1415,14 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 static int __init eventpoll_init(void)
 {
 	struct sysinfo si;
+	long limit;
 
 	si_meminfo(&si);
 	/*
 	 * Allows top 4% of lomem to be allocated for epoll watches (per user).
 	 */
-	max_user_watches = (((si.totalram - si.totalhigh) / 25) << PAGE_SHIFT) /
-		EP_ITEM_COST;
+	limit = (((si.totalram - si.totalhigh) / 25) << PAGE_SHIFT) / EP_ITEM_COST;
+	max_user_watches = min_t(long, limit, INT_MAX);
 
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_nested_calls_init(&poll_safewake_ncalls);

