Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1HIRC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:02:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43671 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab1HIRCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:02:25 -0400
Subject: Re: [PATCH 3/5] writeback: dirty rate control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 09 Aug 2011 19:02:02 +0200
In-Reply-To: <20110806094526.878435971@intel.com>
References: <20110806084447.388624428@intel.com>
	 <20110806094526.878435971@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312909322.1083.52.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-06 at 16:44 +0800, Wu Fengguang wrote:

> +       pos_bw = bw * pos_ratio >> BANDWIDTH_CALC_SHIFT;
> +       pos_bw++;  /* this avoids bdi->dirty_ratelimit get stuck in 0 */
> +

> +       pos_ratio *= bdi->avg_write_bandwidth;
> +       do_div(pos_ratio, dirty_bw | 1);
> +       ref_bw = bw * pos_ratio >> BANDWIDTH_CALC_SHIFT; 

when written out that results in:

           bw * pos_ratio * bdi->avg_write_bandwidth
  ref_bw = -----------------------------------------
                         dirty_bw

which would suggest you write it like:

  ref_bw = div_u64((u64)pos_bw * bdi->avg_write_bandwidth, dirty_bw | 1);

since pos_bw is already bw * pos_ratio per the above.

Or am I missing something?
