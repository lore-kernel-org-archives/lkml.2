Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab2GYIfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:35:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56532 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932802Ab2GYIfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:35:15 -0400
Date: Wed, 25 Jul 2012 09:34:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christopher Covington <cov@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>
Subject: Re: [08/36] AArch64: Kernel booting and initialisation
Message-ID: <20120725083452.GA11389@arm.com>
References: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
 <500DB986.7090309@codeaurora.org>
 <20120724162404.GB29519@arm.com>
 <201207241853.16625.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207241853.16625.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 07:53:16PM +0100, Arnd Bergmann wrote:
> On Tuesday 24 July 2012, Catalin Marinas wrote:
> > On Mon, Jul 23, 2012 at 09:52:22PM +0100, Christopher Covington wrote:
> > > Catalin Marinas - July 8, 2012, 9:18 a.m.
> > > > On Fri, Jul 06, 2012 at 10:32:54PM +0100, Stephen Warren wrote:
> > > > 
> > > >> Also, on Tegra at least and perhaps OMAP too, there are a few parts
> > > >> of earlyprintk serial port setup (i.e. port selection) which happen
> > > >> as part of the decompressor rather than the main kernel image, so
> > > >> we'd have to re-jig that too.
> > > > 
> > > > Whatever we did on AArch32, if it was useful and we want to follow a
> > > > similar model it needs porting given that the code cannot be shared. So
> > > > there is nothing to re-jig but rather implement.
> > > > 
> > > > As for earlyprintk, you can initialise it in the decompressed kernel
> > > > anyway. But even though it's a useful debugging tool, it goes against
> > > > the single Image aim (at least the current printascii/addruart
> > > > implementation). I don't have a proper implementation yet.
> > > 
> > > Would DCC [1] be a reasonably commonly available early printk mechanism
> > > for the single image to provide?
> > 
> > Yes, this can be implemented but I think it has its own restrictions,
> > requiring a JTAG connection.
> 
> Right, which means that it's not generic and we still need to make
> a decision for a how we want to solve the underlying problem. The
> options I see are:
> 
> 1. Have no earlyprintk before loading the console drivers

It may be a long time and wouldn't help with early bugs.

> 2. Make the series from Domenico architecture independent code

I haven't seen this yet.

> 3. Reimplement a layer like that, differently

Any of the two above would be fine.

> 4. Make it a compile-time option and allow this only for
>    low level debugging purposes but disable it in distro kernels.

That's what I currently have (though not included in this post) but I
don't particularly the approach. There are advantages in being able to
call printascii from assembly early on but if we don't have a standard
UART than it goes against single Image file.

My proposal is to allow DCC very early on for development kernels
(possibly called from assembly) with a timeout if there is no JTAG
connection. Immediately after setup_machine_fdt() switch to a UART early
console if there is one. But we retrieve this information from the FDT.

I would say the early_printk console should not bother with UART
initialisation (done by the boot loader) but just the actual character
sending. It should also be placed somewhere under drivers/ as it may
be shared by other architectures (it's just specific to the UART chip).

-- 
Catalin
