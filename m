Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2CUThT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:37:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2CUThM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:37:12 -0400
Date: Wed, 21 Mar 2012 14:37:06 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
        Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Michael Green <green@qca.qualcomm.com>,
        David Quan <dquan@qca.qualcomm.com>,
        Henry Ptasinski <henry@logout.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with regulatory domain support and BCM43224
Message-ID: <20120321193706.GC23643@thinkpad-t410>
Mail-Followup-To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Green <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Henry Ptasinski <henry@logout.com>, linux-kernel@vger.kernel.org
References: <4B96CD77D9161244899852B5F20DB5B70125BC94@nasanexd02d.na.qualcomm.com>
 <CAB=NE6X9c1m63xayNsEf9XZ3AgPZDV2SiRivg3SV2Day83fPQA@mail.gmail.com>
 <20120308200734.GC28133@ubuntu-macmini>
 <4F591E14.4010000@broadcom.com>
 <CAB=NE6XnorRDEu976uMkPFNKHQjhRT0Craf3ZjL9dYysPjmQng@mail.gmail.com>
 <20120320220706.GA17272@thinkpad-t410>
 <4F69B604.4030303@broadcom.com>
 <20120321141916.GA23643@thinkpad-t410>
 <4F6A1514.9090907@broadcom.com>
 <20120321181753.GC24075@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321181753.GC24075@tux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 11:17:53AM -0700, Luis R. Rodriguez wrote:
