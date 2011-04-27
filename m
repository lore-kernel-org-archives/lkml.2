Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab1D0L7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:59:36 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:39141 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab1D0L7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:59:34 -0400
Date: Wed, 27 Apr 2011 13:59:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com
Cc: Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Rene Herman <rene.herman@gmail.com>
Subject: Re: [PATCH v2 3/3] thermal: Make THERMAL_HWMON implementation 
 fully internal
Message-ID: <20110427135922.33f1171f@endymion.delvare>
In-Reply-To: <1303851631.31666.109.camel@groeck-laptop>
References: <20110426165600.1d9ac91b@endymion.delvare>
	<20110426170407.3694e430@endymion.delvare>
	<20110426155212.GB18176@ericsson.com>
	<20110426182905.72bbf7b6@endymion.delvare>
	<1303839812.31666.98.camel@groeck-laptop>
	<20110426213953.6cc227de@endymion.delvare>
	<1303851631.31666.109.camel@groeck-laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Tue, 26 Apr 2011 14:00:31 -0700, Guenter Roeck wrote:
> On Tue, 2011-04-26 at 15:39 -0400, Jean Delvare wrote:
> > Sorry I realize I have been inaccurate. thermal_sys indeed depends on
> > the processor module, and that's what prevents me from unloading it.
> > It's the processor module which has a reference count of 1, and no
> > dependency, so I have no idea how I could unload it.
> > 
> You mean the ACPI processor driver ? This comment might explain it:
> 
> /*
>  * We keep the driver loaded even when ACPI is not running.
>  * This is needed for the powernow-k8 driver, that works even without
>  * ACPI, but needs symbols from this driver
>  */

I doubt it. I don't have powernow-k8 loaded on the affected systems.
And if I did, that would be a regular inter-module dependency that
would be listed by lsmod.

> > (...)
> > I'm not sure. I don't see any relevant call to try_module_get under
> > drivers/acpi, and I'm not aware of any other way to increase the
> > reference count.
> > 
> What happens if the calling code (such as, in my case here, the acpi
> video code) gets built into the kernel ? Would that force the module to
> be and remain loaded ?

For regular inter-module dependencies, that's not even possible. You
can't build into the kernel a driver which depends on a symbol exported
by a driver which is built as a module. It will break at link time.

For reference counts increased by try_module_get(), it is possible, but
that doesn't necessarily make a difference from the all-modules case:
the reference count can be increased at any time, not only during
driver initialization, so the corresponding module_put doesn't
necessarily happen during module unloading (which indeed never happens
for a built-in driver.)

I tried booting in initlevel 1, but it didn't help, the reference count
of module processor is stuck to 1. So it's not user-space causing it...
it's something in the kernel itself. But I really don't have the time
to investigate this further, especially when I have no idea where to
look next.

-- 
Jean Delvare
