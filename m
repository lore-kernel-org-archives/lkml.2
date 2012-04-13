Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2DMNYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:24:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab2DMNYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:24:02 -0400
Date: Fri, 13 Apr 2012 09:23:52 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: Thinkpad hda regression in 3.3
Message-ID: <20120413132352.GD25425@zod.bos.redhat.com>
References: <20120413124306.GC25425@zod.bos.redhat.com>
 <s5hpqbbvkzo.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hpqbbvkzo.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 03:07:07PM +0200, Takashi Iwai wrote:
> At Fri, 13 Apr 2012 08:43:06 -0400,
> Josh Boyer wrote:
> > 
> > Hi Takashi and Jaroslav,
> > 
> > We've had a number of bugs reported about sound not working correctly on
> > various models of Thinkpad machines in the 3.3 kernel.  I've listed them
> > below.
> > 
> > I looked through the commits and found:
> > 
> >     commit 29c5fbbcfefba5225a6783683c46c39e10877703:
> > 
> >     ALSA: HDA: Use model=auto for Thinkpad T510
> > 
> >     The user reports that model=auto works fine for him. Using
> >     model=auto bring in new features such as jack detection notification
> >     to userspace.
> > 
> > I did a local build here with that comment reverted and so far most of
> > the people reported their sound to be working again.  The trivial revert
> > patch is below in case you want it.
> 
> Could you get alsa-info.sh output on the non-working T510?
> If it's really about the built-in speaker or headphone jack, I doubt
> it's rahter the muted output in mixer.  I see only "me too" in the bug
> report, which doesn't help much to diagnose the problem.

OK, I've asked for that.

> I've got a few positive feedbacks of T410 and T510, so basically the
> driver should work.  But I know the problem of docking-station (see
> below).
> 
> 
> > It seems there are multiple models that have PCI ID 17aa:215e and using
> > model=auto does not work for them all.  It particularly messes with
> > machines using a docking station for some reason.
> > 
> > Aside from just reverting the above commit, do you have other thoughts
> > on how to fix this?
> 
> The problem regarding the docking station is basically a BIOS issue.
> ThinkPad BIOS doesn't expose the pins for docking stations at all.
> We have already a workaround for X200, and similar others would be
> needed for T410, T420, etc.
> 
> For testing, you don't need even patch the driver.  When the driver is
> built with CONFIG_SND_HDA_PATCH_LOADER=y, create a file containing the
> below as /lib/firmware/alsa-tp-dock:
> 
> ================================================================
> [codec]
> 0x14f15069 0x17aa21a4 0
> 
> [pincfg]
> 0x1a 0x21a11000
> 0x1c 0x23014250
> ================================================================

The above is for the X200 docking station, correct?  So it should work
with an x201 thinkpad in an x200 dock.

> then pass the module option patch="alsa-tp-dock" to snd-hda-intel,
> e.g. create a file containing below in /etc/modprobe.d/*
> 
> 	options snd-hda-intel patch="alsa-tp-dock"
> 
> This will override the pin-default values of 0x1a and 0x1c, which
> corresponds to the docking-station mic and docking-station output.
> This will set dock-out as the line-out so that the built-in headphone
> is preferred over it.
> 
> Note that after applying this, the new mixer elements will appear, so
> you'd need to adjust the values manually once.
> 
> Similarly, for T420, create a file with the contents below instead:
> 
> ================================================================
> [codec]
> 0x14f1506e 0x17aa21d2 0
> 
> [pincfg]
> 0x19 0x0421104f
> 0x1a 0x21a19050
> 0x1c 0x2121401f
> ================================================================
> 
> The rest procedure is same.
> 
> If the above seem work (again, make sure that you adjust the mixer
> mutes and levels), I'll make kernel patches to add these fixups
> statically in the driver so that it works without extra patching.

OK.  I'll have the reporters test this out.

josh
