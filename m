Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0LPKfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:35:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:40311 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab0LPKfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:35:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,354,1288594800"; 
   d="scan'208";a="868852105"
Date: Thu, 16 Dec 2010 11:35:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Paul Fox <pgf@laptop.org>, Andres Salomon <dilinger@queued.net>,
        linux-kernel@vger.kernel.org
Subject: Re: MFD cell structure and sharing of resources
Message-ID: <20101216103550.GA5946@sortiz-mobl>
References: <AANLkTinrF-dxiw7OQ=dMhQPgKSqS6yYfDzdcnHfhMtyf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinrF-dxiw7OQ=dMhQPgKSqS6yYfDzdcnHfhMtyf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Fri, Dec 10, 2010 at 03:37:30PM +0000, Daniel Drake wrote:
> A few options that spring to mind:
> 
> 1. Adjust the list of mfd cells in drivers/mfd/cs5535-mfd so that
> rather than being a list of resources, it is a list of drivers that
> rely on the mfd driver. The entries would be: gpio, mfgpt,
> olpc-xo1-pm, olpc-xo1-sci. olpc-xo1-pm would have the 2 resources it
> needs (pms & acpi), and the acpi resource would be duplicated into
> olpc-xo1-sci  too.
> 
> We'd then add a machine_is_olpc()  check inside cs5535-mfd so that the
> OLPC-specific cells are only passed to mfd_add_devices on OLPC
> laptops.
> 
> 2. Continue with Andres' olpc-xo1-pm patch that makes that driver act
> as a driver for both acpi & pms. When both resources are available, it
> could probe an olpc-xo1-sci platform device as a child of itself,
> having the ACPI resource shared on the platform_device level (similar
> to how MFD shares resources via cells).
This sounds like an acceptable solution to me.

> 3. For olpc-xo1-pm and olpc-xo1-sci, forget about hooking into MFD and
> go back to the route of looking for the appropriate device on the PCI
> bus and accessing the regions that way.

I see a 4th solution though:

Define and export a set of I/O routines from the MFD driver, for the shared
resources. The routines would take as arguments one of the shared module
(ACPI, PMS, etc..) and a register (and obviously a value for the writing
parts...), and do the I/O operation for your driver. This is similar to what
the twl driver does, although over i2c.
That means requesting and releasing the shared regions from the MFD driver,
before knowing if there is a user for it or not. I realize this could lead to
some resource conflicts, although this is very unlikely. Potentially, we could
have a callback into the MFD driver from the subdevice to let it know that the
resource is requested. But then your #2 solution would look better to me.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
