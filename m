Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab2CGPLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:11:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10803 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757284Ab2CGPLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:11:19 -0500
X-IronPort-AV: E=Sophos;i="4.73,546,1325433600"; 
   d="scan'208";a="4482192"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Eric Paris <eparis@parisplace.org>, James Morris <jmorris@namei.org>,
        sds@tycho.nsa.gov, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] selinux:avc:remove the useless fields in avc_add_callback
Date: Wed, 7 Mar 2012 22:17:14 +0800
Message-Id: <1331129834-1554-2-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1331129834-1554-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1331129834-1554-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 22:16:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 22:17:05,
	Serialize complete at 2012-03-07 22:17:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

avc_add_callback now just used for registering reset functions
in initcalls, and the callback functions just did reset operations.
So, reducing the arguments to only one event is enough now.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 security/selinux/avc.c         |   32 ++++++--------------------------
 security/selinux/include/avc.h |    6 +-----
 security/selinux/netif.c       |    6 ++----
 security/selinux/netnode.c     |    6 ++----
 security/selinux/netport.c     |    6 ++----
 security/selinux/ss/services.c |    6 ++----
 6 files changed, 15 insertions(+), 47 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index c301679..fc8acaa 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -65,14 +65,8 @@ struct avc_cache {
 };
 
 struct avc_callback_node {
-	int (*callback) (u32 event, u32 ssid, u32 tsid,
-			 u16 tclass, u32 perms,
-			 u32 *out_retained);
+	int (*callback) (u32 event);
 	u32 events;
-	u32 ssid;
-	u32 tsid;
-	u16 tclass;
-	u32 perms;
 	struct avc_callback_node *next;
 };
 
@@ -546,22 +540,12 @@ int avc_audit(u32 ssid, u32 tsid,
  * avc_add_callback - Register a callback for security events.
  * @callback: callback function
  * @events: security events
- * @ssid: source security identifier or %SECSID_WILD
- * @tsid: target security identifier or %SECSID_WILD
- * @tclass: target security class
- * @perms: permissions
  *
- * Register a callback function for events in the set @events
- * related to the SID pair (@ssid, @tsid) 
- * and the permissions @perms, interpreting
- * @perms based on @tclass.  Returns %0 on success or
- * -%ENOMEM if insufficient memory exists to add the callback.
+ * Register a callback function for events in the set @events.
+ * Returns %0 on success or -%ENOMEM if insufficient memory
+ * exists to add the callback.
  */
-int __init avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
-				     u16 tclass, u32 perms,
-				     u32 *out_retained),
-		     u32 events, u32 ssid, u32 tsid,
-		     u16 tclass, u32 perms)
+int __init avc_add_callback(int (*callback)(u32 event), u32 events)
 {
 	struct avc_callback_node *c;
 	int rc = 0;
@@ -574,9 +558,6 @@ int __init avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
 
 	c->callback = callback;
 	c->events = events;
-	c->ssid = ssid;
-	c->tsid = tsid;
-	c->perms = perms;
 	c->next = avc_callbacks;
 	avc_callbacks = c;
 out:
@@ -716,8 +697,7 @@ int avc_ss_reset(u32 seqno)
 
 	for (c = avc_callbacks; c; c = c->next) {
 		if (c->events & AVC_CALLBACK_RESET) {
-			tmprc = c->callback(AVC_CALLBACK_RESET,
-					    0, 0, 0, 0, NULL);
+			tmprc = c->callback(AVC_CALLBACK_RESET);
 			/* save the first error encountered for the return
 			   value and continue processing the callbacks */
 			if (!rc)
diff --git a/security/selinux/include/avc.h b/security/selinux/include/avc.h
index 47fda96..0ac5c26 100644
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -88,11 +88,7 @@ u32 avc_policy_seqno(void);
 #define AVC_CALLBACK_AUDITDENY_ENABLE	64
 #define AVC_CALLBACK_AUDITDENY_DISABLE	128
 
-int avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
-				     u16 tclass, u32 perms,
-				     u32 *out_retained),
-		     u32 events, u32 ssid, u32 tsid,
-		     u16 tclass, u32 perms);
+int avc_add_callback(int (*callback)(u32 event), u32 events);
 
 /* Exported to selinuxfs */
 int avc_get_hash_stats(char *page);
diff --git a/security/selinux/netif.c b/security/selinux/netif.c
index 326f22c..47a49d1 100644
--- a/security/selinux/netif.c
+++ b/security/selinux/netif.c
@@ -252,8 +252,7 @@ static void sel_netif_flush(void)
 	spin_unlock_bh(&sel_netif_lock);
 }
 
