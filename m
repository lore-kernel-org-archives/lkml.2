Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1BAShl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:37:41 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36692 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab1BAShk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:37:40 -0500
Subject: Re: [PATCH 1/2] hrtimers: extend hrtimer base code to handle more
 then 2 clockids
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
        Alexander Shishkin <virtuoso@slind.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <alpine.LFD.2.00.1102011505540.31804@localhost6.localdomain6>
References: <1296531837-12879-1-git-send-email-john.stultz@linaro.org>
	 <1296531837-12879-2-git-send-email-john.stultz@linaro.org>
	 <alpine.LFD.2.00.1102011505540.31804@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 10:37:28 -0800
Message-ID: <1296585448.3336.16.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 15:10 +0100, Thomas Gleixner wrote:
> On Mon, 31 Jan 2011, John Stultz wrote:
> > @@ -53,11 +53,10 @@
> >  /*
> >   * The timer bases:
> >   *
> > - * Note: If we want to add new timer bases, we have to skip the two
> > - * clock ids captured by the cpu-timers. We do this by holding empty
> > - * entries rather than doing math adjustment of the clock ids.
> > - * This ensures that we capture erroneous accesses to these clock ids
> > - * rather than moving them into the range of valid clock id's.
> > + * There are more clockids then hrtimer bases. Thus, we index
> 
> s/then/than/

Thenks! ;)

> > + * into the timer bases by the hrtimer_base_type enum. When trying
> > + * to reach a base using a clockid, hrtimer_clockid_to_base()
> > + * is used to convert from clockid to the proper hrtimer_base_type.
> >   */
> >  DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
> >  {
> > @@ -77,6 +76,24 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
> >  	}
> >  };
> >  
> > +static int hrtimer_clock_to_base_table[MAX_CLOCKS];
> > +
> > +static inline int hrtimer_clockid_to_base(clockid_t clock_id)
> > +{
> > +	int ret = hrtimer_clock_to_base_table[clock_id];
> > +
> > +	if(ret == -1) {
> > +		WARN_ON(1);
> > +		/* We just hit an invalid clock base,
> > +		 * but returning -1 isn't safe, so
> > +		 * return the _REALTIME base
> > +		 */
> 
>   How can this happen ?

It can't right now. I'm just worried someone will try to put a clockid
that doesn't have an hrtimer base into that function sometime in the
future. We can wrap it in a debug config maybe?

thanks
-john


