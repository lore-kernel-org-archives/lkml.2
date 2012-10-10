Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2JJJqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:46:38 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:47680 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2JJJqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:46:37 -0400
X-IronPort-AV: E=Sophos;i="4.80,564,1344211200"; 
   d="scan'208";a="15068018"
Message-ID: <1349862394.10070.23.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 5/9] ARM: Xen: fix initial build problems:
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 10 Oct 2012 10:46:34 +0100
In-Reply-To: <201210091819.34310.arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
	 <201210091539.46274.arnd@arndb.de>
	 <1349799035.21847.222.camel@zakaz.uk.xensource.com>
	 <201210091819.34310.arnd@arndb.de>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 19:19 +0100, Arnd Bergmann wrote:
> On Tuesday 09 October 2012, Ian Campbell wrote:
> > On Tue, 2012-10-09 at 16:39 +0100, Arnd Bergmann wrote:
> > > On Tuesday 09 October 2012, Ian Campbell wrote:
> > > > > * The tmem hypercall is not available on ARM
> > > > > 
> > > > > * ARMv6 does not support cmpxchg on 16-bit words that are used in the
> > > > 
> > > > missing the end of this sentence?
> > > 
> > > Right, I meant to say 
> > > 
> > > * ARMv6 does not support cmpxchg on 16-bit words that are used in the
> > >   Xen grant table code, so we must ensure that Xen support is only built
> > >   on ARMv7-only kernels not combined ARMv6/v7 kernels.
> > > 
> > > This should be fixed differently in the future.
> > 
> > Is this is a build time failure because gcc/gas/etc refuses to generate
> > these instructions if it is configured for v6?
> > 
> > I ask because if it is only a runtime issue then we can reason that if
> > we are running Xen specific grant table code, then we must be running on
> > Xen and therefore must necessarily be running on a v7 (because Xen only
> > support v7+virt extensions) even if the kernel happens to be capable of
> > running on v6 too.
> 
> The underlying reason of course is that ARMv6 doesn't have those
> instructions. The symptom you see is a link error because gcc emits
> a reference to the (intentionally missing) __bad_cmpxchg() function
> from

OK, then your fix is the best one for now.

> [...]
> The possible solutions I can see for this are:
> 
> * change the grant table format to use 32 bits for the flags on ARM
> * change the code to always cmpxchg the entire 32 bit word including the flags.

I'd need to check the grant table semantics to see if this will be
possible.

> * implement your own cmpxchg wrapper that may be implemented using a spinlock
>   rather than cmpxchg if ARMv6 is enabled.

Even if ARMv6 is enabled the grant table code will never be running on
one so so it might be ok to just have our own wrapper which
unconditionally uses the v7 instruction? That might upset gas though.

> 
> 	Arnd


