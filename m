Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab0DAAB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 20:01:29 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:44341 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567Ab0DAAB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 20:01:28 -0400
Date: Thu, 1 Apr 2010 02:01:18 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, James Morris <jmorris@namei.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
Message-ID: <20100401000118.GA32239@cmpxchg.org>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <4BB3C739.2020106@kernel.org> <20100331221341.GA20441@elte.hu> <4BB3C9B0.4000205@kernel.org> <20100331224108.GA11284@elte.hu> <4BB3D0F4.902@kernel.org> <20100331225658.GA22975@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331225658.GA22975@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 12:56:58AM +0200, Ingo Molnar wrote:
> I think what we want is your lmb series, with CONFIG_NO_BOOTMEM eliminated 
> altogether and x86 converted to pure (extended) lmb facilities, and without 
> any traces of bootmem left in x86.

That does not make much sense as bootmem is not only used on the architecture
side but also in generic code.  So you either have to emulate the API on x86
or get lmb in a state to replace bootmem on _all_ architectures.

> I.e. a really clean series with no CONFIG_NO_BOOTMEM kind of #ifdef crap left 
> around. This means 'nobootmem.c' (albeit saner than an #ifdef jungle) would be 
> moot as well.
> 
> We tried the dual model as it seemed prudent from a testing/conversion POV 
> (and it certainly allowed people to turn the new code off), but it's rather 
> ugly and we still have bugs left.

I think this was an implementation thing rather than a problem with the model
per se.

As written above, you can hardly get away without emulating the bootmem API
during transition.

> This means that if Linus likes that approach the conversion will be very 
> binary and very painful. The other option would be to go back to bootmem and 
> forget about the whole nobootmem and lmb thing.

I suppose it would be safest to replace early_res with lmb first to get
in sync with the other archs using it.

Step two would be to extend LMB and implement a bootmem emulation API on
top of it so that architectures can switch over to non-bootmem mode one
by one.  Then you can drop the real bootmem code and switch generic code
to use LMB natively, also site by site.  And finally, drop the emulation API.

If other architectures object to removing bootmem, there really is no point
for x86 to even try it.

For step one to work out, it's probably easiest to fully revert to the
.33 state than having to replace early_res while in its current state?
