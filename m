Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1BIVWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:22:39 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:34040
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750946Ab1BIVWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:22:38 -0500
Date: Wed, 9 Feb 2011 21:23:29 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: david@lang.hm, Gergely Nagy <algernon@balabit.hu>,
        James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
Message-ID: <20110209212329.GA24777@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
 <20110203153252.GA24153@mail.hallyn.com>
 <20110204160513.GB17396@mail.hallyn.com>
 <1296837186.24742.15.camel@moria>
 <20110204171502.GA24226@mail.hallyn.com>
 <alpine.DEB.2.00.1102042301420.8162@asgard.lang.hm>
 <20110206011831.GB15805@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110206011831.GB15805@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serge@hallyn.com):
> Quoting david@lang.hm (david@lang.hm):
> > On Fri, 4 Feb 2011, Serge E. Hallyn wrote:
> > 
> > >Quoting Gergely Nagy (algernon@balabit.hu):
> > >>On Fri, 2011-02-04 at 16:05 +0000, Serge E. Hallyn wrote:
> > >>>Quoting Serge E. Hallyn (serge@hallyn.com):
> > >>>>>From 2d7408541dd3a6e19a4265b028233789be6a40f4 Mon Sep 17 00:00:00 2001
> > >>>>From: Serge Hallyn <serge@peq.(none)>
> > >>>>
> > >>>>At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
> > >>>>0, refuse if cap_sys_admin, if 1, then allow.  This will allow
> > >>>>users to acknowledge (permanently, if they must, using /etc/sysctl.conf)
> > >>>>that they've seen the syslog message about cap_sys_admin being
> > >>>>deprecated for syslog.
> > >>>>
> > >>>>Signed-off-by: Serge Hallyn <serge@hallyn.com>
> > >-			goto warn; /* switch to return -EPERM after 2.6.39 */
> > >+		     !capable(CAP_SYSLOG)) {
> > >+			/* remove after 2.6.39 */
> > >+			if (capable(CAP_SYS_ADMIN))
> > >+				WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
> > >+				  "but no CAP_SYSLOG (deprecated).\n");
> > >+			else
> > >+				return -EPERM;
> > >+		}
> > >	}
> > 
> > why does this need to be removed after 2.6.39?
> > 
> > whenever you go to remove it you will break userspace, what's the
> > benifit of breaking userspace?
> > 
> > I can understand that it's better to have a syslog daemon with
> > CAP_SYSLOG instead of CAP_SYS_ADMIN, but does "it would be better to
> > have userspace changed" really translate into "it's so important to
> > have userspace changed that we need to break any userspace that
> > hasn't changed"?
> > 
> > I really don't think so.
> 
> I think I agree with you.  If someone wants to grant one of the other
> CAP_SYS_ADMIN powers without CAP_SYSLOG, then they can break that into
> yet another, i.e. CAP_IPCSET.  Makes sense.

So if that's how we're leaning, then the following patch is much more
concise.  I'll send this to Linus and any appropriate -stable tomorrow
 if noone objects.

>From 5166e114d6a7c508addbadd763322089eb0b02f5 Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serge@hallyn.com>
Date: Thu, 3 Feb 2011 09:26:15 -0600
Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now (v2)

It'd be nice to do that later, but it's not strictly necessary,
and it'll be hard to do without breaking somebody's userspace.

Signed-off-by: Serge Hallyn <serge@hallyn.com>
---
 kernel/printk.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 2ddbdc7..ff58136 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -274,12 +274,12 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 	 * at open time.
 	 */
 	if (type == SYSLOG_ACTION_OPEN || !from_file) {
-		if (dmesg_restrict && !capable(CAP_SYSLOG))
-			goto warn; /* switch to return -EPERM after 2.6.39 */
+		if (dmesg_restrict && !capable(CAP_SYSLOG) && !capable(CAP_SYS_ADMIN))
+			return -EPERM;
 		if ((type != SYSLOG_ACTION_READ_ALL &&
 		     type != SYSLOG_ACTION_SIZE_BUFFER) &&
-		    !capable(CAP_SYSLOG))
-			goto warn; /* switch to return -EPERM after 2.6.39 */
+		     !capable(CAP_SYSLOG) && !capable(CAP_SYS_ADMIN))
+			return -EPERM;
 	}
 
 	error = security_syslog(type);
@@ -423,12 +423,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
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

