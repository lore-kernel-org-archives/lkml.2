Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334Ab0DVEKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 00:10:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57120 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0DVEKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 00:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=SKkxkAqHVNKRhzJCaE1fTc6EPF81IO+Hn6CqUsgbPDf2EC7xGWrW6jKYgfnTSDv+oO
         HMfj2znXgfRlyUCh77rcU/tzxWZuJRcwwPEB1DVrvAoOV6R4FErkWchCKVDfWLakGdpy
         CRxGNFB68eGUNheWCdAn/OE6Gnh2cSbW2ZHK8=
MIME-Version: 1.0
Date: Thu, 22 Apr 2010 12:10:39 +0800
Message-ID: <k2hccf7f6161004212110ze02b6cfbr2b5082441ea6a4d9@mail.gmail.com>
Subject: [PATCH 2.6.34-rc1] proc: fix badness in fs/proc/generic.c
From: GuanJun He <heguanbo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix badness in fs/proc/generic.c,  Bug 15589 -  2.6.34-rc1: Badness at
fs/proc/generic.c:316
this is just to get least waste.

Signed-off-by: Guanjun He <heguanbo@gmail.com>

---
diff -Nupr linux-2.6.34-rc1.orig/fs/proc/generic.c
linux-2.6.34-rc1/fs/proc/generic.c
--- linux-2.6.34-rc1.orig/fs/proc/generic.c     2010-03-09
02:45:44.000000000 +0800
+++ linux-2.6.34-rc1/fs/proc/generic.c  2010-04-22 11:32:00.000000000 +0800
@@ -313,7 +313,15 @@ static int __xlate_proc_name(const char
                                break;
                }
                if (!de) {
-                       WARN(1, "name '%s'\n", name);
+                       char *dup = kstrdup(name, GFP_KERNEL);
+                       if (dup) {
+                               cp = dup;
+                               while(*dup) {
+                                       if (*dup == '/')
+                                               *dup++ = '_';
+                               }
+                               WARN(1, "name '%s'\n", cp);
+                       }
                        return -ENOENT;
                }
                cp += len + 1;
