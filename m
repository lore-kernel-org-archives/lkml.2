Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab2EOOc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:32:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46365 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102Ab2EOOc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:32:58 -0400
Message-ID: <4FB268F9.9040508@ti.com>
Date: Tue, 15 May 2012 16:32:25 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>, Paul Walmsley <paul@pwsan.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: OMAP4: PM: Keep static dep between MPUSS and ABE
 clockdomain
References: <1337082156-30390-1-git-send-email-tarun.kanti@ti.com>
In-Reply-To: <1337082156-30390-1-git-send-email-tarun.kanti@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Paul

Hi Tarun,

On 5/15/2012 1:42 PM, Tarun Kanti DebBarma wrote:
> Commit 68523f4233de5f233478dde0a63047b4efb710b8 (ARM: OMAP4:
> Workaround the OCP synchronisation issue with 32K synctimer)
> does not include GP Timers in ABE domain. Since synchronization
> issue is applicable to all GPTIMER[1-12], we also need to set
> static dependency of MPUSS with abe_clkdm and l4_per_clkdm.
> Dependency with l4_per_clkdm timers is already set in commit
> 12f27826bdaf56b01cbdfc8bdeb577ebc106dee3 (ARM: OMAP4: PM: Keep
> static dep between MPUSS-EMIF and MPUSS-L3/L4 and DUCATI-L3).
> Therefore, set static dependency of MPUSS with abe_clkdm.

It seems to me that these various static dep workaround patches are more and more confusing and should require some further investigation / explanation.

If we keep doing that we will end up having every clock domains always ON each time the CPU is active. This is a very brute force approach not really acceptable for mainline and for PM point of view.

Here we are forcing the ABE domain to be ON each time the MPU is ON even if we do not have any timer used inside the domain.

It was mostly OK to do that for the wakeup domain due to the small power impact, but doing that on the L4_PER and ABE seems a little bit too much.

The fix assumes as well that the MPU is the only user of that timer. What if either DSP or IPU uses it as well?


Moreover the previous 68523f4233de5f2 commit did add tons of deps that does not seems to be really justified by any HW errata AFAIK.
That does not mean they are not needed, but I think we should either remove them or add some more explanation.

+       /*
+        * The dynamic dependency between MPUSS -> MEMIF and
+        * MPUSS -> L4_PER/L3_* and DUCATI -> L3_* doesn't work as
+        * expected. The hardware recommendation is to enable static
+        * dependencies for these to avoid system lock ups or random crashes.
+        */
+       mpuss_clkdm = clkdm_lookup("mpuss_clkdm");
+       emif_clkdm = clkdm_lookup("l3_emif_clkdm");
+       l3_1_clkdm = clkdm_lookup("l3_1_clkdm");
+       l3_2_clkdm = clkdm_lookup("l3_2_clkdm");
+       l4_per_clkdm = clkdm_lookup("l4_per_clkdm");
+       ducati_clkdm = clkdm_lookup("ducati_clkdm");
+       if ((!mpuss_clkdm) || (!emif_clkdm) || (!l3_1_clkdm) ||
+               (!l3_2_clkdm) || (!ducati_clkdm) || (!l4_per_clkdm))
+               goto err2;
+
+       ret = clkdm_add_wkdep(mpuss_clkdm, emif_clkdm);

AFAIK, this one is the only one covered by an errata. It might be good to add a comment to explained the issue.

+       ret |= clkdm_add_wkdep(mpuss_clkdm, l3_1_clkdm);
+       ret |= clkdm_add_wkdep(mpuss_clkdm, l3_2_clkdm);
+       ret |= clkdm_add_wkdep(mpuss_clkdm, l4_per_clkdm);
+       ret |= clkdm_add_wkdep(ducati_clkdm, l3_1_clkdm);
+       ret |= clkdm_add_wkdep(ducati_clkdm, l3_2_clkdm);

Do we have errata for any of these ones?



There is as well a confusion in the way the dep is explained. The dep is from a domain to a other one. Just saying a dep between domains is thus confusing.
We do not know what is the initiator and what is the source.

To add on top of that confusion, the API seems to explain the reverse dep.

 * clkdm_add_wkdep - add a wakeup dependency from clkdm2 to clkdm1
 * @clkdm1: wake this struct clockdomain * up (dependent)
 * @clkdm2: when this struct clockdomain * wakes up (source)

Reading that you are implementing a dep from ABE to MPU. 

> +	ret |= clkdm_add_wkdep(mpuss_clkdm, abe_clkdm);

Which is clearly not what is done, since the HW setting is correct at the end.
The API is setting the CM_MPU_STATICDEP.ABE_STATDEP bit. Meaning a dep from MPU domain toward target ABE domain.

I guess the kerneldoc has to be updated.


Paul,

That sounds like an OMAP3 legacy stuff, isn't it? OMAP4 does not have these separate wkup / sleep dep anymore but only domain dep.


Regards,
Benoit
