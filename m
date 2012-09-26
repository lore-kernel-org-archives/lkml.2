Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2IZQcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:32:04 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:47382 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951Ab2IZQcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:32:02 -0400
Date: Wed, 26 Sep 2012 18:31:45 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor out common code
Message-ID: <20120926163145.GK10147@mail.gnudd.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com> <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com> <20120925192048.GA17038@sirena.org.uk> <20120926145615.GJ10147@mail.gnudd.com> <20120926150429.GQ4428@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120926150429.GQ4428@opensource.wolfsonmicro.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 04:04:29PM +0100, Mark Brown wrote:
> On Wed, Sep 26, 2012 at 04:56:15PM +0200, Davide Ciminaghi wrote:
> > On Tue, Sep 25, 2012 at 08:20:48PM +0100, Mark Brown wrote:
> 
> > > Glancing at the diff here this looks a lot like regmap-mmio...  not sure
> > > if it is or not, though.
> 
> > that would be ideal, but I also need to deal with the common clock framework,
> > which doesn't support regmap: clk_register_divider(), clk_register_mux(),
> > clk_register_gate(), all take a void __iomem * to access clock control
> > registers, so as far as I can understand we can't use regmap, unless of
> > course we convert the common clock framework to regmap.
> 
> The two should be able to coexist happily, regmap-mmio requires the
> caller to do the actual mapping and so long as you don't cache the
> relevant registers the two shouldn't interfere with each other.
>
Well, it just sounded not so clean to me having two ways for accessing the
same registers. The caller would be sta2x11-mfd in our case, while clock
registers are used by the common clock framework, so sta2x11-mfd should still
need to export some void __iomem *  to make the clock framework happy, while
other potential users could go via regmap.
Oh, and there's another problem (I'm looking at the code right now, I had
forgotten about this): the clock framework also asks for a spinlock_t *.
Regmap has its own spinlock (or mutex), and I don't think it would be a
good idea trying to export it.
So, as far as I can understand at present, the best thing to do would be
adding regmap support to the clock framework, which wouldn't be trivial
because I guess we should keep compatibility with the present
clk_register_... api

Davide
