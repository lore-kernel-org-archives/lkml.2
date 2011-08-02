Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1HBO1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:27:19 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53501 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab1HBO1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:27:11 -0400
Date: Tue, 2 Aug 2011 10:27:08 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: corrupted ext4 1000gb filesystem (2.6.32, debian stable)
Message-ID: <20110802142708.GA2967@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Luke Kenneth Casson Leighton <luke.leighton@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAPweEDyUJZ8ggm0zhMquKNM6Kd-ejjUXrCMR3TnJngukSHAFkw@mail.gmail.com>
 <CAPweEDyW9aTKJzUrVdANjK5mG0DW9+R4GRCG5_oaaX8RTEezwg@mail.gmail.com>
 <CAPweEDxo1_KaHSmqjg6YJz688g0=wsb4n3fZ0YRiUK_NWt_Kww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPweEDxo1_KaHSmqjg6YJz688g0=wsb4n3fZ0YRiUK_NWt_Kww@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 02:14:19PM +0100, Luke Kenneth Casson Leighton wrote:
> On Tue, Aug 2, 2011 at 1:15 AM, Luke Kenneth Casson Leighton
> <luke.leighton@gmail.com> wrote:
> 
> > ok, um... i have a bit more information about this situation, to
> > report.  two consecutive runs of fsck.ext4, and the filesystem still
> > reports errors after the first run "corrected" all errors. i'd say
> > that was a bit serious.
> 
>  rright - apologies but i've located the likely source of the problem
> - e2fsck.  the issue is that the bitmaps for the 3-way RAID1 mirror
> were corrupted.  thus, the filesystem would be fixed by e2fsck, only
> to be completely buggered up by picking wildly inappropriate sections
> of the drive... that presumably by either bad luck or by a powercut
> and writes occurring at the time happened to be on inode blocks.

E2fsck doesn't depend on the bitmaps; those are regenerated based on
the information from the inode tables.

Assuming that the disks are stable --- that is, a read from a block
returns the same contents all the time, and writes are not lost (i.e.,
after a write, reads to that block return the written data
consistently), then there should not be any corruptions found after
the first run of e2fsck fixes all errors.

That being said, there have been cases where that's not true, and I
consider that a bug in e2fsck.  

*However*, if you have a RAID1 setup where the data on the disks are
consistent, this can be the cause of much mischief.  Depending on
which disk you read from the mirror, you might get different results.
Once that's the case, all bets with e2fsck are off.

I suggest you make sure that your RAID1 mirror is stable first of all;
in general, you *have* to fix problems with the storage stack from the
lowest level on up.  First make sure the hard drives are all sane;
then make sure the partition table and/or LVM setups are sane; then
make sure any RAID setups are sane; and only *then* run a
filesystem-level checker.  This is true regardless of what file system
you use.

Finally, I strongly recommend that when you are doing this kind of
repair work, that you save a copy of everything you do useing a
program like "script".  A transcript of the e2fsck output can be
critally useful.  Reviewing the transcript can also be useful in
identifying mistakes that you might have made during the recovery
process.

Regards,

						- Ted

P.S.  Note that if you are running e2fsck, and you haven't mounted
the disk yet, if you are seeing failures after a second run of e2fsck,
then it obviously can be a failing in the ext4 kernel code.
