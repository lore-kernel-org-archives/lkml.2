Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab2JKPrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:47:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab2JKPrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:47:10 -0400
Date: Thu, 11 Oct 2012 17:47:07 +0200
From: Jan Kara <jack@suse.cz>
To: Viktor Nagy <viktor.nagy@thx4games.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>,
        chris.mason@fusionio.com
Subject: Re: Linux 3.0+ Disk performance problem - wrong pdflush behaviour
Message-ID: <20121011154707.GB8001@quack.suse.cz>
References: <5073F13C.5050807@thx4games.com>
 <20121010165750.GD32581@quack.suse.cz>
 <5075DE39.8090303@thx4games.com>
 <20121010212725.GA11642@quack.suse.cz>
 <5076A506.8080808@thx4games.com>
 <20121011101005.GB16624@quack.suse.cz>
 <5076C258.1070405@thx4games.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5076C258.1070405@thx4games.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-10-12 13:58:00, Viktor Nagy wrote:
> >>>>>The regression you observe is caused by commit 3d08bcc8 "mm: Wait for
> >>>>>writeback when grabbing pages to begin a write". At the first sight I was
> >>>>>somewhat surprised when I saw that code path in the traces but later when I
> >>>>>did some math it's clear. What the commit does is that when a page is just
> >>>>>being written out to disk, we don't allow it's contents to be changed and
> >>>>>wait for IO to finish before letting next write to proceed. Now if you have
> >>>>>1 GB file, that's 256000 pages. By the observation from my test machine,
> >>>>>writeback code keeps around 10000 pages in flight to disk at any moment
> >>>>>(this number fluctuates a lot but average is around that number). Your
> >>>>>program dirties about 25600 pages per second. So the probability one of
> >>>>>dirtied pages is a page under writeback is equal to 1 for all practical
> >>>>>purposes (precisely it is 1-(1-10000/256000)^25600). Actually, on average
> >>>>>you are going to hit about 1000 pages under writeback per second which
> >>>>>clearly has a noticeable impact (even single page can have). Pity I didn't
> >>>>>do the math when we were considering those patches.
> >>>>>
> >>>>>There were plans to avoid waiting if underlying storage doesn't need it but
> >>>>>I'm not sure how far that plans got (added a couple of relevant CCs).
> >>>>>Anyway you are about second or third real workload that sees regression due
> >>>>>to "stable pages" so we have to fix that sooner rather than later... Thanks
> >>>>>for your detailed report!
> >>>>We develop a game server which gets very high load in some
> >>>>countries. We are trying to serve as much players as possible with
> >>>>one server.
> >>>>Currently the CPU usage is below the 50% at the peak times. And with
> >>>>the old kernel it runs smoothly. The pdflush runs non-stop on the
> >>>>database disk with ~3 MByte/s write (minimal read).
> >>>>This is at 43000 active sockets, 18000 rq/s, ~40000 packets/s.
> >>>>I think we are still below the theoratical limits of this server...
> >>>>but only if the disk writes are never done in sync.
> >>>>
> >>>>I will try the 3.2.31 kernel without the problematic commit
> >>>>(3d08bcc8 "mm: Wait for writeback when grabbing pages to begin a
> >>>>write").
> >>>>Is it a good idea? Will it be worse than 2.6.32?
> >>>   Running without that commit should work just fine unless you use
> >>>something exotic like DIF/DIX or similar. Whether things will be worse than
> >>>in 2.6.32 I cannot say. For me, your test program behaves fine without that
> >>>commit but whether your real workload won't hit some other problem is
> >>>always a question. But if you hit another regression I'm interested in
> >>>hearing about it :).
> >>I've just tested it. After I've set the dirty_bytes over the file
> >>size the writes are never blocked.
> >>So it's working nice without the mentioned commit.
> >>
> >>The problem is that if you read the kernel's documentation about the
> >>dirty page handling it does not work that way (with the commit) It
> >>works unpredictable.
> >   Which documentation do you mean exatly? The process won't be throttled
> >because of dirtying too much memory but we can still block it for other
> >reasons - e.g. because we decide to evict it's code from memory and have to
> >reload it again when the process gets scheduled. Or we can block during
> >memory allocation (which may be needed to allocate a page you write to) if
> >we find it necessary. There are no promises really...
> >
> Ok, it is very hard to get an overview about this whole thing.
> I thought I understood the behaviour checking the file
> Documentation/sysctl/vm.txt:
> 
> "
> dirty_bytes
> 
> Contains the amount of dirty memory at which a process generating
> disk writes
> will itself start writeback.
> ...
> "
> 
> Ok, it not says exactly that other things can influence too.
> 
> Several people are trying to get over the problem caused by the
> commit with setting the value of /sys/block/sda/queue/nr_requests to
> 4 (from 128).
> This helped a lot but was not enough for us.
  Yes, that reduces amount of IO in flight at any moment so it reduces
chances you will wait in grab_cache_page_write_begin(). But it also reduces
throughput...

> I attach two performance graphs which shows our own CPU usage
> measurement (red). One minute averages, the blue line is the SQL
> time %.
> 
> And a nice question: Without reverting the patch is it possible to
> get a smooth performance (in our case)?
  I don't know how to fix the issue without reverting the patch. Sorry.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
