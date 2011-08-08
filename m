Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab1HHEWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 00:22:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35589 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1HHEWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 00:22:53 -0400
Date: Mon, 8 Aug 2011 06:22:43 +0200
From: Jonathan Nieder <jrnieder@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Gergely Nagy <algernon@balabit.hu>,
        david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marc Koschewski <marc@osknowledge.org>,
        lkml <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: [PATCH v2] cap_syslog: don't use WARN_ONCE for CAP_SYS_ADMIN
 deprecation warning
Message-ID: <20110808042243.GG19551@elie.gateway.2wire.net>
References: <20110210144057.GA7193@mail.hallyn.com>
 <AANLkTin-2uDkjPuSPmUE_HZdpxk9zd=Qop=nf==jsyLA@mail.gmail.com>
 <20110803164837.GA2669@elie>
 <CA+55aFw0d0bGQhtLB602=_i-PAMmkBs0vRocvtRZUU33xS8=4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+55aFw0d0bGQhtLB602=_i-PAMmkBs0vRocvtRZUU33xS8=4A@mail.gmail.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syslog-ng versions before 3.3.0beta1 (2011-05-12) assume that
CAP_SYS_ADMIN is sufficient to access syslog, so ever since CAP_SYSLOG
was introduced (2010-11-25) they have triggered a warning.
v2.6.38-rc5~46 (cap_syslog: accept CAP_SYS_ADMIN for now, 2011-02-10)
improved matters a little by making syslog-ng work again, just keeping
the WARN_ONCE().  But still, this is a warning that writes a stack
trace we don't care about to syslog, sets a taint flag, and alarms
sysadmins when nothing worse has happened than use of an old userspace
with a recent kernel.

Convert the WARN_ONCE to a printk_once to avoid that while continuing
to give userspace developers a hint that this is an unwanted
backward-compatibility feature and won't be around forever.

Reported-by: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
Reported-by: Niels <zorglub_olsen@hotmail.com>
Reported-by: Paweł Sikora <pluto@agmk.net>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Liked-by: Gergely Nagy <algernon@madhouse-project.org>
Acked-by: Serge Hallyn <serge@hallyn.com>
Acked-by: James Morris <jmorris@namei.org>
---
Linus Torvalds wrote:

> The problem with this one is that converting away from a warning
> doesn't just get rid of all the ugliness, it gets rid of some of the
> *useful* information in the warning too.
>
> In particular, when you have a warning like "Attempting to access
> syslog", you'd better tell people *who* is attempting to access
> syslog, so that they can fix it or complain to the right person.

True.  I can't imagine people wanting to know much more than the
process's command line and pid, which is basically what the WARN_ONCE
gives (though it also gives registers).  Here's an updated patch.

I've carried over the acks from last time; hopefully that's okay.
Thanks for your help.

 kernel/printk.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 37dff342..836a2ae0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -318,8 +318,10 @@ static int check_syslog_permissions(int type, bool from_file)
 			return 0;
 		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
 		if (capable(CAP_SYS_ADMIN)) {
-			WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
-				 "but no CAP_SYSLOG (deprecated).\n");
+			printk_once(KERN_WARNING "%s (%d): "
+				 "Attempt to access syslog with CAP_SYS_ADMIN "
+				 "but no CAP_SYSLOG (deprecated).\n",
+				 current->comm, task_pid_nr(current));
 			return 0;
 		}
 		return -EPERM;
-- 
1.7.6

