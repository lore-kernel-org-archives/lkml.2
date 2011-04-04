Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1DDQiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:38:21 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:2242 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab1DDQiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:38:20 -0400
X-SpamScore: -33
X-BigFish: VPS-33(zz9371P542N1432N98dK1447Rzz1202hzz8275bhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: RE: [PATCH 2/3] ARM: Xilinx: add SMP specific support files
Date: Mon, 4 Apr 2011 10:37:00 -0600
In-Reply-To: <BANLkTi=ar5HHzr9Os6hXriD411ov457Nig@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/3] ARM: Xilinx: add SMP specific support files
Thread-Index: Acvy2t6DERlnesFDRiWuEIslSVhR5AACxBYA
References: <1301864418-12425-1-git-send-email-john.linn@xilinx.com><1301864418-12425-2-git-send-email-john.linn@xilinx.com><5ad00b91-47d8-4f02-aa72-5a413957cdb5@VA3EHSMHS005.ehs.local> <BANLkTi=ar5HHzr9Os6hXriD411ov457Nig@mail.gmail.com>
From: John Linn <John.Linn@xilinx.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <glikely@secretlab.ca>,
        <jamie@jamieiles.com>, <arnd@arndb.de>
X-OriginalArrivalTime: 04 Apr 2011 16:37:01.0362 (UTC) FILETIME=[85EEF120:01CBF2E6]
X-RCIS-Action: ALLOW
Message-ID: <c1c3050c-4c33-47bb-b257-f424eab5b5b7@VA3EHSMHS011.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p34GcVHi020478

> -----Original Message-----
> From: catalin.marinas@gmail.com [mailto:catalin.marinas@gmail.com] On
> Behalf Of Catalin Marinas
> Sent: Monday, April 04, 2011 9:13 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> linux@arm.linux.org.uk; glikely@secretlab.ca; jamie@jamieiles.com;
> arnd@arndb.de
> Subject: Re: [PATCH 2/3] ARM: Xilinx: add SMP specific support files
> 
> John,
> 
> A few suggestions on barriers below.
> 
> On 3 April 2011 22:00, John Linn <john.linn@xilinx.com> wrote:
> > diff --git a/arch/arm/mach-xilinx/platsmp.c b/arch/arm/mach-
> xilinx/platsmp.c
> > new file mode 100644
> > index 0000000..be2d55c
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/platsmp.c
> ...
> > +int __cpuinit boot_secondary(unsigned int cpu, struct task_struct
> *idle)
> > +{
> > +       unsigned long timeout;
> > +
> > +       /*
> > +        * set synchronisation state between this boot processor
> > +        * and the secondary one
> > +        */
> > +       spin_lock(&boot_lock);
> > +
> > +       printk(KERN_INFO "Xilinx SMP: booting CPU1 now\n");
> > +
> > +       /*
> > +        * Update boot lock register with the boot key to allow the
> > +        * secondary processor to start the kernel after an SEV.
> > +        */
> > +       __raw_writel(BOOT_LOCK_KEY, OCM_HIGH_BASE +
> BOOT_LOCK_OFFSET);
> > +
> > +       /* Flush the kernel cache to ensure that the page tables are
> > +        * available for the secondary CPU to use and make sure that
> > +        * the write buffer is drained before doing an SEV.
> > +        */
> > +       flush_cache_all();
> > +       smp_wmb();
> > +
> > +       /*
> > +        * Send an event to wake the secondary core from WFE state.
> > +        */
> > +       sev();
> 
> You could flush the cache before writing the boot lock register in
> case the secondary wakes up from WFE. 

Understood. Since we control when it gets into the kernel completely I guess I wasn't worried about it, maybe I should have been.  Easy enough to change, not a big deal.

> You also need a wmb() rather
> than the smp_wmb(). The latter only works in the inner shareable
> domain but the secondary CPU hasn't initialised the MMU yet.

Ok, great, appreciate the help there.

> 
> Something like below:
> 
> flush_cache_all();
> __raw_writel(BOOT_LOCK_KEY, OCM_HIGH_BASE + BOOT_LOCK_OFFSET);
> mb();
> sev();
> 
> > +void __init platform_smp_prepare_cpus(unsigned int max_cpus)
> > +{
> > +       int i;
> > +
> > +       /*
> > +        * Initialise the present map, which describes the set of
> CPUs
> > +        * actually populated at the present time.
> > +        */
> > +       for (i = 0; i < max_cpus; i++)
> > +               set_cpu_present(i, true);
> > +
> > +       scu_enable(scu_base);
> > +
> > +       /* Initialize the boot lock register to prevent CPU1 from
> > +          starting the kernel before CPU0 is ready for that.
> > +       */
> > +       __raw_writel(0, OCM_HIGH_BASE + BOOT_LOCK_OFFSET);
> > +
> > +       /*
> > +        * Write the address of secondary startup routine into the
> > +        * boot address. The secondary CPU will use this value
> > +        * to get into the kernel after it's awake from WFE state.
> > +        *
> > +        * Note the physical address is needed as the secondary CPU
> > +        * will not have the MMU on yet. A barrier is added to ensure
> > +        * that write buffer is drained.
> > +        */
> > +       __raw_writel(virt_to_phys(xilinx_secondary_startup),
> > +                                       OCM_HIGH_BASE +
> BOOT_ADDR_OFFSET);
> > +       smp_wmb();
> 
> Same here, use a wmb() or mb() before the sev().
> 

Yes.

Thanks for the input and taking time to review.  I'll wait a bit to see if any 
other input before spinning a new patch set.

-- John

> --
> Catalin


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
