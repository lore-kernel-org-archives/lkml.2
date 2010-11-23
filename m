Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab0KWAlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:41:15 -0500
Received: from cobra.newdream.net ([66.33.216.30]:57844 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab0KWAlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:41:14 -0500
Date: Mon, 22 Nov 2010 16:45:31 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Greg KH <greg@kroah.com>
cc: Yehuda Sadeh <yehuda@hq.newdream.net>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rbd: replace the rbd sysfs interface
In-Reply-To: <20101123001439.GB31294@kroah.com>
Message-ID: <Pine.LNX.4.64.1011221626430.18814@cobra.newdream.net>
References: <1289953929-30896-1-git-send-email-yehuda@hq.newdream.net>
 <20101117171924.GC12050@kroah.com> <AANLkTims_MjBS1SdHkOjOWvGqg1aRABH23MWk8J-E+-Y@mail.gmail.com>
 <20101118013002.GC8558@kroah.com> <AANLkTi=7z40CNBUmfVUEa68J+1R=7nbn9d8vM7ETpajA@mail.gmail.com>
 <20101119020820.GB18767@kroah.com> <1290468787.1792.63.camel@yehudasa-desktop>
 <20101123001439.GB31294@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, 22 Nov 2010, Greg KH wrote:
> On Mon, Nov 22, 2010 at 03:33:07PM -0800, Yehuda Sadeh wrote:
> > 
> > 
> > On Fri, Nov 19, 2010 at 12:42 PM, Yehuda Sadeh Weinraub <yehuda@hq.newdream.net> wrote:
> > > One solution would be to create kobjects for (3) and for (4), without
> > > using a group name. Another way, we can create groups for (2), and (3)
> > > under (1), but that's about it, you can't create the snap specific
> > > directory this way without resorting to some internal sysfs directory
> > > creation, which will be horribly wrong. At that point we don't have
> > > anything for 'snaps', and we don't really need to do any operations
> > > under that directory, we just need it to exist so that it contains the
> > > snapshot-specific directories.
> > >
> > > Another way would be to create a group for (2) under (1) and create a
> > > kobject for (3), for which you can create group per snapshot.
> > >
> > > Am I missing something? We already have the first solution (kobjects
> > > only) implemented, is there some real benefit for using the third
> > > method? We'll have to manually add remove groups anyway, as snapshots
> > > can be removed and new snapshots can be added.
> > >
> > 
> > And following is the implementation for the first solution. It has a device
> > for the rbd_dev, a kobject for the top snapshot directory and a kobject per
> > snapshot. Please let me know if there's any issue with this implementation.
> > We'd like to get this fixed for 2.6.37 and considering the large patch,
> > it'd be nice getting an ack for it.
> 
> It's way too late for .37, as this is new stuff, right?

Well, that's the problem.  The current sysfs interface was based on 
osdblk's.  That part didn't come up during review, and I wasn't aware that 
the sysfs interface should get an explicit ack from you.  After RBD was 
merged in 2.6.37-rc1 I saw part of the SCST sysfs thread and realized the 
current interface was problematic, and we've been trying to work out how 
to fix it ever since.

As things stand, we can either
 1- wait, get an osdblk-like interface in 2.6.37, and change it later (a 
    big fat no-no, as I understand things!)
 2- get an improved sysfs interface sorted out and push to Linus ASAP (my 
    preference)
 3- have Linus revert RBD altogether :(

I'm hoping for #2, but we may need a bit more help from you unfortunately!  

Basically:
 - We keep putting the <snaps> in a subdir because can be arbitrarily 
named, and we don't want them to collide with the other attributes.  It's 
that or prefixing them with something like "snap_", but that seems uglier.
 - They are only there to expose some information to the user.

Thanks!
sage
