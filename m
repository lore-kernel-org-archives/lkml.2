Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0LOJgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:36:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64538 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab0LOJgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:36:15 -0500
Message-ID: <4D088C14.1080405@cn.fujitsu.com>
Date: Wed, 15 Dec 2010 17:36:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: [PATCH v2 5/6] cgroups: Triger BUG if a bindable subsystem calls
 css_get()
References: <4D088BB5.30903@cn.fujitsu.com>
In-Reply-To: <4D088BB5.30903@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 17:36:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 17:36:13,
	Serialize complete at 2010-12-15 17:36:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now unbindable subsystems should not use css_get/put(), so check
this misuse.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    7 +++++--
 kernel/cgroup.c        |    5 +++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 17579b2..e8ad9f1 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -80,13 +80,15 @@ struct cgroup_subsys_state {
 
 /* bits in struct cgroup_subsys_state flags field */
 enum {
-	CSS_ROOT, /* This CSS is the root of the subsystem */
-	CSS_REMOVED, /* This CSS is dead */
+	CSS_ROOT,	/* This CSS is the root of the subsystem */
+	CSS_REMOVED,	/* This CSS is dead */
+	CSS_NO_GET,	/* Forbid calling css_get/put() */
 };
 
 /* Caller must verify that the css is not for root cgroup */
 static inline void __css_get(struct cgroup_subsys_state *css, int count)
 {
+	BUG_ON(test_bit(CSS_NO_GET, &css->flags));
 	atomic_add(count, &css->refcnt);
 }
 
@@ -131,6 +133,7 @@ static inline bool css_tryget(struct cgroup_subsys_state *css)
 {
 	if (test_bit(CSS_ROOT, &css->flags))
 		return true;
+	BUG_ON(test_bit(CSS_NO_GET, &css->flags));
 	while (!atomic_inc_not_zero(&css->refcnt)) {
 		if (test_bit(CSS_REMOVED, &css->flags))
 			return false;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index fa2c5de..d49a459 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -938,6 +938,11 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
 	atomic_set(&css->refcnt, 1);
 	css->flags = 0;
 	css->id = NULL;
+
+	/* For now, unbindable subsystems should not call css_get/put(). */
+	if (ss->unbindable)
+		set_bit(CSS_NO_GET, &css->flags);
+
 	if (cgrp == dummytop)
 		set_bit(CSS_ROOT, &css->flags);
 	BUG_ON(cgrp->subsys[ss->subsys_id]);
-- 
1.6.3

