Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab0JFGhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:37:52 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25194 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab0JFGhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:37:51 -0400
Subject: Re: [PATCH 1/1] omap: Ptr "isr_reg" tracked as NULL was
 dereferenced
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: ext Kevin Hilman <khilman@deeprootsystems.com>, balbi@ti.com
Cc: balbi@ti.com, "tony@atomide.com" <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "zmc@lurian.net" <zmc@lurian.net>,
        "a.j.buxton@gmail.com" <a.j.buxton@gmail.com>
In-Reply-To: <877hhwvg3r.fsf@deeprootsystems.com>
References: <cover.1286261378.git.EXT-Eugeny.Kuznetsov@nokia.com>
	 <131d16236d19895323fca2f058d65f1f116bacad.1286261378.git.EXT-Eugeny.Kuznetsov@nokia.com>
	 <20101005093206.GB2977@legolas.emea.dhcp.ti.com>
	 <877hhwvg3r.fsf@deeprootsystems.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 10:33:22 +0400
Message-ID: <1286346802.24366.89.camel@ekuznets-lx-nokia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2010 06:37:01.0286 (UTC) FILETIME=[E1DC4860:01CB6520]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 08:01 -0700, ext Kevin Hilman wrote:
> Felipe Balbi <balbi@ti.com> writes:
> 
> > Hi,
> >
> > On Tue, Oct 05, 2010 at 03:42:10AM -0500, Evgeny Kuznetsov wrote:
> >>+	if (!isr_reg) {
> >>+		printk(KERN_ERR "FATAL: Incorrect GPIO method %i\n",
> >>+				bank->method);
> >>+		BUG();
> >>+		}
> >
> > this could be simply:
> >
> > BUG_ON(!isr_reg);
> 
> WARN_ON is better.
> 
> A BUG() will panic the kernel and stop everything.  This is not an error
> condition that should prevent the entire kernel from running.

'isr_reg' is dereferenced later in code:
	...
	isr_saved = isr = __raw_readl(isr_reg) & enabled;
	...
So this will stop kernel anyway.
I just hoped to help in understanding of issue by log line. WARN_ON
could be used for this.

As a variant compilation error could be added, to prevent situation when
kernel is incorrectly configured.
E.g.:
#if !defined(CONFIG_ARCH_OMAP1) &&		
	!defined(CONFIG_ARCH_OMAP15XX) &&	
	!defined(CONFIG_ARCH_OMAP16XX) &&	
	!defined(CONFIG_ARCH_OMAP730) &&	
	!defined(CONFIG_ARCH_OMAP850) &&	
	!defined(CONFIG_ARCH_OMAP2) &&	
	!defined(CONFIG_ARCH_OMAP3) &&	
	!defined(CONFIG_ARCH_OMAP4)

#error "Incorrect arch configuration"
#endif

But there are still cases when 'isr_reg' could have NULL value (if
'bank->method' is not equal to configured one).

Regards,
Evgeny
> 
> From asm-generic/bug.h:
> 
> /*
>  * Don't use BUG() or BUG_ON() unless there's really no way out; one
>  * example might be detecting data structure corruption in the middle
>  * of an operation that can't be backed out of.  If the (sub)system
>  * can somehow continue operating, perhaps with reduced functionality,
>  * it's probably not BUG-worthy.
>  *
>  * If you're tempted to BUG(), think again:  is completely giving up
>  * really the *only* solution?  There are usually better options, where
>  * users don't need to reboot ASAP and can mostly shut down cleanly.
>  */



