Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0H1J5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 05:57:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48611 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab0H1J5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 05:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <1282950052.3284.110.camel@dhcp231-106.rdu.redhat.com>
References: <1282950052.3284.110.camel@dhcp231-106.rdu.redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 28 Aug 2010 11:57:26 +0200
Message-ID: <AANLkTi=aEdKM_hunJmPzXxPqkrbok+_C6QUKf8v=Q+18@mail.gmail.com>
Subject: Re: selinux vs devtmpfs (vs udev)
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, greg@kroah.com,
        sds@tycho.nsa.gov
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 01:00, Eric Paris <eparis@redhat.com> wrote:
> I've got 2 bugs now:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=566332
> https://bugzilla.redhat.com/show_bug.cgi?id=627710
>
> Where (I'm assuming) devtmpfs and SELinux are fighting.  In the old old
> days we used to have a script that would, after having created
> everything in /dev, set the proper SELinux labels on those files.  This
> was done so early in boot that races didn't exist yet.
>
> In the new days udev would create nodes in there, but udev is SELinux
> aware.  udev will determine what the right SELinux context is, will tell
> the kernel what the next file it creates should be labeled, and will
> then call mknod, so the device file gets created with the right label.
> Again race free.
>
> In the new new days of devtmpfs things aren't as nice.  The kernel is
> magically creating files in /dev.  These are getting created with the
> 'default' SELinux context.  So herein lies the problem.
>
> The first program that tries to access these files get denied by
> SELinux.  Now udev actually has logic in it to fix the label on any
> closed device file, so udev will at that point swoop in, fix the label,
> and the next program that tries to use the file will work just fine.  Oh
> fun!
>
> Obviously a good solution would be for devtmpfs to create nodes with the
> right label (and udev to not need to be SELinux aware), but that
> information isn't available in the kernel.  That information is a purely
> userspace construct.  I have a long term plan for how we might be able
> to do this long off in the future, but it isn't viable for right now.
>
> So my next best solution would be to ask if it would be possible for
> udev to disable devtmpfs automatic device file creation after it is
> running.  Once udev is running do we need devtmpfs?  Seems like this
> could be a pretty simple /proc/ or /sys/ tunable that udev could twiddle
> when/if it was ready to run the show.

Udev should still label all device nodes, even when they are created
by the kernel. Devtmpfs or not should not make a difference here.

I guess it's a udev bug introduced with:
  http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=578cc8a8085a47c963b5940459e475ac5f07219c

and we just need to fix that.

Kay
