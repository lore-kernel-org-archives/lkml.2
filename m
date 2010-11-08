Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab0KHVac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:30:32 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41495 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab0KHVab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:30:31 -0500
Date: Tue, 9 Nov 2010 06:30:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alexey Charkov <alchark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6 v3] ARM: Add support for the display controllers in VT8500 and WM8505
Message-ID: <20101108213008.GB17708@linux-sh.org>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <1289147348-31969-6-git-send-email-alchark@gmail.com> <20101108041721.GA11605@linux-sh.org> <20101108141407.GA25739@alchark-u3s.lan> <20101108204315.GA12050@linux-sh.org> <AANLkTikXffMT9ZiUpm2QAoW+KPJN3MBf55Dgruj1EJN0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikXffMT9ZiUpm2QAoW+KPJN3MBf55Dgruj1EJN0@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 12:15:19AM +0300, Alexey Charkov wrote:
> 2010/11/8 Paul Mundt <lethal@linux-sh.org>:
> >> + ?? ?? if (!fbi)
> >> + ?? ?? ?? ?? ?? ?? return 0;
> >> +
> > I would kill this test as well. If this ever triggers, something horribly
> > wrong has happened and you likely have bigger things to worry about.
> 
> But a couple of extra instructions for error handling to hold in the
> kernel binary should not hurt, should they? Are there benefits aside
> from code compaction?
> 
It's not a realistic situation. The only way this would trigger is if the
pointer you got handed is one that didn't go through the probe path or
was otherwise corrupted. If it was corrupted, you're going to notice
regardless. The driver core does sensible refcounting already, there's no
need to second guess it.

> >> diff --git a/drivers/video/wmt_ge_rops.c b/drivers/video/wmt_ge_rops.c
> >> new file mode 100644
> >> index 0000000..b201a60
> >> --- /dev/null
> >> +++ b/drivers/video/wmt_ge_rops.c
> >> +EXPORT_SYMBOL(wmt_ge_fillrect);
> >> +EXPORT_SYMBOL(wmt_ge_copyarea);
> >> +EXPORT_SYMBOL(wmt_ge_sync);
> >> +
> > ...
> >
> > Is there a particular reason why you are favouring EXPORT_SYMBOL? In
> > general we prefer that new infrastructure patches and the like stick with
> > EXPORT_SYMBOL_GPL, as this discourages use by non-GPLed modules going
> > forward.
> >
> 
> Well, I have no personal preference towards these, so I just took what
> was in cfb*.c as a guidance. If the *_GPL variant is more welcome, it
> can be changed.
> 
Those exports go back a ways. The idea with the _GPL exports was not to
change symbol export behaviour retroactively, so the old ones stay the
way they were and newer stuff can choose which way it wants to go. If you
are not using this driver with an out-of-tree non-GPLed module then you
are advised to use the GPL variants so others don't either.

> >> +static int __devinit wmt_ge_rops_probe(struct platform_device *pdev)
> >> +{
> > ...
> >> + ?? ?? regbase = ioremap(res->start, resource_size(res));
> >> + ?? ?? if (regbase == NULL) {
> >> + ?? ?? ?? ?? ?? ?? dev_err(&pdev->dev, "failed to map I/O memory\n");
> >> + ?? ?? ?? ?? ?? ?? ret = -EBUSY;
> >> + ?? ?? ?? ?? ?? ?? goto error;
> >> + ?? ?? }
> >> +
> > You might also want to do something like:
> >
> > ?? ?? ?? ??/* Only one ROP engine is presently supported. */
> > ?? ?? ?? ??if (unlikely(regbase)) {
> > ?? ?? ?? ?? ?? ?? ?? ??WARN_ON(1);
> > ?? ?? ?? ?? ?? ?? ?? ??return -EBUSY;
> > ?? ?? ?? ??}
> >
> > ?? ?? ?? ??regbase = ioremap(...);
> > ?? ?? ?? ??...
> >
> 
> But for that I'd have to initialize regbase to NULL (so as not to use
> an uninitialized variable), wouldn't I? checkpatch.pl complains on
> that...
> 
No, regbase is BSS initialized, so it will already be cleared.

> >> +static int __devexit wmt_ge_rops_remove(struct platform_device *pdev)
> >> +{
> >> + ?? ?? iounmap(regbase);
> >> + ?? ?? return 0;
> >> +}
> >> +
> > You're missing a:
> >
> > ?? ?? ?? ??writel(0, regbase + GE_ENABLE_OFF);
> >
> > here?
> >
> 
> In fact, this module only uses a subset of GE functions, so I'm
> somewhat reluctant to disable the hardware altogether when unloading
> the module. And should the hardware really be disabled when the driver
> is removed?
> 
You're the only one who can answer that. I just noticed in your other
drivers that this is the pattern that you opted for, so I thought
that perhaps this was an oversight in the rop engine code.

Having said that, the general expectation is that a remove will balance
out the probe. If the probe is enabling random blocks then the remove
should be disabling them. If this driver is primarily used as a client by
the other drivers and you're concerned from it being ripped out
underneath them, then a bit more thinking and refcounting is needed. This
is however something that can be done later if its a direction you wish
to head in.
