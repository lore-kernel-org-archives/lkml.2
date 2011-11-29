Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1K2LHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:07:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab1K2LHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:07:00 -0500
Date: Tue, 29 Nov 2011 06:06:21 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Jan Kara <jack@suse.cz>
cc: Valerie Aurora <val@vaaconsulting.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        esandeen@redhat.com, Surbhi Palande <csurbhi@gmail.com>
Subject: Re: [PATCH] deadlock with suspend and quotas
In-Reply-To: <20111129102156.GA7463@quack.suse.cz>
Message-ID: <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20111128150400.GE6366@quack.suse.cz> <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz> <20111129102156.GA7463@quack.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue 29-11-11 11:19:01, Jan Kara wrote:
>   Hi,
> 
> On Mon 28-11-11 18:32:18, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > Where can I get that patch set?
> > > 
> > > We are experiencing other similar deadlocks on RHEL-6, caused by sync or 
> > > background writeback (these code paths take s_umount and wait trying to do 
> > > I/O), but I wasn't able to reproduce these deadlocks on upstream kernel? 
> > > Are there other known deadlock possibilities?
> > 
> > I found some patch named "[RFC PATCH 1/3] VFS: Fix s_umount thaw/write 
> > deadlock" (I couldn't find the next two parts of the patch in the 
> > archives). And the patch looks wrong:
>   Yes, that seems to be the series. I generally agree with you that the
> last iteration still had some problems and some changes were requested.
> That's why it's not merged yet after all...
> 
> > - down_read_trylock(&sb->s_umount) doesn't fix anything. The lock is not 
> > held when the filesystem is frozen and it is taken for write when thawing. 
> > Consequently, any task can succeed with down_read_trylock(&sb->s_umount) 
> > on a frozen filesystem and if this tasks attempts to do an I/O that is 
> > waiting for thaw, it may still deadlock.
>   Agreed.
> 
> > - skipping sync on frozen filesystem violates sync semantics. 
> > Applications, such as databases, assume that when sync finishes, data were 
> > written to stable storage. If we skip sync when the filesystem is frozen, 
> > we can cause data corruption in these applications (if the system crashes 
> > after we skipped a sync).
>   Here I don't agree. Filesystem must guarantee there are no dirty data on
> a frozen filesystem.

This is technically impossible to achieve on ext2, fat or other 
non-transactional filesystems. These filesystems have no locks around code 
paths that set data or inodes dirty. And you still need working sync for 
ext2. So the best thing to do in sync is to wait until the filesystem is 
unfrozen.

> Ext4 and XFS do this, ext3 would need proper
> page_mkwrite() implementation for this but that's the problem of ext3, not
> freezing code in general. If there are no dirty data, sync code (and also
> flusher thread) is free to return without doing anything.
> 
> That being said, it is hard to implement freeze handling in page_mkwrite()
> in such a way that there would be no dirty pages (but we know there cannot
> be dirty data in such pages). Currently we mark the page dirty during page
> fault and wait for frozen filesystem only after that so that we are
> guaranteed that either freezing code will wait for page fault to finish and
> will write the page or page fault code notices that freezing is in progress
> and blocks (see fs/buffer.c:block_page_mkwrite()).
> 
> So I believe the consensus was that we should not block sync or flusher
> thread on frozen filesystem. Firstly, it's kind of ugly from user
> perspective (you cannot sync filesystems on your system while one
> filesystem is frozen???), secondly, in case of flusher thread it has some
> serious implications if there are more filesystems on the same device - you
> would effectively stop any writeback to the device possibly hanging the
> whole system due to dirty limit being exceeded. So at least in these two
> cases we should just ignore frozen filesystem.

For background writes I agree, that they should skip frozen filesystems. 
But for synchronous writes (sync) must wait, at least on non-transactional 
filesystems.

> > - I'm not sure what userspace quota subsystem will do if we start 
> > returning -EBUSY spuriously.
>   Quota tools will complain to the user which would be fine I think. But
> blocking is fine as well. In this particular case I don't care much but it
> should be consistent with what happens to sync. So probably Q_SYNC command
> should ignore frozen filesystem, Q_SETQUOTA or Q_SETINFO should block.
> 
> > There is another thing --- I wasn't able to reproduce these sync-related 
> > deadlocks at all. Did anyone succeeded in reproducing them? Are there any 
> > reported deadlocks? When freezing the ext3 or ext4 filesystem, the kernel 
> > prevents creating new dirty data, syncs all data, and freezes the 
> > filesystem. Consequently, the sync function never finds any dirty data and 
> > so it doesn't block (sync doesn't writeback ATIME change, I don't know 
> > why).
>   See above why sync can actually spot some dirty inodes/page (although
> there is not any dirty data). Surbhi (added to CC) from Canonical could
> actually trigger these races and consequent deadlocks (and I belive some of
> their customers as well). Also some RH customers were hitting these
> deadlocks (Eric Sandeen was handling those bugs AFAIK) but those were made
> happy by my changes to block_page_mkwrite() which made the race window much
> narrower.

Mikulas
