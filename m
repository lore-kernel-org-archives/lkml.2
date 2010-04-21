Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0DULJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 07:09:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53753 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab0DULJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 07:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NfBOe5KGcA/2vO8C0IyBr5W9DzDLkjj8XND47Yk31sbtPYfXuh8ySs6BMd2aQ+OTNf
         b/Ov3xjqcXyjW4acS5nCxoTg6oS+lhgqGlgSEid5aK/6h3J3FUAyF8ehQGr1egxFizrw
         DF2mHhTJ6Zsedq//aOR0kZSarbL0DsiGB83S8=
MIME-Version: 1.0
Date: Wed, 21 Apr 2010 19:09:42 +0800
Message-ID: <z2xccf7f6161004210409n817c86eckdb72d9cdb31e3be@mail.gmail.com>
Subject: [PATCH 2.6.34-rc1] proc: fix badness in fs/proc/generic.c
From: GuanJun He <heguanbo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix badness in fs/proc/generic.c,  Bug 15589 -  2.6.34-rc1: Badness at
fs/proc/generic.c:316

Signed-off-by: Guanjun He <heguanbo@gmail.com>

---
diff -Nupr linux-2.6.34-rc1.orig/fs/proc/generic.c
linux-2.6.34-rc1/fs/proc/generic.c
--- linux-2.6.34-rc1.orig/fs/proc/generic.c     2010-03-09
02:45:44.000000000 +0800
+++ linux-2.6.34-rc1/fs/proc/generic.c  2010-04-21 19:02:49.000000000 +0800
@@ -297,11 +297,13 @@ static int __xlate_proc_name(const char
        const char              *cp = name, *next;
        struct proc_dir_entry   *de;
        int                     len;
+       int                     rtn = 0;

        de = *ret;
        if (!de)
                de = &proc_root;

+       spin_lock(&proc_subdir_lock);
        while (1) {
                next = strchr(cp, '/');
                if (!next)
@@ -313,14 +315,17 @@ static int __xlate_proc_name(const char
                                break;
                }
                if (!de) {
-                       WARN(1, "name '%s'\n", name);
-                       return -ENOENT;
+                       WARN(1, "name \"%s\"\n", name);
+                       rtn = -ENOENT;
+                       goto out;
                }
                cp += len + 1;
        }
        *residual = cp;
        *ret = de;
-       return 0;
+out:
+       spin_unlock(&proc_subdir_lock);
+       return rtn;
 }

 static int xlate_proc_name(const char *name, struct proc_dir_entry **ret,
