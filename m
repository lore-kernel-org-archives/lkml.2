Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab0LMUyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:54:11 -0500
Received: from mx2.netapp.com ([216.240.18.37]:3818 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab0LMUyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:54:10 -0500
X-IronPort-AV: E=Sophos;i="4.59,337,1288594800"; 
   d="scan'208";a="494417531"
Subject: Re: [PATCH 30/35] nfs: heuristics to avoid commit
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101213150329.953837345@intel.com>
References: <20101213144646.341970461@intel.com>
	 <20101213150329.953837345@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Mon, 13 Dec 2010 15:53:46 -0500
Message-ID: <1292273626.8795.19.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 13 Dec 2010 20:53:47.0713 (UTC) FILETIME=[D6918B10:01CB9B07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 22:47 +0800, Wu Fengguang wrote:
> plain text document attachment (writeback-nfs-should-commit.patch)
> The heuristics introduced by commit 420e3646 ("NFS: Reduce the number of
> unnecessary COMMIT calls") do not work well for large inodes being
> actively written to.
> 
> Refine the criterion to
> - it has gone quiet (all data transfered to server)
> - has accumulated >= 4MB data to commit (so it will be large IO)
> - too few active commits (hence active IO) in the server

Where does the number 4MB come from? If I'm writing a 4GB file, I
certainly do not want to commit every 4MB; that would make for a total
of 1000 commit requests in addition to the writes. On a 64-bit client
+server both having loads of memory and connected by a decently a fast
network, that can be a significant slowdown...

Most of the time, we really want the server to be managing its dirty
cache entirely independently of the client. The latter should only be
sending the commit when it really needs to free up those pages.

Cheers
  Trond


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

