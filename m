Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab1KQUdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:33:12 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54318 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab1KQUdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:33:11 -0500
Message-ID: <1321561946.25715.16.camel@work-vm>
Subject: Re: CPU hyperthreading turned on after soft power-cycle
From: John Stultz <john.stultz@linaro.org>
To: Clarinet <clarinet@atlas.cz>
Cc: 647095@bugs.debian.org, Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Date: Thu, 17 Nov 2011 12:32:26 -0800
In-Reply-To: <4EC43DF7.4010902@atlas.cz>
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>
	 <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz>
	 <4EB92181.5030500@seznam.cz> <20111110015212.GB2399@elie.gateway.2wire.net>
	 <4EBD2825.6050806@atlas.cz> <4EC43DF7.4010902@atlas.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11111720-3270-0000-0000-000001D94748
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 23:49 +0100, Clarinet wrote:
> Hi all,
> 
> >> Result of bisecting: v2.6.38-rc1 exhibits the problem. v2.6.37 and
> >> many of the topic branches merged in the 2.6.38 merge window work ok.
> >> Some other topic branches do not boot at all.
> >>
> >> Jiri: if you have gitk installed, then "git bisect visualize" can help
> >> get a sense of what's in the middle of the regression range.
> >> "gitk --bisect --first-parent v2.6.37..v2.6.38-rc1" might be a good way
> >> to find mainline commits to test before finding a topic branch to delve
> >> into.
> >
> > I have been able to narrow the interval manually a little bit from the
> > "top" (the bad side) and I will go on from the bottom now. However,
> > there seems to be a large area where kernels are unbootable for me -
> > they mostly stop when init is called and I do not know why.
> 
> Finally! After another 50+ compilations a have it! It took some time as 
> first I had to find a reason why some revisions did not boot (almost 2/3 
> were unbootable and the first bad commit was among them). Having this 
> solved I have been able to bisect without "skipping". The result is 
> surprising (at least for me) - believe it or not, the first bad commit 
> is 6610e089 "RTC: Rework RTC code to use timerqueue for events" from 
> John Stultz (I am sending him a copy of this message).
> 
> I would never expect this would be a problem, but my understanding of 
> this commit is very limited, so I am certainly missing the point. 
> However, I have tried to compile 2.6.38 (which was "bad") with "Real 
> Time Clock" configuration option turned off and it behaves "normally" 
> then (= is "good").

Huh. That's *very* odd.  Is your system doing anything in-particular
with the RTC?  I don't have a clue right off, so probably the next step
is doing a bit of instrumentation to try to figure out where exactly we
trigger the behavior. Could you checkout commit 6610e089 and apply the
patch below to see if we can't narrow it down?

Could you also send your .config to me?

thanks
-john

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 5856167..d049344 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -497,13 +497,13 @@ static int cmos_procfs(struct device *dev, struct seq_file *seq)
 static const struct rtc_class_ops cmos_rtc_ops = {
 	.read_time		= cmos_read_time,
 	.set_time		= cmos_set_time,
-	.read_alarm		= cmos_read_alarm,
-	.set_alarm		= cmos_set_alarm,
-	.proc			= cmos_procfs,
-	.irq_set_freq		= cmos_irq_set_freq,
-	.irq_set_state		= cmos_irq_set_state,
-	.alarm_irq_enable	= cmos_alarm_irq_enable,
-	.update_irq_enable	= cmos_update_irq_enable,
+//	.read_alarm		= cmos_read_alarm,
+//	.set_alarm		= cmos_set_alarm,
+//	.proc			= cmos_procfs,
+//	.irq_set_freq		= cmos_irq_set_freq,
+//	.irq_set_state		= cmos_irq_set_state,
+//	.alarm_irq_enable	= cmos_alarm_irq_enable,
+//	.update_irq_enable	= cmos_update_irq_enable,
 };
 
 /*----------------------------------------------------------------*/



