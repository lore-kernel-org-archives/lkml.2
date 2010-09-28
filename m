Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0I1UMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:12:50 -0400
Received: from comms2.zx.nl ([194.187.76.142]:64914 "EHLO comms2.zx.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab0I1UMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:12:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Subject: Re: [uml-devel] [REGRESSION] um: ubd: block layer issue (Was: ext3
 filesystem corruption in user mode linux)
From: Janjaap Bos <janjaap@bos.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>, tj@kernel.org,
        axboe@kernel.dk, mike.miller@hp.com,
        user-mode-linux-devel@lists.sourceforge.net, adrian@mcmen.demon.co.uk,
        jdike@addtoit.com, LKML <linux-kernel@vger.kernel.org>,
        grant.likely@secretlab.ca, Geert.Uytterhoeven@sonycom.com,
        Chris Frey <cdfrey@foursquare.net>
In-reply-to: <AANLkTi=NiB4hoA5Y8kbR7R8B+J-jJXAHGSu5JdOLSQsj@mail.gmail.com>
References: <AANLkTi=PTp7YW_eYxtF-H2QSxgei3whWH59wU0C9oCkz@mail.gmail.com>
 <1285693648.14518.7.camel@voyager>
 <AANLkTi=NiB4hoA5Y8kbR7R8B+J-jJXAHGSu5JdOLSQsj@mail.gmail.com>
Date: Tue, 28 Sep 2010 22:12:42 +0200
Message-id: <1285704762.14518.19.camel@voyager>
X-Mailer: Evolution 2.28.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2010-09-28 at 21:52 +0200, Geert Uytterhoeven wrote:
> On Tue, Sep 28, 2010 at 19:07, Janjaap Bos <janjaap@bos.nl> wrote:
> > See attached patch, and earlier message posted in March 2010 on uml user
> > list. We are out of maintainer...
> 
> Thanks for the patch!
> 
> | --- a/arch/um/drivers/ubd_kern.c
> | +++ b/arch/um/drivers/ubd_kern.c
> | @@ -1223,7 +1227,7 @@ static void do_ubd_request(struct request_queue *q)
> |       struct io_thread_req *io_req;
> |       struct request *req;
> |       sector_t sector;
> | -     int n;
> | +     int n, last_sectors;
> |
> |       while(1){
> |               struct ubd *dev = q->queuedata;
> | @@ -1239,9 +1243,12 @@ static void do_ubd_request(struct request_queue *q)
> |
> |               req = dev->request;
> |               sector = blk_rq_pos(req);
> | +             last_sectors = 0;
> |               while(dev->start_sg < dev->end_sg){
> |                       struct scatterlist *sg = &dev->sg[dev->start_sg];
> |
> | +                     sector += last_sectors;
> | +                     last_sectors = 0;
> |                       io_req = kmalloc(sizeof(struct io_thread_req),
> |                                        GFP_ATOMIC);
> |                       if(io_req == NULL){
> | @@ -1253,7 +1260,7 @@ static void do_ubd_request(struct request_queue *q)
> |                                       (unsigned long long)sector << 9,
> |                                       sg->offset, sg->length, sg_page(sg));
> |
> | -                     sector += sg->length >> 9;
> | +                     last_sectors = sg->length >> 9;
> |                       n = os_write_file(thread_fd, &io_req,
> |                                         sizeof(struct io_thread_req *));
> |                       if(n != sizeof(struct io_thread_req *)){
> 
> However, I'm wondering what difference this part makes?
> 


It fixes ubd block handling integrity.
With large block operations errors occurred. Probably due to lost
request pointers as explained below. Need to keep a local count of
sectors and delay the update. Done by reverting commit
f81f2f7c9fee307e371f37424577d46f9eaf8692 using the present
block api. (At least which is what I intend, but perhaps quite likely I
am missing the point, also it may not be needed anymore if only single
512 byte sector blocks are used per request. Anyway... it solves the
problem for me ;-)

Regards,
-Janjaap


See:

reverted: commit f81f2f7c9fee307e371f37424577d46f9eaf8692
          Author: Tejun Heo <tj@kernel.org>
          Date:   Tue Apr 28 13:06:10 2009 +0900
          ubd: drop unnecessary rq->sector manipulation
    ubd curiously updates rq->sector while issuing the request
    in multiple pieces.  Don't do it and simply use local copy
    of sector.
        
See for original reason:
    
commit 0a6d3a2a3813e7b25267366cfbf9a4a4698dd1c2
        Author: Jeff Dike <jdike@addtoit.com>
        Date:   Sun Jul 15 23:38:47 2007 -0700
        uml: fix request->sector update
    
    It is theoretically possible for a request to finish and be freed
between writing it to the I/O thread and updating the sector count.  In
this case, the update will dereference a freed pointer.
    To avoid this, I delay the update until processing the next sg
segment, when the request pointer is known to be good.
    
    modified:   arch/um/drivers/ubd_kern.c



