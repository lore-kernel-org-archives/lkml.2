Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0KXLFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:05:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:41692 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab0KXLFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:05:37 -0500
Subject: Re: [PATCH 06/13] writeback: bdi write bandwidth estimation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Li Shaohua <shaohua.li@intel.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101117042850.002299964@intel.com>
References: <20101117042720.033773013@intel.com>
	 <20101117042850.002299964@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 12:05:32 +0100
Message-ID: <1290596732.2072.450.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 12:27 +0800, Wu Fengguang wrote:
> +void bdi_update_write_bandwidth(struct backing_dev_info *bdi,
> +                               unsigned long *bw_time,
> +                               s64 *bw_written)
> +{
> +       unsigned long written;
> +       unsigned long elapsed;
> +       unsigned long bw;
> +       unsigned long w;
> +
> +       if (*bw_written == 0)
> +               goto snapshot;
> +
> +       elapsed = jiffies - *bw_time;
> +       if (elapsed < HZ/100)
> +               return;
> +
> +       /*
> +        * When there lots of tasks throttled in balance_dirty_pages(), they
> +        * will each try to update the bandwidth for the same period, making
> +        * the bandwidth drift much faster than the desired rate (as in the
> +        * single dirtier case). So do some rate limiting.
> +        */
> +       if (jiffies - bdi->write_bandwidth_update_time < elapsed)
> +               goto snapshot;

Why this goto snapshot and not simply return? This is the second call
(bdi_update_bandwidth equivalent).

If you were to leave the old bw_written/bw_time in place the next loop
around in wb_writeback() would see a larger delta..

I guess this funny loop in wb_writeback() is also the reason you've got
a single function and not the get/update like separation

> +       written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]) - *bw_written;
> +       bw = (HZ * PAGE_CACHE_SIZE * written + elapsed/2) / elapsed;
> +       w = min(elapsed / (HZ/100), 128UL);
> +       bdi->write_bandwidth = (bdi->write_bandwidth * (1024-w) + bw * w) >> 10;
> +       bdi->write_bandwidth_update_time = jiffies;
> +snapshot:
> +       *bw_written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]);
> +       *bw_time = jiffies;
> +} 
