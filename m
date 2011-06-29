Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab1F2SAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:00:14 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60769
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313Ab1F2SAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:00:11 -0400
Date: Wed, 29 Jun 2011 14:00:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Curt Wohlgemuth <curtw@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110629180010.GB32236@infradead.org>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
 <20110629005422.GQ32466@dastard>
 <BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
 <20110629081155.GA5558@infradead.org>
 <BANLkTinoFOnQoo3k3KiDgqd7+uBH6shNesxhmVRo9wWr0WCkEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinoFOnQoo3k3KiDgqd7+uBH6shNesxhmVRo9wWr0WCkEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:26:33AM -0700, Curt Wohlgemuth wrote:
> The semantics did change between 2.6.34 and 2.6.35 though.  When the
> work item queue was introduced in 2.6.32, the semantics changed from
> what you describe above to what's present through 2.6.34:
> writeback_inodes_sb() would enqueue a work item, and return.  Your
> commit 83ba7b07 ("writeback: simplify the write back thread queue")
> added the wait_for_completion() call, putting the semantics back to
> where they were pre-2.6.32.

Yes.  The kernels inbetween had that nasty writeback vs umount races
that we could trigger quite often.

> Though one additional change between the old way (pre-2.6.32) and
> today:  with the old kernel, the pdflush thread would operate
> concurrently with the first (and second?) sync path through writeback.
>  Today of course, they're *all* serialized.  So really a call to
> sys_sync() will enqueue 3 work items -- one from
> wakeup_flusher_threads(), one from writeback_inodes_sb(), and one from
> sync_inodes_sb().

Yes.  And having WB_SYNC_NONE items from both wakeup_flusher_threads vs
writeback_inodes_sb is plain stupid.  The initial conversion to the
new sync_filesystem scheme had removed the wakeup_flusher_threads
call, but that caused a huge regression in some benchmark.  

As mentioned before Wu was working on some code to introduce tagging
so that the WB_SYNC_ALL call won't start writing pages dirtied after
the sync call, which should help with your issue.  Although to
completely solve it we really need to get down to just two passes.
