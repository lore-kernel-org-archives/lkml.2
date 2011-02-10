Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab1BJOkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:40:06 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:52974
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751179Ab1BJOkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:40:05 -0500
Date: Thu, 10 Feb 2011 14:40:57 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gergely Nagy <algernon@balabit.hu>, david@lang.hm,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marc Koschewski <marc@osknowledge.org>,
        lkml <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now (v3)
Message-ID: <20110210144057.GA7193@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit ce6ada35bdf710d16582cc4869c26722547e6f11, Serge messed up
userspace backward compatibility.  As Gergely pointed out, userspace
which was doing the right thing and dropping all but cap_sys_admin
before calling syslog is now breaking.

At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 1.  When
0, if the user has cap_sys_admin but no cap_syslog, return -EPERM.
When 1 in that case, allow.  Alternatively, as David pointed out,
just leaving the behavior as below is still very useful.

Please apply.

Signed-off-by: Serge Hallyn <serge@hallyn.com>
---
 kernel/printk.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 2ddbdc7..bc56386 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -274,12 +274,24 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 	 * at open time.
 	 */
 	if (type == SYSLOG_ACTION_OPEN || !from_file) {
-		if (dmesg_restrict && !capable(CAP_SYSLOG))
-			goto warn; /* switch to return -EPERM after 2.6.39 */
+		if (dmesg_restrict && !capable(CAP_SYSLOG)) {
+			/* remove after 2.6.39 */
+			if (capable(CAP_SYS_ADMIN))
+				WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
+				  "but no CAP_SYSLOG (deprecated).\n");
+			else
+				return -EPERM;
+		}
 		if ((type != SYSLOG_ACTION_READ_ALL &&
 		     type != SYSLOG_ACTION_SIZE_BUFFER) &&
-		    !capable(CAP_SYSLOG))
-			goto warn; /* switch to return -EPERM after 2.6.39 */
+		     !capable(CAP_SYSLOG)) {
+			/* remove after 2.6.39 */
+			if (capable(CAP_SYS_ADMIN))
+				WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
+				  "but no CAP_SYSLOG (deprecated).\n");
+			else
+				return -EPERM;
+		}
 	}
 
 	error = security_syslog(type);
@@ -423,12 +435,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 	}
 out:
 	return error;
-warn:
-	/* remove after 2.6.39 */
-	if (capable(CAP_SYS_ADMIN))
-		WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
-		  "but no CAP_SYSLOG (deprecated and denied).\n");
-	return -EPERM;
 }
 
 SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
-- 
1.7.2.3

