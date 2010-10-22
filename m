Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab0JVILN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:11:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56931 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab0JVILK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:11:10 -0400
Message-ID: <4CC14756.5010504@cn.fujitsu.com>
Date: Fri, 22 Oct 2010 16:12:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "akpm >> Andrew Morton" <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: [PATCH 6/7] cgroups: Warn if a bindable subsystem calls css_get()
References: <4CC146A4.9090505@cn.fujitsu.com>
In-Reply-To: <4CC146A4.9090505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now bindable subsystems should not use css_get/put(), so warn
on this misuse.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    7 +++++--
 kernel/cgroup.c        |    3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1e4e1df..10e4e02 100644
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
 
@@ -119,6 +121,7 @@ static inline bool css_tryget(struct cgroup_subsys_state *css)
 {
 	if (test_bit(CSS_ROOT, &css->flags))
 		return true;
+	BUG_ON(test_bit(CSS_NO_GET, &css->flags));
 	while (!atomic_inc_not_zero(&css->refcnt)) {
 		if (test_bit(CSS_REMOVED, &css->flags))
 			return false;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 12c1f7c..88e265d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -936,6 +936,9 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
 	css->cgroup = cgrp;
 	atomic_set(&css->refcnt, 1);
 	css->flags = 0;
+	/* For now, a bindable subsystem should not call css_get/put(). */
+	if (ss->can_bind)
+		set_bit(CSS_NO_GET, &css->flags);
 	css->id = NULL;
 	if (cgrp == dummytop)
 		set_bit(CSS_ROOT, &css->flags);
-- 
1.7.0.1

