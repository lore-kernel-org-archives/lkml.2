Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab0KOXuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:50:17 -0500
Received: from bld-mail20.adl6.internode.on.net ([150.101.137.105]:46481 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751944Ab0KOXuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:50:16 -0500
Date: Tue, 16 Nov 2010 10:49:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: "J.H." <warthog9@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jaxboe@fusionio.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: More XFS resource starvation?
Message-ID: <20101115234940.GE22876@dastard>
References: <4CE17C4E.7010206@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE17C4E.7010206@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 10:30:38AM -0800, J.H. wrote:
> So apparently I'm having fun tripping over all kinds of bugs lately.
> I've seen this a couple of times now on the box in question.  Usually
> happens after a few days, or after particularly heavy rsync traffic on
> the box.
> 
> http://pastebin.osuosl.org/36014
> 
> Christoph seemed to think it's a memory exhaustion problem, so I've
> included the /proc/meminfo and as you can see there's plenty of memory
> around on the system.

That looks very much like some IOs have not been completed and XFS
is waiting around for them to complete. Both the xfsbufd and the
flush daemons are stuck in get_request_wait(), which implies that
the request queue is full and not being serviced. Various rsync process
is stuck waiting for log buffer completion, waiting for buffer reads
to complete, etc, which implies that IO is simply not being completed.

My experience with such hangs is that they are typically caused by a
storage problem (e.g. lost interrupt, IO not completed, controller
firmware problem, etc).

> Loads have, expectedly, climbed currently around 1250.05 but growing slowly.
> 
> Quick overview of the underlying storage:
> 
> xfs -> md (raid 0) -+--> P812 hardware raid6 (cciss driver)
>                     |
>                     +--> P812 hardware raid6 (cciss driver)
> 
> This is running on an HP DL380 G7.
> 
> I saw this both on an older 2.6.30.10-105.2.23.fc11.x86_64, and
> currently on 2.6.34.7-61.fc13.x86_64 (both being Fedora stock kernels)
> 
> I have not seen this on a very similar DL380 G6, with the same storage
> setup and it is currently running the 2.6.30 kernel from above.
> 
> Christoph suggest increasing the nr_request values for each of the
> underlying devices, but this didn't seem to change anything
> significantly on the system.
> 
> Anyone have any ideas on what's going on?

Any other information in the log (e.g. from the cciss driver)? Are
the raid controllers all running the latest (and same) firmware? I'd
be wanting to make sure that all the storage below the filesystem is
working correctly before looking at anything filesystem related...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
