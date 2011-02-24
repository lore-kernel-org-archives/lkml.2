Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1BXRjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:39:06 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33530 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab1BXRjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:39:02 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        djwong <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
In-reply-to: <20110224164758.GH23042@quack.suse.cz>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com> <yq1vd0cf26f.fsf@sermon.lab.mkp.net> <20110223202446.GG4020@noexit> <1298493173-sup-8301@think> <20110224164758.GH23042@quack.suse.cz>
Date: Thu, 24 Feb 2011 12:37:53 -0500
Message-Id: <1298566775-sup-730@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D6697A6.0265:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Jan Kara's message of 2011-02-24 11:47:58 -0500:
> On Wed 23-02-11 15:35:11, Chris Mason wrote:
> > Excerpts from Joel Becker's message of 2011-02-23 15:24:47 -0500:
> > > On Tue, Feb 22, 2011 at 11:45:44AM -0500, Martin K. Petersen wrote:
> > > > Also, DIX is only the tip of the iceberg. Many other impending
> > > > technologies feature checksums and require pages to be stable during I/O
> > > > due to checksumming, encryption and so on.
> > > > 
> > > > The VM is already trying to do the right thing. We just need the
> > > > relevant filesystems to catch up.
> > > 
> > >     ocfs2 handles stable metadata for its checksums when feeding
> > > things to the journal.  If we're doing pagecache-based I/O, is the
> > > pagecache going to help here for data?
> > 
> > Data is much easier than metadata.  All you really need is to wait on
> > writeback in file_write, wait on writeback in page_mkwrite, and make
> > sure you don't free blocks back to the allocator that are actively under
> > IO.
> > 
> > I expect the hard part to be jbd and metadata in ext34.
>   But JBD already has to do data copy if a buffer is going to be modified
> before/while it is written to the journal. So we should alredy do all that
> is needed for metadata. I don't say there aren't any bugs as they could be
> triggered only by crashing at the wrong moment and observing fs corruption.
> But most of the work should be there...

Most of it is there, but there are always little bits and pieces.  The
ext4 journal csumming code was one semi-recent example where we found
metadata changing in flight.

A big part of testing this is getting some way to detect the bugs
without dif/dix.  With btrfs I have patches to do set_memory_ro on
pages once I've don the crc, hopefully we can generalize that idea or
some up with something smarter.

-chris
