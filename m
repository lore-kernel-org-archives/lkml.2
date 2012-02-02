Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab2BBKfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:35:24 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4055 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab2BBKfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:35:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv7 PATCH 3/4] net/sock.h: use poll_does_not_wait() in sock_poll_wait()
Date: Thu,  2 Feb 2012 11:26:56 +0100
Message-Id: <d2c03c4e81aa4fbc8c621241e7016a2c4aa65382.1328176079.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
References: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a92b9a00741769f3c38a54d3a6799509f9089452.1328176079.git.hans.verkuil@cisco.com>
References: <a92b9a00741769f3c38a54d3a6799509f9089452.1328176079.git.hans.verkuil@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

In order to determine whether poll_wait() might actually wait the
poll_table pointer was tested in sock_poll_wait(). This is no longer
sufficient, instead poll_does_not_wait() should be called. That function
also tests whether pt->pq_proc is non-NULL.

Without this change smp_mb() could be called unnecessarily in some
circumstances, causing a performance hit.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/net/sock.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 91c1c8b..da7f2ec 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1824,7 +1824,7 @@ static inline bool wq_has_sleeper(struct socket_wq *wq)
 static inline void sock_poll_wait(struct file *filp,
 		wait_queue_head_t *wait_address, poll_table *p)
 {
-	if (p && wait_address) {
+	if (!poll_does_not_wait(p) && wait_address) {
 		poll_wait(filp, wait_address, p);
 		/*
 		 * We need to be sure we are in sync with the
-- 
1.7.8.3

