Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0ESTvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:51:47 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:45963 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab0ESTvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:51:45 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz98dN936eMzz1202hzzz2fh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4BF44156.2070807@am.sony.com>
Date: Wed, 19 May 2010 12:51:50 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] cpuidle: Add a repeating pattern detector to the
 menu governor
References: <20100509160242.2e351e6a@infradead.org> <20100509160444.260ca9c9@infradead.org>
In-Reply-To: <20100509160444.260ca9c9@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aplogies if this is a duplicate, my outgoing email seems to have not
been working.

On 05/09/10 16:04, Arjan van de Ven wrote:

> +/*
> + * Try detecting repeating patterns by keeping track of the last 8
> + * intervals, and checking if the standard deviation of that set
> + * of points is below a threshold. If it is... then use the
> + * average of these 8 points as the estimated value.
> + */
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

Should the following division by INTERVALS be moved up 6 lines to before
"if (avg > data->expected_us)"?

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


