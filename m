Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab0CXTQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:16:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:16739 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788Ab0CXTQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:16:10 -0400
X-IronPort-AV: E=Sophos;i="4.51,302,1267419600"; 
   d="scan'208";a="7680247"
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
In-Reply-To: <alpine.LFD.2.00.1003241824500.3147@localhost.localdomain>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
	 <1269221770-9667-2-git-send-email-yinghai@kernel.org>
	 <alpine.LFD.2.00.1003220950570.3147@localhost.localdomain>
	 <1269437531.10129.67616.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1003241824500.3147@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 24 Mar 2010 19:16:03 +0000
Message-ID: <1269458163.28761.859.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 17:44 +0000, Thomas Gleixner wrote: 
> On Wed, 24 Mar 2010, Ian Campbell wrote:
> 
> > On Mon, 2010-03-22 at 10:19 +0000, Thomas Gleixner wrote:
> > > On Sun, 21 Mar 2010, Yinghai Lu wrote:
> > > 
> > > > From: Ian Campbell <ian.campbell@citrix.com>
> > > > 
> > > > Move arch_init_copy_chip_data and arch_free_chip_data into function
> > > > pointers in struct irq_chip since they operate on irq_desc->chip_data.
> > > 
> > > Not sure about that. These functions are solely used by x86 and there
> > > is really no need to generalize them.
> > 
> > I thought the idea of struct irq_chip was to allow the potential for
> > multiple IRQ controllers in a system? Given that it seems that struct
> > irq_desc->chip_data ought to be available for use by whichever struct
> > irq_chip is managing a given interrupt. At the moment this is not
> > possible because we step around the abstraction using these arch_*
> > methods.
> 
> Right, but you have exactly _ONE_ irq_chip associated to an irq_desc,
> but that same irq_chip can be associated to several irq_descs. So
> irq_desc->data is there to provide data for the irq_chip functions
> depending on what irq they handle (e.g. base_address ...). 
> 
> irq_desc->chip_data is set when the irq_chip is assigned to the
> irq_desc.
> 
> So there is no point in having functions in irq_chip to set
> irq_desc->chip_data.

So how do you know which is the appropriate irq_chip specific function
to call given an irq_desc that you want to copy/free/migrate? The
contents of the chip_data pointer will take different forms for
different irq_chips. The way the generic code is currently structured it
appears you can't (or at least don't) just do a shallow copy by copying
the irq_desc->chip_data pointer itself -- you need to do a deep copy
using a function which understands that type of chip_data.

How is this operation different to having pointers in irq_chip for
enabling/disabling/masking interrupts for each irq_chip?

Ian.

