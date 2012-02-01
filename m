Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab2BAVvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:51:24 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48105 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932314Ab2BAVIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:24 -0500
X-Sasl-enc: Eg+dBtqFgfLGKsG5q2WSLSJfmPksUn6mOrPiS4AalByb 1328130503
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:39 2012
Message-Id: <20120201205739.410326010@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Ralf Hildebrandt <ralf.hildebrandt@charite.de>,
        Niels <zorglub_olsen@hotmail.com>,
        =?UTF-8?q?Pawe=C5=82=20Sikora?= <pluto@agmk.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Serge Hallyn <serge@hallyn.com>,
        James Morris <jmorris@namei.org>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: [22/65] cap_syslog: dont use WARN_ONCE for CAP_SYS_ADMIN
 deprecation warning
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Nieder <jrnieder@gmail.com>

commit f2c0d0266cc5eb36a4aa44944b4096ec121490aa upstream.

syslog-ng versions before 3.3.0beta1 (2011-05-12) assume that
CAP_SYS_ADMIN is sufficient to access syslog, so ever since CAP_SYSLOG
was introduced (2010-11-25) they have triggered a warning.

Commit ee24aebffb75 ("cap_syslog: accept CAP_SYS_ADMIN for now")
improved matters a little by making syslog-ng work again, just keeping
the WARN_ONCE().  But still, this is a warning that writes a stack trace
we don't care about to syslog, sets a taint flag, and alarms sysadmins
when nothing worse has happened than use of an old userspace with a
recent kernel.

Convert the WARN_ONCE to a printk_once to avoid that while continuing to
give userspace developers a hint that this is an unwanted
backward-compatibility feature and won't be around forever.

Reported-by: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
Reported-by: Niels <zorglub_olsen@hotmail.com>
Reported-by: Paweł Sikora <pluto@agmk.net>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Liked-by: Gergely Nagy <algernon@madhouse-project.org>
Acked-by: Serge Hallyn <serge@hallyn.com>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/printk.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -318,8 +318,10 @@ static int check_syslog_permissions(int
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


