Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab1DXU5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 16:57:40 -0400
Received: from imr3.ericy.com ([198.24.6.13]:41199 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757764Ab1DXU5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 16:57:39 -0400
Date: Sun, 24 Apr 2011 13:56:47 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Len Brown <len.brown@intel.com>, LM Sensors <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rene Herman <rene.herman@gmail.com>
Subject: Re: [lm-sensors] [PATCH] thermal: Drop CONFIG_THERMAL_HWMON
Message-ID: <20110424205647.GA10440@ericsson.com>
References: <20110423150703.78ba86db@endymion.delvare>
 <20110424015853.GA8045@ericsson.com>
 <20110424214053.15aa4def@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110424214053.15aa4def@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 03:40:53PM -0400, Jean Delvare wrote:
> Hi Guenter,
> 
> On Sat, 23 Apr 2011 18:58:53 -0700, Guenter Roeck wrote:
> > On Sat, Apr 23, 2011 at 09:07:03AM -0400, Jean Delvare wrote:
> > > It's about time to revert 16d752397301b95abaa95cbaf9e785d221872311.
> > > Anybody running a kernel >= 2.6.40 would also be running a recent
> > > enough version of lm-sensors.
> > > 
> > > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > > Cc: Rene Herman <rene.herman@gmail.com>
> > > Cc: Len Brown <len.brown@intel.com>
> > 
> > Two other and less complex options:
> > 
> > - Add
> > 	select THERMAL_HWMON if HWMON=y || HWMON=THERMAL
> >   to "menuconfig THERMAL", and keep THERMAL_HWMON as non-selectable bool
> >   [ I don't know what HWMON=THERMAL means, though ]
> 
> HWMON=THERMAL means: both HWMON and THERMAL built as modules, or both
> built into the kernel, or neither built at all. Given that the "y" case
> is already mentioned explicitly, and the whole thing isn't even
> evaluated if THERMAL=n, HWMON=THERMAL here is essentially a shortcut
> for "THERMAL=m && HWMON=m".
> 
> > - Add
> > 	select HWMON
> >   to "menuconfig THERMAL", and remove THERMAL_HWMON.
> 
> Thanks for the suggestions. I admit I blindly reverted the original
> commit without putting much thought into possible alternatives.
> 
> Your second suggestion is by far the most simple. However it has a
> drawback, it makes it impossible to select THERMAL without HWMON. This
> is no concern to me, but maybe some embedded systems will be unhappy
> about this. HWMON has no interest in the absence of local users.
> 
Yes, that is why I suggested it as second option. I don't think the assertion
is correct, though. There could well be a SNMP hardware monitoring MIB
implementation (or something similar) using the hwmon sysfs ABI to interface
with the kernel; such an interface to the outside world would make a lot of sense
in an embedded system.

> Your first suggestion makes a lot of sense, as it avoids repeating the
> same non-trivial conditional construct in 3 different places. But OTOH
> it leaves in Kconfig an option that shouldn't be there, as nobody
> should depend on its value. I consider it an abuse of the Kconfig
> system.
> 
Not really; that kind of construct is used all over the place. Sure, 
it is commonly used if the same option is auto-enabled from more than one
other options, but in my opinion it makes sense here as well: If one wants 
to change the condition for enabling THERMAL_HWMON, it is easier to change
in one place instead of having to track down all the places in the code.

Yet another possibility, which is used all over the place, would be

config THERMAL_HWMON
	bool
	depends on THERMAL
	depends on HWMON=y || HWMON=THERMAL
	default y

ie remove the ability to select it manually. Maybe that would be more appropriate.

> In fact, my impression is that the repeated tests, and the fact that two
> of them are in <linux/thermal.h>, are the consequence of bad code
> design. The fact that THERMAL_HWMON affects a public structure when the
> implementation is completely internal to the thermal driver makes no
> sense. It should be possible to implement things differently.
> 
Yes, it definitely violates the notion of "no ifdefs in the code". It might be 
more difficult to get that kind of code into the kernel today.

Thanks,
Guenter
