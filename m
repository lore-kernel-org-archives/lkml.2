Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab1CIW2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:28:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1CIW2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:28:46 -0500
Date: Thu, 10 Mar 2011 09:28:37 +1100
From: NeilBrown <neilb@suse.de>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: MD-raid broken in 2.6.37.3?
Message-ID: <20110310092837.7b52cccd@notabene.brown>
In-Reply-To: <20110309192642.GA4098@localhost>
References: <20110309090622.GA3570@localhost>
	<20110309210251.744ef954@notabene.brown>
	<20110309192642.GA4098@localhost>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011 20:26:42 +0100 Johan Hovold <jhovold@gmail.com> wrote:

> On Wed, Mar 09, 2011 at 09:02:51PM +1100, NeilBrown wrote:
> > On Wed, 9 Mar 2011 10:06:22 +0100 Johan Hovold <jhovold@gmail.com> wrote:
> > 
> > > Hi Greg and Neil,
> > > 
> > > I updated from 2.6.37.2 to 2.6.37.3 yesterday only to find that my
> > > raid-0 partitions are no longer recognised. The raid-1 ones still are,
> > > though. They did not show up after a reboot. (It has happened once
> > > fairly recently that these exact partitions were not recognised but a
> > > reboot fixed it -- blamed my disks.)
> > > 
> > > Today I mistakenly booted into 2.6.37.3 again -- still missing. No
> > > problems with 2.6.37.2.
> > > 
> > > Browsing the changelog I found f663ed60892c3e1d4490b079a45d9e546271c40c
> > > (md: Fix - again - partition detection when array becomes active) and
> > > other md-related changes so I figure one of these could perhaps be to
> > > blame?
> > > 
> > > As it is my personal/production machine I feel uncomfortable bisecting
> > > this at this point, but maybe Neil has an idea of what might be going
> > > on?
> > 
> > Hi Johan,
> > 
> >  could you please be a bit more specific about the problem that you
> > experienced.
> > What, exactly, was "no longer recognised"?
> > 
> > Was it that the array (e.g. /dev/md1) didn't appear, or was it that the
> > array did appear, but that it has a partition table, and the partitions
> > (e.g. /dev/md1p1, /dev/md1p2) did not appear?
> 
> It's the whole array that is missing. The raid-1 arrays appear but the
> raid-0 does not.

Based on that I am very confident that the problem is not related to
an md patches in 2.6.37.3 - and your own testing below seems to confirm that.

> 
> > If you still have the boot-log from when you booted 2.6.37.3 (or can
> > recreated) and can get a similar log for 2.6.37.2, then it might be useful to
> > compare them.
> 
> Attaching two boot logs for 2.6.37.3 with /dev/md6 missing, and one for
> 2.6.37.2.
> 
> Note that md1, md2, and md3 have v0.90 superblocks, whereas md5 and md6 have
> v1.20 ones and are assembled later.
> 
> When /dev/md6 is successfully assembled, through the gentoo init scripts
> calling "mdadm -As", the log contains:
> 
> 	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sda6>
> 	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sda5>
> 	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sdb5>
> 	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sdb6>

This doesn't look like the output that would be generated if
"mdadm -As" were used.
in that case you would expect to see the two '5' devices together and the
two '6' devices together.
e.g
   sda5
   sdb5
   sda6
   sdb6

This looks more like the result of "mdadm -I" being called on various devices
as udev discovers them and gives them to mdadm (it could be "mdadm
--incremental" rather than "-I").

This suggests that there is some race somewhere that is causing either a6 or
b6 to be missed, either by udev or by mdadm - probably mdadm.

I would suggest that you check if "mdadm -I" is being called by some
udev rules.d files (/liub/udev/rules.d/*.rules or /etc/udev/rules.d/*.rules)

Then maybe try to enable some udev tracing to get a log of everything it
does.  Then if this is something that you want to pursue, post to
  linux-raid@vger.kernel.org
with as many details as you can.

Thanks,
NeilBrown



> 
> and when it fails, either the sda6 or sdb6 bind is missing:
> 
> 	messages.3-1:Mar  8 20:04:39 xi kernel: md: bind<sda6>
> 	messages.3-1:Mar  8 20:04:39 xi kernel: md: bind<sdb5>
> 	messages.3-1:Mar  8 20:04:39 xi kernel: md: bind<sda5>
> 
> 	messages.3-2:Mar  8 20:41:09 xi kernel: md: bind<sdb6>
> 	messages.3-2:Mar  8 20:41:09 xi kernel: md: bind<sdb5>
> 	messages.3-2:Mar  8 20:41:09 xi kernel: md: bind<sda5>
> 
> I mentioned that something similar had happened before, but that a
> reboot fixed it. Tonight I cannot seem to be able to reproduce the
> issue, so it's could very well be that the problem lies elsewhere and
> that only slightly changed timings or such made it appear three times in
> a row in the three first 2.6.37.3 boots (with 2.6.37.2 working in
> between)...
> 
> Thanks,
> Johan

