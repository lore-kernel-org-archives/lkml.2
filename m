Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0LERwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:52:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab0LERwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:52:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ueCHQwaD2444NQhcGIIr+wC/Ya4Pci9XFi2mjbFA6tDLmVMYfOx2LbRNTxsrtiWsxI
         NW3PXR6LUHq+QrhcxpFZSRQdF/4uPKRGOXrp7YuK6HaVhDt0fAb6g//edj6ZvxH2Y3j+
         basxdcmnbt+hgX6leDR7AJidrZAHzCLwv3z18=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 44/45] kstrtox: convert sound/
Date: Sun,  5 Dec 2010 19:49:41 +0200
Message-Id: <1291571382-2719-44-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 sound/drivers/dummy.c          |    2 +-
 sound/pci/hda/hda_hwdep.c      |   10 ++++------
 sound/pci/hda/patch_sigmatel.c |    7 ++-----
 sound/soc/codecs/wm8962.c      |    4 ++--
 sound/soc/soc-core.c           |    6 +++---
 5 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 7f41990..d3b1a02 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -953,7 +953,7 @@ static void dummy_proc_write(struct snd_info_entry *entry,
 		if (i >= ARRAY_SIZE(fields))
 			continue;
 		snd_info_get_str(item, ptr, sizeof(item));
-		if (strict_strtoull(item, 0, &val))
+		if (kstrtoull(item, 0, &val))
 			continue;
 		if (fields[i].size == sizeof(int))
 			*get_dummy_int_ptr(dummy, fields[i].offset) = val;
diff --git a/sound/pci/hda/hda_hwdep.c b/sound/pci/hda/hda_hwdep.c
index bf3ced5..ecc7edb 100644
--- a/sound/pci/hda/hda_hwdep.c
+++ b/sound/pci/hda/hda_hwdep.c
@@ -293,11 +293,11 @@ static ssize_t type##_store(struct device *dev,			\
 {								\
 	struct snd_hwdep *hwdep = dev_get_drvdata(dev);		\
 	struct hda_codec *codec = hwdep->private_data;		\
-	unsigned long val;					\
-	int err = strict_strtoul(buf, 0, &val);			\
+	int err;						\
+								\
+	err = kstrtou32(buf, 0, &codec->type);			\
 	if (err < 0)						\
 		return err;					\
-	codec->type = val;					\
 	return count;						\
 }
 
@@ -699,9 +699,7 @@ static void parse_chip_name_mode(char *buf, struct hda_bus *bus,
 static void parse_##name##_mode(char *buf, struct hda_bus *bus, \
 				 struct hda_codec **codecp) \
 { \
-	unsigned long val; \
-	if (!strict_strtoul(buf, 0, &val)) \
-		(*codecp)->name = val; \
+	kstrtou32(buf, 0, &(*codecp)->name); \
 }
 
 DEFINE_PARSE_ID_MODE(vendor_id);
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index efa4225..0fedc41 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4192,16 +4192,13 @@ static void stac_toggle_power_map(struct hda_codec *codec, hda_nid_t nid,
 				  int enable);
 
 static inline int get_int_hint(struct hda_codec *codec, const char *key,
-			       int *valp)
+			       unsigned int *val)
 {
 	const char *p;
 	p = snd_hda_get_hint(codec, key);
 	if (p) {
-		unsigned long val;
-		if (!strict_strtoul(p, 0, &val)) {
-			*valp = val;
+		if (kstrtouint(p, 0, val) == 0)
 			return 1;
-		}
 	}
 	return 0;
 }
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index e809274..f1f76d8 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3499,10 +3499,10 @@ static ssize_t wm8962_beep_set(struct device *dev,
 			       const char *buf, size_t count)
 {
 	struct wm8962_priv *wm8962 = dev_get_drvdata(dev);
-	long int time;
+	int time;
 	int ret;
 
-	ret = strict_strtol(buf, 10, &time);
+	ret = kstrtoint(buf, 10, &time);
 	if (ret != 0)
 		return ret;
 
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 441285a..3cdf2d2 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -167,7 +167,7 @@ static ssize_t pmdown_time_set(struct device *dev,
 			container_of(dev, struct snd_soc_pcm_runtime, dev);
 	int ret;
 
-	ret = strict_strtol(buf, 10, &rtd->pmdown_time);
+	ret = kstrtol(buf, 10, &rtd->pmdown_time);
 	if (ret)
 		return ret;
 
@@ -204,7 +204,7 @@ static ssize_t codec_reg_write_file(struct file *file,
 	char buf[32];
 	int buf_size;
 	char *start = buf;
-	unsigned long reg, value;
+	u32 reg, value;
 	int step = 1;
 	struct snd_soc_codec *codec = file->private_data;
 
@@ -223,7 +223,7 @@ static ssize_t codec_reg_write_file(struct file *file,
 		return -EINVAL;
 	while (*start == ' ')
 		start++;
-	if (strict_strtoul(start, 16, &value))
+	if (kstrtou32(start, 16, &value))
 		return -EINVAL;
 	codec->driver->write(codec, reg, value);
 	return buf_size;
-- 
1.7.2.2

