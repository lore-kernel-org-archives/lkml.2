Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936841Ab0COVVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:21:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936780Ab0COVVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:21:12 -0400
Date: Mon, 15 Mar 2010 14:20:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: rtc-linux@googlegroups.com, Miguel Aguilar <miguel.aguilar@ridgerun.com>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Samuel Ortiz <sameo@linux.intel.com>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: DaVinci RTC driver
Message-Id: <20100315142024.afa998d9.akpm@linux-foundation.org>
In-Reply-To: <1268420914-6731-1-git-send-email-khilman@deeprootsystems.com>
References: <1268420914-6731-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 11:08:33 -0800
Kevin Hilman <khilman@deeprootsystems.com> wrote:

> +static int convertfromdays(u16 days, struct rtc_time *tm)
> +{
> +	int tmp_days, year, mon;
> +
> +	for (year = 2000;; year++) {
> +		tmp_days = rtc_year_days(1, 12, year);
> +		if (days >= tmp_days)
> +			days -= tmp_days;
> +		else {
> +			for (mon = 0;; mon++) {
> +				tmp_days = rtc_month_days(mon, year);
> +				if (days >= tmp_days) {
> +					days -= tmp_days;
> +				} else {
> +					tm->tm_year = year - 1900;
> +					tm->tm_mon = mon;
> +					tm->tm_mday = days + 1;
> +					break;
> +				}
> +			}
> +			break;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int convert2days(u16 *days, struct rtc_time *tm)
> +{
> +	int i;
> +	*days = 0;
> +
> +	/* epoch == 1900 */
> +	if (tm->tm_year < 100 || tm->tm_year > 199)
> +		return -EINVAL;
> +
> +	for (i = 2000; i < 1900 + tm->tm_year; i++)
> +		*days += rtc_year_days(1, 12, i);
> +
> +	*days += rtc_year_days(tm->tm_mday, tm->tm_mon, 1900 + tm->tm_year);
> +
> +	return 0;
> +}

I'm looking suspiciously at these (slow-looking) functions.  Are they
really specific to this device, or could we be making better use of
library code, or adding functionality to library code?

