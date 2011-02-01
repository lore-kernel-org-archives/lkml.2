Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1BANZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:25:44 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:56547 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab1BANZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:25:42 -0500
Message-ID: <1296566732.4d4809cc1f963@imp.free.fr>
Date: Tue, 01 Feb 2011 14:25:32 +0100
From: castet.matthieu@free.fr
To: Ingo Molnar <mingo@elte.hu>
Cc: matthieu castet <castet.matthieu@free.fr>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu>
In-Reply-To: <20110201080223.GB20372@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 93.1.148.69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ingo Molnar <mingo@elte.hu>:

>
> * matthieu castet <castet.matthieu@free.fr> wrote:
>
> >  static inline int is_kernel_text(unsigned long addr)
> >  {
> > +#if defined(CONFIG_X86_32) && defined(CONFIG_ACPI_SLEEP)
> > +	/*
> > +	 * We need to make the wakeup trampoline in first 1MB !NX
> > +	 */
> > +	if (addr >= PAGE_OFFSET && addr <= (PAGE_OFFSET + (1<<20)))
> > +		return 1;
> > +#endif
>
> That's pretty ugly. Why not use set_memory_x()/set_memory_nx(), and only for
> the
> trampoline itself? Does the whole 1MB need to be marked X?
The previous code was doing that.

If you prefer I can revert to the old code :

static inline int is_kernel_text(unsigned long addr)
{
    if (addr >= PAGE_OFFSET && addr <= (unsigned long)__init_end)
        return 1;
    return 0;
}

The proper fix will be done in 2.6.29, when S3 resume 32 bit trampoline will be
merged with 64 bit (ie call smp trampoline) [1]

>
> Same goes for the Xen fix.
>
The Xen fix reverts code to old behavior.
We can't assume that all data/bss will be RW. And I see no way to detect witch
page in data/bss we should not force to RW in static protection.
So we assume the code that change protection of data/bss knows what it is doing
(that what was doing old code).

Matthieu


[1]http://marc.info/?l=linux-kernel&m=129616541603610&w=2
