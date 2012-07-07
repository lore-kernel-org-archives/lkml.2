Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab2GGWjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 18:39:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53558 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2GGWjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 18:39:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120702101057.2a8dd6a6@notabene.brown>
References: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
	<20120630032333.GB3972@kroah.com>
	<CAMbhsRSYL3oE_mbdjyNbV453DddPNUyJBU2eLJhUNaASF1+MtA@mail.gmail.com>
	<20120630041928.GA1816@kroah.com>
	<CAMbhsRRUs1tHQ+DfWzhKE6M47+Rqu0uB4hQgX7d7ZGzaZi9uyw@mail.gmail.com>
	<20120702101057.2a8dd6a6@notabene.brown>
Date: Sat, 7 Jul 2012 15:39:09 -0700
X-Google-Sender-Auth: ttUxv2T_jQrc7lOZm4scfMGXJqw
Message-ID: <CAMbhsRSQhBTxA9g1b4Pc6px4gYcOzn4miOrS6ecdJmOQ+RNSGA@mail.gmail.com>
Subject: Re: [PATCH] bcb: Android bootloader control block driver
From: Colin Cross <ccross@android.com>
To: NeilBrown <neilb@suse.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Boie <andrew.p.boie@intel.com>, arve@android.com,
        rebecca@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 1, 2012 at 5:10 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 29 Jun 2012 21:37:36 -0700 Colin Cross <ccross@android.com> wrote:
>
>> What's the point of the existing syscall option if it doesn't work on
>> all platforms, or at least all platforms that want to support it?  It
>> doesn't make sense to me to use REBOOT2 on some SoCs because they
>> happen to use something that userspace cannot access, but use direct
>> access from userspace and a different reboot syscall option on other
>> SoCs.

You missed this part of my message.

>> >> <snip>
>> >>
>> >> >>
>> >> >> diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
>> >> >> index 9a99238..c30fd20 100644
>> >> >> --- a/drivers/staging/android/Kconfig
>> >> >> +++ b/drivers/staging/android/Kconfig
>> >> >> @@ -78,6 +78,17 @@ config ANDROID_INTF_ALARM_DEV
>> >> >>         elapsed realtime, and a non-wakeup alarm on the monotonic clock.
>> >> >>         Also exports the alarm interface to user-space.
>> >> >>
>> >> >> +config BOOTLOADER_CONTROL
>> >> >> +     tristate "Bootloader Control Block module"
>> >> >> +     default n
>> >> >> +     help
>> >> >> +       This driver installs a reboot hook, such that if reboot() is invoked
>> >> >> +       with a string argument NNN, "bootonce-NNN" is copied to the command
>> >> >> +       field in the Bootloader Control Block on the /misc partition, to be
>> >> >> +       read by the bootloader. If the string matches one of the boot labels
>> >> >> +       defined in its configuration, it will boot once into that label. The
>> >> >> +       device and partition number are specified on the kernel command line.
>> >> >> +
>> >> >>  endif # if ANDROID
>> >> >>
>> >> >>  endmenu
>> >>
>> >> Most of this driver is not unique to Android.
>> >
>> > Do any other systems use it?
>>
>> None that I'm aware of, but REBOOT2 existed long before Android, so I
>> assume something must have used it.
>
> Dangerous that - making assumptions.
>
> I've just spent a while hunting though the code and the history.
> The LINUX_REBOOT_CMD_RESTART2 option to sys_reboot - which is the only one
> that uses the the 'arg' option - was added in 2.1.30.  This was the same time
> that reboot notifiers were added and there seem to be steps towards a more
> generic "machine_restart" call.
> No code actually *used* the arg.
>
> Looking through current code is rather time consuming as you have to follow
> several levels of indirection to find code that might actually use the arg,
> but I spend a while looking, trying to cover samples for all archs and driver
> classes (there are lots of watchdogs -  I didn't check them all).
> I only found *1* instance of code which actually used the arg.
> This is arch/alpha/kernel/process.c which tests if the arg is NULL, and
> selects between a "cold bootstrap" and a "warm bootstrap".
>
> I think we would be well served by a patch that just removes it.  Or at
> least, that ignores the value of the arg and just passes NULL or (void*)1.
> And definitely don't pass it to the reboot notifiers - no code uses it there.
>
> I can certainly see value in having a standard interface to say "the next
> reboot should boot 'foo' rather than the default".  I don't think there is
> any real need for the kernel to provide that interface.
>
> I would suggest that you create
>     /sbin/next-boot-image
> (or some better name), which gets a different program installed depending on
> what boot loader is in use.  Then your libcutils can just
>
>   system("/sbin/next-boot-image foo")
>   reboot(LINUX_REBOOT_CMD_RESTART);
>
> and work on all platforms.
> (Or use a loadable module, or a binder RPC to some service, or dbus or smoke
> signals or whatever).
>

On many (most?) ARM SoCs, the reboot flag is not stored on disk, or
anywhere else userspace can access.  It is stored in a power
management controller scratch register that survives resets, or a
register in an external I2C PMIC, or in internal SoC RAM (I've seen
all of these).  For your proposal, every SoC would need a custom API
to save the reboot flag somewhere.  For these devices, it clearly
makes more sense to use something like the REBOOT2 API, and if we have
to use it on some devices, it makes no sense to me to not use it on
other devices just because userspace could theoretically handle it.
