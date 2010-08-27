Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0H0XBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 19:01:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab0H0XBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 19:01:02 -0400
Subject: selinux vs devtmpfs (vs udev)
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Cc: kay.sievers@vrfy.org, greg@kroah.com, sds@tycho.nsa.gov
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 19:00:52 -0400
Message-ID: <1282950052.3284.110.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got 2 bugs now:

https://bugzilla.redhat.com/show_bug.cgi?id=566332
https://bugzilla.redhat.com/show_bug.cgi?id=627710

Where (I'm assuming) devtmpfs and SELinux are fighting.  In the old old
days we used to have a script that would, after having created
everything in /dev, set the proper SELinux labels on those files.  This
was done so early in boot that races didn't exist yet.

In the new days udev would create nodes in there, but udev is SELinux
aware.  udev will determine what the right SELinux context is, will tell
the kernel what the next file it creates should be labeled, and will
then call mknod, so the device file gets created with the right label.
Again race free.

In the new new days of devtmpfs things aren't as nice.  The kernel is
magically creating files in /dev.  These are getting created with the
'default' SELinux context.  So herein lies the problem.

The first program that tries to access these files get denied by
SELinux.  Now udev actually has logic in it to fix the label on any
closed device file, so udev will at that point swoop in, fix the label,
and the next program that tries to use the file will work just fine.  Oh
fun!

Obviously a good solution would be for devtmpfs to create nodes with the
right label (and udev to not need to be SELinux aware), but that
information isn't available in the kernel.  That information is a purely
userspace construct.  I have a long term plan for how we might be able
to do this long off in the future, but it isn't viable for right now.

So my next best solution would be to ask if it would be possible for
udev to disable devtmpfs automatic device file creation after it is
running.  Once udev is running do we need devtmpfs?  Seems like this
could be a pretty simple /proc/ or /sys/ tunable that udev could twiddle
when/if it was ready to run the show.

Anyone else have thoughts?

-Eric

