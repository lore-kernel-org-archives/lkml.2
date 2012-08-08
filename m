Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab2HHIEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:04:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36675 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab2HHIEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:04:16 -0400
Date: Wed, 8 Aug 2012 09:04:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120808080411.GB4728@gmail.com>
References: <20120807170333.GV16861@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120807170333.GV16861@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 06:03:34PM +0100, Mark Brown wrote:
> On Tue, Aug 07, 2012 at 06:01:30PM +0100, Lee Jones wrote:
> 
> > Okay, so I've just spent a small amount of time looking at this. I think
> > the best place for this would be in *_get_virq(), using the same logic that
> > selected a *_legacy or *_linear domain in the first place. The only thing 
> > the domain can test for is the 'type' of domain and the requested IRQ. This
> > is where the issue lies. If a hwirq to virq conversion is requested, but a
> > virq is passed (which happens in the non-DT case) a WARN() is triggered
> > because the irq passed is bigger than first_irq + size. I think *_get_virq()
> > should ensure that only a hwirq is passed to irq_create_mapping().
> 
> > Let me know if you had other ideas.
> 
> I'd expect your driver to always pass a hwirq into _get_virq() here.

Okay, actually this isn't so easy. Currently we have:

During DT boot:
 - No platform data is passed, hence no IRQ base for AB8500 is either
 - No IRQ base means we register a Linear IRQ Domain
 - MFD sees there is no base and leaves the IRQ resource as a hwirq
 - AB8500 child devices use *_get_virq() to convert the hwirq to a virq

During non-DT boot:
 - Platform data is passed, which contains an IRQ base
 - If an IRQ base is requested we use it to register a Legacy IRQ Domain
 - MFD adds the IRQ base to the hwirq and registers it as a virq
 - AB8500 child devices use *_get_virq() to convert virq to virq - *ERROR*

I guess my suggestion falls-back to placing logic in *_get_virq() to only
call irq_create_mapping() when when !ab8500->irq_base.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
