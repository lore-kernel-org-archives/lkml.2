Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405Ab2I1TAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:00:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965374Ab2I1TAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:00:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 141/262] cfg80211: fix possible circular lock on reg_regdb_search()
Date: Fri, 28 Sep 2012 11:51:10 -0700
Message-Id: <20120928183014.709730777@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/reg.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -340,6 +340,9 @@ static void reg_regdb_search(struct work
 	struct reg_regdb_search_request *request;
 	const struct ieee80211_regdomain *curdom, *regdom;
 	int i, r;
+	bool set_reg = false;
+
+	mutex_lock(&cfg80211_mutex);
 
 	mutex_lock(&reg_regdb_search_mutex);
 	while (!list_empty(&reg_regdb_search_list)) {
@@ -355,9 +358,7 @@ static void reg_regdb_search(struct work
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
@@ -365,6 +366,11 @@ static void reg_regdb_search(struct work
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


