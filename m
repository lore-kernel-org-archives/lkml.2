Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1BCPcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:32:17 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:57601
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756102Ab1BCPcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:32:16 -0500
Date: Thu, 3 Feb 2011 15:32:53 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Gergely Nagy <algernon@balabit.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
Message-ID: <20110203153252.GA24153@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296733177.14846.26.camel@moria>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gergely Nagy (algernon@balabit.hu):
> Hi!
> 
> Back in november, a patch was merged into the kernel (in  commit
> ce6ada35bdf710d16582cc4869c26722547e6f11), that splits CAP_SYSLOG out of
> CAP_SYS_ADMIN.
> 
> Sadly, this has an unwelcomed consequence, that any userspace syslogd
> that formerly used CAP_SYS_ADMIN will stop working, unless upgraded, or
> otherwise adapted to the change.
> 
> However, updating userspace isn't that easy, either, if one wants to
> support multiple kernels with the same userspace binary: pre-2.6.38, one
> needs CAP_SYS_ADMIN, but later kernels will need CAP_SYS_ADMIN. It would
> be trivial to keep both, but that kind of defeats the purpose of
> CAP_SYSLOG,

The idea would be to only use both when you detect a possibly older
kernel. 

> in my opinion. It can be made configurable, and one can let
> the admin set which one to use, but that's ugly, and doesn't fix the
> underlying issue, just delegates it to the admins. And automatically
> deciding runtime proved to be trickier than I would've liked.
> 
> My question would be, and this is why I'm CCing the author & committer:
> how are userspace syslogds supposed to handle this situation?
> 
> Preferably in a way that does not need manual intervention whenever one
> changes kernel.

It had been considered to just warn in syslog, but I was (and still am)
quite sure that would have been completely ignored by userspace.

However, you're right of course, I really should have provided some way
for userspace to click 'ok, got the message, now continue anyway because
I'm running older userspace for now,'  i.e. a sysctl perhaps.

Sorry about the trouble.  Here is a patch to just warn for now, with
the changelog showing what i intend to push next.

sorry again,
-serge

>From 2d7408541dd3a6e19a4265b028233789be6a40f4 Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serge@peq.(none)>
Date: Thu, 3 Feb 2011 09:26:15 -0600
Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now

At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
0, refuse if cap_sys_admin, if 1, then allow.  This will allow
users to acknowledge (permanently, if they must, using /etc/sysctl.conf)
that they've seen the syslog message about cap_sys_admin being
deprecated for syslog.

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

