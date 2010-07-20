Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab0GTJFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 05:05:22 -0400
Received: from smtp.nokia.com ([192.100.122.230]:17887 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316Ab0GTJFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 05:05:20 -0400
Subject: Re: [RFC][PATCH 04/16] writeback: fix possible race when shutting
 down bdi
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100718064720.GD23811@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
	 <1279284312-2411-5-git-send-email-dedekind1@gmail.com>
	 <20100718064720.GD23811@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 11:58:21 +0300
Message-ID: <1279616301.16462.92.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 Jul 2010 09:04:41.0690 (UTC) FILETIME=[96DA23A0:01CB27EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-18 at 02:47 -0400, Christoph Hellwig wrote:
> On Fri, Jul 16, 2010 at 03:45:00PM +0300, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > 
> > Current bdi code has the following race between 'bdi_wb_shutdown()'
> > and 'bdi_forker_thread()'.
> > 
> > Initial condition: BDI_pending is cleaned, bdi has no writeback thread,
> > because it was inactive and exited, 'bdi_wb_shutdown()' and
> > 'bdi_forker_thread()' are executed concurrently.
> 
> Wouldn't it be better to have a per-bdi mutex to serialize thread
> creation and shutdown?

There are several parties which want to have some serialization with bdi
trheads creation and shutdown:

1. 'bdi_queue_work()' - this should not take any mutex and should be
   fast. It uses spinlock and this is should stay this way

2. I'm going to modify '__mark_inode_dirty()' to wake-up bdi thread -
   this is similar to 'bdi_queue_work()'

3. 'bdi_wb_shutdown()' - this uses the 'BDI_pending' for serialization
   now, but can use a mutex instead.

I guess you mean that for 1 and 2 things stay the same, but for 3 we can
use a mutex. Then the forker thread should also take this mutex. Right?

If yes, this looks fine for me. I am going to try this approach. Then
-->

>   And please also kill the bit wait in favour
> of a proper wait queue - the bit wait interface really is just a hack
> for structures that are very size sensitive, which the backing device
> is not.

--> the bit should go away and so no wait queue will be needed as well. 

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

