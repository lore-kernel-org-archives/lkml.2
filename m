Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1DEThv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:37:51 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43989 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab1DEThu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:37:50 -0400
Date: Tue, 5 Apr 2011 15:37:47 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Charles Samuels <charles@cariden.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Queuing of disk writes
Message-ID: <20110405193747.GG2832@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Charles Samuels <charles@cariden.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201104011259.53936.charles@cariden.com>
 <20110404020235.GA4706@thunk.org>
 <201104041050.12731.charles@cariden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104041050.12731.charles@cariden.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 10:50:12AM -0700, Charles Samuels wrote:
> 
> > Who or what is calling fsync()?  Is it being called by your
> > application because you want to initiate writeout?  Or is it being
> > called by some completely unrelated process?
> 
> It's being called by my own process. When fsync finishes, I update
> another file with some offset counters, fsync that, and with some
> luck, my writes are transactional.

OK, how often are you calling fsync()?  Is this something where you
are trying to get transactional guarantees by calling fsync() between
each transaction?  And if so, how big are you transactions?  If you
are trying to call fsync() 10+ times/second, then your only hope
really is going to be a battery-backed RAID controller card, as David
Lang has already suggested.

> What would be good use of sync_file_range? It looks pretty useful,
> but I don't know how to make good use of it.  For example,
> SYNC_FILE_RANGE_WRITE, wouldn't linux start this pretty much
> immediately?

No, not necessarily.  Generally Linux will pause for a bit to
hopefully allow writes to coalesce.

The reason why I suggested sync_file_range() is because you mentioned
that you tried waiting until there was a large amount of data in the
page cache, and then you called fsync() and that was taking forever.
I assumed from that you didn't necessarily had ACID or transactional
requirements.

The advantage of using sync_file_range() is that instead of forcing a
blocking write for *all* of the data pages, you can only do it on part
of the your data pages.  This would allow the writing from interfering
with subsequent reads that was taking place to your database.

All of this goes by the boards if you need data integrity guarantees,
of course; in that case you need to call fsync() after each atomic
transaction update...

						- Ted
