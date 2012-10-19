Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab2JSVQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:16:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab2JSVQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:16:39 -0400
Message-Id: <20121019211626.903894692@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Fri, 19 Oct 2012 17:16:28 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, Jiri Slaby <jslaby@suse.cz>,
        cgroups@vger.kernel.org
Subject: [PATCH 2/3] device_cgroup: stop using simple_strtoul()
References: <20121019211626.219447423@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=kstrtou32.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the code to use kstrtou32() instead of simple_strtoul()
which is deprecated. The real size of the variables are u32, so use kstrtou32
instead of kstrtoul


Cc: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>

---
 security/device_cgroup.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- github.orig/security/device_cgroup.c	2012-10-19 16:35:46.366102913 -0400
+++ github/security/device_cgroup.c	2012-10-19 16:35:50.801229331 -0400
@@ -361,8 +361,8 @@ static int devcgroup_update_access(struc
 				   int filetype, const char *buffer)
 {
 	const char *b;
-	char *endp;
-	int count;
+	char temp[12];		/* 11 + 1 characters needed for a u32 */
+	int count, rc;
 	struct dev_exception_item ex;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -405,8 +405,16 @@ 		return 0;
 		ex.major = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		ex.major = simple_strtoul(b, &endp, 10);
-		b = endp;
+		memset(temp, 0, sizeof(temp));
+		for (count = 0; count < sizeof(temp) - 1; count++) {
+			temp[count] = *b;
+			b++;
+			if (!isdigit(*b))
+				break;
+		}
+		rc = kstrtou32(temp, 10, &ex.major);
+		if (rc)
+			return -EINVAL;
 	} else {
 		return -EINVAL;
 	}
@@ -419,8 +427,16 @@ 		ex.major = simple_strtoul(b, &endp, 10
 		ex.minor = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		ex.minor = simple_strtoul(b, &endp, 10);
-		b = endp;
+		memset(temp, 0, sizeof(temp));
+		for (count = 0; count < sizeof(temp) - 1; count++) {
+			temp[count] = *b;
+			b++;
+			if (!isdigit(*b))
+				break;
+		}
+		rc = kstrtou32(temp, 10, &ex.minor);
+		if (rc)
+			return -EINVAL;
 	} else {
 		return -EINVAL;
 	}

