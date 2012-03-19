Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab2CSN0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:26:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40554 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2CSN0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:26:34 -0400
Date: Mon, 19 Mar 2012 13:26:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
Message-ID: <20120319132623.GO15988@n2100.arm.linux.org.uk>
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com> <20120319130445.GN15988@n2100.arm.linux.org.uk> <CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 06:49:34PM +0530, Ajeet Yadav wrote:
> On Mon, Mar 19, 2012 at 6:34 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Mar 19, 2012 at 06:31:44PM +0530, Ajeet Yadav wrote:
> >> Hi John, refering to you patch:
> >>
> >> ARM: remove 'select GENERIC_TIME'
> >> GENERIC_TIME is now enabled by default, so 'select GENERIC_TIME' is
> >> redundant.  Remove them.
> >>
> >> The following config's are not selectable:
> >> config NO_HZ, config HIGH_RES_TIMERS, config IRQSOFF_TRACER, config
> >> PREEMPT_TRACER
> >>
> >> As far as I know, ARM now uses GENERIC_TIME via the arch_getoffset()
> >> infrastructure, i.e ARCH_USES_GETTIMEOFFSET=y
> >
> > No.  It is possible to select these options, but only if your platform
> > uses the clockevent and clocksource infrastructure.  If you're using that,
> > then you must _not_ select ARCH_USES_GETTIMEOFFSET.
> >
> > ARCH_USES_GETTIMEOFFSET is for compatibility with old unconverted
> > platforms, which are _not_ possible to use the above features.
> 
> Just before the patch "time: Kill off CONFIG_GENERIC_TIME" Generic
> time was selectable option,

CONFIG_GENERIC_TIME was always set to 'y' on ARM (and everything else)
before that commit.  As the option is always set, there's no point it
existing.  So it was removed, and all the code paths associated with
it became unconditional.

Yes, there are places where GENERIC_TIME was subsituted with
!ARCH_USES_GETTIMEOFFSET.  (John will know the details.)

> Therefore our target configuration with 2.6 kernel was
> GENERIC_CLOCKEVENTS=y, ARCH_USES_GETTIMEOFFSET=y,

It's absolutely absurd to have a platform converted to use clockevents
and clocksources, and then select ARCH_USES_GETTIMEOFFSET.  That's saying
"I provide the new infrastructure, but I want the dodgy old compatibility
which doesn't work properly with a set of other features as well".

> I conclude that GENERIC_CLOCKEVENTS is supported, hence I must set
> ARCH_USES_GETTIMEOFFSET=n, in order to use NO_HZ, HIGH_RES_TIMERS,
> IRQSOFF_TRACER, PREEMPT_TRACER

Correct.  If you're using clockevents and clocksources, you should not
select ARCH_USES_GETTIMEOFFSET.
