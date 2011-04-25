Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab1DYSCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:02:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17398 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab1DYSCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:02:08 -0400
Date: Mon, 25 Apr 2011 20:00:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Len Brown <len.brown@intel.com>, LM Sensors <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rene Herman <rene.herman@gmail.com>
Subject: Re: [PATCH] thermal: Drop CONFIG_THERMAL_HWMON
Message-ID: <20110425200055.07873bd5@endymion.delvare>
In-Reply-To: <20110424205647.GA10440@ericsson.com>
References: <20110423150703.78ba86db@endymion.delvare>
	<20110424015853.GA8045@ericsson.com>
	<20110424214053.15aa4def@endymion.delvare>
	<20110424205647.GA10440@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Sun, 24 Apr 2011 13:56:47 -0700, Guenter Roeck wrote:
> On Sun, Apr 24, 2011 at 03:40:53PM -0400, Jean Delvare wrote:
> > Hi Guenter,
> > 
> > On Sat, 23 Apr 2011 18:58:53 -0700, Guenter Roeck wrote:
> > > On Sat, Apr 23, 2011 at 09:07:03AM -0400, Jean Delvare wrote:
> > > > It's about time to revert 16d752397301b95abaa95cbaf9e785d221872311.
> > > > Anybody running a kernel >= 2.6.40 would also be running a recent
> > > > enough version of lm-sensors.
> > > > 
> > > > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > > > Cc: Rene Herman <rene.herman@gmail.com>
> > > > Cc: Len Brown <len.brown@intel.com>
> > > 
> > > Two other and less complex options:
> > > 
> > > - Add
> > > 	select THERMAL_HWMON if HWMON=y || HWMON=THERMAL
> > >   to "menuconfig THERMAL", and keep THERMAL_HWMON as non-selectable bool
> > >   [ I don't know what HWMON=THERMAL means, though ]
> > 
> > HWMON=THERMAL means: both HWMON and THERMAL built as modules, or both
> > built into the kernel, or neither built at all. Given that the "y" case
> > is already mentioned explicitly, and the whole thing isn't even
> > evaluated if THERMAL=n, HWMON=THERMAL here is essentially a shortcut
> > for "THERMAL=m && HWMON=m".
> > 
> > > - Add
> > > 	select HWMON
> > >   to "menuconfig THERMAL", and remove THERMAL_HWMON.
> > 
> > Thanks for the suggestions. I admit I blindly reverted the original
> > commit without putting much thought into possible alternatives.
> > 
> > Your second suggestion is by far the most simple. However it has a
> > drawback, it makes it impossible to select THERMAL without HWMON. This
> > is no concern to me, but maybe some embedded systems will be unhappy
> > about this. HWMON has no interest in the absence of local users.
> > 
> Yes, that is why I suggested it as second option. I don't think the assertion
> is correct, though. There could well be a SNMP hardware monitoring MIB
> implementation (or something similar) using the hwmon sysfs ABI to interface
> with the kernel; such an interface to the outside world would make a lot of sense
> in an embedded system.

What I had in mind was more like my Linux-based portable media player.
No local user and no networking capabilities, so hardware monitoring is
pointless, while thermal management may be desirable.

> 
> > Your first suggestion makes a lot of sense, as it avoids repeating the
> > same non-trivial conditional construct in 3 different places. But OTOH
> > it leaves in Kconfig an option that shouldn't be there, as nobody
> > should depend on its value. I consider it an abuse of the Kconfig
> > system.
>
> Not really; that kind of construct is used all over the place. Sure, 

Doesn't mean it's right ;)

> it is commonly used if the same option is auto-enabled from more than one
> other options, but in my opinion it makes sense here as well: If one wants 
> to change the condition for enabling THERMAL_HWMON, it is easier to change
> in one place instead of having to track down all the places in the code.

Good point.

> Yet another possibility, which is used all over the place, would be
> 
> config THERMAL_HWMON
> 	bool
> 	depends on THERMAL
> 	depends on HWMON=y || HWMON=THERMAL
> 	default y
> 
> ie remove the ability to select it manually. Maybe that would be more appropriate.

I like it, I think I'll do that, thanks for the suggestion.

> > In fact, my impression is that the repeated tests, and the fact that two
> > of them are in <linux/thermal.h>, are the consequence of bad code
> > design. The fact that THERMAL_HWMON affects a public structure when the
> > implementation is completely internal to the thermal driver makes no
> > sense. It should be possible to implement things differently.
>
> Yes, it definitely violates the notion of "no ifdefs in the code". It might be 
> more difficult to get that kind of code into the kernel today.

Not sure what "notion" you are referring to, but this particular piece
of code isn't that old. There are a lot of config-dependent pieces of
code in the kernel tree, and I don't think this is a problem. The
problem I have here is with the implementation details and their
consequences. Same as including header files which you don't need, it
causes useless rebuilds. Furthermore, the fact that unsetting (or
setting) CONFIG_HWMON will cause a kABI breakage for all users of
thermal is pretty nasty for distributions. I would like to fix this (in
a different patch, of course.)

-- 
Jean Delvare
