Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0KGOOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 09:14:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:43787 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab0KGOOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 09:14:07 -0500
Date: Sun, 7 Nov 2010 15:14:03 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alessio Igor Bogani <abogani@texware.it>, Jan Kara <jack@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] udf: Add missed protection for s_lvid_dirty
Message-ID: <20101107141403.GF5126@quack.suse.cz>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
 <20101106180530.GB13315@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101106180530.GB13315@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 06-11-10 14:05:30, Christoph Hellwig wrote:
> On Sat, Nov 06, 2010 at 06:47:08PM +0100, Alessio Igor Bogani wrote:
> > As reported in udf_sb.h the udf_sb_infoi's structure member s_lvid_dirty should
> > be protected by s_alloc_mutex. Added that mutex on a couple of places where it
> > miss.
> 
> The whole s_lvid_dirty flag doesn't make any sense to me.  As a start it
> simply duplicates s_dirty in the VFS superblock, but even more it just
> controls the dirty state of s_lvid_bh.  I think you could simply kill
> s_lvid_dirty, plus s_dirty inside udf and replace all calls to
> udf_updated_lvid with a simple mark_buffer_dirty(sbi->s_lvid_bh) and
> also get rid of all the locking around it.
  Well, I should have probably commented more on it :). The problem is that
people sometimes tend to mount CD-RW with UDF filesystem directly under
Linux.  Now LVID is updated on each allocation so if you write to the media,
the block carrying LVID is written rather often (like once per 5 seconds or
so) which quickly deteriorates that block on the media.
  So we basically want to hide the dirty bit on that buffer from VFS so that
it does not write the block so often.
  Looking at it now, cleaner fix might be to move the counters to sbi and
write them to the LVID only during umount. So that might be a nice cleanup
as well.

> While looking at this I also noticed that large parts of udf_open_lvid
> and udf_close_lvid are basically duplicate.  The only difference seems
> to be setting an integrityType of LVID_INTEGRITY_TYPE_OPEN vs
> LVID_INTEGRITY_TYPE_CLOSE and updating a few revision counters on close.
> If you're interested in working on udf that seems like a nice little
> cleanup.
  Yes, that could be cleaned up.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
