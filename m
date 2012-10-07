Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2JGXZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:25:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38686 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698Ab2JGXXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:30 -0400
Message-Id: <20121007225838.996445652@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 031/108] cfg80211: fix possible circular lock on reg_regdb_search()
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

commit a85d0d7f3460b1a123b78e7f7e39bf72c37dfb78 upstream.

When call_crda() is called we kick off a witch hunt search
for the same regulatory domain on our internal regulatory
database and that work gets kicked off on a workqueue, this
is done while the cfg80211_mutex is held. If that workqueue
kicks off it will first lock reg_regdb_search_mutex and
later cfg80211_mutex but to ensure two CPUs will not contend
against cfg80211_mutex the right thing to do is to have the
reg_regdb_search() wait until the cfg80211_mutex is let go.

The lockdep report is pasted below.

cfg80211: Calling CRDA to update world regulatory domain

======================================================
[ INFO: possible circular locking dependency detected ]
3.3.8 #3 Tainted: G           O
-------------------------------------------------------
kworker/0:1/235 is trying to acquire lock:
 (cfg80211_mutex){+.+...}, at: [<816468a4>] set_regdom+0x78c/0x808 [cfg80211]

but task is already holding lock:
 (reg_regdb_search_mutex){+.+...}, at: [<81646828>] set_regdom+0x710/0x808 [cfg80211]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (reg_regdb_search_mutex){+.+...}:
       [<800a8384>] lock_acquire+0x60/0x88
       [<802950a8>] mutex_lock_nested+0x54/0x31c
       [<81645778>] is_world_regdom+0x9f8/0xc74 [cfg80211]

-> #1 (reg_mutex#2){+.+...}:
       [<800a8384>] lock_acquire+0x60/0x88
       [<802950a8>] mutex_lock_nested+0x54/0x31c
       [<8164539c>] is_world_regdom+0x61c/0xc74 [cfg80211]

-> #0 (cfg80211_mutex){+.+...}:
       [<800a77b8>] __lock_acquire+0x10d4/0x17bc
       [<800a8384>] lock_acquire+0x60/0x88
       [<802950a8>] mutex_lock_nested+0x54/0x31c
       [<816468a4>] set_regdom+0x78c/0x808 [cfg80211]

other info that might help us debug this:

Chain exists of:
  cfg80211_mutex --> reg_mutex#2 --> reg_regdb_search_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(reg_regdb_search_mutex);
                               lock(reg_mutex#2);
                               lock(reg_regdb_search_mutex);
  lock(cfg80211_mutex);

 *** DEADLOCK ***

3 locks held by kworker/0:1/235:
 #0:  (events){.+.+..}, at: [<80089a00>] process_one_work+0x230/0x460
 #1:  (reg_regdb_work){+.+...}, at: [<80089a00>] process_one_work+0x230/0x460
 #2:  (reg_regdb_search_mutex){+.+...}, at: [<81646828>] set_regdom+0x710/0x808 [cfg80211]

stack backtrace:
Call Trace:
[<80290fd4>] dump_stack+0x8/0x34
[<80291bc4>] print_circular_bug+0x2ac/0x2d8
[<800a77b8>] __lock_acquire+0x10d4/0x17bc
[<800a8384>] lock_acquire+0x60/0x88
[<802950a8>] mutex_lock_nested+0x54/0x31c
[<816468a4>] set_regdom+0x78c/0x808 [cfg80211]

Reported-by: Felix Fietkau <nbd@openwrt.org>
Tested-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/reg.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2ded3c7..72d170c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -350,6 +350,9 @@ static void reg_regdb_search(struct work_struct *work)
 	struct reg_regdb_search_request *request;
 	const struct ieee80211_regdomain *curdom, *regdom;
 	int i, r;
+	bool set_reg = false;
+
+	mutex_lock(&cfg80211_mutex);
 
 	mutex_lock(&reg_regdb_search_mutex);
 	while (!list_empty(&reg_regdb_search_list)) {
@@ -365,9 +368,7 @@ static void reg_regdb_search(struct work_struct *work)
 				r = reg_copy_regd(&regdom, curdom);
 				if (r)
 					break;
-				mutex_lock(&cfg80211_mutex);
-				set_regdom(regdom);
-				mutex_unlock(&cfg80211_mutex);
+				set_reg = true;
 				break;
 			}
 		}
@@ -375,6 +376,11 @@ static void reg_regdb_search(struct work_struct *work)
 		kfree(request);
 	}
 	mutex_unlock(&reg_regdb_search_mutex);
+
+	if (set_reg)
+		set_regdom(regdom);
+
+	mutex_unlock(&cfg80211_mutex);
 }
 
 static DECLARE_WORK(reg_regdb_work, reg_regdb_search);


