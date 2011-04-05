Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1DEDFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 23:05:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:47547 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab1DEDFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 23:05:50 -0400
Date: Tue, 5 Apr 2011 13:05:41 +1000
From: NeilBrown <neilb@suse.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>, dm-devel@redhat.com
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110405130541.6c2b5f86@notabene.brown>
In-Reply-To: <20110310005810.GA17911@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
	<20110303221353.GA10366@redhat.com>
	<4D761E0D.8050200@fusionio.com>
	<20110308202100.GA31744@redhat.com>
	<4D76912C.9040705@fusionio.com>
	<20110308220526.GA393@redhat.com>
	<20110310005810.GA17911@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011 19:58:10 -0500 Mike Snitzer <snitzer@redhat.com> wrote:

> Also, in your MD changes, you removed all calls to md_unplug() but
> didn't remove md_unplug().  Seems it should be removed along with the
> 'plug' member of 'struct mddev_t'?  Neil?

I've been distracted by other things and only just managed to have a look at
this.

The new plugging code seems to completely ignore the needs of stacked devices
- or at least my needs in md.

For RAID1 with a write-intent-bitmap, I queue all write requests and then on
an unplug I update the write-intent-bitmap to mark all the relevant blocks
and then release the writes.

With the new code there is no way for an unplug event to wake up the raid1d
thread to start the writeout - I haven't tested it but I suspect it will just
hang.

Similarly for RAID5 I gather write bios (long before they become 'struct
request' which is what the plugging code understands) and on an unplug event
I release the writes - hopefully with enough bios per stripe so that we don't
need to pre-read.

Possibly the simplest fix would be to have a second list_head in 'struct
blk_plug' which contained callbacks (a function pointer a list_head in a
struct which is passed as an arg to the function!).
blk_finish_plug could then walk the list and call the call-backs.
It would be quite easy to hook into that.


I suspect I also need to add blk_start_plug/blk_finish_plug around the loop
in raid1d/raid5d/raid10d, but that is pretty straight forward.

Am I missing something important?
Is there a better way to get an unplug event to md?

Thanks,
NeilBrown
