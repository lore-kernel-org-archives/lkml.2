Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935913Ab1KJRPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:15:55 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36281 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934243Ab1KJRPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:15:53 -0500
Message-ID: <4EBC06C5.4080805@parallels.com>
Date: Thu, 10 Nov 2011 21:15:49 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: [PATCH 2/3] pids: Split alloc_pidmap into parts
References: <4EBC0696.9030103@parallels.com>
In-Reply-To: <4EBC0696.9030103@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The map's page allocation code is moved to separate function
to make clone-with-pids patching simpler.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---
 kernel/pid.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 2d9704c..700dda3 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -159,6 +159,25 @@ static void set_last_pid(struct pid_namespace *pid_ns, int base, int pid)
 	} while ((prev != last_write) && (pid_before(base, last_write, pid)));
 }
 
+static int alloc_pidmap_page(struct pidmap *map)
+{
+	void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+
+	/*
+	 * Free the page if someone raced with us
+	 * installing it:
+	 */
+	spin_lock_irq(&pidmap_lock);
+	if (!map->page) {
+		map->page = page;
+		page = NULL;
+	}
+	spin_unlock_irq(&pidmap_lock);
+	kfree(page);
+
+	return map->page ? 0 : -1;
+}
+
 static int alloc_pidmap(struct pid_namespace *pid_ns)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
@@ -176,22 +195,10 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	 */
 	max_scan = DIV_ROUND_UP(pid_max, BITS_PER_PAGE) - !offset;
 	for (i = 0; i <= max_scan; ++i) {
-		if (unlikely(!map->page)) {
-			void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
-			/*
-			 * Free the page if someone raced with us
-			 * installing it:
-			 */
-			spin_lock_irq(&pidmap_lock);
-			if (!map->page) {
-				map->page = page;
-				page = NULL;
-			}
-			spin_unlock_irq(&pidmap_lock);
-			kfree(page);
-			if (unlikely(!map->page))
+		if (unlikely(!map->page))
+			if (alloc_pidmap_page(map))
 				break;
-		}
+
 		if (likely(atomic_read(&map->nr_free))) {
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
-- 
1.5.5.6
