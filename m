Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab0CQQ6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:58:07 -0400
Received: from verein.lst.de ([213.95.11.210]:40012 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0CQQ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:58:03 -0400
Date: Wed, 17 Mar 2010 17:57:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Avi Kivity <avi@redhat.com>
Cc: Chris Webb <chris@arachsys.com>, balbir@linux.vnet.ibm.com,
       KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
Message-ID: <20100317165725.GB29548@lst.de>
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com> <4B9F4CBD.3020805@redhat.com> <20100317152452.GZ31148@arachsys.com> <4BA101C5.9040406@redhat.com> <4BA105FE.2000607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA105FE.2000607@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 06:40:30PM +0200, Avi Kivity wrote:
> Chris, can you carry out an experiment?  Write a program that pwrite()s 
> a byte to a file at the same location repeatedly, with the file opened 
> using O_SYNC.  Measure the write rate, and run blktrace on the host to 
> see what the disk (/dev/sda, not the volume) sees.  Should be a (write, 
> flush, write, flush) per pwrite pattern or similar (for writing the data 
> and a journal block, perhaps even three writes will be needed).
> 
> Then scale this across multiple guests, measure and trace again.  If 
> we're lucky, the flushes will be coalesced, if not, we need to work on it.

As the person who has written quite a bit of the current O_SYNC
implementation and also reviewed the rest of it I can tell you that
those flushes won't be coalesced.  If we always rewrite the same block
we do the cache flush from the fsync method and there's is nothing
to coalesced it there.  If you actually do modify metadata (e.g. by
using the new real O_SYNC instead of the old one that always was O_DSYNC
that I introduced in 2.6.33 but that isn't picked up by userspace yet)
you might hit a very limited transaction merging window in some
filesystems, but it's generally very small for a good reason.  If it
were too large we'd make the once progress wait for I/O in another just
because we might expect transactions to coalesced later.  There's been
some long discussion about that fsync transaction batching tuning
for ext3 a while ago.

