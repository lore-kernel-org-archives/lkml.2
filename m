Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab2H0PXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:23:13 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:37311 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab2H0PXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:23:11 -0400
X-Greylist: delayed 1152 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 11:23:10 EDT
Date: Mon, 27 Aug 2012 17:03:40 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, shawn.guo@linaro.org, viresh.linux@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org, rubini@gnudd.com,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH RFC] sta2x11 common clock framework implementation
Message-ID: <20120827150340.GA28839@mail.gnudd.com>
References: <1340242165-4279-1-git-send-email-dciminaghi@mail.gnudd.com> <20120824014719.4547.80902@nucleus>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120824014719.4547.80902@nucleus>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M >ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 06:47:19PM -0700, Mike Turquette wrote:
> Quoting Davide Ciminaghi (2012-06-20 18:29:25)
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 7b989ca..72013efe 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -497,6 +497,9 @@ config STA2X11
> >         depends on X86_32_NON_STANDARD && PCI
> >         select X86_DEV_DMA_OPS
> >         select X86_DMA_REMAP
> > +       select HAVE_CLK
> > +       select CLKDEV_LOOKUP
> > +       select COMMON_CLK
> >         select SWIOTLB
> >         select MFD_STA2X11
> >         select ARCH_REQUIRE_GPIOLIB
> 
> You only need to select COMMON_CLK here.  It selects CLKDEV_LOOKUP which
> in turn selects HAVE_CLK.
>
ok.

 
> <snip>
> > diff --git a/drivers/clk/sta2x11/clk-audio-pll.c b/drivers/clk/sta2x11/clk-audio-pll.c
> > new file mode 100644
> > index 0000000..6b28126
> > --- /dev/null
> > +++ b/drivers/clk/sta2x11/clk-audio-pll.c
> > @@ -0,0 +1,146 @@
> > +/*
> > + * Common clock api implementation for sta2x11
> > + * audio-pll clock type implementation
> > + *
> 
> Nitpick:  It is more common to put the copyright header at the very top
> and then this brief description below it.
> 
ok.

> > + * Copyright ST Microelectronics 2012 (Davide Ciminaghi)
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > + * See the GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> > + */
> 
> <snip>
> > +static int clk_audio_pll_enable(struct clk_hw *hw)
> > +{
> > +       struct clk_audio_pll *audio_pll = to_clk_audio_pll(hw);
> > +       u32 scpllctl;
> > +       spin_lock(audio_pll->lock);
> 
> spin_lock_irqsave?  clk_enable may be called with interrupts disabled.
> 
ok.

.....

> > +struct clk *sta2x11_clk_audio_pll(const char *name, const char *parent_name,
> > +                                 void __iomem *base, spinlock_t *lock)
> > +{
> 
> How about register_sta2x11_clk_audio_pll?
>
ok.
 
> > diff --git a/drivers/clk/sta2x11/clk-soc-pll.c b/drivers/clk/sta2x11/clk-soc-pll.c
> > new file mode 100644
> > index 0000000..80dc8bc
> > --- /dev/null
> > +++ b/drivers/clk/sta2x11/clk-soc-pll.c
> > @@ -0,0 +1,94 @@
> > +/*
> > + * Common clock api implementation for sta2x11
> > + * soc-pll clock type implementation
> > + *
> > + * Copyright ST Microelectronics 2012 (Davide Ciminaghi)
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > + * See the GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> > + */
> > +#define DEBUG
> > +
> > +#include <linux/slab.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/mfd/core.h>
> > +#include <linux/mfd/sta2x11-mfd.h>
> > +#include <asm/sta2x11.h>
> 
> #include <clk-provider.h>?
> 
> <snip>
> > diff --git a/drivers/clk/sta2x11/clk.h b/drivers/clk/sta2x11/clk.h
> > new file mode 100644
> > index 0000000..f505a64
> > --- /dev/null
> > +++ b/drivers/clk/sta2x11/clk.h
> > @@ -0,0 +1,68 @@
> > +/*
> > + * Common clock api implementation for sta2x11
> > + *
> > + * Davide Ciminaghi 2012 <ciminaghi@gnudd.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > + * See the GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> > + */
> > +#ifndef __STA2X11_CLK_H__
> > +#define __STA2X11_CLK_H__
> > +
> > +#include <linux/clk.h>
> > +#include <linux/clk-provider.h>
> 
> If clk-provider.h is included then clk.h is redundant.
> 
ok.

> <snip>
> > +/*
> > + * struct sta2x11_clk_data
> > + * This structure is used to build the table listing all the
> > + * clocks for a connext chip.
> > + *
> > + * @basename : basename of the clock (a .%d suffix will be added to
> > + * deal with multiple connext instances).
> > + * @type : sta2x11 clock type (see clk.h, enum sta2x11_clk_type)
> > + * @reg_offset : the controlling register's offset for this clock
> > + * @init : pointer to init function. When this pointer is not NULL, the
> > + * pointed function is invoked before clock registration. This is used to
> > + * fill the clock struct fields which are unknown at compile time (typically
> > + * virtual addresses of controlling registers).
> > + * @args : arguments needed for registration
> > + */
> > +struct sta2x11_clk_data {
> > +       const char *basename;
> > +       int type;
> > +       unsigned int reg_offset;
> > +       void (*init)(struct sta2x11_clk_data *, struct sta2x11_clk_reg_data *);
> > +       unsigned long flags;
> > +       union {
> > +               struct  {
> > +                       const char *parent_name;
> > +                       unsigned long rate;
> > +               } fixed_rate_root;
> > +               struct {
> > +                       const char *parent_name;
> > +                       unsigned int mult;
> > +                       unsigned int div;
> > +               } fixed_factor;
> > +               struct {
> > +                       const char **parent_names;
> > +                       u8 num_parents;
> > +                       void __iomem *reg;
> > +                       u8 shift;
> > +                       u8 width;
> > +                       u8 clk_mux_flags;
> > +                       spinlock_t *lock;
> > +               } mux;
> > +               struct {
> > +                       const char *parent_name;
> > +                       void __iomem *base;
> > +                       spinlock_t *lock;
> > +               } soc_pll;
> > +               struct {
> > +                       const char *parent_name;
> > +                       void __iomem *base;
> > +                       spinlock_t *lock;
> > +               } audio_pll;
> > +               struct {
> > +                       const char *parent_name;
> > +                       void __iomem *reg;
> > +                       u8 shift;
> > +                       u8 width;
> > +                       spinlock_t *lock;
> > +                       unsigned int *div_tab;
> > +               } tab_divider;
> > +       } args;
> > +};
> > +
> 
> Yikes.  Is this code copied from a legacy clock framework
> implementation?  Since we have the nice struct clk_hw abstraction now I
> think it is worth considering breaking up struct sta2x11_clk_data into
> separate structs, one for each clock types.  This lets you get rid of
> the union and the .type member while keeping things nice and tidy and
> reducing the number of run-time checks.
> 

mmmm, not sure I have fully understood your comment here.
My basic idea was avoiding a huge list of clk_register_xxxyyy() calls by
using an array with one entry per clock and a for cycle. We then walk through
the array and call an init() function which does a runtime initialization of
the relevant table entry (by adding data such as pci base addresses, which are
unknown at compile time).  Finally a registration function is invoked, which
actually registers each clock.
We have one registration function per clock type, and the .type field is
needed to invoke the right registration function for each entry.
Then of course we need just one struct type to get an array. I
solved this by declaring a struct sta2x11_clk_data with some common fields
and an args union containing  "private" data for each clock type.
Intermediate register functions (do_register_xxxyyy()) are needed
because the clk_register_xxxyyy() functions have different prototypes for
each xxxyyy.

Would it be ok to have something like this:


struct sta2x11_clk_data {
       const char *basename;
       unsigned int reg_offset;
       struct clk *(*register)(struct sta2x11_clk_data *, const char *, int);
       void (*init)(struct sta2x11_clk_data *, struct sta2x11_clk_reg_data *);
       unsigned long flags;
       void *priv;
};

?

with .priv pointing to a different struct for each clock type (for instance
struct fixed_rate_root_priv_data for a fixed rate clock), as you suggested.

Note that the .type field has also been replaced by a .register function
pointer. This would let us avoid the regfuncs[] table and make things more
symmetric (initialization would just work like registration). Well, I was
actually planning to use the .type field for disabling unimplemented clocks
on some of the supported boards (by setting their .type to "none"), but we
could do this by setting the init and/or register pointers to NULL, so that the
relevant array entry is skipped.
This new approach would require separate tables for each clock's private data,
instead of a single table containing everything is needed for registration,
but if it is ok for you, I'm fine with it.


Thanks for your review and regards
Davide




