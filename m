Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab0EUTnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 15:43:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154Ab0EUTnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 15:43:17 -0400
Date: Fri, 21 May 2010 12:43:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: frank.rowand@am.sony.com
Cc: Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuidle: Add a repeating pattern detector to the
 menu governor
Message-Id: <20100521124309.28e25866.akpm@linux-foundation.org>
In-Reply-To: <4BF44156.2070807@am.sony.com>
References: <20100509160242.2e351e6a@infradead.org>
	<20100509160444.260ca9c9@infradead.org>
	<4BF44156.2070807@am.sony.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 12:51:50 -0700
Frank Rowand <frank.rowand@am.sony.com> wrote:

> Aplogies if this is a duplicate, my outgoing email seems to have not
> been working.
> 
> On 05/09/10 16:04, Arjan van de Ven wrote:
> 
> > +/*
> > + * Try detecting repeating patterns by keeping track of the last 8
> > + * intervals, and checking if the standard deviation of that set
> > + * of points is below a threshold. If it is... then use the
> > + * average of these 8 points as the estimated value.
> > + */
> > +static void detect_repeating_patterns(struct menu_device *data)
> > +{
> > +	int i;
> > +	uint64_t avg = 0;
> > +	uint64_t stddev = 0; /* contains the square of the std deviation */
> > +
> > +	/* first calculate average and standard deviation of the past */
> > +	for (i = 0; i < INTERVALS; i++)
> > +		avg += data->intervals[i];
> > +
> > +	/* if the avg is beyond the known next tick, it's worthless */
> > +	if (avg > data->expected_us)
> > +		return;
> > +
> 
> Should the following division by INTERVALS be moved up 6 lines to before
> "if (avg > data->expected_us)"?

Quite possibly.

> > +	avg = avg / INTERVALS;
> > +	for (i = 0; i < INTERVALS; i++)
> > +		stddev += (data->intervals[i] - avg) *
> > +			  (data->intervals[i] - avg);
> > +
> > +	stddev = stddev / INTERVALS;
> > +
> > +	/*
> > +	 * now.. if stddev is small.. then assume we have a
> > +	 * repeating pattern and predict we keep doing this.
> > +	 */
> > +
> > +	if (avg && stddev < STDDEV_THRESH)
> > +		data->predicted_us = avg;
> > +}

wakey wakey, Arjan.


Also, expected_us is 32-bit and predicted_us is 64-bit.  Was that rational?
