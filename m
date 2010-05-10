Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab0EJVjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:39:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756537Ab0EJVi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:38:57 -0400
Date: Mon, 10 May 2010 14:38:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpuidle: Add a repeating pattern detector to the
 menu governor
Message-Id: <20100510143850.fde16046.akpm@linux-foundation.org>
In-Reply-To: <20100509160444.260ca9c9@infradead.org>
References: <20100509160242.2e351e6a@infradead.org>
	<20100509160444.260ca9c9@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 May 2010 16:04:44 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> +static void detect_repeating_patterns(struct menu_device *data)
> +{
> +	int i;
> +	uint64_t avg = 0;
> +	uint64_t stddev = 0; /* contains the square of the std deviation */
> +
> +	/* first calculate average and standard deviation of the past */
> +	for (i = 0; i < INTERVALS; i++)
> +		avg += data->intervals[i];
> +
> +	/* if the avg is beyond the known next tick, it's worthless */
> +	if (avg > data->expected_us)
> +		return;
> +
> +	avg = avg / INTERVALS;
> +	for (i = 0; i < INTERVALS; i++)
> +		stddev += (data->intervals[i] - avg) *
> +			  (data->intervals[i] - avg);
> +
> +	stddev = stddev / INTERVALS;
> +
> +	/*
> +	 * now.. if stddev is small.. then assume we have a
> +	 * repeating pattern and predict we keep doing this.
> +	 */
> +
> +	if (avg && stddev < STDDEV_THRESH)
> +		data->predicted_us = avg;
> +}

You got lucky there, because INTERVALS is a power of two.  If someone
changes INTERVALS to 7, this code will ask for __udivdi3 and won't link
on i364.
