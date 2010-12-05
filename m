Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0LELtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 06:49:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:25401 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab0LELtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 06:49:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,302,1288594800"; 
   d="scan'208";a="684051197"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "adrian.hunter@nokia.com" <adrian.hunter@nokia.com>,
        "prakity@marvell.com" <prakity@marvell.com>
Date: Sun, 5 Dec 2010 19:48:51 +0800
Subject: RE: [PATCH v3 2/3]set timeout control reg for such SDHCI host
Thread-Topic: [PATCH v3 2/3]set timeout control reg for such SDHCI host
Thread-Index: AcuT+vb+/wq8m0KFQH+1IfsPb0re8gAcoGGg
Message-ID: <5D8008F58939784290FAB48F54975198320B3E4508@shsmsx502.ccr.corp.intel.com>
References: <20101202112613.GC10358@intel.com>
 <20101202115329.GE3345@pengutronix.de>
 <5D8008F58939784290FAB48F54975198320B3E41F7@shsmsx502.ccr.corp.intel.com>
 <20101204213348.GE671@pengutronix.de>
In-Reply-To: <20101204213348.GE671@pengutronix.de>
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

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org
> [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of Wolfram Sang
> Sent: Sunday, December 05, 2010 5:34 AM
> To: Dong, Chuanxiao
> Cc: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; cjb@laptop.org;
> arjan@linux.intel.com; alan@linux.intel.com; akpm@linux-foundation.org;
> adrian.hunter@nokia.com; prakity@marvell.com
> Subject: Re: [PATCH v3 2/3]set timeout control reg for such SDHCI host
> 
> On Fri, Dec 03, 2010 at 10:38:59AM +0800, Dong, Chuanxiao wrote:
> >  >
> > > On Thu, Dec 02, 2010 at 07:26:13PM +0800, Chuanxiao Dong wrote:
> > >
> > > > +	if (host->quirks & SDHCI_QUIRK_FORCE_ERASE_SINGLE) {
> > > > +		/* Set the timeout to be the maximum value */
> > > > +		if (cmd->erase_timeout)
> > > > +			sdhci_writeb(host, 0xE, SDHCI_TIMEOUT_CONTROL);
> > > > +	}
> > > > +
> > > >  	sdhci_writew(host, SDHCI_MAKE_CMD(cmd->opcode, flags),
> > > > SDHCI_COMMAND);
> > >
> > > Hmm, this looks like another argument for Philip's idea to always
> > > use the maximum timeout value and skip the quirks related to it?
> >
> > Yes, if always using the maximum timeout value is OK for other command, the
> patch2 can be removed I think.
> > The new added quirk in the serials patches is used to set the limitation of request
> queue, not only just to set the timeout control reg.
> > Even the timeout value was set to be 0xE (the maximum value), erasing too many
> sectors can still be failed since the timeout time was still not longer enough.
> > So the count of erased sectors passed down by request queue should be reduced
> by using this quirk.
> 
> Yes, I think I understand the issue. Have you tried adding a callback, so we don't
> have the options between MAX_UINT and '1' but rather MAX_UINT and return
> value of the callback?

I added a function to calculate a more suitable max_discard_sectors value for SDHCI host controller in version 1 patches. This value was calculated by the timeout time host controller can wait and the erase timeout. Is that the callback you mean?
In this version, I added a function called mmc_set_discard_limit to detect whether the host has a new cap called MMC_CAP_ERASE_SINGLE. They can be found in patch1. If host has been set MMC_CAP_ERASE_SINGLE cap, just returns '1'. And if not, return MAX_UINT.
I used this way in version 3 patches instead of the calculated way since I thought using an easier way to work around a hardware issue was better. Any suggestion about solving this kind of problem?

Thanks
Chuanxiao
