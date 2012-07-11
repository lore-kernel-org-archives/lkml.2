Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab2GKNhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:37:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab2GKNhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:37:38 -0400
Date: Wed, 11 Jul 2012 15:37:35 +0200
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Deadlocks due to per-process plugging
Message-ID: <20120711133735.GA8122@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  we've recently hit a deadlock in our QA runs which is caused by the
per-process plugging code. The problem is as follows:
  process A					process B (kjournald)
  generic_file_aio_write()
    blk_start_plug(&plug);
    ...
    somewhere in here we allocate memory and
    direct reclaim submits buffer X for IO
    ...
    ext3_write_begin()
      ext3_journal_start()
        we need more space in a journal
        so we want to checkpoint old transactions,
        we block waiting for kjournald to commit
        a currently running transaction.
						journal_commit_transaction()
						  wait for IO on buffer X
						  to complete as it is part
						  of the current transaction

  => deadlock since A waits for B and B waits for A to do unplug.
BTW: I don't think this is really ext3/ext4 specific. I think other
filesystems can get into problems as well when direct reclaim submits some
IO and the process subsequently blocks without submitting the IO.

Effectively the per process plugging introduces a lock dependency
buffer_lock -> any lock acquired after IO submission before the process'
queue is unplugged. This certainly creates lots of cycles in the lock
dependency graph...

I'm wondering how we should fix this best. Trivial fix would be to flush
the IO plug on every schedule, not just io_schedule(), but that can have
some peformance implications I guess (the effect of plugging would be very
limited). Better (although more tedious) solution would be to push the
plugs from higher levels down into the filesystems where they could be
managed to not create problematic lock dependencies (but e.g. for ext3/ext4
that means we have to unplug after writing each page so it is effectively
rather similar to unplugging on every schedule()).

Thoughts?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
