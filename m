Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934569Ab1ETOBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:01:30 -0400
Received: from imr3.ericy.com ([198.24.6.13]:45370 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933765Ab1ETOB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:01:27 -0400
Date: Fri, 20 May 2011 07:00:45 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Dajun Chen <Dajun.Chen@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCHv3 6/11] HWMON: Fixed point conversion gives linktime
 error
Message-ID: <20110520140045.GC23076@ericsson.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BDC3D33@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BDC3D33@KCINPUNHJCMS01.kpit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 06:57:18AM -0400, Ashish Jangam wrote:
> Hi,
> 
> As requested approximation of battery temperature calculation with fixed point conversion is tried but it causes couple of link time errors, like undefined reference to __aeabi_i2d at sprintf(). Have a look at the function da9052_read_tbat(); we feel that this function should not be supported else there will be a prerequisite to the support the required floating point library. Enabling FPE_NWFPE support in the kernel gives the same link time errors.
> 
You have defined

#define LOGN2          0.693147181

and use it, which makes the entire calculation a floating point calculation
and defeats the purpose. The idea would have been to define something like 

#define CAL_LOG2(nr)	((int)((ilog2(nr) - ilog2(100)) * 693147181LL / 1000000000LL))

Also, there is no need for rounding, say, 0.003355705 to 0.0034, or 2.5 to 3.
Add a few digits, like above, and remove them afterwards.

	x * 2.5 = x * 5 / 2.
	x * 33.55705 = x * 3355705 / 100000

Just be careful that you don't get overflows.

Guenter
