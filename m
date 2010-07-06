Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0GFRtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 13:49:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab0GFRto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 13:49:44 -0400
Date: Wed, 7 Jul 2010 03:49:36 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/52] vfs scalability patches updated
Message-ID: <20100706174935.GK11732@laptop>
References: <20100624030212.676457061@suse.de>
 <20100630113054.GL24712@dastard>
 <20100630124049.GH21358@laptop>
 <20100701172317.GB1830@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701172317.GB1830@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 03:23:17AM +1000, Nick Piggin wrote:
> On Wed, Jun 30, 2010 at 10:40:49PM +1000, Nick Piggin wrote:
> > But actually it's not all for scalability. I have some follow on patches
> > (that require RCU inodes, among other things) that actually improve
> > single threaded performance significnatly. git diff workload IIRC was
> > several % improved from speeding up stat(2).
> 
> I rewrote the store-free path walk patch that goes on top of this
> patchset (it's now much cleaner and more optimised, I'll post a patch
> soonish). It is quicker than I remembered.
> 
> A single thread running stat(2) in a loop on a file "./file" has the
> following cost (on an 2s8c Barcelona):
> 
> 2.6.35-rc3	595 ns/op
> patched		336 ns/op
> 
> stat(2) takes 56% the time with patches. It's something like 13 fewer
> atomic operations per syscall.
> 
> What's that good for? A single threaded, cached `git diff` on the linux
> kernel tree takes just 81% of the time after the vfs patches (0.27s vs
> 0.33s).

At the other end of the scale, I tried dbench on ramfs on the little
32n64c Altix. Dbench actually has statfs() call completely removed from
the workload -- it's still a little problematic and patched kernel
throughput is ~halved with statfs().

dbench procs        1         64
2.6.35-rc3    235MB/s     95MB/s ( 0.6% scaling)
patched       245MB/s  14870MB/s (94.8% scaling)

(note all these numbers are with store-free path walking patches on top
of the posted patchset -- dbench procs do path walking from common cwds
so it will never scale this well if we have to take refcounts on common
dentries)

Thanks,
Nick

