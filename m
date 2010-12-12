Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0LLMm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 07:42:59 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:40475 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0LLMm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 07:42:58 -0500
Date: Sun, 12 Dec 2010 13:42:47 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20101212124247.GA14450@gundam.enneenne.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: fsnotify & sysfs
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I know that a sysfs file may be pollable but I'm asking to myself how
it could be difficult adding notifying support also.

Maybe adding a call to the fsnotify subsystem within the
sysfs_notify() function as follow can do the trick?

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index da3fefe..afee69f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -484,8 +486,10 @@ void sysfs_notify(struct kobject *k, const char
*dir, const
                sd = sysfs_find_dirent(sd, NULL, dir);
        if (sd && attr)
                sd = sysfs_find_dirent(sd, NULL, attr);
-       if (sd)
+       if (sd) {
                sysfs_notify_dirent(sd);
+               fsnotify_change(dentry, ATTR_SIZE);
+       }
 
        mutex_unlock(&sysfs_mutex);
 }

However my problem is how to get the struct dentry pointer needed by
fsnotify_change() related to the struct sysfs_dirent pointer passed to
sysfs_notify(). :(

Can you please give me any advice about to solve it?

Another question: in file linux/fs/sysfs/file.c I see:

   #include <linux/fsnotify.h>

but none of its functions are called into file.c... maybe it's a
mistake?

Thanks in advance,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
