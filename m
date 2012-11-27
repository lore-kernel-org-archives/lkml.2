Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab2K0Rww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:52:52 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62476 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab2K0Rwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:52:51 -0500
MIME-Version: 1.0
In-Reply-To: <20121126195742.21126.16500@nucleus>
References: <1353957609-1295-1-git-send-email-Russ.Dill@ti.com>
	<20121126195742.21126.16500@nucleus>
Date: Tue, 27 Nov 2012 09:52:50 -0800
X-Google-Sender-Auth: wNHs5UyUWHN6BEAvrO0dkt_4t1s
Message-ID: <CA+Bv8XbR68-VcOF3JkL47+L9yZFkpv16JTbQfA02yZUGnPZvEQ@mail.gmail.com>
Subject: Re: [PATCH] Don't mark shared helper functions as inline
From: Russ Dill <Russ.Dill@ti.com>
To: Mike Turquette <mturquette@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 11:57 AM, Mike Turquette <mturquette@ti.com> wrote:
>
> Quoting Russ Dill (2012-11-26 11:20:09)
> > The helper functions that access the opaque struct clk should
> > not be marked inline since they are contained in clk.c, but expected
> > to be used by other compilation units. This causes compile errors
> > under gcc-4.7
> >
> > In file included from arch/arm/mach-omap2/clockdomain.c:25:0:
> > arch/arm/mach-omap2/clockdomain.c: In function ‘clkdm_clk_disable’:
> > include/linux/clk-provider.h:338:12: error: inlining failed in call to always_inline ‘__clk_get_enable_count’: function body not available
> > arch/arm/mach-omap2/clockdomain.c:1001:28: error: called from here
> > make[1]: *** [arch/arm/mach-omap2/clockdomain.o] Error 1
> > make: *** [arch/arm/mach-omap2] Error 2
> >
>
> Hi Russ,
>
> A fix for this was merged into rc7.  See 93532c8a, "clk: remove inline
> usage from clk-provider.h".
>
> Regardless, I'm still considering this patch.  I've heard many times
> that we should trust the compiler to optimize for us and some folks look
> down on inlining in general.  If anyone has an opinion on removing
> inlines from the common clk core then please do speak up.
>
> Russ, can you update to the latest rc and verify if that fix is enough
> for you?

Yes, that commit fixes the compile issue too. I'd go with the more
complete removal of inlines though. If you have a declaration in a
header, it makes no sense to call it inline in the .c

> Regards,
> Mike
>
> >
> > Signed-off-by: Russ Dill <Russ.Dill@ti.com>
> > ---
> >  drivers/clk/clk.c            | 14 +++++++-------
> >  include/linux/clk-provider.h |  4 ++--
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > index 56e4495e..ed01746 100644
> > --- a/drivers/clk/clk.c
> > +++ b/drivers/clk/clk.c
> > @@ -249,32 +249,32 @@ late_initcall(clk_disable_unused);
> >
> >  /***    helper functions   ***/
> >
> > -inline const char *__clk_get_name(struct clk *clk)
> > +const char *__clk_get_name(struct clk *clk)
> >  {
> >         return !clk ? NULL : clk->name;
> >  }
> >
> > -inline struct clk_hw *__clk_get_hw(struct clk *clk)
> > +struct clk_hw *__clk_get_hw(struct clk *clk)
> >  {
> >         return !clk ? NULL : clk->hw;
> >  }
> >
> > -inline u8 __clk_get_num_parents(struct clk *clk)
> > +u8 __clk_get_num_parents(struct clk *clk)
> >  {
> >         return !clk ? -EINVAL : clk->num_parents;
> >  }
> >
> > -inline struct clk *__clk_get_parent(struct clk *clk)
> > +struct clk *__clk_get_parent(struct clk *clk)
> >  {
> >         return !clk ? NULL : clk->parent;
> >  }
> >
> > -inline int __clk_get_enable_count(struct clk *clk)
> > +int __clk_get_enable_count(struct clk *clk)
> >  {
> >         return !clk ? -EINVAL : clk->enable_count;
> >  }
> >
> > -inline int __clk_get_prepare_count(struct clk *clk)
> > +int __clk_get_prepare_count(struct clk *clk)
> >  {
> >         return !clk ? -EINVAL : clk->prepare_count;
> >  }
> > @@ -300,7 +300,7 @@ out:
> >         return ret;
> >  }
> >
> > -inline unsigned long __clk_get_flags(struct clk *clk)
> > +unsigned long __clk_get_flags(struct clk *clk)
> >  {
> >         return !clk ? -EINVAL : clk->flags;
> >  }
> > diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> > index c127315..f9f5e9e 100644
> > --- a/include/linux/clk-provider.h
> > +++ b/include/linux/clk-provider.h
> > @@ -335,8 +335,8 @@ const char *__clk_get_name(struct clk *clk);
> >  struct clk_hw *__clk_get_hw(struct clk *clk);
> >  u8 __clk_get_num_parents(struct clk *clk);
> >  struct clk *__clk_get_parent(struct clk *clk);
> > -inline int __clk_get_enable_count(struct clk *clk);
> > -inline int __clk_get_prepare_count(struct clk *clk);
> > +int __clk_get_enable_count(struct clk *clk);
> > +int __clk_get_prepare_count(struct clk *clk);
> >  unsigned long __clk_get_rate(struct clk *clk);
> >  unsigned long __clk_get_flags(struct clk *clk);
> >  int __clk_is_enabled(struct clk *clk);
> > --
> > 1.8.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
