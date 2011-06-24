Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab1FXDnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 23:43:13 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:11273
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751304Ab1FXDnL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 23:43:11 -0400
X-SpamScore: -6
X-BigFish: VS-6(zz1432N98dKc8kzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 24 Jun 2011 11:49:00 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <patches@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Jason Liu <jason.hui@linaro.org>, <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
Message-ID: <20110624034859.GB19188@S2100-06.ap.freescale.net>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-2-git-send-email-shawn.guo@linaro.org>
 <20110618161934.GH8195@ponder.secretlab.ca>
 <20110619073000.GA23171@S2100-06.ap.freescale.net>
 <20110621135558.GB9228@S2101-09.ap.freescale.net>
 <BANLkTim4vunTm1176MRw3pqRZnunu4=9jg@mail.gmail.com>
 <20110623183821.GA19188@S2100-06.ap.freescale.net>
 <BANLkTi=8Mks6T85WnEyihmB21U1j7reHrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <BANLkTi=8Mks6T85WnEyihmB21U1j7reHrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 05:11:54PM -0600, Grant Likely wrote:
[...]
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index 632ebae..90349a2 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -17,12 +17,27 @@
> >  *      as published by the Free Software Foundation; either version
> >  *      2 of the License, or (at your option) any later version.
> >  */
> > +#include <linux/ctype.h>
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/slab.h>
> >  #include <linux/proc_fs.h>
> >
> > +struct alias_devname {
> > +       char devname[32];
> > +       struct list_head link;
> > +       struct list_head head;
> > +};
> > +
> > +struct alias_devid {
> > +       int devid;
> > +       struct device_node *node;
> > +       struct list_head link;
> > +};
> 
> Some LinuxDoc documentation on the meaning of these structures would
> be helpful.  I'm not convinced that a two level lookup table is really
> necessary.  A flat table containing alias, device_node pointer, and
> possibly decoded devname and id is probably sufficient to get started.
>  Also, I think it will still be useful to store a pointer to the
> actual alias name in the alias_devid record.
> 
I thought two level lookup with driver probe function passing in
stem name will get the matching faster.  But I agree with you that
a flat table may be sufficient to get started, since practically
the alias number will not be that huge.

> > +
> > +static LIST_HEAD(aliases_lookup);
> > +
> >  struct device_node *allnodes;
> >  struct device_node *of_chosen;
> >
> > @@ -922,3 +937,170 @@ out_unlock:
> >  }
> >  #endif /* defined(CONFIG_OF_DYNAMIC) */
> >
> > +/*
> > + * get_alias_dev_name_id - Get device name and id from alias name
> > + *
> > + * an: The alias name passed in
> > + * dn: The pointer used to return device name
> 
> There is actually little point in decoding an alias to the device
> name.  It is more useful to decode alias to the device_node pointer
> which can be found with of_find_node_by_path().  I'd like to have a
> lookup table generated which contains {const char *alias_name,
> device_node *np} pairs.  It would also be useful for that table to
> decode the 'id' from the end of the alias name when available.  Then,
> given an alias stem and id (like imxuart and 2) the code could match
> it to alias imxuart0 and look up the device_node associated with (I
> could see this used by console setup code).  Alternately, driver probe

Yes, this is definitely one way to match.  But it's not as handy as
the alternate one below, in terms of migrating the current platform
drivers that use pdev->id everywhere to dt.  For the imx console
setup example, we can get the device_node by matching alias stem and
id, but we have to address the port we need with another two
contains_of(), device_node -> dev -> port.

> code could use its device_node pointer to lookup its alias, and if no
> alias exists, then use the table to find an unused id (and possibly
> even add an entry to the table when it allocates an id).
> 
And this is easier for the current platform drivers to migrate to
dt, so I would keep purchasing this one.

[...]
> > +               int devid = get_alias_name_id(pp->name, devname);
> > +
> > +               /* We do not want to proceed this sentinel one */
> > +               if (!strcmp(pp->name, "name") && !strcmp(pp->value, "aliases"))
> > +                       break;
> 
> Skipping the 'name' property is good, but I don't think you need to
> check the value.  You should also skip the "phandle" property.
> 
Ok. I have not seen "phandle" property in aliases node though.  Can
you give me an example, so that I can make one up for testing?

-- 
Regards,
Shawn

