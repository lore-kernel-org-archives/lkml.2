Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1IEPD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:03:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:41335 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab1IEPD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:03:26 -0400
Subject: Re: [PATCH 02/18] writeback: dirty position control
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 05 Sep 2011 17:02:59 +0200
In-Reply-To: <20110904020914.848566742@intel.com>
References: <20110904015305.367445271@intel.com>
	 <20110904020914.848566742@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315234979.3191.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> + * (o) bdi control lines
> + *
> + * The control lines for the global/bdi setpoints both stretch up to @limit.
> + * The below figure illustrates the main bdi control line with an auxiliary
> + * line extending it to @limit.
> + *
> + *   o
> + *     o
> + *       o                                      [o] main control line
> + *         o                                    [*] auxiliary control line
> + *           o
> + *             o
> + *               o
> + *                 o
> + *                   o
> + *                     o
> + *                       o--------------------- balance point, rate scale = 1
> + *                       | o
> + *                       |   o
> + *                       |     o
> + *                       |       o
> + *                       |         o
> + *                       |           o
> + *                       |             o------- connect point, rate scale = 1/2
> + *                       |               .*
> + *                       |                 .   *
> + *                       |                   .      *
> + *                       |                     .         *
> + *                       |                       .           *
> + *                       |                         .              *
> + *                       |                           .                 *
> + *  [--------------------+-----------------------------.--------------------*]
> + *  0              bdi_setpoint                    x_intercept           limit
> + *
> + * The auxiliary control line allows smoothly throttling bdi_dirty down to
> + * normal if it starts high in situations like
> + * - start writing to a slow SD card and a fast disk at the same time. The SD
> + *   card's bdi_dirty may rush to many times higher than bdi_setpoint.
> + * - the bdi dirty thresh drops quickly due to change of JBOD workload 

In light of the global control thing already having a hard stop at
limit, what's the point of the auxiliary line? Why not simply run the
bdi control between [0.5, 1.5] and leave it at that?
