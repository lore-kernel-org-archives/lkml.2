Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1HCQsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:48:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63383 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1HCQsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:48:47 -0400
Date: Wed, 3 Aug 2011 18:48:37 +0200
From: Jonathan Nieder <jrnieder@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Gergely Nagy <algernon@balabit.hu>,
        david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marc Koschewski <marc@osknowledge.org>,
        lkml <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: [PATCH/RFC] cap_syslog: make CAP_SYS_ADMIN deprecation notice less
 alarming
Message-ID: <20110803164837.GA2669@elie>
References: <20110210144057.GA7193@mail.hallyn.com>
 <AANLkTin-2uDkjPuSPmUE_HZdpxk9zd=Qop=nf==jsyLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTin-2uDkjPuSPmUE_HZdpxk9zd=Qop=nf==jsyLA@mail.gmail.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syslog-ng versions in active use assume that CAP_SYS_ADMIN is
sufficent to access syslog.  As a result, ever since CAP_SYSLOG was
introduce in v2.6.38-rc1~429^2~18 (security: Define CAP_SYSLOG,
2010-11-25), they have triggered a warning, complete with kernel
backtrace.

v2.6.38-rc5~46 (cap_syslog: accept CAP_SYS_ADMIN for now, 2011-02-10)
made things a little better by removing the regression in behavior,
just keeping the WARN_ONCE.  But still, this is a warning that adds
many lines to syslog, sets a taint flag, and alarms sysadmins when
nothing worse has happened than use of an old userspace with a recent
kernel.

Convert the WARN_ONCE to a printk_once to avoid this while continuing
to give userspace developers a hint that this is an unwanted
backward-compatibility feature and won't be around forever.

Reported-by: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
Reported-by: Niels <zorglub_olsen@hotmail.com>
Reported-by: Paweł Sikora <pluto@agmk.net>
Liked-by: Gergely Nagy <algernon@madhouse-project.org>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Hi,

Nothing urgent about this, but it seems to be a frequently[1] reported[2]
source of unnecessary worry.  Thoughts?

[1] http://thread.gmane.org/gmane.linux.kernel/1145040
[2] http://thread.gmane.org/gmane.linux.kernel/1153808

Context: http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=32;bug=636501

 kernel/printk.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 37dff342..db64c951 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -318,7 +318,8 @@ static int check_syslog_permissions(int type, bool from_file)
 			return 0;
 		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
 		if (capable(CAP_SYS_ADMIN)) {
-			WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
+			printk_once(KERN_WARNING
+				 "Attempt to access syslog with CAP_SYS_ADMIN "
 				 "but no CAP_SYSLOG (deprecated).\n");
 			return 0;
 		}
-- 
1.7.6

