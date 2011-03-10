Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1CJA62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:58:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1CJA61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:58:27 -0500
Date: Wed, 9 Mar 2011 19:58:10 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>, dm-devel@redhat.com,
        neilb@suse.de
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110310005810.GA17911@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
 <20110303221353.GA10366@redhat.com>
 <4D761E0D.8050200@fusionio.com>
 <20110308202100.GA31744@redhat.com>
 <4D76912C.9040705@fusionio.com>
 <20110308220526.GA393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308220526.GA393@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08 2011 at  5:05pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Mar 08 2011 at  3:27pm -0500,
> Jens Axboe <jaxboe@fusionio.com> wrote:
> 
> > On 2011-03-08 21:21, Mike Snitzer wrote:
> > > On Tue, Mar 08 2011 at  7:16am -0500,
> > > Jens Axboe <jaxboe@fusionio.com> wrote:
> > > 
> > >> On 2011-03-03 23:13, Mike Snitzer wrote:
> > >>> I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
> > >>> kernel, when I try an fsync heavy workload to a request-based mpath
> > >>> device (the kernel ultimately goes down in flames, I've yet to look at
> > >>> the crashdump I took)
> > >>
> > >> Mike, can you re-run with the current stack-plug branch? I've fixed the
> > >> !CONFIG_BLOCK and rebase issues, and also added a change for this flush
> > >> on schedule event. It's run outside of the runqueue lock now, so
> > >> hopefully that should solve this one.
> > > 
> > > Works for me, thanks.
> > 
> > Super, thanks! Out of curiousity, did you use dm/md?
> 
> Yes, I've been using a request-based DM multipath device.

Hi Jens,

I just got to reviewing your onstack plugging DM changes (I looked at
the core block layer changes for additional context and also had a brief
look at MD).

I need to put more time to the review of all this code but one thing
that is immediately apparent is that after these changes DM only has one
onstack plug/unplug -- in drivers/md/dm-kcopyd.c:do_work()

You've removed a considerable amount of implicit plug/explicit unplug
code from DM (and obviously elsewhere but I have my DM hat on ;).

First question: is relying on higher-level (aio, fs, read-ahead)
explicit plugging/unplugging sufficient?  Seems odd to not have the
control/need to unplug the DM device upon resume (after a suspend).

(this naive question/concern stems from me needing to understand the
core block layer's onstack plugging changes better)

(but if those higher-level explicit onstack plug changes make all this
code removal possible shouldn't those commits come before changing
underlying block drivers like DM, MD, etc?)

I noticed that driver/md/dm-raid1.c:do_mirror() seems to follow the same
pattern of drivers/md/dm-kcopyd.c:do_work().. so rather than remove
dm_table_unplug_all() shouldn't it be replaced with a
blk_start_plug/blk_finish_plug?

Also, in your MD changes, you removed all calls to md_unplug() but
didn't remove md_unplug().  Seems it should be removed along with the
'plug' member of 'struct mddev_t'?  Neil?

Thanks,
Mike
