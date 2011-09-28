Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1I1O6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:58:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:52164 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab1I1O6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:58:23 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jens Axboe <axboe@kernel.dk>, Rocko Requin <rockorequin@hotmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hannes Reinecke <hare@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block fixes for 3.1-rc
Thread-Topic: [GIT PULL] block fixes for 3.1-rc
Thread-Index: AQHMfXCcnYUd7fOZtkqge8SS0JlJSpViaTKAgADtu4CAAAF3AA==
Date: Wed, 28 Sep 2011 14:57:41 +0000
Message-ID: <1317221858.19034.29.camel@dabdike.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1109281042250.2089-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1109281042250.2089-100000@iolanthe.rowland.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.243.235.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <07D6503EB8688947A770EE3E1E57AA0A@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8SEwb2r031808

On Wed, 2011-09-28 at 10:52 -0400, Alan Stern wrote:
> On Tue, 27 Sep 2011, Jens Axboe wrote:
> 
> > On 2011-09-27 17:52, Linus Torvalds wrote:
> > > On Wed, Sep 21, 2011 at 5:19 AM, Jens Axboe <axboe@kernel.dk> wrote:
> > >>
> > >> Final round of patches for 3.1.
> > > 
> > > Apparently better not.
> > > 
> > > The "block layer oopses on USB device removal" is still there, it seems.
> > > 
> > > I can even find a patch from it from Alan Stern:
> > > 
> > >    https://lkml.org/lkml/2011/9/18/63
> > > 
> > > and the reason I found that was that my wife's machine just saw what
> > > looks very much like that bug in elv_put_request().
> > > 
> > > The call chain on that particular machine was:
> > > 
> > >  - __blk_put_request
> > >   blk_put_request
> > >   scsi_execute
> > >   scsi_execute_req
> > >   sd_check_events
> > >   disk_events_workfn
> > >   process_one_work
> > > 
> > > in one of the kthread helpers. It sounds like something either
> > > generates disk events after the unplug event (despite a "safely
> > > remove" thing), or doesn't properly wait for the disk events to have
> > > flushed before the elevator is cleared.
> > > 
> > > The "things go oops at USB removal" reports have been with us for a
> > > *loong* time now. Can we please get this fixed already, and have
> > > somebody really look at it?
> > > 
> > > And if you can't figure out why it happens, at least apply Alan's
> > > patch (or ack it).
> > 
> > The whole thing is a bit of a mess, it was introduced by changes meant
> > to clean it up, which didn't get to the root of the problem (and
> > seemingly only made it worse). We need the queue clearly referenced and
> > released, not just pointed to. That would be the more invasive and real
> > fix. I will apply Alan's fix for a happier 3.1.
> 
> You guys should be asking the person who first reported the most recent 
> version of this bug and is able to reproduce it easily.
> 
> Rocko has already tested Hannes's patch in
> 
> 	http://marc.info/?l=linux-scsi&m=131669751909474&w=2
> 
> successfully.  The only difference between it and James's patch in
> 
> 	http://marc.info/?l=linux-kernel&m=131300594629839
> 
> is the assignment to q->queue_lock, which doesn't appear to be
> essential in the SCSI case.  (Furthermore, Hannes's patch makes an
> unnecessary test before doing the assignment, which is inelegant.)

I'm not so sure about the inelegance:  The CPU guys have been drilling
into us that for the if (a!=b) a=b; is useful to avoid dirtying cache
lines (provided a==b is likely to be true for some of the cases).

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
