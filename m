Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1BDROX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:14:23 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:38560
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752511Ab1BDROW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:14:22 -0500
Date: Fri, 4 Feb 2011 17:15:02 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Gergely Nagy <algernon@balabit.hu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
Message-ID: <20110204171502.GA24226@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
 <20110203153252.GA24153@mail.hallyn.com>
 <20110204160513.GB17396@mail.hallyn.com>
 <1296837186.24742.15.camel@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296837186.24742.15.camel@moria>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gergely Nagy (algernon@balabit.hu):
> On Fri, 2011-02-04 at 16:05 +0000, Serge E. Hallyn wrote:
> > Quoting Serge E. Hallyn (serge@hallyn.com):
> > > >From 2d7408541dd3a6e19a4265b028233789be6a40f4 Mon Sep 17 00:00:00 2001
> > > From: Serge Hallyn <serge@peq.(none)>
> > > Date: Thu, 3 Feb 2011 09:26:15 -0600
> > > Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now
> > > 
> > > At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
> > > 0, refuse if cap_sys_admin, if 1, then allow.  This will allow
> > > users to acknowledge (permanently, if they must, using /etc/sysctl.conf)
> > > that they've seen the syslog message about cap_sys_admin being
> > > deprecated for syslog.
> > > 
> > > Signed-off-by: Serge Hallyn <serge@hallyn.com>
> 
> [...snip...]
> 
> > James, do you mind taking this patch?
> 
> Would it be possible to change the commit message to say that 1 would be
> the default? Just to avoid future confusion... (having it at 0 default
> later would just postpone the userspace breakage)
> 

Good point, attached.

>From ead9a1649880806c333b7f2378509d7d93725480 Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serge@peq.(none)>
Date: Thu, 3 Feb 2011 09:26:15 -0600
Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now

At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 1.  When
0, refuse if cap_sys_admin, if 1, then allow.

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

