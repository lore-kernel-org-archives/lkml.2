Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab2IXPG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:06:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902Ab2IXPGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:06:13 -0400
From: Matthew Garrett <mjg@redhat.com>
To: yakui.zhao@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cminyard@mvista.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/4] IPMI: Add a callback to indicate that probing has finished
Date: Mon, 24 Sep 2012 11:05:39 -0400
Message-Id: <1348499140-13550-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1348499140-13550-1-git-send-email-mjg@redhat.com>
References: <1348499140-13550-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IPMI callbacks may want to know how many IPMI devices were registered
or perform some specific action after probing has been completed. Add a
new callback to handle that.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/char/ipmi/ipmi_msghandler.c | 15 +++++++++++++++
 drivers/char/ipmi/ipmi_si_intf.c    |  6 +++++-
 include/linux/ipmi.h                |  3 ++-
 include/linux/ipmi_smi.h            |  5 +++++
 4 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 2c29942..3aacb6d 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -571,6 +571,9 @@ int ipmi_smi_watcher_register(struct ipmi_smi_watcher *watcher)
 		kfree(e);
 	}
 
+	if (watcher->smi_probe_complete)
+		watcher->smi_probe_complete();
+
 	mutex_unlock(&smi_watchers_mutex);
 
 	return 0;
@@ -2807,6 +2810,18 @@ void ipmi_poll_interface(ipmi_user_t user)
 }
 EXPORT_SYMBOL(ipmi_poll_interface);
 
+void ipmi_smi_probe_complete(void)
+{
+	struct ipmi_smi_watcher *w;
+
+	mutex_lock(&smi_watchers_mutex);
+	list_for_each_entry(w, &smi_watchers, link) {
+		if (w->smi_probe_complete)
+			w->smi_probe_complete();
+	}
+	mutex_unlock(&smi_watchers_mutex);
+}
+
 int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
 		      void		       *send_info,
 		      struct ipmi_device_id    *device_id,
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 83f85cf..75e3c4f 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3408,6 +3408,7 @@ static int __devinit init_ipmi_si(void)
 	/* type will only have been set if we successfully registered an si */
 	if (type) {
 		mutex_unlock(&smi_infos_lock);
+		ipmi_smi_probe_complete();
 		return 0;
 	}
 
@@ -3422,8 +3423,10 @@ static int __devinit init_ipmi_si(void)
 	}
 	mutex_unlock(&smi_infos_lock);
 
-	if (type)
+	if (type) {
+		ipmi_smi_probe_complete();
 		return 0;
+	}
 
 	if (si_trydefaults) {
 		mutex_lock(&smi_infos_lock);
@@ -3444,6 +3447,7 @@ static int __devinit init_ipmi_si(void)
 		return -ENODEV;
 	} else {
 		mutex_unlock(&smi_infos_lock);
+		ipmi_smi_probe_complete();
 		return 0;
 	}
 }
diff --git a/include/linux/ipmi.h b/include/linux/ipmi.h
index 48dcba9..6c8faaa 100644
--- a/include/linux/ipmi.h
+++ b/include/linux/ipmi.h
@@ -435,12 +435,13 @@ struct ipmi_smi_watcher {
 	   a module (generally just set it to "THIS_MODULE"). */
 	struct module *owner;
 
-	/* These two are called with read locks held for the interface
+	/* These three are called with read locks held for the interface
 	   the watcher list.  So you can add and remove users from the
 	   IPMI interface, send messages, etc., but you cannot add
 	   or remove SMI watchers or SMI interfaces. */
 	void (*new_smi)(int if_num, struct device *dev);
 	void (*smi_gone)(int if_num);
+	void (*smi_probe_complete)(void);
 };
 
 int ipmi_smi_watcher_register(struct ipmi_smi_watcher *watcher);
diff --git a/include/linux/ipmi_smi.h b/include/linux/ipmi_smi.h
index fcb5d44..56abc7c 100644
--- a/include/linux/ipmi_smi.h
+++ b/include/linux/ipmi_smi.h
@@ -215,6 +215,11 @@ int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
 int ipmi_unregister_smi(ipmi_smi_t intf);
 
 /*
+ * Indicate to the IPMI driver that probing has been completed
+ */
+void ipmi_smi_probe_complete(void);
+
+/*
  * The lower layer reports received messages through this interface.
  * The data_size should be zero if this is an asyncronous message.  If
  * the lower layer gets an error sending a message, it should format
-- 
1.7.11.4

