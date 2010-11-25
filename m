Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab0KYDdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 22:33:04 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47028 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0KYDdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 22:33:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=fXXBHvWUXNLiJCbzAHc8gjmGUXR45qfDwux/CenLDW2Hb/3EGx6cy3c1QMIe/YWsB0
         O/+TpIeW7447EYcMGm2FjXZjhvSZQehoH1SwqMTIWYWQH8Ob0eZhSm/vo0EAJpO/rUKI
         VOhIs2R/XC6fDZPQ2X0Db/6iwMNyor03Ocq/o=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH] epoll: initialize slack for negative timeout values
Date: Wed, 24 Nov 2010 21:31:49 -0600
Message-Id: <1290655909-10616-1-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <AANLkTi=oTq3_-7OZZwGrYjQPXA0TCDFB_DaFXJ7rvWH9@mail.gmail.com>
References: <AANLkTi=oTq3_-7OZZwGrYjQPXA0TCDFB_DaFXJ7rvWH9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a negative timeout value is passed to epoll the 'slack' variable is
currently uninitialized:

fs/eventpoll.c: In function ‘ep_poll’:
fs/eventpoll.c:1119: warning: ‘slack’ may be used uninitialized in this function

In this case a NULL pointer is passed to schedule_hrtimeout_range()
specifying an infinite timeout.  The current implementation of
schedule_hrtimeout_range() does not use slack in this case, but we
should still initialize slack to 0 in case future implementations use it.

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
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
1.7.3.2

