Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0H3QU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:20:27 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:26505 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755866Ab0H3QU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:20:26 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: HYbMW3gVM1nPGcGatgDC0CDqJZiqD6iPYcRZAUXqfWOFNAD
 4lSzY0od0jQmqJ7JO7iWjLpSCRWAFFP4DcHpcMefeShTnN.P4O7Q30A1EKAF
 MECFZE1.k_gsIYKsBDlu_ivr36yLlPqlMLWB1bAYm5LS0isZSCZThQaUTqUr
 FRfRwx4_0HnkklS7vfhzTZKPEe81.CeqM2hkpkQyNS.GvZ1x8hBQmbn_usHU
 JXVBibEZnSIkAa4Nvj28se5Lck7_9
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 30 Aug 2010 11:20:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Nitin Gupta <ngupta@vflare.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] Use percpu stats
In-Reply-To: <1281374816-904-4-git-send-email-ngupta@vflare.org>
Message-ID: <alpine.DEB.2.00.1008301114460.10316@router.home>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org> <1281374816-904-4-git-send-email-ngupta@vflare.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Aug 2010, Nitin Gupta wrote:

> -static void zram_stat_inc(u32 *v)
> +static void zram_add_stat(struct zram *zram,
> +			enum zram_stats_index idx, s64 val)
>  {
> -	*v = *v + 1;
> +	struct zram_stats_cpu *stats;
> +
> +	preempt_disable();
> +	stats = __this_cpu_ptr(zram->stats);
> +	u64_stats_update_begin(&stats->syncp);
> +	stats->count[idx] += val;
> +	u64_stats_update_end(&stats->syncp);
> +	preempt_enable();

Maybe do

#define zram_add_stat(zram, index, val)
		this_cpu_add(zram->stats->count[index], val)

instead? It creates an add in a single "atomic" per cpu instruction and
deals with the fallback scenarios for processors that cannot handle 64
bit adds.

