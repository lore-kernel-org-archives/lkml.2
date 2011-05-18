Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1ERUCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:02:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37040 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab1ERUCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:02:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 1/3] PM: Introduce DEVFREQ: generic DVFS framework with device-specific OPPs
Date: Wed, 18 May 2011 22:02:46 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Mark Brown <broonie@sirena.org.uk>, Jiejing Zhang <kzjeef@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com> <201105180036.03836.rjw@sisk.pl> <BANLkTi=_1DJPS+6goLA-UvdHJXEoPWBF2w@mail.gmail.com>
In-Reply-To: <BANLkTi=_1DJPS+6goLA-UvdHJXEoPWBF2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105182202.46820.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 18, 2011, MyungJoo Ham wrote:
> 2011/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> > Hi,

Hi,

... 
> >
> >> +}
> >> +
> >> +#define dev_dbg_once(dev, fmt, ...)                          \
> >> +     if (!once) {                                            \
> >> +             once = 1;                                       \
> >> +             dev_dbg(dev, pr_fmt(fmt), ##__VA_ARGS__);       \
> >> +     }
> >
> > Why do you need this?
> >
> 
> This devfreq_do is going to be called periodically; thus, I want to
> print a message if there is an error, but not too many messages with
> the repeated calls.
> 
> Besides, I'd change the macro like this:
> 
> #define dev_dbg_once(dev, fmt, ...)                          \
>      {                                                                \
>              static int once;                                   \
>              if (!once) {                                            \
>                      once = 1;                                       \
>                      dev_dbg(dev, pr_fmt(fmt), ##__VA_ARGS__);       \
>              }                                                 \
>      }
> 
> so that "static int once;" in functions can be removed.

That's a good change in my opinion, but since there is the dynamic debug
feature, I don't think you need to worry too much about that (the user
can always disable output from those dev_dbg() statements if they generate
too much noise).

...
> >> +     list_for_each_entry(devfreq, &devfreq_list, node) {
> >> +             if (devfreq->next_polling == 0)
> >> +                     continue;
> >> +
> >> +             reserved++;
> >
> > Why is the variable called 'reserved'?
> 
> The variable reserves the next devfreq_monitor call. If there is no
> one reserves, we stop monitoring.

So I'd call it 'continue_polling' or something like this.

> However, I've found a bug in this routine (not affecting "reserved++"
> directly though) that a tickled device without polling governor may
> not return to its original frequency. It is easily addressed by adding
> one more condition to the if statement before reserved++;. I'll fix
> that in the next revision.

OK

> >
> >> +
> >> +             if (devfreq->tickle) {
> >> +                     devfreq->tickle--;
> >> +                     continue;
> >> +             }
> >
> > I'd put a coment above that explaining what's going on here.
> 
> Ok.
> 
> >
> >> +             if (devfreq->next_polling == 1) {
> >> +                     error = devfreq_do(devfreq);
> >> +                     if (error && !once) {
> >> +                             once = 1;
> >> +                             dev_err(devfreq->dev, "devfreq_do error(%d)\n",
> >> +                                     error);
> >
> > Hmm.  I'm not sure, but wouldn't it make sense to drop the device from
> > the list if devfreq_do() returns error code?
> 
> Umm... yeah.. that option (calling devfreq_remove_device() for errors)
> is also possible, which will also remove the need for the macro you've
> mentioned.

Yes.

> However, when the error is temporary or the device has blocked
> changing frequencies temporarily from target callback or governor, it
> could be not so desirable.

I guess we need some experience here.  Namely, it's difficult to say
what's going to be more frequent, devices that have temporary failures
or such that either work or not work at all.

That said, I think the simpler approach is to drop devices from the list
on errors (perhaps depending on the type of the error).

> So, I'm considering to call devfreq_remove_device() at error if the
> error is not "EAGAIN". That will also remove the need for the macro
> and debug messages above. How about that?

Sounds reasonable.

...
> >> @@ -225,3 +225,28 @@ config PM_OPP
> >>         representing individual voltage domains and provides SOC
> >>         implementations a ready to use framework to manage OPPs.
> >>         For more information, read <file:Documentation/power/opp.txt>
> >> +
> >> +config PM_DEVFREQ
> >> +     bool "Generic Dynamic Voltage and Frequency Scaling (DVFS) Framework"
> >> +     depends on PM_OPP
> >
> > This assumes the user will know if his/her platform uses that code.
> > It may be a good idea to make it depend on a user-invisible option that
> > can be selected by the platform.
> 
> I think that like CPUFREQ, users will want to enable and disable
> DEVFREQ feature by choice although they cannot choose the governor
> directly. I'm also considering to allow users to set governors
> forcibly and globally at menuconfig (like CPUFREQ does). With CPUFREQ,
> such options helped a lot in troubleshooting of CPU related issues.
> 
> Do you think it'd be better to have DEVFREQ enabled unconditionally
> (if PM_OPP is available) nonetheless?

First off, it doesn't make sense to enable it if the platform is not going to
use it.  That's why I think it should depend on a platform-selected option.
Only if that option is set the user should be given the choice to select
DEVFREQ.

Second, I'm not sure if that's a good idea to force DEVFREQ is the platform
is going to use it.  Perhaps in the future if there are no major issues with
it, we can do that.

Thanks,
Rafael
