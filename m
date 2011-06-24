Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698Ab1FXPoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 11:44:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60678 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab1FXPoS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 11:44:18 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>, "Grosen, Mark" <mgrosen@ti.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 24 Jun 2011 21:13:49 +0530
Subject: RE: [RFC 5/8] remoteproc: add davinci implementation
Thread-Topic: [RFC 5/8] remoteproc: add davinci implementation
Thread-Index: AcwygZv0mvORrL7JTyCtPxMg8s/QwAAAcl8w
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D6C2F29@dbde02.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
	<1308640714-17961-6-git-send-email-ohad@wizery.com>
	<4E035B78.3080200@mvista.com>
	<FFF198FBBF957F4393BA834040FEFFA202D66E@DFLE35.ent.ti.com>
 <4E04A9AE.3030801@mvista.com>
In-Reply-To: <4E04A9AE.3030801@mvista.com>
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

Hi Mark,

On Fri, Jun 24, 2011 at 20:43:50, Sergei Shtylyov wrote:

> >>> +	rproc->priv = dsp_clk;
> >>> +
> >>> +	psc_base = ioremap(soc_info->psc_bases[0], SZ_4K);
> >>> +
> >>> +	/* insure local reset is asserted before writing start address */
> >>> +	__raw_writel(NEXT_ENABLED, psc_base + MDCTL + 4 *
> >> DA8XX_LPSC0_GEM);
> >>> +
> >>> +	__raw_writel(bootaddr, DA8XX_SYSCFG0_VIRT(HOST1CFG));
> 
> >>     DA8XX_SYSCFG0_VIRT() is not supposed to be used outside mach-davinci. The
> >> variable it refers is not exported, so driver module won't work.
> 
> > Ooops, I clearly did not build this as a module. Suggestion how to fix this?
> 
>     Using the normal ioremap() of SYSCFG0 space, I suppose.

Since procedure to set the boot address varies across DaVinci
platforms, you could have a callback populated in platform data
which will be implemented differently for original DaVinci and
DA8xx devices.

Also, all PSC accesses are better off going through clock
framework to ensure proper locking and modularity.

To assert/de-assert local reset when enabling or disabling PSC,
you could use a flag in the clock structure to indicate the need
for this. This way, if there is any other module needing a local
reset, it can just define the same flag. Similarly, if the DSP
does not need a local reset on a particular platform, that
platform can simply skip the flag.

This can be done in a manner similar to how the support for
a forced transition PSC was added here:

https://patchwork.kernel.org/patch/662941/

Thanks,
Sekhar

