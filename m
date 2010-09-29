Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab0I2OnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:43:18 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28530 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0I2OnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:43:17 -0400
Date: Wed, 29 Sep 2010 16:42:51 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ben Dooks <ben-i2c@fluff.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, mikpe@it.uu.se,
        rdunlap@xenotime.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH (Option 1)] of/i2c: fix module load order issue caused 
 by of_i2c.c
Message-ID: <20100929164251.0243ac7f@endymion.delvare>
In-Reply-To: <20100928232054.GQ21564@trinity.fluff.org>
References: <20100924221313.28357.61419.stgit@angua>
	<20100928232054.GQ21564@trinity.fluff.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 00:20:54 +0100, Ben Dooks wrote:
> On Fri, Sep 24, 2010 at 04:14:53PM -0600, Grant Likely wrote:
> > Commit 959e85f7, "i2c: add OF-style registration and binding" caused a
> > module dependency loop where of_i2c.c calls functions in i2c-core, and
> > i2c-core calls of_i2c_register_devices() in of_i2c.  This means that
> > when i2c support is built as a module when CONFIG_OF is set, then
> > neither i2c_core nor of_i2c are able to be loaded.
> > 
> > This patch fixes the problem by moving the of_i2c_register_devices()
> > function into the body of i2c_core and renaming it to
> > i2c_scan_of_devices (of_i2c_register_devices is analogous to the
> > existing i2c_scan_static_board_info function and so should be named
> > similarly).  This function isn't called by any code outside of
> > i2c_core, and it must always be present when CONFIG_OF is selected, so
> > it makes sense to locate it there.  When CONFIG_OF is not selected,
> > of_i2c_register_devices() becomes a no-op.
> 
> I sort of go with this one.

Actually I would prefer option #2, even though I understand it won't
make Grant too happy. Having a large chunk of OF-specific code in
i2c-core, leaving of_i2c.c almost empty, doesn't seem right.

I took a look at what other relevant subsystems do. SPI is boolean so it
doesn't have the issue. MDIO is tristate, the registration function is
in of_mdio.c and individual drivers call it. And there are a lot more
of these (9) than i2c drivers (3).

So I would let individual drivers call of_i2c_register_devices(), as it
used to be until 2.6.35. 2 extra functions calls doesn't seem a high
price to pay to keep the code logically separated. This also make
things consistent, with all OF registration functions living under
drivers/of.

Thanks,
-- 
Jean Delvare
