Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab2DXO1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:27:39 -0400
Received: from londo.lunn.ch ([80.238.139.98]:50258 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab2DXO1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:27:37 -0400
Date: Tue, 24 Apr 2012 16:29:39 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: viresh kumar <viresh.linux@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Viresh Kumar <viresh.kumar@st.com>,
        akpm@linux-foundation.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        linux@arm.linux.org.uk, linux-ide@vger.kernel.org
Subject: Re: [PATCH V3 07/12] ata/sata_mv: Remove conditional compilation of
 clk code
Message-ID: <20120424142939.GG24089@lunn.ch>
Mail-Followup-To: viresh kumar <viresh.linux@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Viresh Kumar <viresh.kumar@st.com>,
	akpm@linux-foundation.org, spear-devel@list.st.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
	linux@arm.linux.org.uk, linux-ide@vger.kernel.org
References: <cover.1335266056.git.viresh.kumar@st.com>
 <abbcf661dc58948794839eb0fba1d5a0950ec848.1335266056.git.viresh.kumar@st.com>
 <20120424120019.GE24089@lunn.ch>
 <CAOh2x==YaPxYxigyE=n2weoKHhu4ktGRHHGdzgs2+d1_Lo-D4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x==YaPxYxigyE=n2weoKHhu4ktGRHHGdzgs2+d1_Lo-D4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 07:12:10PM +0530, viresh kumar wrote:
> On 4/24/12, Andrew Lunn <andrew@lunn.ch> wrote:
> > Sorry, but still wrong.
> >
> > The clock is optional. If we can find a clock, turn it on. If not,
> > keep going....
> >
> > You patch causes the missing clock to become a fatal error.
> >
> > This sata_mv exists in multiple forms. It can be part of a SoC. It can
> > also be on a PCI bus. In the PCI form, it is unlikely to have a clk
> > which can be controlled. When built into a SoC, namely one of the
> > Orion family, dove, orion5x, mv78xx0 do not have a clock which can be
> > controlled. However kirkwood does have a clock.
> >
> > So, kirkwood will provide a clock and expects that sata_mv will turn
> > it on. All the other ways of using sata_mv will not provide a clock,
> > but still expect the driver to be happy.
> 
> Hmm. What this code does now is:
> If HAVE_CLK is selected, then there must be a clock for the device. Otherwise
> it will always pass.
> 

-#if defined(CONFIG_HAVE_CLK)
    hpriv->clk = clk_get(&pdev->dev, NULL);
-   if (IS_ERR(hpriv->clk))
-           dev_notice(&pdev->dev, "cannot get clkdev\n");
-   else
-           clk_enable(hpriv->clk);
-#endif
+   if (IS_ERR(hpriv->clk)) {
+           dev_err(&pdev->dev, "cannot get clkdev\n");
+           return PTR_ERR(hpriv->clk);
+   }
+
+   clk_enable(hpriv->clk);

There are three use cases....

1) The platform does not implement HAVE_CLK. So we are using your NOP
   operations.

   clk_get() returns NULL.

   IS_ERR(NULL) is false. So it keeps going, calls clk_enable() which is
   also NOP and the driver is happy.

2) The platform does have HAVE_CLK. So we are using driver/clk/
   code. There is no clk defined for the device, since there is no
   controllable clk. Its using the PCI clock, or some hard wired
   internal SoC clock.

   clk_get() returns ERR_PTR(-ENOENT)

   IS_ERR(hpriv->clk) is true, you output a dev_err() and the device
   probe fails.

   This is wrong. Not having the clk is not fatal. The old code would
   carefully not call clk_enable(), since it has an error pointer, not
   have a valid clk, and would also not call clk_disable during
   removal.

3) The platform does have HAVE_CLK. So we are using driver/clk/ code.
   There is however a gateable clock driving this lump of silicon.

   clk_get() returns a valid pointer to a clk.
   IS_ERR(hpriv->clk) is false, so it keeps going.
   clk_enable() is called and the driver is happy.

   Well, actually, his brings up a new issues 

static int __clk_enable(struct clk *clk)
{
        int ret = 0;

        if (!clk)
                return 0;

        if (WARN_ON(clk->prepare_count == 0))
                return -ESHUTDOWN;

   this should actually be clk_prepare_enable(). Did you see my
   patches adding generic clk framework support for Orion. I fixed
   this as part of that patch set.

Anyway.... You asked:

> You want not to return error if a platform does have HAVE_CLK, but
> doesn't have a clock for sata? That would be simple to fix, but want
> to confirm if this is actually required.

Correct.

	Andrew
   
   
