Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab0JELGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:06:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46082 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0JELGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rXkJLRZZev7tL01fcQYVZxLe8Zsnx5sG8JePyEjS7BHzBbZCGzJUBOc9OIiSSWb13n
         1QSrG/+kLkJL0gtZb4nvILPnfB0xQqC9eYo3nQW4ZNsLYgqQ5ezqdgV6vPFQnX5qLvJs
         i7FatQ4Md38Z8xFUe6YDSHToJQ4gRWvKxexKw=
Date: Tue, 5 Oct 2010 04:06:22 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Bcache version 8
Message-ID: <20101005110622.GA2473@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcache is a patch to cache arbitrary block devices with an SSD. It's got
writeback caching, it uses a hybrid btree/log for the index, and it's
designed around avoiding random writes. It's fast, on benchmarks that
test random IO it's faster than just using the SSD (with my corsair
nova) - at least with bonnie++ and sysbench's mysql benchmark.

It should be about beta quality now - provided you've got backups (this
is highly complicated code that handles your data, after all) you should
be able to use it on non critical machines. It needs more testers
though, proceed with caution until you've tested it on your own setup.
Patch is currently against 2.6.35, alas I need to backport before I can
go back to targeting mainline.

There are some important caveats, the main one being that the ordering
constraints of barriers are are ignored - worse, silently (due to the
way it hooks into existing block devices instead of providing its own).
You must explicitly disable barriers when you mount your filesystem if
you don't want filesystem corruption after you reboot (writes are never
returned as completed before everything's on disk though - it doesn't
act like a disk that caches writes, it's just the ordering that's
problematic).

Besides that, IO error handling is working, and recovering from unclean
shutdown appears to be working reliably - there's one race that I know
of left so it shouldn't be trusted, but in practice it's very hard to
hit. I've been kill -9ing VMs while they're running dbench/bonnie/etc.
and not finding any errors.

Biggest thing left is making memory allocation deadlock proof - in
particular for the btree, which I'm currently using the page cache for.
The current code works, but I doubt it's entirely correct or sane - if
any reviewers would be willing to take a look at what I'm trying to do
there, that's probably what needs it most.

Also, anyone have any opinion on whether I should inline a 6k line
patch? Given that there's not much I can do to usefully break it up, I
don't know that it'd help - suggestions are welcome.

Git repo is up at:
git://evilpiepirate.org/~kent/linux-bcache.git
Wiki is up at http://bcache.evilpiepirate.org

 Documentation/bcache.txt |   75 +
 block/Kconfig            |   14 +
 block/Makefile           |    4 +
 block/bcache.c           | 5279 ++++++++++++++++++++++++++++++++++++++++++++++
 block/bcache_util.c      |  140 ++
 block/bcache_util.h      |  297 +++
 block/blk-core.c         |   10 +-
 fs/bio.c                 |   17 +-
 include/linux/bio.h      |    4 +
 include/linux/blkdev.h   |    2 +
 include/linux/fs.h       |    5 +
 include/linux/sched.h    |    4 +
 kernel/fork.c            |    3 +
13 files changed, 5850 insertions(+), 4 deletions(-)
