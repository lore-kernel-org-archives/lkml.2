Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1EQSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:25:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41810 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077Ab1EQSZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:25:25 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 17 May 2011 23:55:01 +0530
Subject: RE: [PATCH 1/1] davinci: changed SRAM allocator to shared ram.
Thread-Topic: [PATCH 1/1] davinci: changed SRAM allocator to shared ram.
Thread-Index: AcwT/KSEkgx/ItD8QB+urAAS8R/5QwAl9fKQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024CF13FC0@dbde02.ent.ti.com>
References: <1297434088-27995-1-git-send-email-subhasish@mistralsolutions.com>
	<B85A65D85D7EB246BE421B3FB0FBB593024BE49175@dbde02.ent.ti.com>
	<886E26C48DE446C3937D89ECF86030B2@subhasishg>
	<B85A65D85D7EB246BE421B3FB0FBB593024BE49711@dbde02.ent.ti.com>
	<25DBF349769A4CF7B883D6D7FF01AD70@subhasishg>
	<B85A65D85D7EB246BE421B3FB0FBB593024C0082E3@dbde02.ent.ti.com>
 <BANLkTimDw3T2CFAw6te-smj2q07F=+_wbA@mail.gmail.com>
In-Reply-To: <BANLkTimDw3T2CFAw6te-smj2q07F=+_wbA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 00:38:21, Ben Gardiner wrote:
> Hi Subhasish and Sekhar,
> 
> Subhashish, I was testing your patch here while investigating
> davinci-pcm ping-pong buffers on da850.
> 
> On Fri, Feb 11, 2011 at 9:21 AM, Subhasish Ghosh
> <subhasish@mistralsolutions.com> wrote:
> > This patch modifies the sram allocator to allocate memory
> > from the DA8XX shared RAM.
> >
> > Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> > ---
> >  arch/arm/mach-davinci/da850.c              |    6 +++---
> >  arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
> 
> Since this changes only the da850 behaviour, a subject prefix of da850
> might be more appropriate than 'davinci'.

Please use "davinci: da850: ..."

> 
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
> > index 3443d97..8a4de97 100644
> > --- a/arch/arm/mach-davinci/da850.c
> > +++ b/arch/arm/mach-davinci/da850.c
> > @@ -711,7 +711,7 @@ static struct map_desc da850_io_desc[] = {
> >        },
> >        {
> >                .virtual        = SRAM_VIRT,
> > -               .pfn            = __phys_to_pfn(DA8XX_ARM_RAM_BASE),
> > +               .pfn            = __phys_to_pfn(DA8XX_SHARED_RAM_BASE),
> >                .length         = SZ_8K,
> 
> Assigning only 8K to this iomap will result in a fault for the first
> victim to access SRAM_VIRT+0x2000. This will happen for example with
> mcasp ping-pong buffers totalling more than 8K on the da850.
> 
> Unfortunately SZ_128K cannot be used here since it will cause a panic

Okay, I am seeing this too. Kernel panics after freeing init memory.
No idea on this one, needs to be debugged.

Freeing init memory: 136K
Kernel panic - not syncing: Attempted to kill init!
[<c002f094>] (unwind_backtrace+0x0/0xec) from [<c024bf7c>] (panic+0x5c/0x184)
[<c024bf7c>] (panic+0x5c/0x184) from [<c00427dc>] (do_exit+0xb4/0x6c4)
[<c00427dc>] (do_exit+0xb4/0x6c4) from [<c0042ea4>] (do_group_exit+0xb8/0xe8)
[<c0042ea4>] (do_group_exit+0xb8/0xe8) from [<c004eaa4>] (get_signal_to_deliver+0x398/0x3f4)
[<c004eaa4>] (get_signal_to_deliver+0x398/0x3f4) from [<c002ca7c>] (do_notify_resume+0x60/0x610)
[<c002ca7c>] (do_notify_resume+0x60/0x610) from [<c002afd4>] (work_pending+0x24/0x28)

> on boot. SZ_64K works though.

Right.

> 
> >                .type           = MT_DEVICE
> >        },
> > @@ -1083,8 +1083,8 @@ static struct davinci_soc_info davinci_soc_info_da850 = {
> >        .gpio_irq               = IRQ_DA8XX_GPIO0,
> >        .serial_dev             = &da8xx_serial_device,
> >        .emac_pdata             = &da8xx_emac_pdata,
> > -       .sram_dma               = DA8XX_ARM_RAM_BASE,
> > -       .sram_len               = SZ_8K,
> > +       .sram_dma               = DA8XX_SHARED_RAM_BASE,
> > +       .sram_len               = SZ_128K,
> 
> This should probably be set to match whatever is reported in the map

You are right, the two sizes should match.

> entry above -- or an ioremap could be issued later but before the sram
> init?

Yes, ioremap would be better. I am not sure why a fixed mapping
for SRAM is required.

Please base these patches on Russell's SRAM consolidation patch.

Thanks,
Sekhar

