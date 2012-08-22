Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab2HVWpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:45:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38274 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab2HVWo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:44:58 -0400
Date: Wed, 22 Aug 2012 19:44:52 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>
Subject: Re: [ 04/16] drm/i915: correctly order the ring init sequence
Message-ID: <20120822224451.GC3076@herton-Z68MA-D2H-B3>
References: <20120820035457.653002510@linuxfoundation.org>
 <20120820035458.292084336@linuxfoundation.org>
 <20120821051318.GB3625@herton-Z68MA-D2H-B3>
 <CAKMK7uFpj+qctqKOk6PJqRn_7XAiDbE7Bv2r2VseGyUHUTD2mA@mail.gmail.com>
 <20120821131115.GA3132@herton-Z68MA-D2H-B3>
 <CAKMK7uFjxQZYXLrs14RydnSKp6_ghwUL-1xGQm5C5dXao60Fhg@mail.gmail.com>
 <20120822045015.GB3132@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822045015.GB3132@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 01:50:16AM -0300, Herton Ronaldo Krzesinski wrote:
> On Tue, Aug 21, 2012 at 06:55:30PM +0200, Daniel Vetter wrote:
> > On Tue, Aug 21, 2012 at 3:11 PM, Herton Ronaldo Krzesinski
> > <herton.krzesinski@canonical.com> wrote:
> > > On Tue, Aug 21, 2012 at 08:42:35AM +0200, Daniel Vetter wrote:
> > >> On Tue, Aug 21, 2012 at 7:13 AM, Herton Ronaldo Krzesinski
> > >> <herton.krzesinski@canonical.com> wrote:
> > >> > I had the same problem as on 3.2 with this change, i915 stopped working
> > >> > unable to initialize render ring, eg. on one of the boots here:
> > >> > [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f003 head 00001020 tail 00000000 start 00001000
> > >> >
> > >> > But unlike I was expecting as with 3.2 case, picking commit
> > >> > f01db988ef6f6c70a6cc36ee71e4a98a68901229 ("drm/i915: Add wait_for in
> > >> > init_ring_common") here isn't enough, it continues to fail even if I
> > >> > try to increase the delay in the wait_for, I'm not sure why yet... may
> > >> > be something else is going on, or 3.0 has something else missing.
> > >> >
> > >> > Also the same proposed patch for 3.4.10 gives the same problem, but
> > >> > picking f01db988ef6f6c70a6cc36ee71e4a98a68901229 there made things work
> > >> > again like happend on first 3.2.28 proposed update. Only 3.0
> > >> > is misteriously failing either way here.
> > >>
> > >> I guess we're missing something then still in the stable backports for
> > >> 3.0. Herton, what machine do you have exaclty (lspci -nn)?
> > >
> > > It's a G41 based board:
> > 
> > Hm, I've reviewed git log and bug reports and I have no idea what's
> > missing on 3.0. I guess the best course of action is to not apply this
> > patch to 3.0 stable - it fixes an ivb issue anyway, and 3.0 is a
> > rather old kernel for ivb support anyway (we generally recommend 3.2.x
> > for ivb).
> > -Daniel
> 
> Yeah, 3.0 being old, if it was only for ivb, supported only later, makes
> sense. I continued investigating this today, and some things are looking
> very strange to me. Here is what I discovered and narrowed down so far:
[...]

Really sorry about this, but it was a hardware+bios setting problem
here. I finished investigating what was happening here, and is related to
the DRAM installed on this machine. The memory installed is DDR3-1333,
and on bios it was configured as that, but turns out the chipset (G41)
only supports up to DDR3-1066 (as on specs, although the motherboard
lists the 1333 as supported, but as "OC", and allows configuring this
way automatically or manually).

After setting manually back to 1066, I stopped seeing all the weird
behaviour, like the writes to the start address don't trigger anymore
setting on the head offset. I'm sorry about that, and really it's a
brown paper bag time for me :(. The machine worked fine and passed
through memtest and never gave any problems, this was the first
time (seems only the video device didn't like the memory setting, and
the code change probably changed timing in the right way to pop up this
now, also never had graphics corruption or other noticeable problems).
I retested kernels that gave problems and they run fine now.

-- 
[]'s
Herton
