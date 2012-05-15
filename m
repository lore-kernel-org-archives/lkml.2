Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab2EOPBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:01:08 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:40778 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932875Ab2EOPBG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:01:06 -0400
MIME-Version: 1.0
In-Reply-To: <4FB268F9.9040508@ti.com>
References: <1337082156-30390-1-git-send-email-tarun.kanti@ti.com> <4FB268F9.9040508@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Tue, 15 May 2012 20:30:44 +0530
Message-ID: <CAMQu2gy72cbR4+xr6pYQBamNSjLdxUu4s_MkDf=pwrPnB56enA@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP4: PM: Keep static dep between MPUSS and ABE clockdomain
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>, Paul Walmsley <paul@pwsan.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 8:02 PM, Cousson, Benoit <b-cousson@ti.com> wrote:
> + Paul
>
> Hi Tarun,
>
> On 5/15/2012 1:42 PM, Tarun Kanti DebBarma wrote:
>> Commit 68523f4233de5f233478dde0a63047b4efb710b8 (ARM: OMAP4:
>> Workaround the OCP synchronisation issue with 32K synctimer)
>> does not include GP Timers in ABE domain. Since synchronization
>> issue is applicable to all GPTIMER[1-12], we also need to set
>> static dependency of MPUSS with abe_clkdm and l4_per_clkdm.
>> Dependency with l4_per_clkdm timers is already set in commit
>> 12f27826bdaf56b01cbdfc8bdeb577ebc106dee3 (ARM: OMAP4: PM: Keep
>> static dep between MPUSS-EMIF and MPUSS-L3/L4 and DUCATI-L3).
>> Therefore, set static dependency of MPUSS with abe_clkdm.
>
> It seems to me that these various static dep workaround patches are more and more confusing and should require some further investigation / explanation.
>
This is a new BUG which has not made it to errata list yet. It will
make it eventually.

> If we keep doing that we will end up having every clock domains always ON each time the CPU is active. This is a very brute force approach not really acceptable for mainline and for PM point of view.
>
Indeed.

> Here we are forcing the ABE domain to be ON each time the MPU is ON even if we do not have any timer used inside the domain.
>
Actually the BUG is really related to timers running on 32KHz and only
in that case such a WA is needed. BTW, the WA is suggested by hardware
team.

> It was mostly OK to do that for the wakeup domain due to the small power impact, but doing that on the L4_PER and ABE seems a little bit too much.
>
L4PER and ABE should not be set default....

> The fix assumes as well that the MPU is the only user of that timer. What if either DSP or IPU uses it as well?
>

> Moreover the previous 68523f4233de5f2 commit did add tons of deps that does not seems to be really justified by any HW errata AFAIK.
> That does not mean they are not needed, but I think we should either remove them or add some more explanation.
>
EMIF and L3 are covered as part of the errata's. Most if these static
deps issues never worked properly and people ended up hacking
like disable L3 when display ON etc etc.

> +       /*
> +        * The dynamic dependency between MPUSS -> MEMIF and
> +        * MPUSS -> L4_PER/L3_* and DUCATI -> L3_* doesn't work as
> +        * expected. The hardware recommendation is to enable static
> +        * dependencies for these to avoid system lock ups or random crashes.
> +        */
> +       mpuss_clkdm = clkdm_lookup("mpuss_clkdm");
> +       emif_clkdm = clkdm_lookup("l3_emif_clkdm");
> +       l3_1_clkdm = clkdm_lookup("l3_1_clkdm");
> +       l3_2_clkdm = clkdm_lookup("l3_2_clkdm");
> +       l4_per_clkdm = clkdm_lookup("l4_per_clkdm");
> +       ducati_clkdm = clkdm_lookup("ducati_clkdm");
> +       if ((!mpuss_clkdm) || (!emif_clkdm) || (!l3_1_clkdm) ||
> +               (!l3_2_clkdm) || (!ducati_clkdm) || (!l4_per_clkdm))
> +               goto err2;
> +
> +       ret = clkdm_add_wkdep(mpuss_clkdm, emif_clkdm);
>
> AFAIK, this one is the only one covered by an errata. It might be good to add a comment to explained the issue.
>
> +       ret |= clkdm_add_wkdep(mpuss_clkdm, l3_1_clkdm);
> +       ret |= clkdm_add_wkdep(mpuss_clkdm, l3_2_clkdm);
> +       ret |= clkdm_add_wkdep(mpuss_clkdm, l4_per_clkdm);
> +       ret |= clkdm_add_wkdep(ducati_clkdm, l3_1_clkdm);
> +       ret |= clkdm_add_wkdep(ducati_clkdm, l3_2_clkdm);
>
> Do we have errata for any of these ones?
>
If we forget about the latest timer issues doing the round only EMIF and L3
deps with different initiators were needed. L4PER was because of UART
idle mode issue which I fixed recently. At least with that fix, L4PER should
be killed. Will be good to take the latest findings on the static deps issues
and update above list.

These timer OCP sync issue has really created a big mess again...
Timer is 3 domains. AON, ABE and L4pER and the WA suggested is
static dep as if it is free. There is no other WA.

Regards
Santosh
