Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1HDJ1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:27:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47061 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab1HDJ1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:27:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH] PM / Freezer: Freeze filesystems along with freezing processes (was: Re: PM / hibernate xfs lock up / xfs_reclaim_inodes_ag)
Date: Thu, 4 Aug 2011 11:27:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Nigel Cunningham <nigel@tuxonice.net>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Christoph <cr2005@u-club.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
References: <4E1C70AD.1010101@u-club.de> <201108032315.06012.rjw@sisk.pl> <20110803172922.GA2126@ucw.cz>
In-Reply-To: <20110803172922.GA2126@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108041127.30944.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 03, 2011, Pavel Machek wrote:
> Hi!
> 
> > Freeze all filesystems during the freezing of tasks by calling
> > freeze_bdev() for each of them and thaw them during the thawing
> > of tasks with the help of thaw_bdev().
> > 
> > This is needed by hibernation, because some filesystems (e.g. XFS)
> > deadlock with the preallocation of memory used by it if the memory
> > pressure caused by it is too heavy.
> > 
> > The additional benefit of this change is that, if something goes
> > wrong after filesystems have been frozen, they will stay in a
> > consistent state and journal replays won't be necessary (e.g. after
> > a failing suspend or resume).  In particular, this should help to
> > solve a long-standing issue that in some cases during resume from
> > hibernation the boot loader causes the journal to be replied for the
> > filesystem containing the kernel image and initrd causing it to
> > become inconsistent with the information stored in the hibernation
> > image.
> 
> > +/**
> > + * freeze_filesystems - Force all filesystems into a consistent state.
> > + */
> > +void freeze_filesystems(void)
> > +{
> > +	struct super_block *sb;
> > +
> > +	lockdep_off();
> 
> Ouch. So... why do we need to silence this?

So that it doesn't complain? :-)

I'll need some time to get the exact details here.

> > +	/*
> > +	 * Freeze in reverse order so filesystems dependant upon others are
> > +	 * frozen in the right order (eg. loopback on ext3).
> > +	 */
> > +	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
> > +		if (!sb->s_root || !sb->s_bdev ||
> > +		    (sb->s_frozen == SB_FREEZE_TRANS) ||
> > +		    (sb->s_flags & MS_RDONLY) ||
> > +		    (sb->s_flags & MS_FROZEN))
> > +			continue;
> 
> Should we stop NFS from modifying remote server, too?

What do you mean exactly?

> Plus... ext3 writes to read-only filesystems on mount; not sure if it
> does it later. But RDONLY means 'user cant write to it' not 'bdev will
> not be modified'. Should we freeze all?
> 
> How can 'already frozen' happen?
> 
> > +	list_for_each_entry(sb, &super_blocks, s_list)
> > +		if (sb->s_flags & MS_FROZEN) {
> > +			sb->s_flags &= ~MS_FROZEN;
> > +			thaw_bdev(sb->s_bdev, sb);
> > +		}
> 
> ...because we'll unfreeze it even if we did not freeze it...

So we need not check MS_FROZEN in freeze_filesystems().  OK

Thanks,
Rafael
