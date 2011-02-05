Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1BEOYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:24:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1BEOWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pFhLtNgKy01P4NbDV7zKTvu0ujijEwgVENdvXX/LcxtaOnURlmWXGLNNG27W72Lbn8
         Y4lutUANENy0pAEZB+/dXZLCv9Mbiko2NSDWOlOnMFvcDyYrxB0JNTLdo0f9/PltMZCo
         TiwGOPbRuWOy+um6qKrfPzr7qeLOyadDZalVQ=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 43/52] kstrtox: convert sound/
Date: Sat,  5 Feb 2011 16:20:46 +0200
Message-Id: <1296915654-7458-43-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
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
index 9ea48b4..4ebbe64 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4194,16 +4194,13 @@ static void stac_toggle_power_map(struct hda_codec *codec, hda_nid_t nid,
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
index b9cb1fc..996676f 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3501,10 +3501,10 @@ static ssize_t wm8962_beep_set(struct device *dev,
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
index bac7291..75f278d 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -151,7 +151,7 @@ static ssize_t pmdown_time_set(struct device *dev,
 			container_of(dev, struct snd_soc_pcm_runtime, dev);
 	int ret;
 
-	ret = strict_strtol(buf, 10, &rtd->pmdown_time);
+	ret = kstrtol(buf, 10, &rtd->pmdown_time);
 	if (ret)
 		return ret;
 
@@ -188,7 +188,7 @@ static ssize_t codec_reg_write_file(struct file *file,
 	char buf[32];
 	int buf_size;
 	char *start = buf;
-	unsigned long reg, value;
+	u32 reg, value;
 	int step = 1;
 	struct snd_soc_codec *codec = file->private_data;
 
@@ -207,7 +207,7 @@ static ssize_t codec_reg_write_file(struct file *file,
 		return -EINVAL;
 	while (*start == ' ')
 		start++;
-	if (strict_strtoul(start, 16, &value))
+	if (kstrtou32(start, 16, &value))
 		return -EINVAL;
 	snd_soc_write(codec, reg, value);
 	return buf_size;
-- 
1.7.3.4

