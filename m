Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0KLBbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 20:31:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:59959 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab0KLBbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 20:31:44 -0500
Date: Fri, 12 Nov 2010 01:31:27 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [RFC-PATCH] clocksource: update lpj if clocksource has been
 changed.
To: john stultz <johnstul@us.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Magnus Damm <damm@opensource.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20101112012108785@myungjoo.ham
Msgkey: 20101112012108785@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20101112012108785@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <6129485.11361289525487170.JavaMail.weblogic@epml16>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAC1Vslu007612

On Fri, 2010-11-12 at 09:23 AM, john stultz wrote:
> On Fri, 2010-11-12 at 08:58 +0900, MyungJoo Ham wrote:
> > On Fri, Nov 12, 2010 at 5:02 AM, john stultz wrote:
> > > On Thu, 2010-11-11 at 17:36 +0900, MyungJoo Ham wrote:
> > >> With a clocksource change, loops_per_jiffy may have been changed; thus,
> > >> the loops_per_jiffy in each cpu should be updated. Especially after some
> > >> of the cpus were turned off and on, their loops_per_jiffy values are
> > >> updated while the cpus kept on are not. Therefore, in order to make them
> > >> "normalized equally", we need to let the loops_per_jiffy values of
> > >> different cpus be based on the same clocksource.
> > >>
> > >> Signed-off-by: MyungJoo Ham 
> > >> Signed-off-by: Kyungmin Park 
> > >
> > > First, Thanks for reporting the issue and submitting the patch!
> > >
> > > So the premise is that read_current_timer -> get_cycles ->
> > > clocksource_read on some arches. And then when we select a different
> > > clocksource for timekeeping, this also changes the get_cycles source
> > > breaking delay loops.
> > >
> > > The clocksource selected for timekeeping and the counter being used for
> > > get_cycles really shouldn't be explicitly bound. On most systems I don't
> > > think that is the case, so this patch would force needless recalibration
> > > calls on clocksource changes.
> > >
> > > Which arch specifically are you seeing the issue on? I suspect there is
> > > be a better way to fix this.
> > >
> > > thanks
> > > -john
> > 
> > We are working on ARM/S5PC210 with two cores. Actually, in single core
> > systems, clocksource changes that affect loops-per-jiffy do not matter
> > much as in multi-core systems because we do not have something to
> > compare with in such a system. This patch adds some overheads on
> > changing system clocksources; however, is happens only once at boot.
> 
> Well, clocksource changes can happen any time a system is running.
> 
> Looking through the 2.6.37-rc arm code, I'm not seeing any counter based
> delay implementation. I only see the loop based implementation in
> arm/lib/delay.S. Additionally, I don't see ARCH_HAS_READ_CURRENT_TIMER
> or a get_cycles implementation that uses the clocksource.
> 
> Have implemented a non-loop based delay for your platform? Or could you
> more clearly explain how the clocksource being used for timekeeping
> effects the delay function on your hardware?
> 

Ah.. I'm not concerned with delay functions in this clocksource recalibration issue. The delay function has been working just fine. The issue affects the consistency of "BogoMIPS" values when we try "# cat /proc/cpuinfo", which is based on loops_per_jiffy stroed at cpu_data of each core. The cpu-on/off function recalibrates loops_per_jiffy for the cpu that was turned off and on. In a situation where part of cpus were turned off and on after the clocksource has been changed, the bogomips values have inconsistency between cpus. So, I'm not concerned with the delay function, which has been working fine before and after the patch, but with the consistency of loops_per_jiffy values in different cpus/cores.

> 
> > Or, would it be better if we add another entry to struct clocksource;
> > i.e., "bool recalibrate" in struct clocksource? Then, we can put
> > recalibration routine in clocksource_select() at the end of the
> > function deciding whether to recalibrate based on the
> > "base->recalibrate" value. How about this?
> 
> No, I don't think adding more to the clocksource is the right fix here. 
> 
> In my view, the correct solution should be to separate the get_cycles or
> read_current_timer implementation (if that is the culprit) so it is not
> dependent on the clocksource that the timekeeping code is currently
> using.
> 
> That way, changes to the time keeping clocksource won't affect the delay
> function, and the re-calibration will be unnecessary.
> 
> thanks
> -john
> 
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
