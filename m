Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab0FIVrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:47:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:56252 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab0FIVru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Sy7Ku8m7ZFz2SK679xp/v/hokCAo8+HjAUixcetaglcSxT0m7aiQfjJJz+PqFMdQ4C
         WJ96V4mss1ROcra8nrHXXmlpufWYvrXl01IZJ6jrszqwLPW+PvzvSBoOTXqM4VqnF3oB
         I9CDTRYoRznKXGks8TN8cv7p5UWyKnQZcHog0=
Date: Thu, 10 Jun 2010 00:47:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, yi.y.yang@intel.com
Subject: [PATCH 2/2] kstrto*: convert kernel/params.c
Message-ID: <20100609214744.GB31340@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove proxy variable and checking that casting to a type doesn't change
value -- kstrto* do all of this inside.
---

 kernel/params.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 0b30ecd..0e5c4ad 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -175,17 +175,15 @@ int parse_args(const char *name,
 }
 
 /* Lazy bastard, eh? */
-#define STANDARD_PARAM_DEF(name, type, format, tmptype, strtolfn)      	\
+#define STANDARD_PARAM_DEF(name, type, format, strtolfn)		\
 	int param_set_##name(const char *val, struct kernel_param *kp)	\
 	{								\
-		tmptype l;						\
 		int ret;						\
 									\
 		if (!val) return -EINVAL;				\
-		ret = strtolfn(val, 0, &l);				\
-		if (ret == -EINVAL || ((type)l != l))			\
-			return -EINVAL;					\
-		*((type *)kp->arg) = l;					\
+		ret = strtolfn(val, 0, (type *)kp->arg);		\
+		if (ret < 0)						\
+			return ret;					\
 		return 0;						\
 	}								\
 	int param_get_##name(char *buffer, struct kernel_param *kp)	\
@@ -193,13 +191,13 @@ int parse_args(const char *name,
 		return sprintf(buffer, format, *((type *)kp->arg));	\
 	}
 
-STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
-STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
-STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(long, long, "%li", long, strict_strtol);
-STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(byte, u8, "%c", kstrtou8);
+STANDARD_PARAM_DEF(short, s16, "%hi", kstrtos16);
+STANDARD_PARAM_DEF(ushort, u16, "%hu", kstrtou16);
+STANDARD_PARAM_DEF(int, int, "%i", kstrtoint);
+STANDARD_PARAM_DEF(uint, unsigned int, "%u", kstrtouint);
+STANDARD_PARAM_DEF(long, long, "%li", kstrtol);
+STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", kstrtoul);
 
 int param_set_charp(const char *val, struct kernel_param *kp)
 {
-- 
1.6.4.4

