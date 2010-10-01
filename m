Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab0JAEKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 00:10:46 -0400
Received: from relais.videotron.ca ([24.201.245.36]:11359 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab0JAEKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 00:10:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 01 Oct 2010 00:10:44 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: lkml <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] vcs: invoke the vt update callback when /dev/vcs* is
 written to
Message-id: <alpine.LFD.2.00.1009302329370.1146@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A notifier chain is called whenever the vt code modifies a terminal
content, except for one case which is when the modification comes
through writes to /dev/vcs* devices.  Let's add the missing notifier
invocation at the end of vcs_write() for that case too.

Signed-off-by: Nicolas Pitre <nicolas.pitre@canonical.com>
---
 drivers/char/vc_screen.c  |    2 ++
 drivers/char/vt.c         |    5 +++++
 include/linux/selection.h |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
index 9013573..58e8d5e 100644
--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -528,6 +528,8 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
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

