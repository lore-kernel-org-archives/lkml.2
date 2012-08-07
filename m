Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2HGRBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:01:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53595 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab2HGRBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:01:37 -0400
Date: Tue, 7 Aug 2012 18:01:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120807170129.GA3759@gmail.com>
References: <1344256323-10484-1-git-send-email-lee.jones@linaro.org>
 <20120806081915.GA4518@core.coreip.homeip.net>
 <20120806153750.GI10524@gmail.com>
 <20120806160226.GF29272@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120806160226.GF29272@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 05:02:26PM +0100, Mark Brown wrote:
> On Mon, Aug 06, 2012 at 04:37:52PM +0100, Lee Jones wrote:
> > On Mon, Aug 06, 2012 at 01:19:15AM -0700, Dmitry Torokhov wrote:
> 
> > > > +	ponkey->irq_dbf = (np) ? ab8500_irq_get_virq(ab8500, irq_dbf) : irq_dbf;
> > > > +	ponkey->irq_dbr = (np) ? ab8500_irq_get_virq(ab8500, irq_dbr) : irq_dbr;
> 
> > > Why this isn't done inside ab8500_irq_get_virq()?
> 
> > There's no reason why it can't be.
> 
> > My first version of the patch did just that in fact.
> 
> > Would that be your preference?
> 
> Restating my comment elsewhere...  why do we even need to do this in
> _get_virq() - I'd *really* expect this to be handled by the irq domain
> code.

Okay, so I've just spent a small amount of time looking at this. I think
the best place for this would be in *_get_virq(), using the same logic that
selected a *_legacy or *_linear domain in the first place. The only thing 
the domain can test for is the 'type' of domain and the requested IRQ. This
is where the issue lies. If a hwirq to virq conversion is requested, but a
virq is passed (which happens in the non-DT case) a WARN() is triggered
because the irq passed is bigger than first_irq + size. I think *_get_virq()
should ensure that only a hwirq is passed to irq_create_mapping().

Let me know if you had other ideas.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
