Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab0JVSWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:22:06 -0400
Received: from kroah.org ([198.145.64.141]:41932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590Ab0JVSWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:22:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Nicolas Pitre <nicolas.pitre@canonical.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/49] vcs: invoke the vt update callback when /dev/vcs* is written to
Date: Fri, 22 Oct 2010 11:21:09 -0700
Message-Id: <1287771688-14805-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Pitre <nico@fluxnic.net>

A notifier chain is called whenever the vt code modifies a terminal
content, except for one case which is when the modification comes
through writes to /dev/vcs* devices.  Let's add the missing notifier
invocation at the end of vcs_write() for that case too.

Signed-off-by: Nicolas Pitre <nicolas.pitre@canonical.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vc_screen.c  |    2 ++
 drivers/char/vt.c         |    5 +++++
 include/linux/selection.h |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
index 6f7054e..273ab44 100644
--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -538,6 +538,8 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	}
 	*ppos += written;
 	ret = written;
+	if (written)
+		vcs_scr_updated(vc);
 
 unlock_out:
 	release_console_sem();
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 281aada..a8ec48e 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -4182,6 +4182,11 @@ void vcs_scr_writew(struct vc_data *vc, u16 val, u16 *org)
 	}
 }
 
+void vcs_scr_updated(struct vc_data *vc)
+{
+	notify_update(vc);
+}
+
 /*
  *	Visible symbols for modules
  */
diff --git a/include/linux/selection.h b/include/linux/selection.h
index 8cdaa11..85193aa 100644
--- a/include/linux/selection.h
+++ b/include/linux/selection.h
@@ -39,5 +39,6 @@ extern void putconsxy(struct vc_data *vc, unsigned char *p);
 
 extern u16 vcs_scr_readw(struct vc_data *vc, const u16 *org);
 extern void vcs_scr_writew(struct vc_data *vc, u16 val, u16 *org);
+extern void vcs_scr_updated(struct vc_data *vc);
 
 #endif
-- 
1.7.2

