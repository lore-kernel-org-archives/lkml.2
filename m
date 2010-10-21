Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab0JUUqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 16:46:45 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:34072 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567Ab0JUUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 16:46:42 -0400
Date: Thu, 21 Oct 2010 21:46:20 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in
	get_property()
Message-ID: <20101021204620.GB3318@sucs.org>
References: <20101016141321.GA11054@sucs.org> <201010172032.43206.rjw@sisk.pl> <20101021165420.GA8718@sucs.org> <201010212157.47952.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010212157.47952.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 09:57:47PM +0200, Rafael J. Wysocki wrote:
> On Thursday, October 21, 2010, Sitsofe Wheeler wrote:
> > 
> > It's a shame the previous changes didn't work as they stopped a buggy
> > upower using the -1 value (and producing a nonsense rate like 8.4e-06)
> 
> Hmm.  So upower _doesn't_ handle -1?  What does it do with -1000, then?

It can't handle that either and outputs a nonsense rate like 0.0084.
Looking at the code, it would take a very strange value for it to realise
it is handling a special value as it does arithmetic on the sysfs value
before doing its check:

	/* get rate; it seems odd as it's either in uVh or uWh */
	energy_rate = fabs (sysfs_get_double (native_path, "current_now") / 1000000.0);

	/* convert charge to energy */
	if (energy == 0) {
		energy = sysfs_get_double (native_path, "charge_now") / 1000000.0;
		if (energy == 0)
			energy = sysfs_get_double (native_path, "charge_avg") / 1000000.0;
		energy *= voltage_design;
		energy_rate *= voltage_design;
	}

	/* some batteries don't update last_full attribute */
	if (energy > energy_full) {
		egg_warning ("energy %f bigger than full %f", energy, energy_full);
		energy_full = energy;
	}

	/* present voltage */
	voltage = sysfs_get_double (native_path, "voltage_now") / 1000000.0;
	if (voltage == 0)
		voltage = sysfs_get_double (native_path, "voltage_avg") / 1000000.0;

	/* ACPI gives out the special 'Ones' value for rate when it's unable
	 * to calculate the true rate. We should set the rate zero, and wait
	 * for the BIOS to stabilise. */
	if (energy_rate == 0xffff)
		energy_rate = 0;

By the time the comparison against energy_rate is done the original
sysfs value has at _least_ divided by 1000000.0 and made positive. Hence
the test program in my first mail where I mention that 0xfffff produced
65535.000000, fabs(-1000 / 1000000.0) produced 0.001000 and fabs(-1 /
1000000.0) produces 0.000001. That's also assuming it doesn't wind up
multiplying the previous value by voltage_design...

> > but it's not clear which part of the stack can't handle -ENODATA
> > perhaps it is another part of the kernel?
> 
> I don't really think it's a part of the kernel.

How do I find out which part is not producing those sysfs nodes?

> > Richard, any chance of upower being changed to test for -1 before doing
> > doing anything with current_now (
> > http://cgit.freedesktop.org/DeviceKit/upower/tree/src/linux/up-device-supply.c?id=5387183d53c16a987a0737c1bdec1b62edf3daa6#n561)?
> > I guess there are a whole bunch of other attributes that could
> > theoretically be -1 and shouldn't be used if they return it...
> 
> If user space doesn't handle -1 correctly too, I think the right approach for
> us should be to use the previous version of the patch and return error code
> for unknown values.

So long as sysfs can be made to work properly I am in agreement.

-- 
Sitsofe | http://sucs.org/~sits/
