Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137Ab1KWAhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:37:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759089Ab1KWAh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:37:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:57 2011
Message-Id: <20111123002557.611213284@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: [50/53] batman-adv: remove references for global tt entries
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>

commit 531027fcddbcf81c9937dd04f08a7e8f11fd47d2 upstream.

struct tt_global_entry holds a reference to an orig_node which must be
decremented before deallocating the structure.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Tested-by: Alexey Fisher <bug-track@fisher-privat.net>
Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/batman-adv/translation-table.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -137,10 +137,22 @@ static void tt_local_entry_free_ref(stru
 		kfree_rcu(tt_local_entry, rcu);
 }
 
+static void tt_global_entry_free_rcu(struct rcu_head *rcu)
+{
+	struct tt_global_entry *tt_global_entry;
+
+	tt_global_entry = container_of(rcu, struct tt_global_entry, rcu);
+
+	if (tt_global_entry->orig_node)
+		orig_node_free_ref(tt_global_entry->orig_node);
+
+	kfree(tt_global_entry);
+}
+
 static void tt_global_entry_free_ref(struct tt_global_entry *tt_global_entry)
 {
 	if (atomic_dec_and_test(&tt_global_entry->refcount))
-		kfree_rcu(tt_global_entry, rcu);
+		call_rcu(&tt_global_entry->rcu, tt_global_entry_free_rcu);
 }
 
 static void tt_local_event(struct bat_priv *bat_priv, const uint8_t *addr,


