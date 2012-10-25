Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab2JYSUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:20:11 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57566 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759774Ab2JYSUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:20:09 -0400
Date: Thu, 25 Oct 2012 14:20:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-ext4@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4-fs error w/ external USB drive
Message-ID: <20121025182004.GA16257@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
References: <507C4BDA.20205@gmx.de>
 <20121019210723.GA4721@thunk.org>
 <5085923F.9050801@gmx.de>
 <20121024011128.GG28626@thunk.org>
 <5088260D.7080403@gmx.de>
 <20121024183505.GA6142@thunk.org>
 <50896B42.90606@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <50896B42.90606@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 06:39:30PM +0200, Toralf Förster wrote:
> After a lot of file operations (Gentoo emerging, kernel build, git
> pulls, ...) I s2disk the system (that with the external USB drive)
> yesterday, wake it up today, rebooted it -
> and had to manually repair the file system, because the automatic fsck
> gave up.

OK, I'm going to send another patch series which I'd hope you could
test to see if reduces the rate at which this happens.

> Nevertheless there's another Linux system I have (64bit RH EL,internal
> drive), where with kernel 3.5.4-1.el6.elrepo.x86_64 EXT4 errors occurred.
> I attached the whole appropriate section of /var/log/message.

I don't have easy access to the RHEL kernel sources, and so I don't
know which patches were applied.  Specifically, I'd really like to
know if the commit represented by 14b4ed22a6 is in RHEL
3.5.4-1.el6.elrepo.  Also, I'd like to know which line number was
reflected here, which was the first EXT4-fs error:

> Sep 26 09:26:54 x kernel: EXT4-fs error (device dm-1) in ext4_new_inode:938: IO failure

This was from fs/ext4/ialloc.c line 938, and there are two
ext4_std_error() that this could represent, so which is why having the
exact kernel sources from this RHEL kernel would be useful.  (I'd also
suggest opening a RHEL support ticket if you have a support contract,
since that way Red Hat can track this issue, and that way Eric can
count the work he's been doing on this fire drill as supporting a
customer.  :-)

What's a bit unfortunate is that there was no other error messages
before this line.  So we can't know for sure what caused or returned
the -EIO error code.  I *suspect* it was this, which would would be
indocate a corrupted inode bitmap:

	if (insert_inode_locked(inode) < 0) {
		/*
		 * Likely a bitmap corruption causing inode to be allocated
		 * twice.
		 */
		err = -EIO;
		goto fail;
	}

Do you know if this external disk could have suffered from a cable
pull, or a flaky cable, or some kind of unclean shutdown/power failure
before it rebooted?  That would be an interesting data point.  

For the future, we need to add some better error reporting for
failures such as this.  In addition, I have a recent change we made at
work that I should get upstream which avoids allocating from a block
group once we notice a corruption (currently just for the block
allocations, but I think we should do this for inode allocations as
well), to minimize the chances of lost data once we notice that the
block/inode allocation bitmap can't be trusted.  This avoids data loss
in the case where users are using the default errors=continue instead
of errors=panic or errors=remount-ro.

Speaking of which, for your production RHEL server, you might want to
seriously consider errors=panic for any critical file system volume.
This allows the file system to get corrected via e2fsck, and prevents
the server from stumbling along, possibly causing more data loss due
to a fs corruption.

Regards,

						- Ted
