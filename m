Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab1E0Kn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 06:43:59 -0400
Received: from service87.mimecast.com ([94.185.240.25]:38574 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758831Ab1E0Kn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 06:43:58 -0400
Subject: Re: [PATCH 0/4] ARM: smp_twd: mpcore_wdt: Fix MPCORE watchdog setup
From: Marc Zyngier <Marc.Zyngier@arm.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: vkuzmichev@mvista.com, linux@arm.linux.org.uk,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110527082640.GC16394@infomag.iguana.be>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
	 <20110527082640.GC16394@infomag.iguana.be>
Organization: ARM Ltd
Date: Fri, 27 May 2011 11:44:38 +0100
Message-ID: <1306493078.27474.269.camel@e102391-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
X-OriginalArrivalTime: 27 May 2011 10:44:04.0484 (UTC) FILETIME=[FF6C8C40:01CC1C5A]
X-MC-Unique: 111052711435304801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 10:26 +0200, Wim Van Sebroeck wrote:
> Hi Vitaly,
> 
> > From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
> > 
> > The series of patches fixes various bugs in ARM MPCORE watchdog setup.
> > They also introduce some changes in common SMP_TWD timer setup code.
> > The PATCH 1/4 adds an exported function to obtain calibrated timer rate
> > in mpcore_wdt. However, this solution might be unacceptable, so we may
> > discuss another 2 variants:
> >  1) use clock framework
> >    This may require to fix all MPCORE boards clock implementations.
> >  2) copy calibration loop to mpcore_wdt
> >    However, this increases boot time.
> > 
> > 
> > Vitaly Kuzmichev (4):
> >   ARM: smp_twd: mpcore_wdt: Fix watchdog counter loading
> >   ARM: smp_twd: Fix typo in twd_timer_rate printout
> >   ARM: mpcore_wdt: Fix WDIOC_SETOPTIONS handling
> >   ARM: mpcore_wdt: Fix timer mode setup
> > 
> >  arch/arm/include/asm/smp_twd.h |    7 +++++++
> >  arch/arm/kernel/smp_twd.c      |    8 +++++++-
> >  drivers/watchdog/mpcore_wdt.c  |   29 +++++++++++++++++++++--------
> >  3 files changed, 35 insertions(+), 9 deletions(-)
> 
> What's the status on this? I don't recall having seen any answers from ARM community.

Overall, I'm not too happy about patch #1. Exposing some "random"
internal state of the timer doesn't seem the right thing to me.

Furthermore, the internal rate of the TWD changes with the CPU
frequency. Blindly trusting the calibrated value at boot time is a nice
way to see the watchdog kicking in unexpectedly when frequency is
increased.

I suggest you have a look at this patch:
https://patchwork.kernel.org/patch/801472/

Together with a cpufreq notifier, this "smp_twd" clock looks like a much
better option. Over time, all platform would be converted to that
particular clock, and the problem would be solved in a much nicer way.

Cheers,

	M.
-- 
Reality is an implementation detail.


