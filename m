Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829Ab2KUUno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:43:44 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39935 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964773Ab2KUUnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:43:43 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
 <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
 <CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com>
Message-ID: <20121121204324.21126.99677@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Date: Wed, 21 Nov 2012 12:43:24 -0800
X-Originating-IP: [10.188.36.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Viresh Kumar (2012-11-20 02:13:55)
> On 20 November 2012 14:52, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > We'll need to invoke clk_unprepare() via a pointer in our devm_*
> > conversion so let's uninline the pair.
> 
> Sorry, but you aren't doing this :(
> This routine is already uninlined as it is in clk.c
> 
> Instead you are just moving clk_prepare(), etc calls within
> #ifdef CONFIG_HAVE_CLK
> #else
> #endif
> 
> I doubt why they have been added under #ifdef CONFIG_HAVE_CLK_PREPARE
> earlier. Can they exist without CONFIG_HAVE_CLK
> 
> @Mike: ?
> 

HAVE_CLK logically wraps HAVE_CLK_PREPARE.  There is no point in
selecting HAVE_CLK_PREPARE without HAVE_CLK.

Looking through the code I see that this used to be the case.  Commit
93abe8e "clk: add non CONFIG_HAVE_CLK routines" moved the
clk_(un)prepare declarations outside of #ifdef CONFIG_HAVE_CLK.  That
commit was authored by you.  Can you elaborate on why that aspect of the
patch was needed?

Thanks,
Mike

> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> >  drivers/clk/clk.c   |  4 ++++
> >  include/linux/clk.h | 68 +++++++++++++++++++++++++----------------------------
> >  2 files changed, 36 insertions(+), 36 deletions(-)
> >
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > index 56e4495e..1b642f2 100644
> > --- a/drivers/clk/clk.c
> > +++ b/drivers/clk/clk.c
> > @@ -374,6 +374,7 @@ struct clk *__clk_lookup(const char *name)
> >
> >  void __clk_unprepare(struct clk *clk)
> >  {
> > +#ifdef CONFIG_HAVE_CLK_PREPARE
> 
> clk.c is compiled if COMMON_CLK is selected. And COMMON_CLK has following:
>         select HAVE_CLK_PREPARE
> 
> So, these checks you added don't have a meaning.
> 
> >         if (!clk)
> >                 return;
> >
> > @@ -389,6 +390,7 @@ void __clk_unprepare(struct clk *clk)
> >                 clk->ops->unprepare(clk->hw);
> >
> >         __clk_unprepare(clk->parent);
> > +#endif
> >  }
> >
> >  /**
> > @@ -412,6 +414,7 @@ EXPORT_SYMBOL_GPL(clk_unprepare);
> >
> >  int __clk_prepare(struct clk *clk)
> >  {
> > +#ifdef CONFIG_HAVE_CLK_PREPARE
> 
> ditto.
> 
> >         int ret = 0;
> >
> >         if (!clk)
> > @@ -432,6 +435,7 @@ int __clk_prepare(struct clk *clk)
> >         }
> >
> >         clk->prepare_count++;
> > +#endif
> >
> >         return 0;
> >  }
> > diff --git a/include/linux/clk.h b/include/linux/clk.h
> > index b3ac22d..f8204c3 100644
> > --- a/include/linux/clk.h
> > +++ b/include/linux/clk.h
> > @@ -84,42 +84,6 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
> >
> >  #endif
> >
> > -/**
> > - * clk_prepare - prepare a clock source
> > - * @clk: clock source
> > - *
> > - * This prepares the clock source for use.
> > - *
> > - * Must not be called from within atomic context.
> > - */
> > -#ifdef CONFIG_HAVE_CLK_PREPARE
> > -int clk_prepare(struct clk *clk);
> > -#else
> > -static inline int clk_prepare(struct clk *clk)
> > -{
> > -       might_sleep();
> > -       return 0;
> > -}
> > -#endif
> > -
> > -/**
> > - * clk_unprepare - undo preparation of a clock source
> > - * @clk: clock source
> > - *
> > - * This undoes a previously prepared clock.  The caller must balance
> > - * the number of prepare and unprepare calls.
> > - *
> > - * Must not be called from within atomic context.
> > - */
> > -#ifdef CONFIG_HAVE_CLK_PREPARE
> > -void clk_unprepare(struct clk *clk);
> > -#else
> > -static inline void clk_unprepare(struct clk *clk)
> > -{
> > -       might_sleep();
> > -}
> > -#endif
> > -
> >  #ifdef CONFIG_HAVE_CLK
> >  /**
> >   * clk_get - lookup and obtain a reference to a clock producer.
> > @@ -159,6 +123,27 @@ struct clk *clk_get(struct device *dev, const char *id);
> >  struct clk *devm_clk_get(struct device *dev, const char *id);
> >
> >  /**
> > + * clk_prepare - prepare a clock source
> > + * @clk: clock source
> > + *
> > + * This prepares the clock source for use.
> > + *
> > + * Must not be called from within atomic context.
> > + */
> > +int clk_prepare(struct clk *clk);
> > +
> > +/**
> > + * clk_unprepare - undo preparation of a clock source
> > + * @clk: clock source
> > + *
> > + * This undoes a previously prepared clock.  The caller must balance
> > + * the number of prepare and unprepare calls.
> > + *
> > + * Must not be called from within atomic context.
> > + */
> > +void clk_unprepare(struct clk *clk);
> > +
> > +/**
> >   * clk_enable - inform the system when the clock source should be running.
> >   * @clk: clock source
> >   *
> > @@ -292,6 +277,17 @@ static inline void clk_put(struct clk *clk) {}
> >
> >  static inline void devm_clk_put(struct device *dev, struct clk *clk) {}
> >
> > +static inline int clk_prepare(struct clk *clk)
> > +{
> > +       might_sleep();
> > +       return 0;
> > +}
> > +
> > +static inline void clk_unprepare(struct clk *clk)
> > +{
> > +       might_sleep();
> > +}
> > +
> >  static inline int clk_enable(struct clk *clk)
> >  {
> >         return 0;
> > --
> > 1.7.11.7
> >
