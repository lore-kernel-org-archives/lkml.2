Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab0I1UiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:38:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33644 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab0I1UiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DjBuVDLQvkt05UBanDbr6eKM8d5Uw7f4M6Vs6ebvCm9tm9cgYWP1+fKE76LlGDMu+B
         mtLSBSHLOPQfXgN8cNywXS81zp7lWC8YOMaYyGWRENix7hEfS/TP9kt3R301YLtO36Ve
         GjNGBCuHGQew7lWmK1fvSO2DMj1V+FcF8DfOg=
MIME-Version: 1.0
In-Reply-To: <1285704762.14518.19.camel@voyager>
References: <AANLkTi=PTp7YW_eYxtF-H2QSxgei3whWH59wU0C9oCkz@mail.gmail.com>
	<1285693648.14518.7.camel@voyager>
	<AANLkTi=NiB4hoA5Y8kbR7R8B+J-jJXAHGSu5JdOLSQsj@mail.gmail.com>
	<1285704762.14518.19.camel@voyager>
Date: Tue, 28 Sep 2010 22:37:59 +0200
X-Google-Sender-Auth: 7-9n7XCxGud1mpT7LAxAInNB4Ws
Message-ID: <AANLkTikquMSnLFW2dcDEWW=Jtez5zzYSuRPFwbyVnk+y@mail.gmail.com>
Subject: Re: [uml-devel] [REGRESSION] um: ubd: block layer issue (Was: ext3
 filesystem corruption in user mode linux)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Janjaap Bos <janjaap@bos.nl>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>, tj@kernel.org,
        axboe@kernel.dk, mike.miller@hp.com,
        user-mode-linux-devel@lists.sourceforge.net, adrian@mcmen.demon.co.uk,
        jdike@addtoit.com, LKML <linux-kernel@vger.kernel.org>,
        grant.likely@secretlab.ca, Geert.Uytterhoeven@sonycom.com,
        Chris Frey <cdfrey@foursquare.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 22:12, Janjaap Bos <janjaap@bos.nl> wrote:
>> On Tue, 2010-09-28 at 21:52 +0200, Geert Uytterhoeven wrote:
>> On Tue, Sep 28, 2010 at 19:07, Janjaap Bos <janjaap@bos.nl> wrote:
>> > See attached patch, and earlier message posted in March 2010 on uml user
>> > list. We are out of maintainer...
>>
>> Thanks for the patch!
>>
>> | --- a/arch/um/drivers/ubd_kern.c
>> | +++ b/arch/um/drivers/ubd_kern.c
>> | @@ -1223,7 +1227,7 @@ static void do_ubd_request(struct request_queue *q)
>> |       struct io_thread_req *io_req;
>> |       struct request *req;
>> |       sector_t sector;
>> | -     int n;
>> | +     int n, last_sectors;
>> |
>> |       while(1){
>> |               struct ubd *dev = q->queuedata;
>> | @@ -1239,9 +1243,12 @@ static void do_ubd_request(struct request_queue *q)
>> |
>> |               req = dev->request;
>> |               sector = blk_rq_pos(req);
>> | +             last_sectors = 0;
>> |               while(dev->start_sg < dev->end_sg){
>> |                       struct scatterlist *sg = &dev->sg[dev->start_sg];
>> |
>> | +                     sector += last_sectors;
>> | +                     last_sectors = 0;
>> |                       io_req = kmalloc(sizeof(struct io_thread_req),
>> |                                        GFP_ATOMIC);
>> |                       if(io_req == NULL){
>> | @@ -1253,7 +1260,7 @@ static void do_ubd_request(struct request_queue *q)
>> |                                       (unsigned long long)sector << 9,
>> |                                       sg->offset, sg->length, sg_page(sg));
>> |
>> | -                     sector += sg->length >> 9;
>> | +                     last_sectors = sg->length >> 9;
>> |                       n = os_write_file(thread_fd, &io_req,
>> |                                         sizeof(struct io_thread_req *));
>> |                       if(n != sizeof(struct io_thread_req *)){
>>
>> However, I'm wondering what difference this part makes?
>>
>
>
> It fixes ubd block handling integrity.
> With large block operations errors occurred. Probably due to lost
> request pointers as explained below. Need to keep a local count of
> sectors and delay the update. Done by reverting commit
> f81f2f7c9fee307e371f37424577d46f9eaf8692 using the present
> block api. (At least which is what I intend, but perhaps quite likely I
> am missing the point, also it may not be needed anymore if only single
> 512 byte sector blocks are used per request. Anyway... it solves the
> problem for me ;-)
>
> Regards,
> -Janjaap
>
>
> See:
>
> reverted: commit f81f2f7c9fee307e371f37424577d46f9eaf8692
>          Author: Tejun Heo <tj@kernel.org>
>          Date:   Tue Apr 28 13:06:10 2009 +0900
>          ubd: drop unnecessary rq->sector manipulation
>    ubd curiously updates rq->sector while issuing the request
>    in multiple pieces.  Don't do it and simply use local copy
>    of sector.
>
> See for original reason:
>
> commit 0a6d3a2a3813e7b25267366cfbf9a4a4698dd1c2
>        Author: Jeff Dike <jdike@addtoit.com>
>        Date:   Sun Jul 15 23:38:47 2007 -0700
>        uml: fix request->sector update
>
>    It is theoretically possible for a request to finish and be freed
> between writing it to the I/O thread and updating the sector count.  In
> this case, the update will dereference a freed pointer.
>    To avoid this, I delay the update until processing the next sg
> segment, when the request pointer is known to be good.
>
>    modified:   arch/um/drivers/ubd_kern.c

This changeset from 2007 indeed moved the update of req->sector.

However, in the new code, before or after applying your patch, there's no update
of req->sector anymore. Everything is done in local variables.

Is it possible that we only need the hunk below to fix the corruption?

| diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
| index 5ff5546..655ed9e 100644
| --- a/arch/um/drivers/ubd_kern.c
| +++ b/arch/um/drivers/ubd_kern.c
| @@ -746,8 +746,12 @@ static int ubd_open_dev(struct ubd *ubd_dev)
|       }
|       ubd_dev->fd = fd;
|
| +     /* A setting higher than 1 sector currently (v2.6.33) generates
| +     data loss, both for raw and cow ubd. */
| +     blk_queue_max_sectors(ubd_dev->queue, 1 * sizeof(long));
| +     blk_queue_max_phys_segments(ubd_dev->queue, 1 * sizeof(long));
| +
|       if(ubd_dev->cow.file != NULL){
| -             blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
|
|               err = -ENOMEM;
|               ubd_dev->cow.bitmap = vmalloc(ubd_dev->cow.bitmap_len);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
