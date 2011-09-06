Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1IFAPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 20:15:33 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53143 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1IFAOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 20:14:19 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/12] cgroups: Pull up res counter charge failure interpretation to caller
Date: Tue,  6 Sep 2011 02:13:02 +0200
Message-Id: <1315267986-28937-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

res_counter_charge() always returns -ENOMEM when the limit is reached
and the charge thus can't happen.

However it's up to the caller to interpret this failure and return
the appropriate error value. The task counter subsystem will need
to report the user that a fork() has been cancelled because of some
limit reached, not because we are too short on memory.

Fix this by returning -1 when res_counter_charge() fails.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <tj@kernel.org>
---
 kernel/res_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 4aaa790..45fa6fb 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -26,7 +26,7 @@ int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
 {
 	if (counter->usage + val > counter->limit) {
 		counter->failcnt++;
-		return -ENOMEM;
+		return -1;
 	}
 
 	counter->usage += val;
-- 
1.7.5.4

