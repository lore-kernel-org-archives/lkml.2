Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab0EVFUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 01:20:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:40088 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab0EVFUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 01:20:11 -0400
Date: Fri, 21 May 2010 22:23:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: frank.rowand@am.sony.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuidle: Add a repeating pattern detector to the
 menu governor
Message-ID: <20100521222323.4799b1ca@infradead.org>
In-Reply-To: <20100521124309.28e25866.akpm@linux-foundation.org>
References: <20100509160242.2e351e6a@infradead.org>
	<20100509160444.260ca9c9@infradead.org>
	<4BF44156.2070807@am.sony.com>
	<20100521124309.28e25866.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 12:43:09 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 19 May 2010 12:51:50 -0700
> Frank Rowand <frank.rowand@am.sony.com> wrote:
> 
> > Aplogies if this is a duplicate, my outgoing email seems to have not
> > been working.
> > 
> > On 05/09/10 16:04, Arjan van de Ven wrote:
> > 
> > > +/*
> > > + * Try detecting repeating patterns by keeping track of the last
> > > 8
> > > + * intervals, and checking if the standard deviation of that set
> > > + * of points is below a threshold. If it is... then use the
> > > + * average of these 8 points as the estimated value.
> > > + */
> > > +static void detect_repeating_patterns(struct menu_device *data)
> > > +{
> > > +	int i;
> > > +	uint64_t avg = 0;
> > > +	uint64_t stddev = 0; /* contains the square of the std
> > > deviation */ +
> > > +	/* first calculate average and standard deviation of the
> > > past */
> > > +	for (i = 0; i < INTERVALS; i++)
> > > +		avg += data->intervals[i];
> > > +
> > > +	/* if the avg is beyond the known next tick, it's
> > > worthless */
> > > +	if (avg > data->expected_us)
> > > +		return;
> > > +
> > 
> > Should the following division by INTERVALS be moved up 6 lines to
> > before "if (avg > data->expected_us)"?
> 
> Quite possibly.

yeah that's a bug; I'll make a patch to fix it

> 
> > > +	avg = avg / INTERVALS;
> > > +	for (i = 0; i < INTERVALS; i++)
> > > +		stddev += (data->intervals[i] - avg) *
> > > +			  (data->intervals[i] - avg);
> > > +
> > > +	stddev = stddev / INTERVALS;
> > > +
> > > +	/*
> > > +	 * now.. if stddev is small.. then assume we have a
> > > +	 * repeating pattern and predict we keep doing this.
> > > +	 */
> > > +
> > > +	if (avg && stddev < STDDEV_THRESH)
> > > +		data->predicted_us = avg;
> > > +}
> 
> wakey wakey, Arjan.

sorry, seems this email got lost in 400 "Suspend block API" emails ;(


> 
> 
> Also, expected_us is 32-bit and predicted_us is 64-bit.  Was that
> rational?

predicted holds intermediate results of some calculations.. and those
overflow 32 bit...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
