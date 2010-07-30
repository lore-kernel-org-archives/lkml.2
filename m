Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0G3RD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:03:56 -0400
Received: from kroah.org ([198.145.64.141]:35597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab0G3RDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:03:45 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 09:59:55 2010
Message-Id: <20100730165955.294243235@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 09:57:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andre Osterhues <aosterhues@escrypt.com>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [17/17] ecryptfs: Bugfix for error related to ecryptfs_hash_buckets
In-Reply-To: <20100730170054.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andre Osterhues <aosterhues@escrypt.com>

commit a6f80fb7b5986fda663d94079d3bba0937a6b6ff upstream.

The function ecryptfs_uid_hash wrongly assumes that the
second parameter to hash_long() is the number of hash
buckets instead of the number of hash bits.
This patch fixes that and renames the variable
ecryptfs_hash_buckets to ecryptfs_hash_bits to make it
clearer.

Fixes: CVE-2010-2492

Signed-off-by: Andre Osterhues <aosterhues@escrypt.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/messaging.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -30,9 +30,9 @@ static struct mutex ecryptfs_msg_ctx_lis
 
 static struct hlist_head *ecryptfs_daemon_hash;
 struct mutex ecryptfs_daemon_hash_mux;
-static int ecryptfs_hash_buckets;
+static int ecryptfs_hash_bits;
 #define ecryptfs_uid_hash(uid) \
-        hash_long((unsigned long)uid, ecryptfs_hash_buckets)
+        hash_long((unsigned long)uid, ecryptfs_hash_bits)
 
 static u32 ecryptfs_msg_counter;
 static struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
@@ -599,18 +599,19 @@ int ecryptfs_init_messaging(unsigned int
 	}
 	mutex_init(&ecryptfs_daemon_hash_mux);
 	mutex_lock(&ecryptfs_daemon_hash_mux);
-	ecryptfs_hash_buckets = 1;
-	while (ecryptfs_number_of_users >> ecryptfs_hash_buckets)
-		ecryptfs_hash_buckets++;
+	ecryptfs_hash_bits = 1;
+	while (ecryptfs_number_of_users >> ecryptfs_hash_bits)
+		ecryptfs_hash_bits++;
 	ecryptfs_daemon_hash = kmalloc((sizeof(struct hlist_head)
-					* ecryptfs_hash_buckets), GFP_KERNEL);
+					* (1 << ecryptfs_hash_bits)),
+				       GFP_KERNEL);
 	if (!ecryptfs_daemon_hash) {
 		rc = -ENOMEM;
 		printk(KERN_ERR "%s: Failed to allocate memory\n", __func__);
 		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		goto out;
 	}
-	for (i = 0; i < ecryptfs_hash_buckets; i++)
+	for (i = 0; i < (1 << ecryptfs_hash_bits); i++)
 		INIT_HLIST_HEAD(&ecryptfs_daemon_hash[i]);
 	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	ecryptfs_msg_ctx_arr = kmalloc((sizeof(struct ecryptfs_msg_ctx)
@@ -680,7 +681,7 @@ void ecryptfs_release_messaging(unsigned
 		int i;
 
 		mutex_lock(&ecryptfs_daemon_hash_mux);
-		for (i = 0; i < ecryptfs_hash_buckets; i++) {
+		for (i = 0; i < (1 << ecryptfs_hash_bits); i++) {
 			int rc;
 
 			hlist_for_each_entry(daemon, elem,