> Adding Michael and David just for their information. I know Henry
> is not with Broadcom any more but hey, hey may be interested.
> 
> On Wed, Mar 21, 2012 at 06:51:16PM +0100, Arend van Spriel wrote:
> > On 03/21/2012 03:19 PM, Seth Forshee wrote:
> > >On Wed, Mar 21, 2012 at 12:05:40PM +0100, Arend van Spriel wrote:
> > >>On 03/20/2012 11:07 PM, Seth Forshee wrote:
> > >>>On Thu, Mar 08, 2012 at 01:06:57PM -0800, Luis R. Rodriguez wrote:
> > >>>>>Hi, Seth
> > >>>>>
> > >>>>>Noticed your email yesterday, but did not get to chime into the
> > >>>>>conversation. brcmsmac does indeed provide a regulatory hint, which is
> > >>>>>either from SPROM or hard-coded to "US". Since "X0" is not a known
> > >>>>>regulatory domain for crda it does not make sense to pass it as a regulatory
> > >>>>>hint. However, the "full" story is told on linuxwireless.org (see [1]).
> > >>>>
> > >>>>The Linux kernel allows you to define custom regulatory domains, the
> > >>>>ath module uses these, it defines 13 of them. You can review that code
> > >>>>for an example of how to use them. So your X0 can still be used, you
> > >>>>just have to define the data structure.
> > >>>
> > >>>I took a shot at implementing custom regulatory domain support for
> > >>>brcmsmac. I've got it working to the point of letting me see APs on the
> > >>>DFS channels at least. The patch is below. A number of issues
> > >>>undoubtedly remain to be resolved. Some that I can think of:
> > >>
> > >>Hi Seth,
> > >>
> > >>Thanks for looking into this. I also did some tinkering over here,
> > >>but not sure which way to go here, ie. 1) define and use custom
> > >>regulatory domains, or 2) be happy with world regulatory domain as
> > >>is and do not pass the custom codes if found in sprom.
> > >
> > >For 2 I think you also have to set WIPGHY_FLAG_CUSTOM_REGULATORY or else
> > >the default world domain will still be applied. That certainly seems to
> > >be the quick-and-easy fix, but I'm not sure about what's preferable.
> > >
> > >However, I do think that passing up the custom codes as hints doesn't
> > >make sense, and the patch I sent only passes it up if it's not known to
> > >be one of the custom domains.
> > 
> > Ok. so the wiphy_apply_custom_regulatory() does not make the custom
> > domains known by their code (.alpha2).
> > 
> > >>>  - I set up two custom domains, X0 and X2, which are identical. I'm not
> > >>>    sure precisely how each needs to be set up, but I took a reasonable
> > >>>    guess.
> > >>
> > >>There are 9 custom domains in the proprietary driver. X0 only allows
> > >>using channels 1-11. X2 allows 1-13. There are other parameters like
> > >>rates and txpower that may differ.
> > >
> > >That's the kind if information I would need to make this patch viable.
> > >I'll go ahead and update the patch to remove channels 12-13 from X0, and
> > >14 from both. Are the 5 GHz rules correct?
> > 
> > 5G channels are all considered passive by brcmsmac. Not sure whether
> > that should be made explicit in the rules. Also the driver does not
> > support IBSS so those flags are redundant now, but it is good to
> > have it already in place.
> > 
> > >Are the custom domains named X[0-8]? If that's the case I can simplify
> > >some of the code.
> > 
> > Unfortunately, no.
> > 
> > >>>  - I tried to integrate with the existing X2 domain support, but this
> > >>>    could probably be improved. I avoided making large changes because
> > >>>    there's some complexity in the current code that doesn't seem to
> > >>>    serve a purpose currently, but I assume it's there for a reason.
> > >>
> > >>The code in channel.c was taken from our proprietary driver.
> > >>Basically, the LOCALES hold the same information as the rules in
> > >>regdomain.
> > >
> > >I assumed as much, but I haven't made much of an effort to understand it
> > >yet.
> > >
> > >But the complexity I'm referring to is really the infrastructure to
> > >support multiple locales and revisions that just isn't used right now. I
> > >can only assume that there are plans to use additional locales and
> > >revisions at some point.
> > 
> > Understood. The proprietary driver (which is not a mac80211 driver)
> > supports a lot of locales, which are selected on country code and
> > regulatory revision (both read from sprom). I suspect this is done
> > to support the regulatory rules for which the device was certified.
> > Revisiting channel.c is on our work list, but it would mean more
> > moving toward using the regdomain approach you started on instead of
> > locales.
> 
> Let me first explain a little on how Atheros' regulatory mapping works, hope
> this helps you.
> 
> If companies have a map of a regdomain to an alpha2 then the country alpha2
> approach makes sense. For Atheros it just so happens that some EEPROM codes map
> to a direct alpha2, which is a direct map. In other cases we have an EEPROM
> code map to a region, but such region allows usage of a card in set of
> different countries -- these countries all happen to have the same regulatory
> domain, which is why for these regions we just ask for the first alphabetical
> alpha2. Regardless of the country in the region the regulatory domain in CRDA
> is expected to be the same. Then we have 12 custom world regulatory domains
> which are exactly for that -- world roaming. In these cases we have 12 custom
> regulatory domains and disable initiating radiation on them until we know where
> we are through a country IE. We also take advantage of the beacon regulatory
> hints in this case. The custom regulatory domains should be used only if you
> really cannot map a region code to any alpha2, but consider the case of
> grouping countries together if you know the assumption was that different
> countries had the same regulatory domain. This can help simoplify your
> implementation. For more details please read:
> 
> http://wireless.kernel.org/en/users/Drivers/ath#Regulatory
> http://wireless.kernel.org/en/developers/Regulatory/processing_rules
> 
> One idea that occcurs to me to help simplify this even further is --
> for us to consider mapping a region to a set of different alpha2s, then
> send a custom regdomain building request to userspace based on these
> group of alpha2s, userpace could respond with an intersection of the
> alpha2s. CRDA already implements the capability to intersect regulatory
> domains, so the code is already there, we'd just need the hooks for
> the kernel if this is deemed desirable. This is just and idea and
> worth considering for the revamp of regulatory code.
> 
> More and more I see things like this getting complicated by the
> years, perhaps its a good time to review the possibility of getting
> together and sticking to something simple for the better or simplicity.
> I realize that the difficulty lies here in supporting other OSes, which
> is why we have worked hard at ensuring we permissively license all
> regulatory code and recently we even relicensed cfg80211's reg.c
> and other regulatory components. To help with this even further I
> have also started a userspace regulatory simulator [0] complete permissively
> licensed which allows us to simulate and engineer regulatory solutions
> completley in userspace and if we are happy later adapt the code to
> kernelspace / firmware / proprietary software / whatever.
> 
> So -- please consider all these things when implmenting your solution
> on the Broadcom driver. Keep in mind the ways to improve regulatory
> and current work and design considreations.
> 
> [0] git://github.com/mcgrof/regsim.git

Great information, Luis. Thanks so much.

Arend, in order to proceed it looks like what we need to know is what
the custom domains represent, i.e. whether they map to a specific
country or set of countries, etc. From what you've said so far it looks
like X0 may map to US while X2 is more of a world roaming domain, but
again I'm just guessing.

Seth

