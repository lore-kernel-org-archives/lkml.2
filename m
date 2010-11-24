Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0KXK6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:58:30 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40959 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0KXK63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:58:29 -0500
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
Date: Wed, 24 Nov 2010 11:58:22 +0100
Message-ID: <1290596302.2072.445.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 12:27 +0800, Wu Fengguang wrote:

> @@ -555,8 +592,10 @@ static void balance_dirty_pages(struct a
>  		pause = clamp_val(pause, 1, HZ/10);
>  
>  pause:
> +		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
>  		__set_current_state(TASK_INTERRUPTIBLE);
>  		io_schedule_timeout(pause);
> +		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
>  
>  		/*
>  		 * The bdi thresh is somehow "soft" limit derived from the

So its really a two part bandwidth calculation, the first call is:

  bdi_get_bandwidth()

and the second call is:

  bdi_update_bandwidth()

Would it make sense to actually implement it with two functions instead
of overloading the functionality of the one function?