-static int sel_netif_avc_callback(u32 event, u32 ssid, u32 tsid,
-				  u16 class, u32 perms, u32 *retained)
+static int sel_netif_avc_callback(u32 event)
 {
 	if (event == AVC_CALLBACK_RESET) {
 		sel_netif_flush();
@@ -292,8 +291,7 @@ static __init int sel_netif_init(void)
 
 	register_netdevice_notifier(&sel_netif_netdev_notifier);
 
-	err = avc_add_callback(sel_netif_avc_callback, AVC_CALLBACK_RESET,
-			       SECSID_NULL, SECSID_NULL, SECCLASS_NULL, 0);
+	err = avc_add_callback(sel_netif_avc_callback, AVC_CALLBACK_RESET);
 	if (err)
 		panic("avc_add_callback() failed, error %d\n", err);
 
diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 8636585..28f911c 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -297,8 +297,7 @@ static void sel_netnode_flush(void)
 	spin_unlock_bh(&sel_netnode_lock);
 }
 
-static int sel_netnode_avc_callback(u32 event, u32 ssid, u32 tsid,
-				    u16 class, u32 perms, u32 *retained)
+static int sel_netnode_avc_callback(u32 event)
 {
 	if (event == AVC_CALLBACK_RESET) {
 		sel_netnode_flush();
@@ -320,8 +319,7 @@ static __init int sel_netnode_init(void)
 		sel_netnode_hash[iter].size = 0;
 	}
 
-	ret = avc_add_callback(sel_netnode_avc_callback, AVC_CALLBACK_RESET,
-			       SECSID_NULL, SECSID_NULL, SECCLASS_NULL, 0);
+	ret = avc_add_callback(sel_netnode_avc_callback, AVC_CALLBACK_RESET);
 	if (ret != 0)
 		panic("avc_add_callback() failed, error %d\n", ret);
 
diff --git a/security/selinux/netport.c b/security/selinux/netport.c
index 7b9eb1f..d353797 100644
--- a/security/selinux/netport.c
+++ b/security/selinux/netport.c
@@ -234,8 +234,7 @@ static void sel_netport_flush(void)
 	spin_unlock_bh(&sel_netport_lock);
 }
 
-static int sel_netport_avc_callback(u32 event, u32 ssid, u32 tsid,
-				    u16 class, u32 perms, u32 *retained)
+static int sel_netport_avc_callback(u32 event)
 {
 	if (event == AVC_CALLBACK_RESET) {
 		sel_netport_flush();
@@ -257,8 +256,7 @@ static __init int sel_netport_init(void)
 		sel_netport_hash[iter].size = 0;
 	}
 
-	ret = avc_add_callback(sel_netport_avc_callback, AVC_CALLBACK_RESET,
-			       SECSID_NULL, SECSID_NULL, SECCLASS_NULL, 0);
+	ret = avc_add_callback(sel_netport_avc_callback, AVC_CALLBACK_RESET);
 	if (ret != 0)
 		panic("avc_add_callback() failed, error %d\n", ret);
 
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 185f849..08123cd 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -3018,8 +3018,7 @@ out:
 
 static int (*aurule_callback)(void) = audit_update_lsm_rules;
 
-static int aurule_avc_callback(u32 event, u32 ssid, u32 tsid,
-			       u16 class, u32 perms, u32 *retained)
+static int aurule_avc_callback(u32 event)
 {
 	int err = 0;
 
@@ -3032,8 +3031,7 @@ static int __init aurule_init(void)
 {
 	int err;
 
-	err = avc_add_callback(aurule_avc_callback, AVC_CALLBACK_RESET,
-			       SECSID_NULL, SECSID_NULL, SECCLASS_NULL, 0);
+	err = avc_add_callback(aurule_avc_callback, AVC_CALLBACK_RESET);
 	if (err)
 		panic("avc_add_callback() failed, error %d\n", err);
 
-- 
1.7.9.2.323.gf051a

