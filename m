Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab1F2Q55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:57:57 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:51089 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab1F2Q54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:57:56 -0400
From: Richard Weinberger <richard@nod.at>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/4] um: Fix _FORTIFY_SOURCE=2 support for kernel modules
Date: Wed, 29 Jun 2011 18:57:50 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: Vitaliy Ivanov <vitalivanov@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        Florian Fainelli <florian@openwrt.org>
References: <1309212931-19772-1-git-send-email-richard@nod.at> <201106291742.24137.richard@nod.at> <BANLkTikLEPgtK+Z6jD1r18TySkzNbLQJjg@mail.gmail.com>
In-Reply-To: <BANLkTikLEPgtK+Z6jD1r18TySkzNbLQJjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291857.50810.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 29 Juni 2011, 18:42:43 schrieb Geert Uytterhoeven:
> On Wed, Jun 29, 2011 at 17:42, Richard Weinberger <richard@nod.at> wrote:
> > Am Mittwoch 29 Juni 2011, 17:37:54 schrieb Vitaliy Ivanov:
> >> On Tue, Jun 28, 2011 at 1:15 AM, Richard Weinberger <richard@nod.at> wrote:
> >> > When UML is compiled with _FORTIFY_SOURCE we have to
> >> > export all _chk() functions which are used in modules.
> >> > For now it's only the case for __sprintf_chk().
> >> > 
> >> > Tested-by: Florian Fainelli <florian@openwrt.org>
> >> > Reported-by: Florian Fainelli <florian@openwrt.org>
> >> > Signed-off-by: Richard Weinberger <richard@nod.at>
> >> > ---
> >> >  arch/um/os-Linux/user_syms.c |    5 +++++
> >> >  1 files changed, 5 insertions(+), 0 deletions(-)
> >> > 
> >> > diff --git a/arch/um/os-Linux/user_syms.c
> >> > b/arch/um/os-Linux/user_syms.c index 05f5ea8..45ffe46 100644
> >> > --- a/arch/um/os-Linux/user_syms.c
> >> > +++ b/arch/um/os-Linux/user_syms.c
> >> > @@ -113,3 +113,8 @@ EXPORT_SYMBOL(__stack_smash_handler);
> >> > 
> >> >  extern long __guard __attribute__((weak));
> >> >  EXPORT_SYMBOL(__guard);
> >> > +
> >> > +#ifdef _FORTIFY_SOURCE
> >> > +extern int __sprintf_chk(char *str, int flag, size_t strlen, const
> >> > char *format); +EXPORT_SYMBOL(__sprintf_chk);
> >> > +#endif
> >> > --
> >> 
> >> Can you please clarify why it's needed? I use FORTIFY_SOURCES on
> >> Linus' tree UML on Ubuntu w/ no problems and w/o this patch...
> > 
> > The problem appears only when a UML kernel module is using sprintf().
> > E.g: CONFIG_UML_WATCHDOG.
> > Then loading the module will fail because of the missing symbol
> > __sprintf_chk().
> 
> What about changing harddog_user.c to not use sprintf(), but snprintf()?

Then we still have to export __snprintf_chk().

Anyway, replacing all the ugly sprintf() by snprintf() is already on my TODO list.
harddog_user.c is not the only user.

> Besides, the code does look fishy to me:
> 
>     char pid_buf[sizeof("nnnnn\0")];
>     sprintf(pid_buf, "%d", os_getpid());
> 
> os_getpid() returns int:
> 
>     int os_getpid(void)
>     {
>             return syscall(__NR_getpid);
>     }
> 
> but sys_getpid() returns long.
> 
> So we truncate a (possibly 64-bit number) to 32-bit, and format it
> in a buffer that has space for 5 chars only...

True, the code assumes quite short pid numbers.
Thanks for pointing this out!

The sizeof("nnnnn\0") notation is very error-prone, UML is riddled with it.
It's time to get rid of it.

Thanks,
//richard
