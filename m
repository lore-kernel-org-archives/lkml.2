Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab1H3TQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:16:12 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:37258
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab1H3TP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:15:28 -0400
Message-ID: <4E5D36C7.5020706@kernel.dk>
Date: Tue, 30 Aug 2011 13:15:19 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] block: introduce __bio_endio()
References: <1314589660-2918-1-git-send-email-namhyung@gmail.com> <1314589660-2918-3-git-send-email-namhyung@gmail.com>
In-Reply-To: <1314589660-2918-3-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-28 21:47, Namhyung Kim wrote:
> Currently, bio_endio() lacks its completion tracepoint in it,
> so that the bio-based devices - except DM which inserted the
> tracepoint explicitly - cannot send us such an event when using
> blktrace. Adding the tracepoint in the function will fix this.
> 
> However, bio_endio() is also used for other ways like some
> nested bio-handling path and request-based devices. Simply
> adding will result in duplicated event for those cases. Thus
> add new __bio_endio() function to do things as before but no
> tracepoint. Similarly, __bio_io_error() helper was added too.

Not crazy about this solution, it seems a little fragile. And it's hard
to know what the difference between bio_endio() and __bio_endio() is
without looking at the code.

I think it would be cleaner to mark a bio as going inflight, so that we
can check this flag on completion. If it's never been in flight, don't
trigger a completion event trace for it.

-- 
Jens Axboe

