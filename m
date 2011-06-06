Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab1FFHtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:49:13 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:33740 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab1FFHtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:49:09 -0400
Date: Mon, 6 Jun 2011 09:49:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Emese Revfy <re.emese@gmail.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk
Subject: Re: [Cocci] Re: status of constification
In-Reply-To: <4DEBF96D.3030209@gmail.com>
Message-ID: <Pine.LNX.4.64.1106060948050.17498@ask.diku.dk>
References: <20101108223844.GS5876@outflux.net> <4CD9BF25.4090306@gmail.com>
 <20110528031348.GA19633@outflux.net> <Pine.LNX.4.64.1105280838150.30088@ask.diku.dk>
 <4DEBF96D.3030209@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jun 2011, Emese Revfy wrote:

> > Could I see the semantic patch?  The clean up issue sounds interesting.
> > Perhaps there is a way around it.
> 
> Hi,
> I no longer use Coccinelle to generate constification patch, but only to find
> candidate structures for constification. This is because I ran into several
> issues
> some of which I will try describe now from memory (unfortunately I don't have
> those Cocci scripts anymore):
> 
> 1. Sometimes (always?) cocci removed NULL initialization while emitting the
> constified patch:
> 
> linux-2.6.39-rc7/arch/frv/mb93090-mb00/pci-vdk.c
> @@ -356,7 +356,7 @@ void __init pcibios_fixup_bus(struct pci
>  
>  int __init pcibios_init(void)
>  {
> -       struct pci_ops *dir = NULL;
> +       const struct pci_ops *dir;
>  
>         if (!mb93090_mb00_detected)
>                 return -ENXIO;
> 
> 2. Sometimes (always?) cocci joined structure field lines into one line while
> constifying  them:
> 
> linux-2.6.39-rc7/arch/x86/include/asm/x86_init.h
> @@ -119,14 +119,7 @@ struct x86_init_pci {
>   *
>   */
>  struct x86_init_ops {
> -       struct x86_init_resources       resources;
> -       struct x86_init_mpparse         mpparse;
> -       struct x86_init_irqs            irqs;
> -       struct x86_init_oem             oem;
> -       struct x86_init_paging          paging;
> -       struct x86_init_timers          timers;
> -       struct x86_init_iommu           iommu;
> -       struct x86_init_pci             pci;
> +       const struct x86_init_resources resources;const struct
> x86_init_mpparse mpparse;const struct x86_init_irqs irqs;const struct
> x86_init_oem oem;const struct x86_init_paging paging;const struct
> x86_init_timers timers;const struct x86_init_iommu iommu;const struct
> x86_init_pci pci;
>  };

This problem seem to be solved.  At least, I don't see the problem for the 
following semantic patch:

@@
identifier i,x;
type T;
@@

struct i {
  ...
- T x;
+ const T x;
  ...
};

on the following code:

struct i {
  int a;
  int b;
  /* a comment */
  int c;
  int d;
};

The comment is preserved as well.

julia

>  /**
> 
> 3. Sometimes cocci removed comment lines while joining others, maybe related
>    to the previous issue:
>  linux-2.6.39-rc7/drivers/net/wireless/ath/ath9k/hw.h
> @@ -753,9 +753,7 @@ struct ath_hw {
>         } enable_32kHz_clock;
> 
>         /* Private to hardware code */
> -       struct ath_hw_private_ops private_ops;
> -       /* Accessed by the lower level driver */
> -       struct ath_hw_ops ops;
> +       const struct ath_hw_private_ops private_ops;const struct ath_hw_ops
> ops;
> 
>         /* Used to program the radio on non single-chip devices */
>         u32 *analogBank0Data;
> 
> 4. My constification patch generator cocci script didn't find all structures
> that it should have, I don't know whether it was a bug in my script or in
> cocci but in the end I just gave it up.
> 
> --
> Emese
> 
> 
