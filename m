Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab2JQIBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:01:03 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:56686 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423Ab2JQIBB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:01:01 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Date: Wed, 17 Oct 2012 10:00:10 +0200
Subject: RE: [PATCHv5 1/4] modem_shm: Add Modem Access Framework
Thread-Topic: [PATCHv5 1/4] modem_shm: Add Modem Access Framework
Thread-Index: Ac2rHRRbdhYXo04FSvKRYFMvakzctgBFOvrw
Message-ID: <F45880696056844FA6A73F415B568C695B9C5CECE3@EXDCVYMBSTM006.EQ1STM.local>
References: <1350278920-25510-1-git-send-email-arun.murthy@stericsson.com>
 <1350278920-25510-2-git-send-email-arun.murthy@stericsson.com>
 <20121015212943.GA12540@kroah.com>
In-Reply-To: <20121015212943.GA12540@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Oct 15, 2012 at 10:58:37AM +0530, Arun Murthy wrote:
> 
> I'm going to ignore your .c logic, as there are things in it that I don't think is
> correct.  But it all comes down to your data structures, if you fix them, then
> the .c logic will become correct:
> 
> > --- /dev/null
> > +++ b/include/linux/modem_shm/modem.h
> > @@ -0,0 +1,59 @@
> > +/*
> > + * Copyright (C) ST-Ericsson SA 2011
> > + *
> > + * License Terms: GNU General Public License v2
> > + * Author: Kumar Sanghvi
> > + *	Arun Murthy <arun.murthy@stericsson.com>
> > + *
> > + * Heavily adapted from Regulator framework  */ #ifndef __MODEM_H__
> > +#define __MODEM_H__
> 
> __MODEM_SHM_MODEM_H__, right?
> 

Done!

> > +
> > +#include <linux/device.h>
> > +
> > +struct clients {
> > +	struct device *dev;
> 
> Why is this a pointer?  It should be embedded in the structure.

This is the pointer to the clients's device structure. There will be a
single entity for a modem but multiple clients. Hence this struct is 
specific for each client.

> 
> > +	const char *name;
> 
> Why is this needed?  It should be the same as the device, right?

Ok, will remove this.

> 
> > +	atomic_t cnt;
> 
> Why is this needed at all?  And if it's needed, why is it an atomic?
> (hint, your use of atomic_t really isn't correct at all in this patch, it's not doing
> what you think it is doing...)

Basically the operation done by this, i.e modem access/release has a lot of
affect on the clients. Since we are accesing some modem registers without
this modem request it might lead to system freeze. Hence such cross over
scenarios are considered and the counter is increased/decreased after the
operation(modem access/release). And reading of these variable are done
especially during system suspend, where decision is taken based on the value
of the counter read, hence any modification done should preside over read.
Moreover since there are multiple clients, using atomic for a simple locking
mechanism.

> 
> > +};
> 
> Also, the name of the structure here is _VERY_ generic, that's not acceptable
> in the global kernel namespace.  Hint, it probably isn't even needed to be
> defined in this .h file at all, right?

Yes, even I felt so yest while reviewing, will change it accordingly.

> 
> > +
> > +struct modem_desc {
> > +	int (*request)(struct modem_desc *);
> > +	void (*release)(struct modem_desc *);
> > +	int (*is_requested)(struct modem_desc *);
> > +	struct clients *mclients;
> 
> Why do you have a pointer to a device, and yet:

This pointer to device is for the clients device.

> 
> > +	struct device *dev;
> 
> have a device here?
This pointer to device is the modem's device struct.

> 
> > +	char *name;
> 
> Same *dev and name comment as above.

Ok will remove this.

> 
> > +	u8 no_clients;
> > +	atomic_t use_cnt;
> > +	atomic_t cli_cnt;
> 
> Same question about these atomic_t variables, why are they here, and most
> importantly, why are they an atomic variable?

Explained above.

Thanks and Regards,
Arun R Murthy
------------------
