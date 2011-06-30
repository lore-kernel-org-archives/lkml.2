Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1F3MQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:16:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1F3MQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:16:00 -0400
Date: Thu, 30 Jun 2011 14:15:58 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Curt Wohlgemuth <curtw@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110630121558.GF28475@quack.suse.cz>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
 <20110629005422.GQ32466@dastard>
 <BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
 <20110629081155.GA5558@infradead.org>
 <20110629165714.GF17590@quack.suse.cz>
 <20110629175534.GA32236@infradead.org>
 <20110629191518.GA23196@quack.suse.cz>
 <20110629201234.GA31129@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629201234.GA31129@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 29-06-11 16:12:34, Christoph Hellwig wrote:
> On Wed, Jun 29, 2011 at 09:15:18PM +0200, Jan Kara wrote:
> >   True but writeback_single_inode() has in it:
> >         if (wbc->sync_mode == WB_SYNC_ALL) {
> >                 int err = filemap_fdatawait(mapping);
> >                 if (ret == 0)
> >                         ret = err;
> >         }
> >   So we end up waiting much earlier. Probably we should remove this wait
> > but that will need some audit I guess.
> 
> Uhh, indeed.  We'll need this wait for things like sync_inode, though.
  Yes. Actually, specifically for filesystems like XFS which update inode
after IO completion we would need more passes to be efficient and correct:
  for all inodes
    fdatawrite
  for all inodes
    fdatawait
  for all inodes
    write_inode
  for all inodes
    wait for inode IO

  But maybe this could be handled by having new WB_SYNC_ mode indicating
that writeback_single_inode() should not bother waiting (thus we'd really
end up waiting in sync_inodes_sb()) and then XFS and other filesystems that
need it would writeout inodes in their sync_fs() implementation (possibly
using a generic helper)?
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
