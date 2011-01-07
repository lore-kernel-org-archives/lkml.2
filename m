Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1AGFQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 00:16:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44797 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1AGFQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 00:16:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FFDtRSP8y7D+ljCwSfBWxhhCEoJgSI/JIzMv5qOFxMEvW+j5V/6JJq3+QfmmK2pp1M
         HLi6FT2eSmelzgzVqu6BLn1DU4lCPjSNgvdctGEN7tEwTMx+dDfHJegVuPawOvIb0g5g
         TffOwWz5E+Xw/foHAIq0IDUi7ODPQa/jHDM9Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTimHE35jUOY6Lhd7OnATSD6BeB4poUosaQ+bR61i@mail.gmail.com>
References: <AANLkTimHE35jUOY6Lhd7OnATSD6BeB4poUosaQ+bR61i@mail.gmail.com>
Date: Fri, 7 Jan 2011 00:16:31 -0500
Message-ID: <AANLkTikt2D2ijwZxSst0R5=nLzMwxHh8sbYd=h_bFk6v@mail.gmail.com>
Subject: Re: Who does determine the number of requests that can be serving
 simultaneously in a storage?
From: Yuehai Xu <yuehaixu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, cmm@us.ibm.com, rwheeler@redhat.com, vgoyal@redhat.com,
        czoccolo@gmail.com, yhxu@wayne.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I add a patch to kernel 2.6.35.7, in order to find out the number of
pending/serving requests regards to SSD, Intel_M. The benchmark I use
is postmark, access pattern is random small write. Below is the patch:

diff -Nur orig/block/blk-core.c new/block/blk-core.c
--- orig/block/blk-core.c       2011-01-06 23:57:39.000000000 -0500
+++ new/block/blk-core.c        2011-01-06 23:57:46.000000000 -0500
@@ -37,6 +37,10 @@
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);

+#define complete_log(queue, fmt, args...)     \
+        blk_add_trace_msg(queue, "yh " fmt, ##args)
+
 static int __make_request(struct request_queue *q, struct bio *bio);

 /*
@@ -1974,6 +1978,10 @@
        if (!req->bio)
                return false;

+       complete_log(req->q, "nr_sorted: %u, in_flight[0]: %u,
in_flight[1]: %u",
+               req->q->nr_sorted, req->q->in_flight[0], req->q->in_flight[1]);
+
        trace_block_rq_complete(req->q, req);

        /*

Here, I consider nr_sorted in "struct request_queue" as the number of
pending requests, while in_flight[0/1] represent for the number of
async/sync requests serving simultaneously in SSD. I think this little
patch should exactly show the pending/serving number of requests.

The result from blkparse shows that the number of serving requests in
SSD is almost 1, while the pending number varies from tens to a
hundred. Since I only run a single process for postmark, does that
mean the number of requests in flight is always 1 even the storage is
SSD?

I have tested ext3/ext4/btrfs on cfq/deadline/noop, the numbers for
requests in flight are the same, almost no more than 1.

Thanks,
Yuehai

On Thu, Jan 6, 2011 at 10:21 PM, Yuehai Xu <yuehaixu@gmail.com> wrote:
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
>
> Does different file system handle this differently?
>
> I appreciate any help. Thanks very much!
>
> Yuehai
>
