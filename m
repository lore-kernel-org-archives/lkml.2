Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1G1XTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:19:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33586 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab1G1XTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:19:32 -0400
Subject: Re: [PATCH] blktrace: add FLUSH/FUA support
From: Namhyung Kim <namhyung@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        linux-btrace@vger.kernel.org
In-Reply-To: <x494o26ma11.fsf@segfault.boston.devel.redhat.com>
References: <x494o26ma11.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 08:19:24 +0900
Message-ID: <1311895164.1913.57.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-07-28 (목), 16:21 -0400, Jeff Moyer:
> Hi,
> 
> Sorry, I don't have the original posting of this message, so I've just
> cut-n-paste from the archives on lkml.org:
>   https://lkml.org/lkml/2011/6/1/235
> 

Hello, Jeff.

Thanks for finding and replying to this :)


> The proposal was this:
> 
> > Add FLUSH/FUA support to blktrace. As FLUSH precedes WRITE and/or
> > FUA follows WRITE, use the same 'F' flag for both cases and
> > distinguish them by their (relative) position. The end results
> > look like (other flags might be shown also):
> > 
> >  - WRITE:            W
> >  - WRITE_FLUSH:      FW
> >  - WRITE_FUA:        WF
> >  - WRITE_FLUSH_FUA:  FWF
> 
> I'm not sure I'll ever be able to keep that straight.  How about we use
> 'F' for FUA, since FUA is capitalized anyway, and use 'f' for flush?
> Too subtle?
> 

Either way is fine to me. Jens?


> Next...
> 
> > @@ -14,7 +14,7 @@
> >  enum blktrace_cat {
> >  	BLK_TC_READ	= 1 << 0,	/* reads */
> >  	BLK_TC_WRITE	= 1 << 1,	/* writes */
> > -	BLK_TC_BARRIER	= 1 << 2,	/* barrier */
> > +	BLK_TC_FUA	= 1 << 2,	/* fua requests */
> 
> I would prefer to replace BARRIER with FLUSH, as I think they are closer
> relatives.  Doing it the way you've suggested would mean that older
> blktrace user-space would report FUA as a Barrier.
> 

I thought about that too. But as I said in the changelog, it led to a
negative number at the rhs of MASC_TC_BIT calculation, so the end result
was not good.

In the meantime, I found that Matthew Wilcox posted a patch which
relocates some REQ_ flags to appropriate positions.

https://lkml.org/lkml/2011/6/2/324

With the patch, it seems ok to replace BARRIER with FLUSH. However it
looks like the patch isn't included into the tree yet.

BTW, I'm thinking about user-space again. I'm not sure it's ok if older
blktrace tool reports FLUSH/FUA as BARRIER. Actually I posted a patch
that treats FLUSH as BARRIER [1], and Jens and others commented we
should not do that.

To end that, I could leave BLK_TC_BARRIER as is, and add
BLK_TC_{FLUSH,FUA} at the end of blktrace_cat. But as we exhause space
in the 16-bit act_mask, it would require a substantial change.

Any thoughts?


> Comments?  No matter what's agreed upon, we should get this in sooner
> rather than later, as it's a big missing piece in trying to diagnose
> performance issues!
> 
> Cheers,
> Jeff

Thanks.

[1] https://lkml.org/lkml/2011/5/27/206


-- 
Regards,
Namhyung Kim


