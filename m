Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab0KFSFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:05:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53096 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab0KFSFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:05:40 -0400
Date: Sat, 6 Nov 2010 14:05:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] udf: Add missed protection for s_lvid_dirty
Message-ID: <20101106180530.GB13315@infradead.org>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289065631-2256-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 06:47:08PM +0100, Alessio Igor Bogani wrote:
> As reported in udf_sb.h the udf_sb_infoi's structure member s_lvid_dirty should
> be protected by s_alloc_mutex. Added that mutex on a couple of places where it
> miss.

The whole s_lvid_dirty flag doesn't make any sense to me.  As a start it
simply duplicates s_dirty in the VFS superblock, but even more it just
controls the dirty state of s_lvid_bh.  I think you could simply kill
s_lvid_dirty, plus s_dirty inside udf and replace all calls to
udf_updated_lvid with a simple mark_buffer_dirty(sbi->s_lvid_bh) and
also get rid of all the locking around it.

While looking at this I also noticed that large parts of udf_open_lvid
and udf_close_lvid are basically duplicate.  The only difference seems
to be setting an integrityType of LVID_INTEGRITY_TYPE_OPEN vs
LVID_INTEGRITY_TYPE_CLOSE and updating a few revision counters on close.
If you're interested in working on udf that seems like a nice little
cleanup.
