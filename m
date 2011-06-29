Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1F2IME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:12:04 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60428
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132Ab1F2IMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:12:00 -0400
Date: Wed, 29 Jun 2011 04:11:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Curt Wohlgemuth <curtw@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110629081155.GA5558@infradead.org>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
 <20110629005422.GQ32466@dastard>
 <BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 06:56:41PM -0700, Curt Wohlgemuth wrote:
> I don't quite understand this.  It's true that all IO done as a result
> of calling wb_writeback() on this work item won't finish before the
> completion takes place, but sending all those pages in flight *will*
> take place.  And that's a lot of time.  To wait on this before we then
> call sync_inodes_sb(), and do it all over again, seems odd at best.
> 
> Pre-2.6.35 kernels would start non-integrity sync writeback and
> immediately return, which would seem like a reasonable "prefetch-y"
> thing to do, considering it's going to be immediately followed by a
> data integrity sync writeback operation.

The only old kernel I have around is 2.6.16, so looking at that one
for old semantics:

 - it first does a wakeup_pdflush() which does a truely asynchronous
   writeback of everything in the system.  This is replaced with a
   wakeup_flusher_threads(0) in 3.0, which has pretty similar sematics.
 - after that things change a bit as we reordered sync quite a bit too
   a) improve data integrity by properly ordering the steps of the sync
   and b) shared code between the global sync and per-fs sync as
   used by umount, sys_syncfs and a few other callers.  But both do
   an semi-sync pass and a sync pass on per-sb writeback.  For the old
   code it's done from the calling threads context, while the next code
   moved it to the flushers thread, but still waiting for it with the
   completion.  No major change in semantics as far as I can see.

The idea of the async pass is to start writeback on as many as possible
pages before actively having to wait on them.  I'd agree with your
assessment that the writeback_inodes_sb might not really help all that
much - given that a lot of the waiting might not actually be for I/O
completion but e.g. for the block level throtteling (or maybe cgroups
in your case?).

For sys_sync I'm pretty sure we could simply remove the
writeback_inodes_sb call and get just as good if not better performance,
but we'd still need a solution for the other sync_filesystem callers,
assuming the first write actually benefits them.  Maybe you can run
some sys_syncfs microbenchmarks to check it?  Note that doing multiple
passes generally doesn't actually help live-lock avoidance either, but
wu has recently done some work in that area.

Another thing we've discussed a while ago is changing sync_inodes_sb
to the writeback or at least the waiting back in the calling threads
context to not block the flushers threads from getting real work done.
