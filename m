Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1AFUtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:49:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab1AFUtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:49:12 -0500
Date: Thu, 6 Jan 2011 15:49:11 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110106204911.GB2872@infradead.org>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.759480620@kernel.dk>
 <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
 <20110104083132.GA4485@amd>
 <20110104092541.GC2760@infradead.org>
 <20110104095231.GB4812@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104095231.GB4812@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 08:52:31PM +1100, Nick Piggin wrote:
> OK I missed that part about not requiring dirty metadata to be written,
> just currently ongoing async operations. But then I don't understand how
> it would be used by nfsd, how does nfsd start some async operation on
> the inode metadata such that ->commit_metadata would do anything useful
> for it?

NFSD calls various inode operations (create/mkdir/mknod/link/symlink/
rename/unlink/rmdir/setattr) and then requires those operations to be
on disk before completing the request to the client, but it does not
require other dirty state to be written (data, unlogged size
or timestamp updates).  Take a look at the XFS implementation: it just
checks if the inode is still pinned (that is in the in-memory log, but
not commited to disk) and if so forces the log up to the log buffer
that contains the last changes to the inode.

