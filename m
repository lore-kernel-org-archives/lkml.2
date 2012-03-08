Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2CHLwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:52:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:43418 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab2CHLwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:52:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="115855325"
Message-ID: <1331207650.7257.33.camel@sauron.fi.intel.com>
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <rw@linutronix.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tim.bird@am.sony.com
Date: Thu, 08 Mar 2012 13:54:10 +0200
In-Reply-To: <4F57D0C4.1050605@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	 <1331138007.3463.16.camel@sauron.fi.intel.com>
	 <4F57D0C4.1050605@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 22:19 +0100, Richard Weinberger wrote:
> Maybe ubiattach to make the attach method selectable.
> Attaching by scanning or checkpointing...

I guess this is also something not really needed unless there is a user.
Attach should just pick the fastest way automatically.

What I meant is actually ubiformat - that would be nice to change. But
this is not the first urgency thing as well.

> 
> > On Tue, 2012-02-14 at 21:06 +0100, Richard Weinberger wrote:
> >> 1) A primary checkpoint block, which contains merily a pointer to the
> >>     erase block(s) which hold the real checkpointing data.
> >>
> >>     This primary block is guaranteed to be held within the first N
> >>     eraseblocks of a device. N is momentarily set to 16, but it might
> >>     be necessary to make this configurable in some way.
> >
> > Does it mean that you reserve the first 16 PEBs for the primary block?
> 
> The current implementation selects out one of the first 64 blocks.
> I know I wrote 16 in the initial RFC, but it's 64.
> But it does not reserve them.

So you will need to update the primary block from time to time, right?
How is it done?

> While writing a new checkpoint it tries to select an other early block.

Would you please also stricten the terminology around word "block". In
UBI and UBIFS I tried hard to stick to:

PEB - physical eraseblock
LEB - logical eraseblock

I tried to not use "block" or "eraseblock" to keep things unambiguous.

I did not read your code through, but is my assumption correct:

primary PEB - the physical eraseblock withing the first 64 PEBs which
contains the primary block.

primary block - a data structure which is stored in the primary PEB.

I would imagine you write primary blocks to the primary PEB one after
another, and when there is no more space in the primary PEB, you have to
fine a new one or erase the old one. At least this is something I'd
probably do...

But I guess you just re-write whole primary PEB every time and do not
squeeze many primary blocks into one PEB, right?

Would be great if you maintained a text file somewhere and updated it so
that we had a reference doc with design basics/terminology available.
Not too detailed so it would not take too much time.

> If no new early block is available it reuses the old one.

Hmm, I would think it should work like this:

You need to update the primary block. You check its erase counter. 

If the erasecounter is too high ( > min. EC + some threshold), you have
to pick a different PEB, otherwise just keep using the old one.

Picking a different primary PEB: you first check if there is a free PEB
withing those 64 with not too high EC. If yes - great, pick it.

If no, check if there is any PEB withing 64 with suitable EC at all - if
yes, you move the data from this PEB somewhere else (beyond the first
64) and use it.

If there is no suitable PEB at all, you just do not do the checkpoint
(let's pick another name finally please) and print a scary warning.

Something like this I'd imagine...

> > BTW, WRT short-term etc - how about just killing these concepts? I am
> > really not sure they make much sense anyway and give any improvements.
> 
> Good idea!

So I can expect the removal patches? :-)

> > Well, is it really true? The larger is the flash the more you read and
> > process anyway, and it is still linear, but the multiplier becomes very
> > small, so this is a huge improvement.
> 
> Yes. :)
> 
> Using checkpointing UBI only has to scan a fixed (independent of the 
> flash size!) number of blocks.

Checkpoint has elements inside, and the larger is the flash, the more
elements it has. And eraseblock size grows much slower than flash size I
believe.


-- 
Best Regards,
Artem Bityutskiy

