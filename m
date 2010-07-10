Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0GJV6J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:58:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45425 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0GJV6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Ftqj7yTCQdwZBZifupr2EiT4kdKBeajrVJtXcjCUvktjTa4JJQzCNHmEvW43HhuU9W
         kOTi+UAhnvVOMI5fOznGuC69kkpKZKaJrub7oL3wUt4YGLLDJxr+wv0piz+L4pxEEo4c
         QJA5HjnA141ZhmLltWWBM6hck8SWW42jeDi4s=
From: Kevin Winchester <kjwinchester@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kevin Winchester <kjwinchester@gmail.com>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix warning: statement with no effect due to vt_kern.h
Date: Sat, 10 Jul 2010 18:57:56 -0300
Message-Id: <1278799076-5928-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Greg Kroah-Hartman <gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 include/linux/vt_kern.h |   57 +++++++++++++++++++++++++++++++++++++---------
 1 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 7f56db4..8c9ab62 100644
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
1.7.1

