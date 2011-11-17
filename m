Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab1KQLmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:42:49 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:15777 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab1KQLms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:42:48 -0500
Message-ID: <4EC4F334.1030706@parallels.com>
Date: Thu, 17 Nov 2011 15:42:44 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: [PATCH 2/3] pids: Split alloc_pidmap into parts
References: <4EC4F2FB.408@parallels.com>
In-Reply-To: <4EC4F2FB.408@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The map's page allocation code is moved to separate function
to make clone-with-pids patching simpler.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---
 kernel/pid.c |   39 +++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 4816f43..86bf7d2 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -159,6 +159,26 @@ static void set_last_pid(struct pid_namespace *pid_ns, int base, int pid)
 	} while ((prev != last_write) && (pid_before(base, last_write, pid)));
 }
 
+static int alloc_pidmap_page(struct pidmap *map)
+{
+	if (unlikely(!map->page)) {
+		void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+		/*
+		 * Free the page if someone raced with us
+		 * installing it:
+		 */
+		spin_lock_irq(&pidmap_lock);
+		if (!map->page) {
+			map->page = page;
+			page = NULL;
+		}
+		spin_unlock_irq(&pidmap_lock);
+		kfree(page);
+	}
+
+	return !map->page;
+}
+
 static int alloc_pidmap(struct pid_namespace *pid_ns)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
@@ -176,22 +196,9 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
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
-				break;
-		}
+		if (alloc_pidmap_page(map))
+			break;
+
 		if (likely(atomic_read(&map->nr_free))) {
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
-- 
1.5.5.6
