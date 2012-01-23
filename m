Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2AWXvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:51:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697Ab2AWXv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:51:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:30 2012
Message-Id: <20120123234030.183780271@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:40:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jim Keniston <jkenisto@us.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srinivasa D S <srinivasa@in.ibm.com>
Subject: [85/90] kprobes: initialize before using a hlist
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

commit d496aab567e7e52b3e974c9192a5de6e77dce32c upstream.

Commit ef53d9c5e ("kprobes: improve kretprobe scalability with hashed
locking") introduced a bug where we can potentially leak
kretprobe_instances since we initialize a hlist head after having used
it.

Initialize the hlist head before using it.

Reported by: Jim Keniston <jkenisto@us.ibm.com>
Acked-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srinivasa D S <srinivasa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1077,6 +1077,7 @@ void __kprobes kprobe_flush_task(struct
 		/* Early boot.  kretprobe_table_locks not yet initialized. */
 		return;
 
+	INIT_HLIST_HEAD(&empty_rp);
 	hash = hash_ptr(tk, KPROBE_HASH_BITS);
 	head = &kretprobe_inst_table[hash];
 	kretprobe_table_lock(hash, &flags);
@@ -1085,7 +1086,6 @@ void __kprobes kprobe_flush_task(struct
 			recycle_rp_inst(ri, &empty_rp);
 	}
 	kretprobe_table_unlock(hash, &flags);
-	INIT_HLIST_HEAD(&empty_rp);
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);


