Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2BADiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 22:38:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60762 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2BADiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 22:38:20 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Tim Hockin <thockin@hockin.org>, Tejun Heo <htejun@gmail.com>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH 05/10] res_counter: allow charge failure pointer to be null
Date: Wed,  1 Feb 2012 04:37:45 +0100
Message-Id: <1328067470-5980-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that callers of res_counter_charge() don't have to create and pass this
pointer even if they aren't interested in it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Containers <containers@lists.linux-foundation.org>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Cgroups <cgroups@vger.kernel.org>
Cc: Daniel J Walsh <dwalsh@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Max Kellermann <mk@cm4all.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/res_counter.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 6dc6164..d2fc4cd 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -43,14 +43,16 @@ int res_counter_charge_until(struct res_counter *counter,
 	unsigned long flags;
 	struct res_counter *c, *u;
 
-	*limit_fail_at = NULL;
+	if (limit_fail_at)
+		*limit_fail_at = NULL;
 	local_irq_save(flags);
 	for (c = counter; c != limit; c = c->parent) {
 		spin_lock(&c->lock);
 		ret = res_counter_charge_locked(c, val);
 		spin_unlock(&c->lock);
 		if (ret < 0) {
-			*limit_fail_at = c;
+			if (limit_fail_at)
+				*limit_fail_at = c;
 			goto undo;
 		}
 	}
-- 
1.7.5.4

