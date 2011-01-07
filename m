Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1AGLYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 06:24:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:24634 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab1AGLYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 06:24:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,288,1291622400"; 
   d="scan'208";a="590790156"
Date: Fri, 7 Jan 2011 19:24:09 +0800
From: Yin Kangkai <kangkai.yin@intel.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Liu, Bing Wei" <bing.wei.liu@intel.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH V2] platform-driver-x86: ACPI EC Extra driver for
 Oaktrail
Message-ID: <20110107112409.GU9496@kai-debian>
References: <20110106025949.GJ9496@kai-debian>
 <20110107074115.GH30215@kai-debian>
 <AANLkTik=x-OTWGzRB2BgB1u748EDM=B3nsGpWbR8D-C5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik=x-OTWGzRB2BgB1u748EDM=B3nsGpWbR8D-C5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-07, 09:56 +0100, Corentin Chary wrote:
> > +static struct rfkill *oaktrail_rfkill_new(char *name, enum rfkill_type type,
> > +                                         unsigned long mask)
> > +{
> > +       int err;
> > +       struct rfkill *rfkill_dev;
> > +
> > +       rfkill_dev = rfkill_alloc(name, &oaktrail_device->dev, type,
> > +                                 &oaktrail_rfkill_ops, (void *)mask);
> > +       if (!rfkill_dev)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       err = rfkill_register(rfkill_dev);
> 
> Maybe you should add a rfkill_init_sw_state() call here, to be sure
> that the rfkill initial state is right.

Yes, agree with you, and I'm trying to do that, add a
rfkill_init_sw_state between rfkill_alloc() and rfkill_register()...

+       ec_read(OT_EC_DEVICE_STATE_ADDRESS, &value);
+       rfkill_init_sw_state(rfkill_dev, (value & mask) != 1);


However, test shows the EC seems not ready yet when booting runs here
(value = 0), and then all the radio set as "blocked". Hence the radio
state can't be persistent during reboot.. This is not we want.

Also tried to read out the EC address a little bit later, seems the EC
won't be ready until very late.

Am I doing something wrong? or I need to check with HW guy about this.


> > +       if (err) {
> > +               rfkill_destroy(rfkill_dev);
> > +               return ERR_PTR(err);
> > +       }
> > +       return rfkill_dev;
> > +}
> > +
