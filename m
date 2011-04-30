Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636Ab1D3AYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:24:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43098 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745Ab1D3AYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:24:31 -0400
Subject: Re: [tip:timers/core] time: Add timekeeping_inject_sleeptime
From: John Stultz <john.stultz@linaro.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <BANLkTin12hcs1Q=4E4REdF_-zn08EJXzvw@mail.gmail.com>
References: <tip-304529b1b6f8612ccbb4582e997051b48b94f4a4@git.kernel.org>
	 <BANLkTin12hcs1Q=4E4REdF_-zn08EJXzvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 17:24:21 -0700
Message-ID: <1304123061.30215.38.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 16:28 -0700, Arve Hjønnevåg wrote:
> On Fri, Apr 29, 2011 at 10:31 AM, tip-bot for John Stultz
> > @@ -85,15 +82,13 @@ static int rtc_resume(struct device *dev)
> >                        pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
> >                return 0;
> >        }
> > +       /* calculate the RTC time delta */
> > +       set_normalized_timespec(&time, newtime - oldtime, 0);
> >
> > -       /* restore wall clock using delta against this RTC;
> > -        * adjust again for avg 1/2 second RTC sampling error
> > -        */
> > -       set_normalized_timespec(&time,
> > -                               newtime + delta.tv_sec,
> > -                               (NSEC_PER_SEC >> 1) + delta.tv_nsec);
> > -       do_settimeofday(&time);
> > +       /* subtract kernel time between rtc_suspend to rtc_resume */
> > +       time = timespec_sub(time, timespec_sub(newts, oldts));
> 
> The delta you got from the rtc can be almost a second to long or
> short. Do you do anything to prevent these errors from accumulating?

Indeed. Right now we don't do anything.

I'm hoping to extend the RTC interface to provide finer resolution where
possible, but that won't help on hardware that really only gives us
seconds.

We could maybe not only track the suspend time but the RTC time deltas
for when the system is running as well and utilize those values to avoid
accumulating the error long term. But then there can be other
complications between the NTP corrected system time and the uncorrected
RTC time.

Other ideas? I know you've got a patch in the Android tree to try to
address this, should I try to adapt it for use here?

thanks
-john

