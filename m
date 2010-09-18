Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab0IRTM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:12:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43221 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab0IRTMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:12:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>,
        "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-pm" <linux-pm@lists.linux-foundation.org>,
        "linux-omap" <linux-omap@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] opp: introduce library for device-specific OPPs
Date: Sat, 18 Sep 2010 21:11:25 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>
References: <1284686973-13993-1-git-send-email-nm@ti.com> <201009180045.56122.rjw@sisk.pl> <4C93F794.1030308@ti.com>
In-Reply-To: <4C93F794.1030308@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009182111.26065.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trimming the CC list]

On Saturday, September 18, 2010, Nishanth Menon wrote:
> Rafael J. Wysocki had written, on 09/17/2010 05:45 PM, the following:
> 
> Thanks for your review. few views below..
> 
> > On Friday, September 17, 2010, Nishanth Menon wrote:
> >> Nishanth Menon had written, on 09/17/2010 10:05 AM, the following:
> >>> Linus Walleij had written, on 09/17/2010 08:41 AM, the following:
> >>>> 2010/9/17 Nishanth Menon <nm@ti.com>:
> >>>>
> >>>>> diff --git a/Documentation/power/00-INDEX b/Documentation/power/00-INDEX
> >>>>> index fb742c2..45e9d4a 100644
> >>>>> --- a/Documentation/power/00-INDEX
> >>>>> +++ b/Documentation/power/00-INDEX
> >>>>> @@ -14,6 +14,8 @@ interface.txt
> >>>>>        - Power management user interface in /sys/power
> >>>>>  notifiers.txt
> >>>>>        - Registering suspend notifiers in device drivers
> >>>>> +opp.txt
> >>>>> +       - Operating Performance Point library
> >>>>>  pci.txt
> >>>>>        - How the PCI Subsystem Does Power Management
> >>>> Hm you add the documentation to the index but not the documentation
> >>>> itself (easy slip) would you mind posting it?
> >>> ouch.. Sorry.. I realized that I missed adding MAINTAINER entry as 
> >>> well.. v2 coming up..
> >>>
> >> while the review goes on, I will till end of the day before posting a v2 
> >> will collated comments, here is the opp.txt documentation for the same.. 
> >> apologies on missing in my v1..
> > 
> > OK, I'm not generally familiar with these things, so a couple of questions.
> > 
> >> OPP Layer
> >> ==============
> >> SOCs have a standard set of tuples consisting of frequency and
> >> voltage pairs that the device will support per voltage domain. This
> >> is called Operating Performance Point or OPP. The actual definitions
> >> of OPP varies over silicon within the same family of devices.
> >> For a specific domain, you can have a set of {frequency, voltage}
> >> pairs. As the kernel boots and more information is available, a set
> >> of these are activated based on the precise nature of device the kernel
> >> boots up on.
> > 
> > Does it mean that the full set of possible OPPs is already known from the
> > hardware configuration and the ones that are actually useable are found
> > during boot?
> 
> yes. example - https://patchwork.kernel.org/patch/183742/ (based on 
> original patch posted to l-arm, this will need some tweaks with the 
> latest evolution, the concepts remain the same).
> 
> For example, consider in the patch above where we have a opp definitions 
> we can choose from omap3430 and 3630,
> 
> when using 3630 silicon as a specific, certain boards wish to enable 
> 1GHz, this allows us to do something as follows:
> in the generic omap code, we do init of all opps
> in the board specific file, we enable 1Ghz
> 
> The selection of oppset and actual availability is done on the fly.

OK, so why don't you simply drop the OPPs you're not going to use from the
list in the board-specific file?

...
> >> OPP layer organizes the data internally using device pointers representing
> >> individual voltage domains.
> > 
> > Can you please describe these data structures in a bit more detail?
> probably a dumb question: Is'nt it enough to give detailed verbose 
> information in the  struct comment header? why duplicate here as well.. 
> other than giving an overview?

I meant "explain it to me" rather than "explain it in the doc". :-)  Sorry for
not being clear enough.

> >> NOTE:
> >> a) the OPP layer implementation expects to be used in multiple contexts
> >> based on SOC implementation and recommends locking schemes appropriate to
> >> the usage of SOC.
> >> b) All pointer returns are expected to be handled by standard error checks
> >> such as IS_ERR() and appropriate actions taken by the caller.
> > 
> > I noticed that in a few places it isn't really necessary to return a pointer.
> > I think you can simply return int in such cases.
> could you help and point these to me. opp_find_freq_exact, 
> opp_find_freq_ceil, opp_find_freq_floor are the only ones that return 
> pointers and they need to return the pointer to the opp they found to 
> operate on them such as add_freq etc..

Hmm, OK.  I must have made a mistake, sorry.

...
> >> Data Structures:
> >> ---------------
> >> struct opp * is a handle structure whose internals are known only
> >> to the OPP layer and is meant to hide the complexity away from users of
> >> opp layer.
> >>
> >> struct opp_def * is the definitions that users can interface with
> >> opp layer and is meant to define one OPP for a domain device.
> > 
> > The data structures require some more description IMHO.  They aren't completely
> > intuitive.
> 
> ok, a repeat question -> why duplicate the information defined in the 
> structure comment header?

Because it doesn't imply the specific implementation, AFAICS.

Like what the list heads in your structures are used for etc.

Thanks,
Rafael
