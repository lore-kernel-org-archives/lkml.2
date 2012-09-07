Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab2IGJ2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:28:55 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:35688 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760242Ab2IGJ2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:28:52 -0400
Date: Fri, 7 Sep 2012 11:28:34 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, shawn.guo@linaro.org, viresh.linux@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org, rubini@gnudd.com,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH RFC] sta2x11 common clock framework implementation
Message-ID: <20120907092834.GA11151@mail.gnudd.com>
References: <1340242165-4279-1-git-send-email-dciminaghi@mail.gnudd.com> <20120824014719.4547.80902@nucleus> <20120827150340.GA28839@mail.gnudd.com> <20120906233214.20289.8056@nucleus>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120906233214.20289.8056@nucleus>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 04:32:14PM -0700, Mike Turquette wrote:
> Quoting Davide Ciminaghi (2012-08-27 08:03:40)
> > On Thu, Aug 23, 2012 at 06:47:19PM -0700, Mike Turquette wrote:
> > > Yikes.  Is this code copied from a legacy clock framework
> > > implementation?  Since we have the nice struct clk_hw abstraction now I
> > > think it is worth considering breaking up struct sta2x11_clk_data into
> > > separate structs, one for each clock types.  This lets you get rid of
> > > the union and the .type member while keeping things nice and tidy and
> > > reducing the number of run-time checks.
> > > 
> > 
> > mmmm, not sure I have fully understood your comment here.
> > My basic idea was avoiding a huge list of clk_register_xxxyyy() calls by
> > using an array with one entry per clock and a for cycle. We then walk through
> > the array and call an init() function which does a runtime initialization of
> > the relevant table entry (by adding data such as pci base addresses, which are
> > unknown at compile time).  Finally a registration function is invoked, which
> > actually registers each clock.
> > We have one registration function per clock type, and the .type field is
> > needed to invoke the right registration function for each entry.
> > Then of course we need just one struct type to get an array. I
> > solved this by declaring a struct sta2x11_clk_data with some common fields
> > and an args union containing  "private" data for each clock type.
> > Intermediate register functions (do_register_xxxyyy()) are needed
> > because the clk_register_xxxyyy() functions have different prototypes for
> > each xxxyyy.
> > 
> 
> I did not read the code carefully enough the first time through and I
> think I misunderstood the purpose of the struct.
>
ok.
 
> > Would it be ok to have something like this:
> > 
> > 
> > struct sta2x11_clk_data {
> >        const char *basename;
> >        unsigned int reg_offset;
> >        struct clk *(*register)(struct sta2x11_clk_data *, const char *, int);
> >        void (*init)(struct sta2x11_clk_data *, struct sta2x11_clk_reg_data *);
> >        unsigned long flags;
> >        void *priv;
> > };
> > 
> > ?
> > 
> > with .priv pointing to a different struct for each clock type (for instance
> > struct fixed_rate_root_priv_data for a fixed rate clock), as you suggested.
> > 
> > Note that the .type field has also been replaced by a .register function
> > pointer. This would let us avoid the regfuncs[] table and make things more
> > symmetric (initialization would just work like registration). Well, I was
> > actually planning to use the .type field for disabling unimplemented clocks
> > on some of the supported boards (by setting their .type to "none"), but we
> > could do this by setting the init and/or register pointers to NULL, so that the
> > relevant array entry is skipped.
> > This new approach would require separate tables for each clock's private data,
> > instead of a single table containing everything is needed for registration,
> > but if it is ok for you, I'm fine with it.
> > 
> 
> That is up to you.  I'm OK with your original implementation, or the new
> suggested one.

Well, what I proposed could be somehow better, but the first version has the
advantage of being ready and tested :-) . I have to think about this a little
bit.

> Sorry for the noise.  

ok no problem.

> The other review comments from me still stand (especially spin_lock versus
> spin_lock_irqsave).  Will you be resubmitting the patch with the minor fixes?

yes of course. While waiting for your comments, I have been working on a
device tree implementation for our boards, so I will probably also submit
an initial devicetree support for clocks. I also need some patches of mine
on sta2x11-mfd to be accepted before the clock infrastructure can compile
on linux-next, I hope that will happen shortly (by the way, that's the main
reason why the patch was RFC only).

Thanks again and regards
Davide
