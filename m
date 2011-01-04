Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab1ADOWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:22:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab1ADOWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:22:06 -0500
Subject: Re: [patch 7/8] fs: fix or note I_DIRTY handling bugs in
 filesystems
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com,
        joel.becker@oracle.com
In-Reply-To: <20110103165821.GA1336@infradead.org>
References: <20101218014634.943276411@kernel.dk>
	 <20101218015117.652706340@kernel.dk> <20101229150108.GA13358@infradead.org>
	 <1294067009.2429.109.camel@dolmen>  <20110103165821.GA1336@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 04 Jan 2011 14:22:06 +0000
Message-ID: <1294150926.2455.31.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2011-01-03 at 11:58 -0500, Christoph Hellwig wrote:
> On Mon, Jan 03, 2011 at 03:03:29PM +0000, Steven Whitehouse wrote:
> > 
> >  - With "journaled data" files
> >    - Do a log flush conditional upon the inode's glock
> >    - The core code then writes back any dirty pages
> 
> Any data writeback is done before calling ->fsync.
> 
> >  - With regular files/directories
> >   - If datasync is not set, we need to write back the metadata including
> > timestamp updates, so that is done via ->write_inode. Note that an extra
> > complication here is that we need to get the glock on the inode if we
> > don't already have it in order to check and conditionally update the
> > atime.The call to ->write_inode includes an implicit (conditional) log
> > flush.
> >  - If datasync is set, we assume that only the data pages need to be
> > written out. My understanding of datasync was that it was only supposed
> > to write out data and never any of the metadata. The reason for the call
> > to flush the log for "stuffed" files is that the data shares a disk
> > block with the inode metadata, so we cannot avoid the log flush in this
> > case, since we must unpin the block to write it back.
> 
> What happens to indirect blocks, inode size updates, etc?  In general
> the only correct form to use the datasync argument is along the lines
> of:
> 
> 	if ((inode->i_state & I_DIRTY_DATASYNC) ||
> 	    ((inode->i_state & I_DIRTY_SYNC) && !datasync)) {
> 		/* write out the inode */
> 	} else {
> 		/*
> 		 * VFS inode not dirty, no need to write it out.
> 		 *
> 		 * If the filesystem support asynchronous inode writes,
> 		 * we may have to wait for them here.
> 		 */
> 	}
> 
> or rather mostly correct, as pointed out by Nick in this series, that's
> why the above gets replaced with an equivalent check that also
> participates in the writeback locking protocol in this series.
> 
Yes, that looks much better than what we have at the moment.

> For gfs2 on current mainline an fsync respecting that would look like:
> 
> static int gfs2_fsync(struct file *file, int datasync)
> {
> 	struct inode *inode = file->f_mapping->host;
> 	struct gfs2_inode *ip = GFS2_I(inode);
> 	int ret = 0;
> 
> 	if (gfs2_is_jdata(ip) {
> 		gfs2_log_flush(GFS2_SB(inode), ip);
> 		return 0;
> 	}
> 
> 	if ((inode->i_state & I_DIRTY_DATASYNC) ||
> 	    ((inode->i_state & I_DIRTY_SYNC) && !datasync))
> 		sync_inode_metadata(inode, 1);
> 	else if (gfs2_is_stuffed(ip))
> 		gfs2_log_flush(GFS2_SB(inode), ip->i_gl);
> }
> 
> Note that the asynchronous write_inode_now is replaced with a
> sync_inode_metadata, which doesn't incorrectly write data again, and
> makes sure we do a synchronous write.
>
> I'm still not quite sure how the gfs2_log_flush are supposed to work.
> What's the reason we don't need the ->write_inode call for journaled
> data mode?  Also is it guaranteed that we might not have an asynchronous
> transaction that update the inode in the log, e.g. why doesn't gfs2
> need some sort of log flush even if the VFS inode is not dirty, unlike
> most other journaled filesystems.
> 

I think that has just been missed due to the way in which the code has
developed. It appears to be needed to me, but originally all the
timestamp updates were handled internally by GFS2 and in a synchronous
manner, so that there was no need for ->write_inode() in that case. I
think that needs to be added now the vfs looks after atime updates
though, in order to be correct.

After the log flush there should also be a write on the metadata mapping
as per the inode_go_sync() function which is very similar (but not quite
similar enough to use the same code, I think) function,

Steve.


