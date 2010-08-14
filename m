Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0HNUER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 16:04:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36567 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab0HNUEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 16:04:16 -0400
Date: Sat, 14 Aug 2010 16:04:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: perf scripting
Message-ID: <20100814200415.GA24704@infradead.org>
References: <1280497020-22816-1-git-send-email-mel@csn.ul.ie>
 <1280497020-22816-2-git-send-email-mel@csn.ul.ie>
 <20100730140441.GB5269@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100730140441.GB5269@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 04:04:42PM +0200, Frederic Weisbecker wrote:
> I have the feeling you've made an ad-hoc post processing script that seems
> to rewrite all the format parsing, debugfs, stream handling, etc... we
> have that in perf tools already.
> 
> May be you weren't aware of what we have in perf in terms of scripting support.

Frederic, any chance you could help me getting a bit more familar with
the perf perl scripting.  I currently have a hacky little sequence that
I use to profile what callers generate XFS log traffic, and it like to
turn it into a script so that I can do a direct perf call to use it
to profile things without manual work, and generate nicer output.

Currently it looks like this:

perf probe --add xlog_sync

perf record -g -e probe:xlog_sync -a -- <insert actualy workload here>

then do

perf report -n -g flat

to get me the callchain in a readable format.

Now what I'd really like is a perl script that can read a file like
latencytop.trans (or just has the information embedded) which contains
functions in the backtrace that we're interested in.

E.g. one simple from the report command above may look like:

                xlog_sync
		xlog_write
		xlog_cil_push
		_xfs_log_force
		xfs_log_force
		xfs_sync_data
		xfs_quiesce_data
		xfs_fs_sync_fs

In which case I'm interested in xfs_log_force and xfs_fs_sync_fs.  So
the output of the perl script should looks something like:


  Samples	Caller
	2	xfs_fs_sync_fs
	1	xfs_file_fsync
	1	xfs_commit_dummy_trans

Or if I have a way to parse the argument of the probe (in the worst case
I can replace it with a trace event if that makes it easier):

  Samples	Flags		Callers
	1	sync		xfs_fs_sync_fs
	1			xfs_fs_sync_fs
	1	sync		xfs_file_fsync
	1	sync		xfs_commit_dummy_trans

