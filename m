Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1GBLcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 07:32:17 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48462
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470Ab1GBLcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 07:32:14 -0400
Date: Sat, 2 Jul 2011 07:32:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Curt Wohlgemuth <curtw@google.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110702113204.GA1362@infradead.org>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
 <20110629005422.GQ32466@dastard>
 <BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
 <20110629081155.GA5558@infradead.org>
 <20110629165714.GF17590@quack.suse.cz>
 <20110629175534.GA32236@infradead.org>
 <20110629191518.GA23196@quack.suse.cz>
 <BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 03:55:33PM -0700, Curt Wohlgemuth wrote:
> One other issue I have with sync as it's structured is that we don't
> do a WB_SYNC_ALL pass on any inode that's only associated with a block
> device, and not on a mounted filesystem.  Blockdev mounts are
> pseudo-mounts, and are explicitly skipped in __sync_filesystem().  So
> if you've written directly to a block device and do a sync, the only
> pass over the pages for this inode are via the
> wakeup_flusher_threads() -- which operates on a BDI, regardless of the
> superblock, and uses WB_SYNC_NONE.
> 
> All the sync_filesystem() calls are per-sb, not per-BDI, and they'll
> exclude pseudo-superblocks.

Interesting.  I think that's actually correct by the traditional
defintion of sync, but not really useful.  I also doubt it's
intentional.

> I've seen cases in our modified kernels here at Google in which
> lilo/shutdown failed because of a lack of WB_SYNC_ALL writeback for
> /dev/sda (though I haven't been able to come up with a consistent test
> case, nor reproduce this on an upstream kernel).

lilo really should do an fsync of the partition it installed itself
into.  That's won't only fix this issue, but also has a lot less impact
on the rest of the system.

