Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab1CXRuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:50:01 -0400
Received: from flusers.ccur.com ([173.221.59.2]:29457 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756671Ab1CXRs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:58 -0400
Date: Thu, 24 Mar 2011 13:48:04 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/24] jrcu: bugfix: process all tokens
Message-ID: <20110324174804.GA18943@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: process all tokens written to debugfs file rcudata,
not just the first one.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -659,6 +659,7 @@ static ssize_t rcu_debugfs_write(struct 
 	if (__get_user(c, &buffer[i++]))
 		return -EFAULT;
 
+next:
 	/* Token extractor -- first, skip leading whitepace */
 	while (c && isspace(c) && i < count) {
 		if (__get_user(c, &buffer[i++]))
@@ -693,8 +694,7 @@ static ssize_t rcu_debugfs_write(struct 
 		rcu_wdog_lim = wdog * USEC_PER_SEC;
 	} else
 		return -EINVAL;
-
-	return count;
+	goto next;
 }
 
 static int rcu_debugfs_open(struct inode *inode, struct file *file)
