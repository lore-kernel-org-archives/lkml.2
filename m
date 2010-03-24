Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab0CXNcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:32:22 -0400
Received: from smtp.citrix.com ([66.165.176.89]:12307 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab0CXNcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:32:18 -0400
X-IronPort-AV: E=Sophos;i="4.51,301,1267419600"; 
   d="scan'208";a="7673872"
Subject: Re: [PATCH 01/10] irq: move some interrupt arch_* functions into
 struct irq_chip.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "x86@kernel.org" <x86@kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "lguest@ozlabs.org" <lguest@ozlabs.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1003220950570.3147@localhost.localdomain>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
	 <1269221770-9667-2-git-send-email-yinghai@kernel.org>
	 <alpine.LFD.2.00.1003220950570.3147@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 24 Mar 2010 13:32:11 +0000
Message-ID: <1269437531.10129.67616.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 10:19 +0000, Thomas Gleixner wrote:
> On Sun, 21 Mar 2010, Yinghai Lu wrote:
> 
> > From: Ian Campbell <ian.campbell@citrix.com>
> > 
> > Move arch_init_copy_chip_data and arch_free_chip_data into function
> > pointers in struct irq_chip since they operate on irq_desc->chip_data.
> 
> Not sure about that. These functions are solely used by x86 and there
> is really no need to generalize them.

I thought the idea of struct irq_chip was to allow the potential for
multiple IRQ controllers in a system? Given that it seems that struct
irq_desc->chip_data ought to be available for use by whichever struct
irq_chip is managing a given interrupt. At the moment this is not
possible because we step around the abstraction using these arch_*
methods.

Although this might be unusual on x86 I think it is not uncommon in the
embedded world to have an architectural interrupt controller cascading
through to various different IRQ controllers/multiplexors, from random
FPGA based things, to GPIO controllers and things like superio chips
etc.

Currently the set of architectures which typically have this sort of
thing are disjoint from the ones which make use of struct
irq_desc->chip_data but with the growing use of embedded-x86 is this not
something worth considering? (Genuine question, I've been out of the
embedded space for a while now so maybe my experiences are out of date
or I'm overestimating the role of embedded-x86 etc).

Xen is a bit more of a specialised case than the above since it would
like to replace the architectural interrupt handling but I think the
broad requirements on the irq_chip interface are the same. Going forward
it is possible/likely that we would like to be able to make Xen event
channels available via a cascade model as well -- demultiplexing one (or
more?) x86 architectural interrupts into event channels would be part of
running PV Xen drivers on a fully-virtualised (i.e. native) kernel.

>  The problem you try to solve is
> x86/xen specific and can be solved by x86_platform_ops as well w/o
> adding extra function pointers to irq_chip.
[...]
> AFAICT the function pointer to irq_to_desc_alloc_node is completely
> pointless. It just solves a Xen/x86 specific problem which can be
> solved by using x86_platform_ops and keeps the churn x86 internal.

I have no problem with that if that is the x86/irq maintainer's
preference, I just thought it would be nicer to solve what I saw as an
oddity in the existing abstraction generically in the core.

> Aside of the general objection against this, please use descriptive
> function names and do not distinguish functions by adding random
> characters which tell us absolutely nothing about the purpose.

I agree on this one. More generally I would say that the number of
existing users of this interface is small enough that _if_ we decide we
need to modify it then we should just bite the bullet and do that
instead of building compatibility layers around stuff. For this reason I
think my original patch was preferable to this version (general
objections not withstanding).

Ian.

