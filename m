Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1AGISl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:18:41 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43904 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1AGISk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:18:40 -0500
Message-ID: <4D26CCEE.4070508@kernel.dk>
Date: Fri, 07 Jan 2011 09:21:02 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Yuehai Xu <yuehaixu@gmail.com>
CC: linux-kernel@vger.kernel.org, cmm@us.ibm.com, rwheeler@redhat.com,
        vgoyal@redhat.com, czoccolo@gmail.com, yhxu@wayne.edu
Subject: Re: Who does determine the number of requests that can be serving
  simultaneously in a storage?
References: <AANLkTimHE35jUOY6Lhd7OnATSD6BeB4poUosaQ+bR61i@mail.gmail.com>
In-Reply-To: <AANLkTimHE35jUOY6Lhd7OnATSD6BeB4poUosaQ+bR61i@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-07 04:21, Yuehai Xu wrote:
> Hi all,
> 
> We know that couples of requests can be serving simultaneously in a
> storage because of NCQ. My question is that who does determine the
> exact number of the servicing requests in HDD or SSD? Since the
> capability for different storages(hdd/ssd) to server multiple requests
> is different, how the OS know the exact number of requests that can be
> served simultaneously?
> 
> I fail to figure out the answer. I know the dispatch routine in I/O
> schedulers is elevator_dispatch_fn, which are invoked at two places.
> One is in __elv_next_request(), the other is elv_drain_elevator(). I
> fail to figure out the exact condition to trigger the routine of
> elv_drain_elevator(), from the source code, I know that it should
> dispatch all the requests in pending queue to "request_queue", from
> which the request is selected to dispatch into device driver.
> 
> For __elv_next_request(), it is actually invoked by
> blk_peek_reqeust(), which is invoked by blk_fetch_request(). From
> their comments, I know that only a request should be fetched from
> "request_queue" and this request should be dispatched into
> corresponding device driver. However, I notice that blk_fetch_request
> is invoked at a number of places, it fetches the requests endlessly
> with different stop condition. Which condition is the exact one that
> control the number of requests which can be served at the same time?
> The OS would of course not dispatch requests more than that the
> storage can serve, for example, for SSD, the number of multi requests
> serving simultaneously might be 32, while for HDD, the number is 4.
> But how the OS handle this?

The driver has to take care of this. Since requests are pulled by the
driver, it knows when to stop asking for more work.

BTW, your depth of 4 for the HDD seems a bit odd. Typically all SATA
drives share the same queue depth, limited by what NCQ provides (32).

-- 
Jens Axboe

