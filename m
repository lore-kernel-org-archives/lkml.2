Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1DKMFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 08:05:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:56471 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab1DKMFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 08:05:15 -0400
Date: Mon, 11 Apr 2011 22:05:05 +1000
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110411220505.1028816e@notabene.brown>
In-Reply-To: <4DA2E7F0.9010904@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
	<20110303221353.GA10366@redhat.com>
	<4D761E0D.8050200@fusionio.com>
	<20110308202100.GA31744@redhat.com>
	<4D76912C.9040705@fusionio.com>
	<20110308220526.GA393@redhat.com>
	<20110310005810.GA17911@redhat.com>
	<20110405130541.6c2b5f86@notabene.brown>
	<20110411145022.710c30e9@notabene.brown>
	<4DA2C7BE.6060804@fusionio.com>
	<20110411205928.13915719@notabene.brown>
	<4DA2E03A.2080607@fusionio.com>
	<20110411212635.7959de70@notabene.brown>
	<4DA2E7F0.9010904@fusionio.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 13:37:20 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:

> On 2011-04-11 13:26, NeilBrown wrote:
> > On Mon, 11 Apr 2011 13:04:26 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
> > 
> >>>
> >>> I'm sure one of us is missing something (probably both) but I'm not
> >>> sure what.
> >>>
> >>> The callback is central.
> >>>
> >>> It is simply to use plugging in md.
> >>> Just like blk-core, md will notice that a blk_plug is active and will put
> >>> requests aside.  I then need something to call in to md when blk_finish_plug
> >>
> >> But this is done in __make_request(), so md devices should not be
> >> affected at all. This is the part of your explanation that I do not
> >> connect with the code.
> >>
> >> If md itself is putting things on the plug list, why is it doing that?
> > 
> > Yes.  Exactly.  md itself want to put things aside on some list.
> > e.g. in RAID1 when using a write-intent bitmap I want to gather as many write
> > requests as possible so I can update the bits for all of them at once.
> > So when a plug is in effect I just queue the bios somewhere and record the
> > bits that need to be set.
> > Then when the unplug happens I write out the bitmap updates in a single write
> > and when that completes, I write out the data (to all devices).
> > 
> > Also in RAID5 it is good if I can wait for lots of write request to arrive
> > before committing any of them to increase the possibility of getting a
> > full-stripe write.
> > 
> > Previously I used ->unplug_fn to release the queued requests.  Now that has
> > gone I need a different way to register a callback when an unplug happens.
> 
> Ah, so this is what I was hinting at. But why use the task->plug for
> that? Seems a bit counter intuitive. Why can't you just store these
> internally?
> 
> > 
> >>
> >>> is called so that put-aside requests can be released.
> >>> As md can be built as a module, that call must be a call-back of some sort.
> >>> blk-core doesn't need to register blk_plug_flush because that is never in a
> >>> module, so it can be called directly.  But the md equivalent could be in a
> >>> module, so I need to be able to register a call back.
> >>>
> >>> Does that help? 
> >>
> >> Not really. Is the problem that _you_ would like to stash things aside,
> >> not the fact that __make_request() puts things on a task plug list?
> >>
> > 
> > Yes, exactly.  I (in md) want to stash things aside.
> > 
> > (I don't actually put the stashed things on the blk_plug, though it might
> > make sense to do that later in some cases - I'm not sure.  Currently I stash
> > things in my own internal lists and just need a call back to say "ok, flush
> > those lists now").
> 
> So we are making some progress... The thing I then don't understand is
> why you want to make it associated with the plug? Seems you don't have
> any scheduling restrictions, and in which case just storing them in md
> seems like a much better option.
> 

Yes.  But I need to know when to release the requests that I have stored.
I need to know when ->write_pages or ->read_pages or whatever has finished
submitting a pile of pages so that I can start processing the request that I
have put aside.  So I need a callback from blk_finish_plug.

(and I also need to know if a thread that was plugging schedules for the same
reason that you do).

NeilBrown


