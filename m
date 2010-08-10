Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab0HJWA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:00:59 -0400
Received: from kroah.org ([198.145.64.141]:44999 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab0HJWAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 50/68] vt: Fix warning: statement with no effect due to vt_kern.h
Date: Tue, 10 Aug 2010 14:59:12 -0700
Message-Id: <1281477570-18944-50-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Winchester <kjwinchester@gmail.com>

Using:

	gcc (GCC) 4.5.0 20100610 (prerelease)

with CONFIG_CONSOLE_TRANSLATIONS=n, the following warnings are seen:

	drivers/char/vt_ioctl.c: In function ‘vt_ioctl’:
	drivers/char/vt_ioctl.c:1309:4: warning: statement with no effect
	drivers/char/vt.c: In function ‘vc_allocate’:
	drivers/char/vt.c:774:3: warning: statement with no effect
	drivers/video/console/vgacon.c: In function ‘vgacon_init’:
	drivers/video/console/vgacon.c:587:3: warning: statement with no effect
	drivers/video/console/vgacon.c: In function ‘vgacon_deinit’:
	drivers/video/console/vgacon.c:606:2: warning: statement with no effect
	drivers/video/console/fbcon.c: In function ‘fbcon_init’:
	drivers/video/console/fbcon.c:1087:3: warning: statement with no effect
	drivers/video/console/fbcon.c:1089:3: warning: statement with no effect
	drivers/video/console/fbcon.c: In function ‘fbcon_set_disp’:
	drivers/video/console/fbcon.c:1369:3: warning: statement with no effect
	drivers/video/console/fbcon.c:1371:3: warning: statement with no effect

This is because several functions in include/linux/vt_kern.h are
defined to (0).  Convert them to static inline functions to
silence the warnings and gain a bit of type safety.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/vt_kern.h |   57 +++++++++++++++++++++++++++++++++++++---------
 1 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 56cce34..6625cc1 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -76,17 +76,52 @@ int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);
 #define vc_translate(vc, c) ((vc)->vc_translate[(c) |			\
 					((vc)->vc_toggle_meta ? 0x80 : 0)])
 #else
-#define con_set_trans_old(arg) (0)
-#define con_get_trans_old(arg) (-EINVAL)
-#define con_set_trans_new(arg) (0)
-#define con_get_trans_new(arg) (-EINVAL)
-#define con_clear_unimap(vc, ui) (0)
-#define con_set_unimap(vc, ct, list) (0)
-#define con_set_default_unimap(vc) (0)
-#define con_copy_unimap(d, s) (0)
-#define con_get_unimap(vc, ct, uct, list) (-EINVAL)
-#define con_free_unimap(vc) do { ; } while (0)
-#define con_protect_unimap(vc, rdonly) do { ; } while (0)
+static inline int con_set_trans_old(unsigned char __user *table)
+{
+	return 0;
+}
+static inline int con_get_trans_old(unsigned char __user *table)
+{
+	return -EINVAL;
+}
+static inline int con_set_trans_new(unsigned short __user *table)
+{
+	return 0;
+}
+static inline int con_get_trans_new(unsigned short __user *table)
+{
+	return -EINVAL;
+}
+static inline int con_clear_unimap(struct vc_data *vc, struct unimapinit *ui)
+{
+	return 0;
+}
+static inline
+int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
+{
+	return 0;
+}
+static inline
+int con_get_unimap(struct vc_data *vc, ushort ct, ushort __user *uct,
+		   struct unipair __user *list)
+{
+	return -EINVAL;
+}
+static inline int con_set_default_unimap(struct vc_data *vc)
+{
+	return 0;
+}
+static inline void con_free_unimap(struct vc_data *vc)
+{
+}
+static inline void con_protect_unimap(struct vc_data *vc, int rdonly)
+{
+}
+static inline
+int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc)
+{
+	return 0;
+}
 
 #define vc_translate(vc, c) (c)
 #endif
-- 
1.7.2

