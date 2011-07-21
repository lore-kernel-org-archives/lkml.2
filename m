Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1GUVAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:00:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab1GUU75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:59:57 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, mikew@google.com, tony.luck@intel.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 4/9] pstore: Allow the user to explicitly choose a backend
Date: Thu, 21 Jul 2011 16:57:55 -0400
Message-Id: <1311281880-28041-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1311281880-28041-1-git-send-email-mjg@redhat.com>
References: <1311281880-28041-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pstore only allows one backend to be registered at present, but the
system may provide several. Add a parameter to allow the user to choose
which backend will be used rather than just relying on load order.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 Documentation/ABI/testing/pstore    |    6 ++++++
 Documentation/kernel-parameters.txt |    2 ++
 fs/pstore/platform.c                |   11 +++++++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/pstore b/Documentation/ABI/testing/pstore
index ddf451e..ff1df4e 100644
--- a/Documentation/ABI/testing/pstore
+++ b/Documentation/ABI/testing/pstore
@@ -39,3 +39,9 @@ Description:	Generic interface to platform dependent persistent storage.
 		multiple) files based on the record size of the underlying
 		persistent storage until at least this amount is reached.
 		Default is 10 Kbytes.
+
+		Pstore only supports one backend at a time. If multiple
+		backends are available, the preferred backend may be
+		set by passing the pstore.backend= argument to the kernel at
+		boot time.
+
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ede3209..abafa88 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2156,6 +2156,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			[HW,MOUSE] Controls Logitech smartscroll autorepeat.
 			0 = disabled, 1 = enabled (default).
 
+	pstore.backend=	Specify the name of the pstore backend to use
+
 	pt.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
 
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 49ff1de..c5300ec 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -37,6 +37,8 @@
 static DEFINE_SPINLOCK(pstore_lock);
 static struct pstore_info *psinfo;
 
+static char *backend;
+
 /* How much of the console log to snapshot */
 static unsigned long kmsg_bytes = 10240;
 
@@ -131,6 +133,12 @@ int pstore_register(struct pstore_info *psi)
 		spin_unlock(&pstore_lock);
 		return -EBUSY;
 	}
+
+	if (backend && strcmp(backend, psi->name)) {
+		spin_unlock(&pstore_lock);
+		return -EINVAL;
+	}
+
 	psinfo = psi;
 	spin_unlock(&pstore_lock);
 
@@ -208,3 +216,6 @@ int pstore_write(enum pstore_type_id type, char *buf, size_t size)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pstore_write);
+
+module_param(backend, charp, 0444);
+MODULE_PARM_DESC(backend, "Pstore backend to use");
-- 
1.7.6

