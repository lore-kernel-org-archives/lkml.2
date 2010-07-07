Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab0GGC5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 22:57:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:48962 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0GGC5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 22:57:48 -0400
Date: Wed, 7 Jul 2010 12:57:26 +1000
From: Neil Brown <neilb@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       "J. Bruce Fields" <bfields@fieldses.org>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100707125726.3695587a@notabene.brown>
In-Reply-To: <20100707021150.GF25018@dastard>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<871vbn2mk9.fsf@linux.vnet.ibm.com>
	<20100702064108.64034561@notabene.brown>
	<87iq4y29a6.fsf@linux.vnet.ibm.com>
	<20100706161002.GD7387@fieldses.org>
	<87eifgfsez.fsf@linux.vnet.ibm.com>
	<20100706232351.GD25018@dastard>
	<20100707093629.10c2feab@notabene.brown>
	<20100707021150.GF25018@dastard>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010 12:11:50 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Jul 07, 2010 at 09:36:29AM +1000, Neil Brown wrote:
> > On Wed, 7 Jul 2010 09:23:51 +1000
> > Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > > I can add a new syscall that returns 
> > > > 
> > > > struct fs_uuid {
> > > >        u8 fs_uuid[16];  
> > > > };
> > > > 
> > > > long sys_get_fs_uuid(int dfd, char *name, struct fs_uuid *fsid, int flag);  
> > > 
> > > libblkid already provides the UUID to userspace applications, doesn't it?
> > 
> > Yes and no.
> > 
> > libblkid provides the uuid of the thing that uses a block device.  That
> > doesn't directly map to "UUID of a filesystem".
> 
> True.
> 
> > There are two types of filesystem that I can think of for which libblkid
> > cannot give a uuid.
> >   - network filesystems (or virtual filesystems, or fuse )
> 
> How would you guarantee persistent uniqueness for such filesystems?

Persistent shouldn't be too hard in many cases.
What uniqueness guarantees do we have anyway?  Mostly stochastic I expect.


> 
> >   - filesystems which share a block device, such as btrfs.
> >     btrfs can have 'subvols' - multiple "filesystems" within
> >     the one (set of) block device(s).  libblkid cannot be asked about these
> >     different subvols.
> > 
> > libblkid is useful, but not a real solution.
> 
> So libblkid doesn't cover everything, but I think my question is
> still valid - if we want per-filesystem UUIDs, why a syscall and not
> just publishing it somewhere where we already publish per-mount
> information?  e.g. in /proc/mounts?

The trouble with /proc/mounts is that it is somewhat clumsy to parse
(remember to handle \0ctal escapes) and doesn't include major/minor number
which is the primary key for identifying filesystems in Linux
(see /sys/class/bdi/MAJOR:MINOR which is e.g. the best place to configure
read-ahead for a filesystem).

So /proc/mounts could work (and would probably be better than a new syscall)
but I would really rather see something sane in /sys for
inspecting/configuring filesystems (rather than each filesystem doing their
own independent thing in /sys/fs).

NeilBrown

