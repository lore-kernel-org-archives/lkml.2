Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895Ab2F3ETe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 00:19:34 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40740 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2F3ETd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 00:19:33 -0400
Date: Sat, 30 Jun 2012 00:19:28 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Colin Cross <ccross@android.com>
Cc: Andrew Boie <andrew.p.boie@intel.com>, arve@android.com,
        rebecca@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcb: Android bootloader control block driver
Message-ID: <20120630041928.GA1816@kroah.com>
References: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
 <20120630032333.GB3972@kroah.com>
 <CAMbhsRSYL3oE_mbdjyNbV453DddPNUyJBU2eLJhUNaASF1+MtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMbhsRSYL3oE_mbdjyNbV453DddPNUyJBU2eLJhUNaASF1+MtA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 08:43:34PM -0700, Colin Cross wrote:
> On Fri, Jun 29, 2012 at 8:23 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Jun 29, 2012 at 12:36:30PM -0700, Andrew Boie wrote:
> >> Android userspace tells the kernel that it wants to boot into recovery
> >> or some other non-default OS environment by passing a string argument
> >> to reboot(). It is left to the OEM to hook this up to their specific
> >> bootloader.
> >
> > How does userspace "tell" the kernel this?  You are creating a new
> > user/kernel api here, and haven't documented it at all.  That's not
> > generally a wise idea.
> 
> Android's libcutils uses the existing reboot syscall with
> reboot(LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2,
> LINUX_REBOOT_CMD_MAGIC2, <string>).  According to "man 2 reboot":
>        LINUX_REBOOT_CMD_RESTART2
>               (0xa1b2c3d4; since 2.1.30).  The message "Restarting system with
>               command  '%s'"  is  printed,  and  a  restart (using the command
>               string given in arg) is performed immediately.  If not  preceded
>               by a sync(2), data will be lost.

Yes, but now you have given the <string> field here a "magic" value and
data which causes the kernel to write something to a random disk block.
And that <string> is now not just a string, but it is really a structure
that the kernel is interpreting.

In other words, you have just created a new syscall :)

> >> This driver uses the bootloader control block (BCB) in the 'misc'
> >> partition, which is the AOSP mechanism used to communicate with
> >> the bootloader. Writing 'bootonce-NNN' to the command field
> >> will cause the bootloader to do a oneshot boot into an alternate
> >> boot label NNN if it exists. The device and partition number are
> >> passed in via kernel command line.
> >
> > I don't understand still, why userspace can't just do this as it is the
> > one that knws where the device and partition is, and it knows what it
> > wants to have written in this area, why have the kernel do this?  Why
> > not just modify userspace to do it instead?
> 
> In this particular case, userspace could handle writing the data.  On
> many SoCs, reboot mode is written to a register or to internal IO
> mapped memory.  Supporting the REBOOT2 argument to the syscall
> requires something in the kernel to save that message, this driver
> seems to commonize saving that to a disk partition, which is the least
> common denominator way to handle it.

Ok, but as that is what this driver is doing, userspace should be doing
it instead as there is no writing to magic registers or internal IO
mapped memory happening.

> <snip>
> 
> >>
> >> diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
> >> index 9a99238..c30fd20 100644
> >> --- a/drivers/staging/android/Kconfig
> >> +++ b/drivers/staging/android/Kconfig
> >> @@ -78,6 +78,17 @@ config ANDROID_INTF_ALARM_DEV
> >>         elapsed realtime, and a non-wakeup alarm on the monotonic clock.
> >>         Also exports the alarm interface to user-space.
> >>
> >> +config BOOTLOADER_CONTROL
> >> +     tristate "Bootloader Control Block module"
> >> +     default n
> >> +     help
> >> +       This driver installs a reboot hook, such that if reboot() is invoked
> >> +       with a string argument NNN, "bootonce-NNN" is copied to the command
> >> +       field in the Bootloader Control Block on the /misc partition, to be
> >> +       read by the bootloader. If the string matches one of the boot labels
> >> +       defined in its configuration, it will boot once into that label. The
> >> +       device and partition number are specified on the kernel command line.
> >> +
> >>  endif # if ANDROID
> >>
> >>  endmenu
> 
> Most of this driver is not unique to Android.

Do any other systems use it?

> If you remove the status and recovery fields in the partition and the
> list of possible command values, it becomes a neutral way to pass the
> REBOOT2 argument from userspace to the bootloader.  status and
> recovery are a separate contract between userspace and the bootloader,
> and could go into a separate block in the same partition for systems
> that need it.

Possibly, but again, writing to a specific block should be something
that userspace does, not the kernel, as userspace just told the kernel
to write this data to the disk already, why not use the standard method
instead of creating a new way?

thanks,

greg k-h
