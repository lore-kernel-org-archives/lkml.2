Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab1GATew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 15:34:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab1GATet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 15:34:49 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary physical addresses
Date: Fri, 1 Jul 2011 21:34:45 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.5-default; KDE/4.6.0; i686; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <201106171038.25988.ptesarik@suse.cz> <4E0DEF2C.3040504@zytor.com> <20110701161345.GA29775@elte.hu>
In-Reply-To: <20110701161345.GA29775@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107012134.45881.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Pá 1. července 2011 18:13:45 Ingo Molnar napsal(a):
> * H. Peter Anvin <hpa@zytor.com> wrote:
> > On 07/01/2011 08:36 AM, Ingo Molnar wrote:
> > > So we could kill multiple birds with the same stone here:
> > >  - remove various ugly uses of /dev/mem (including the rootkit usage),
> > >  
> > >    with or without strict-devmem
> > >  
> > >  - extending it to above-4G for inspection purposes
> > >  
> > >  - allowing to kill /dev/mem access runtime similar to the
> > >  
> > >    disable_modules lock-down killswitch, for the so inclined.
> > > 
> > > Would you be interested in modifying your patch-set in such a
> > > fashion?

Yes, this works for me. How persistent should the kill-switch be? I assume it 
doesn't make much sense to make a sysfs toggle, because then it would still be 
open to abuse. I'd rather see it specified on boot and never changed. Agreed?

Something like "enable_dev_mem" on the kenrel command line (default is 
disabled).

On a similar note, I should probably rip off write_mem() completely and 
disallow PROT_WRITE mmapping of the device. Right?

> > There is another use that I have looked at, as well: for testing
> > purposes, it would be extremely good to be able to dirty and/or
> > flush an arbitrary physical cache line for testing purposes.
> > 
> > This is very very similar to /dev/mem usage -- access to an
> > arbitrary chunk of memory -- and a fully enabled /dev/mem can of
> > course support this use (just mmap the page with the relevant cache
> > line).  However, it could also be a separate device which could
> > have looser permissions than /dev/mem; or a set of ioctls on
> > /dev/mem with a separate kill switch, because no data would ever be
> > have modified or returned to user space.
> > 
> > Either way, though, we found that it would share a lot of code with
> > the /dev/mem implementation, and as such fixing up the underlying
> > machinery is the sanest way to upstream this.
> 
> To me that cache flush thing sounds obscure (but still useful) enough
> to justify a new ioctl over /dev/mem.
> 
> Not sure it even needs a killswitch, unless there's some real
> security problem related to it.

It can be used for DoS, but if you have permission for the ioctl(), then you 
probably also have easier ways to kill the system.

Petr
