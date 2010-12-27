Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0L0KEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 05:04:23 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:37590 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab0L0KEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 05:04:22 -0500
From: Florian Fainelli <ffainelli@freebox.fr>
Organization: Freebox
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] coretemp: fix junction temperature for Intel CE4100
Date: Mon, 27 Dec 2010 11:04:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-server; KDE/4.5.1; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "sodaville@linutronix.de" <sodaville@linutronix.de>
References: <201012142217.07194.ffainelli@freebox.fr> <493994B35A117E4F832F97C4719C4C04D781EF3F@orsmsx505.amr.corp.intel.com>
In-Reply-To: <493994B35A117E4F832F97C4719C4C04D781EF3F@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012271104.43416.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Saturday 25 December 2010 23:28:33 Yu, Fenghua wrote:
> > -----Original Message-----
> > From: Florian Fainelli [mailto:f.fainelli@gmail.com] On Behalf Of
> > Florian Fainelli
> > Sent: Tuesday, December 14, 2010 1:17 PM
> > To: linux-kernel@vger.kernel.org; Dirk Brandewie;
> > sodaville@linutronix.de; Yu, Fenghua
> > Subject: [PATCH] coretemp: fix junction temperature for Intel CE4100
> > 
> > From: Florian Fainelli <ffainelli@freebox.fr>
> > 
> > The Intel CE4100 System-on-a-Chip has a slightly higher junction
> > temperature
> > (110 degrees Celsius) than other Atom-based hardware.
> > 
> > Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> > Cc: sodaville@linutronix.de
> > Cc: Fenghua Yu <fenghua.yu@intel.com>
> > Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
> > ---
> > diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> > index 42de98d..e47b405 100644
> > --- a/drivers/hwmon/coretemp.c
> > +++ b/drivers/hwmon/coretemp.c
> > @@ -178,12 +178,23 @@ static int __devinit adjust_tjmax(struct
> > cpuinfo_x86 *c, u32 id, struct device *
> > 
> >  		host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
> > 
> > -		if (host_bridge && host_bridge->vendor ==
> > PCI_VENDOR_ID_INTEL
> > -		    && (host_bridge->device == 0xa000	/* NM10 based
> > nettop */
> > -		    || host_bridge->device == 0xa010))	/* NM10 based
> > netbook */
> > -			tjmax = 100000;
> > -		else
> > -			tjmax = 90000;
> > +		if (host_bridge && host_bridge->vendor ==
> > PCI_VENDOR_ID_INTEL) {
> > +			switch (host_bridge->device) {
> > +			/* NM10 based nettop */
> > +			case 0xa000:
> > +			/* NM10 based netbook */
> > +			case 0xa010:
> > +				tjmax = 100000;
> > +				break;
> > +			/* IntelCE Sodaville (CE4100) */
> > +			case 0x0708:
> > +				tjmax = 110000;
> > +				break;
> > +			default:
> > +				tjmax = 90000;
> > +				break;
> > +			}
> > +		}
> > 
> >  		pci_dev_put(host_bridge);
> >  	
> >  	}
> 
> When host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL is not true,
> tjmax is not assigned to 90000. This is different from original code.

Whoops, I will post a second version of that patch.

> 
> Could you add public spec URL or public spec name for 110 degrees C in your
> comments? People may get lost to find this info.

I will try to find a public documentation stating that, but that was in the SDK
we received and I could not find any public information about this yet.
--
Florian
