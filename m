Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1DTAF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 20:05:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:9239 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab1DTAF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 20:05:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,242,1301900400"; 
   d="scan'208";a="911922331"
Subject: Re: [PATCH 4/4] n_tracerouter and n_tracesink ldisc additions.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <20110419162015.e4446442.rdunlap@xenotime.net>
References: <james_p_freyensee@linux.intel.com>
	 <1303253889-10074-5-git-send-email-james_p_freyensee@linux.intel.com>
	 <20110419162015.e4446442.rdunlap@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 19 Apr 2011 17:05:55 -0700
Message-ID: <1303257955.13457.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 16:20 -0700, Randy Dunlap wrote:
> On Tue, 19 Apr 2011 15:58:09 -0700 james_p_freyensee@linux.intel.com wrote:
> 
> >  drivers/tty/Kconfig         |   31 ++++++
> >  drivers/tty/Makefile        |    2 +
> >  drivers/tty/n_tracerouter.c |  241 ++++++++++++++++++++++++++++++++++++++++++
> >  drivers/tty/n_tracesink.c   |  244 +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/tty/n_tracesink.h   |   36 +++++++
> >  include/linux/tty.h         |    2 +
> >  6 files changed, 556 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/tty/n_tracerouter.c
> >  create mode 100644 drivers/tty/n_tracesink.c
> >  create mode 100644 drivers/tty/n_tracesink.h
> > 
> > diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
> > index 3fd7199..d1ab9c0 100644
> > --- a/drivers/tty/Kconfig
> > +++ b/drivers/tty/Kconfig
> > @@ -319,3 +319,34 @@ config N_GSM
> >  	  This line discipline provides support for the GSM MUX protocol and
> >  	  presents the mux as a set of 61 individual tty devices.
> >  
> > +config TRACE_ROUTER
> > +	tristate "Trace data router for MIPI P1149.7 cJTAG standard"
> > +	depends on TRACE_SINK
> > +	default Y
> 
> Don't add default Y misc drivers.

This actually isn't a misc driver.  From the help, it's "Linux tty line
discipline"

But I can turn it off.

> 
> > +	help
> > +	  The trace router uses the Linux tty line discipline framework to
> > +	  route trace data coming from a tty port (say UART for example) to
> > +	  the trace sink line discipline driver and to another tty port(say 
> > +	  USB). This is part of a solution for the MIPI P1149.7, compact JTAG,
> > +	  standard, which is for debugging mobile devices. The PTI driver in
> > +	  drivers/misc/pti.c defines the majority of this MIPI solution.
> > +
> > +	  You should select this driver if the target kernel is meant for
> > +	  a mobile device containing a modem.  Then you will need to select
> > +	  "Trace data sink for MIPI P1149.7 cJTAG standard" line discipline
> > +	  driver.
> > +
> > +config TRACE_SINK
> > +	tristate "Trace data sink for MIPI P1149.7 cJTAG standard"
> > +	default Y
> 
> ditto.
> 
> > +	help
> > +	  The trace sink uses the Linux line discipline framework to receive
> > +	  trace data coming from the trace router line discipline driver
> > +	  to a user-defined tty port target, like USB.
> > +	  This is to provide a way to extract modem trace data on
> > +	  devices that do not have a PTI HW module, or just need modem
> > +	  trace data to come out of a different HW output port.
> > +	  This is part of a solution for the P1149.7, compact JTAG, standard.
> > +
> > +	  If you select this option, you need to select
> > +	  "Trace data router for MIPI P1149.7 cJTAG standard".
> 
> > diff --git a/drivers/tty/n_tracerouter.c b/drivers/tty/n_tracerouter.c
> > new file mode 100644
> > index 0000000..7295799
> > --- /dev/null
> > +++ b/drivers/tty/n_tracerouter.c
> > @@ -0,0 +1,241 @@
> > +/*
> > + *  n_tracerouter.c - Trace data router through tty space
> > + *
> > + *  Copyright (C) Intel 2011
> > + *
> > + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > + *
> > + *  This program is free software; you can redistribute it and/or modify
> > + *  it under the terms of the GNU General Public License version 2
> > + *  as published by the Free Software Foundation.
> > + *
> > + *  This program is distributed in the hope that it will be useful,
> > + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *  GNU General Public License for more details.
> > + *
> > + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > + *
> > + * This trace router uses the Linux line discipline framework to route
> > + * trace data coming from a HW Modem to a PTI (Parallel Trace Module) port.
> > + * The solution is not specific to a HW modem and this line disciple can
> > + * be used to route any stream of data in kernel space.
> > + * This is part of a solution for the P1149.7, compact JTAG, standard.
> > + *
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/types.h>
> > +#include <linux/ioctl.h>
> > +#include <linux/tty.h>
> > +#include <linux/tty_ldisc.h>
> > +#include <linux/errno.h>
> > +#include <linux/string.h>
> > +#include <linux/mutex.h>
> > +#include <linux/slab.h>
> > +#include <asm-generic/bug.h>
> > +#include "n_tracesink.h"
> > +
> > +/* Other ldisc drivers use 65536 which basically means,
> > + * 'I can always accept 64k' and flow control is off.
> > + * This number is deemed appropriate for this driver.
> > + */
> 
> Fix multi-line comment style throughout.

