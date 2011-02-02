Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1BBWJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:09:31 -0500
Received: from mail.atheros.com ([12.19.149.2]:32381 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab1BBWJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:09:30 -0500
Date: Wed, 2 Feb 2011 14:09:26 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Zhao, Shanyu" <shanyu.zhao@intel.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: Backporting other subsystems on Linux
Message-ID: <20110202220926.GB3035@tux>
References: <380B2771CDD78E46856E6B788D9F1997D2468080@orsmsx503.amr.corp.intel.com>
 <BD672EAEE3AD2C47A7120B0973C3FB3A50F0AC156A@SC1EXMB-MBCL.global.atheros.com>
 <380B2771CDD78E46856E6B788D9F1997D27D86D2@orsmsx503.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <380B2771CDD78E46856E6B788D9F1997D27D86D2@orsmsx503.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increasing audience.

On Wed, Feb 02, 2011 at 01:27:10PM -0800, Zhao, Shanyu wrote:
> Hi Luis,
> 
> Thank you for the quick response. When I say USB, I didn't mean USB network
> drivers, I'm talking about USB host/device controller drivers or gadget
> drivers. For example, we can backport USB3 support to, say, 2.6.28.
> 
> From what I understand, I can add any driver to your compat-wireless tree and
> build it the same way as other wireless drivers. Am I right?

That's right.

> Then your tree should really be called compat-drivers. :) I'm not sure if
> you're welcoming non-network related drivers.

I see the value in providing backport support for not just 802.11 but
other drivers as well. Today compat-wireless backports: 802.11, Bluetooth,
Ethernet, and because some of these drivers require larger components like
the Sonic Silicon Backplane (ssb) for b44 an b43, it means it also backports
a bit more.

I would be hesitant to allow for more drivers to go into compat-wireless if
it was not for the fact that I am actually getting a good slew of contributions
from other members and this helps me maintain this thing. So -- if are willing
to upkeep backport support for other non 802.11/Bluetooth/Ethernet drivers
in compat-wireless, I gladly welcome the changes.

> What's the routine of maintaining a driver in compat-xxx?

I use linux-next.git to suck out drivers and we apply backport stuff to them
during a kernel development cycle. Generic kernel backport crap goes into the
compat.git tree: new request_firmware API got added recently, so we have a
compat_firmware_class, and respective udev changes. Things that are specific to
the stuff you are backport get stuffed into the compat-wireless.git tree.
Typically this involves patches which apply onto the linux-next.git code we
suck out which we cannot backport through compat.git. Preference is to always
push for compat.git changes over some nasty patch with ifdefs, and only leave
as a last resort uses patches on compat-wireless. The patches in
compat-wireless patches/ directory are sorted by the API change that requires
patching the kernel. This helps add support for new drivers that we want to add
to compat-wireless. The offsets for patches are adjusted regularly through some
Quilt magic that Hauke Mehrtens implemented (./scripts/admin-update refresh).
When crap fails to compile we either remove the driver or fix it. PCMCIA for
example was deemed as pointless to backport on our last Linux wireless summit
so there is some desire to remove all that crap but so far no one has so we go
on with it.

> Do you periodically
> run compat-xxx along with compat and latest kernel (mainstream) and fix any
> patch that no longer applies cleanly? How about stable kernel like 2.6.35.3?
> How do you align compat, compat-wireless and mainstream kernel?

Apart from bleeding edge code from linux-next.git, I also make branches for
both compat-wireless.git and compat.git for each stable kernel release. This
follows the model H. Peter Anvin has implemented in the maintenance of the
linux-2.6-allstable.git tree. When a branch there say on linux-2.6.36.y gets a new
extraversion and I know it has some juicy stuff I update my linux-2.6.36.y trees
as well and make a release through the stable compat-wireless page:

http://wireless.kernel.org/en/users/Download/stable/

It used to be that we only made bleeding edge releases based on linux-next.git but
that proved too unstable for some users.

Check out the ChangeLog for the latest stable compat-wireless, I have automated
the ChangeLog release to include the git shortlog of all components involved
between each stable kernel release.

The next question you have which you have not asked me yet is how do you address
cherry picks or patches not upstream. For that I have added three directories,
they are self described by their names with a URL to their respective README:

  * linux-next-cherry-picks/ http://bit.ly/h76wrL 
  * linux-next-pending/      http://bit.ly/eY4aCY 
  * pending-stable/          http://bit.ly/dOsi7J 

What I really need to get to at some point is to use implement a
menuconfig thingy, we already drag the Kconfigs in but use config.mk for
makefile/dependency mapping. Patches welcomed.

  Luis
