Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab2IEMzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:55:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab2IEMzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:55:35 -0400
Date: Wed, 5 Sep 2012 14:55:33 +0200
From: Jan Kara <jack@suse.cz>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Jan Kara <jack@suse.cz>, Ian Abbott <ian.abbott@mev.co.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3] UDF: Add support for O_DIRECT
Message-ID: <20120905125533.GD18051@quack.suse.cz>
References: <1343731212-4381-1-git-send-email-abbotti@mev.co.uk>
 <1346752179-28052-1-git-send-email-abbotti@mev.co.uk>
 <20120904143947.GC8656@quack.suse.cz>
 <50461A24.8070003@mev.co.uk>
 <20120905120520.GA18051@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905120520.GA18051@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-09-12 14:05:20, Jan Kara wrote:
> On Tue 04-09-12 16:11:32, Ian Abbott wrote:
> > >>1. Small files stored in the ICB (inode control block?): just return 0
> > >>from the new udf_adinicb_direct_IO() handler to fall back to buffered
> > >>I/O.  For direct writes, there is a "gotcha" to deal with when
> > >>generic_file_direct_write() in mm/filemap.c invalidates the pages.  In
> > >>the udf_adinicb_writepage() handler, only part of the page data will be
> > >>valid and the rest will be zeroed out, so only copy the valid part into
> > >>the ICB.  (This is actually a bit inefficient as udf_adinicb_write_end()
> > >>will have already copied the data into the ICB once, but it's pretty
> > >>likely that the file will grow to the point where its data can no longer
> > >>be stored in the ICB and will be moved to a different area of the file
> > >>system.  At that point, a different direct_IO handler will be used - see
> > >>below.)
> > >   Sorry, I didn't quite get this. What is the problem with copying all the
> > >data to inode in udf_adinicb_writepage() as it is now?
> > 
> > Part of the good data in the ICB outside the range being addressed
> > would get overwritten by zeroes.  This can be tested by creating a
> > UDF filesystem with 4KiB blocks and with small files stored in the
> > ICB, backed by a block device with 512 byte sectors.  Create a 2KiB
> > file with random (or non-zero) data on the file system so that its
> > data gets stored in the ICB.  Then open the file for writing without
> > truncation and with the O_DIRECT flag set, write 512 bytes at some
> > 512 byte offset within the 2KiB file and close it.  If you then
> > hexdump the file, you'll find some of the old random data has been
> > zeroed out.
>   But don't you fall back to buffered IO for files in ICB? So then no
> zeroing should happen?
  Oh, I've tested things now and the bug is in buffered write as well!
It has nothing to do with direct IO. We cannot use simple_write_begin() for
UDF when the file is in ICB. I'll write a proper fix.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