Could you please show me how and what you are looking for?  You pointed
out a similar issue using a different comment style, despite that at
least I made it a point to maintain a consistent comment style
throughout the code in the file.  So I'm not quite sure what is desired.
Thanks, I appreciate this.


> 
> > +#define RECEIVE_ROOM	65536
> > +#define DRIVERNAME	"n_tracerouter"
> > +
> > +/* struct to hold private configuration data for this ldisc.
> > + * opencalled is used to hold if this ldisc has been opened.
> > + * kref_tty holds the tty reference the ldisc sits on top of.
> > + */
> > +struct tracerouter_data {
> > +	u8 opencalled;
> > +	struct tty_struct *kref_tty;
> > +};
> > +static struct tracerouter_data *tr_data;
> > +
> > +/* lock for when tty reference is being used */
> > +static DEFINE_MUTEX(routelock);
> 
> 
> > +/* Flush buffer is not impelemented as the ldisc has no internal buffering
> > + * so the tty_driver_flush_buffer() is sufficient for this driver's needs.
> > + */
> > +
> > +static struct tty_ldisc_ops tty_ptirouter_ldisc = {
> > +	.owner		= THIS_MODULE,
> > +	.magic		= TTY_LDISC_MAGIC,
> > +	.name		= DRIVERNAME,
> > +	.open		= n_tracerouter_open,
> > +	.close		= n_tracerouter_close,
> > +	.read		= n_tracerouter_read,
> > +	.write		= n_tracerouter_write,
> > +	.receive_buf	= n_tracerouter_receivebuf
> > +};
> 
> > diff --git a/drivers/tty/n_tracesink.c b/drivers/tty/n_tracesink.c
> > new file mode 100644
> > index 0000000..4c40127
> > --- /dev/null
> > +++ b/drivers/tty/n_tracesink.c
> > @@ -0,0 +1,244 @@
> > +/*
> > + *  n_tracesink.c - Trace data router and sink path through tty space.
> > + *
> > + *  Copyright (C) Intel 2011
> > + *
> > + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > + *
> > + *  This program is free software; you can redistribute it and/or modify
> > + *  it under the terms of the GNU General Public License version 2
> > + *  as published by the Free Software Foundation.
> > + *
> > + *  This program is distributed in the hope that it will be useful,
> > + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *  GNU General Public License for more details.
> > + *
> > + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > + *
> > + * The trace sink uses the Linux line discipline framework to receive
> > + * trace data coming from the PTI source line discipline driver
> > + * to a user-desired tty port, like USB.
> > + * This is to provide a way to extract modem trace data on
> > + * devices that do not have a PTI HW module, or just need modem
> > + * trace data to come out of a different HW output port.
> > + * This is part of a solution for the P1149.7, compact JTAG, standard.
> > + *
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/types.h>
> > +#include <linux/ioctl.h>
> > +#include <linux/tty.h>
> > +#include <linux/tty_ldisc.h>
> > +#include <linux/errno.h>
> > +#include <linux/string.h>
> > +#include <asm-generic/bug.h>
> > +#include "n_tracesink.h"
> > +
> > +/* Other ldisc drivers use 65536 which basically means,
> > + * 'I can always accept 64k' and flow control is off.
> > + * This number is deemed appropriate for this driver.
> > + */
> 
> Fix multi-line comment style throughout.
> 
> > +#define RECEIVE_ROOM	65536
> > +#define DRIVERNAME	"n_tracesink"
> > +
> > +/* there is a quirk with this ldisc is he can write data
> > + * to a tty from anyone calling his kernel API, which
> > + * meets customer requirements in the drivers/misc/pti.c
> > + * project.  So he needs to know when he can and cannot write when
> > + * the API is called. In theory, the API can be called
> > + * after an init() but before a successful open() which
> > + * would crash the system if tty is not checked.
> > + */
> > +static struct tty_struct *this_tty;
> > +static DEFINE_MUTEX(writelock);
> 
> > +/* Flush buffer is not impelemented as the ldisc has no internal buffering
> > + * so the tty_driver_flush_buffer() is sufficient for this driver's needs.
> > + */
> > +
> > +/*
> > + * tty_ldisc function operations for this driver.
> > + */
> > +static struct tty_ldisc_ops tty_n_tracesink = {
> > +	.owner		= THIS_MODULE,
> > +	.magic		= TTY_LDISC_MAGIC,
> > +	.name		= DRIVERNAME,
> > +	.open		= n_tracesink_open,
> > +	.close		= n_tracesink_close,
> > +	.read		= n_tracesink_read,
> > +	.write		= n_tracesink_write
> > +};
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***


