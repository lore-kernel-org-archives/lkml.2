Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1AORBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 12:01:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60377 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1AORBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 12:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=CUG7KLKqH3q5MLDFcWyloRWD8S+qy4n4+HRz4BEAOBI7x+MQvLJS/UIvxD42NjciH/
         NTJUaBIBISQU6e9Z0BSlD2ypy+yQqkJn9k2CWqA+nO5x8ojsL1kPav8J6HAP+H/Pyr/u
         TcsPoHG/cuw+AUQT7hTWxe4gB2QhdneQeOA5E=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Stone <jwjstone@fastmail.fm>, Viresh Kumar <viresh.kumar@st.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Davide Libenzi <davidel@xmailserver.org>,
        Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 1/3] epoll: initialize slack for negative timeout values
Date: Sat, 15 Jan 2011 11:00:35 -0600
Message-Id: <1295110837-3061-1-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110115162027.GA2552@lintop>
References: <20110115162027.GA2552@lintop>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a negative timeout value is passed to epoll the 'slack' variable is
currently unitialized:

fs/eventpoll.c: In function ‘ep_poll’:
fs/eventpoll.c:1119: warning: ‘slack’ may be used uninitialized in this function

In this case a NULL pointer is passed to schedule_hrtimeout_range()
specifying an infinite timeout.  The current implementation of
schedule_hrtimeout_range() does not use slack in this case, but we
should still initialize slack to 0 in case future implementations use it.

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
---
 fs/eventpoll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8cf0724..c24a032 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1116,7 +1116,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 {
 	int res, eavail, timed_out = 0;
 	unsigned long flags;
-	long slack;
+	long slack = 0;
 	wait_queue_t wait;
 	struct timespec end_time;
 	ktime_t expires, *to = NULL;
-- 
1.7.3.4

