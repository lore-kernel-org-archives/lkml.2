Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2HMUUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:20:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52193 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab2HMUUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:32 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ralf Baechle <ralf@linux-mips.org>
Date: Mon, 13 Aug 2012 13:18:24 -0700
Message-Id: <1344889115-21610-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+wkbdFobSkhWghk6WKzXgOLCuWQHqFNdE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2072]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 10/21] userns: Convert net/ax25 to use kuid_t where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/net/ax25.h  |    4 ++--
 init/Kconfig        |    1 -
 net/ax25/ax25_uid.c |   21 ++++++++++++++-------
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 5d23521..53539ac 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -157,7 +157,7 @@ enum {
 typedef struct ax25_uid_assoc {
 	struct hlist_node	uid_node;
 	atomic_t		refcount;
-	uid_t			uid;
+	kuid_t			uid;
 	ax25_address		call;
 } ax25_uid_assoc;
 
@@ -434,7 +434,7 @@ extern unsigned long ax25_display_timer(struct timer_list *);
 
 /* ax25_uid.c */
 extern int  ax25_uid_policy;
-extern ax25_uid_assoc *ax25_findbyuid(uid_t);
+extern ax25_uid_assoc *ax25_findbyuid(kuid_t);
 extern int __must_check ax25_uid_ioctl(int, struct sockaddr_ax25 *);
 extern const struct file_operations ax25_uid_fops;
 extern void ax25_uid_free(void);
diff --git a/init/Kconfig b/init/Kconfig
index 64ff9ce..8447e0c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -952,7 +952,6 @@ config UIDGID_CONVERTED
 	depends on NET_KEY = n
 	depends on INET_DIAG = n
 	depends on DNS_RESOLVER = n
-	depends on AX25 = n
 
 	# Filesystems
 	depends on USB_GADGETFS = n
diff --git a/net/ax25/ax25_uid.c b/net/ax25/ax25_uid.c
index e3c579b..957999e 100644
--- a/net/ax25/ax25_uid.c
+++ b/net/ax25/ax25_uid.c
@@ -51,14 +51,14 @@ int ax25_uid_policy;
 
 EXPORT_SYMBOL(ax25_uid_policy);
 
-ax25_uid_assoc *ax25_findbyuid(uid_t uid)
+ax25_uid_assoc *ax25_findbyuid(kuid_t uid)
 {
 	ax25_uid_assoc *ax25_uid, *res = NULL;
 	struct hlist_node *node;
 
 	read_lock(&ax25_uid_lock);
 	ax25_uid_for_each(ax25_uid, node, &ax25_uid_list) {
-		if (ax25_uid->uid == uid) {
+		if (uid_eq(ax25_uid->uid, uid)) {
 			ax25_uid_hold(ax25_uid);
 			res = ax25_uid;
 			break;
@@ -84,7 +84,7 @@ int ax25_uid_ioctl(int cmd, struct sockaddr_ax25 *sax)
 		read_lock(&ax25_uid_lock);
 		ax25_uid_for_each(ax25_uid, node, &ax25_uid_list) {
 			if (ax25cmp(&sax->sax25_call, &ax25_uid->call) == 0) {
-				res = ax25_uid->uid;
+				res = from_kuid_munged(current_user_ns(), ax25_uid->uid);
 				break;
 			}
 		}
@@ -93,9 +93,14 @@ int ax25_uid_ioctl(int cmd, struct sockaddr_ax25 *sax)
 		return res;
 
 	case SIOCAX25ADDUID:
+	{
+		kuid_t sax25_kuid;
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
-		user = ax25_findbyuid(sax->sax25_uid);
+		sax25_kuid = make_kuid(current_user_ns(), sax->sax25_uid);
+		if (!uid_valid(sax25_kuid))
+			return -EINVAL;
+		user = ax25_findbyuid(sax25_kuid);
 		if (user) {
 			ax25_uid_put(user);
 			return -EEXIST;
@@ -106,7 +111,7 @@ int ax25_uid_ioctl(int cmd, struct sockaddr_ax25 *sax)
 			return -ENOMEM;
 
 		atomic_set(&ax25_uid->refcount, 1);
-		ax25_uid->uid  = sax->sax25_uid;
+		ax25_uid->uid  = sax25_kuid;
 		ax25_uid->call = sax->sax25_call;
 
 		write_lock(&ax25_uid_lock);
@@ -114,7 +119,7 @@ int ax25_uid_ioctl(int cmd, struct sockaddr_ax25 *sax)
 		write_unlock(&ax25_uid_lock);
 
 		return 0;
-
+	}
 	case SIOCAX25DELUID:
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
@@ -172,7 +177,9 @@ static int ax25_uid_seq_show(struct seq_file *seq, void *v)
 		struct ax25_uid_assoc *pt;
 
 		pt = hlist_entry(v, struct ax25_uid_assoc, uid_node);
-		seq_printf(seq, "%6d %s\n", pt->uid, ax2asc(buf, &pt->call));
+		seq_printf(seq, "%6d %s\n",
+			from_kuid_munged(seq_user_ns(seq), pt->uid),
+			ax2asc(buf, &pt->call));
 	}
 	return 0;
 }
-- 
1.7.5.4

