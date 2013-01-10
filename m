Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3AJO1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 09:27:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab3AJO1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:27:50 -0500
Date: Thu, 10 Jan 2013 09:26:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
Subject: Re: [PATCH] Only reset e820 once, even with multiple memmap=exactmap
 params
Message-ID: <20130110142643.GB32223@redhat.com>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
 <201301081747.17853.trenn@suse.de>
 <CAE9FiQW=gT86Eo0gwPHi5iFi4sg=1SHkBohBAo2KXdoB_Ouqvw@mail.gmail.com>
 <1586060.uJlkOEQfVW@hammer82.arch.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586060.uJlkOEQfVW@hammer82.arch.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 04:21:49AM +0100, Thomas Renninger wrote:
> On Tuesday, January 08, 2013 09:19:18 AM Yinghai Lu wrote:
> ...
> > 
> > that exactmap logic still have problem:
> > We need to check exactmap at first, aka need to scan the whole comand line
> > to see if exactmap is there at first and reset e820 tables then handle
> > other memmap opt.
> > 
> > Also please update your patch after
> > 
> > tip/x86/mm2
> > 
> > I have one patch that process memmap= with "," there.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=9710f58
> > 1bb4c35589ac046b0cfc0deb7f369fc85
> > 
> > We could put exactmap scanning in new parse_memmap_opt.
> 
> I still do not understand why:
> 
> Kexec (kexec/firmware_memmap.c) is setting up the e820 map from:
> /sys/firmware/memmap/*

Kexe reads it from /sys/firmware/memmap/* because that's supposed to
be e820 map as passed by BIOS. And if user has specified some
command line options like mem=X, /sys/firmware/memmap/* is not truncated
but one exported using /proc/iomem is truncated accordingly.

So if we pass mem=1G in first kernel but not in second kernel, we want
second kernel to see whole of the system memory and not just 1G.

> and pass it via bootloader structures.

That's how bootloader is supposed to pass e820 memory map to kernel and
kexec is a bootloader.

> And this e820 table gets immediately voided by memmap=exactmap
> and a new one passed via boot parameters is set up.
> If I read this correctly, this is what happens?

This happens only in case of kdump and not kexec. In case of kdump
we want second kernel to use only selected memory areas.

In fact this is one improvement area. Instead of using memmap= entries
in kdump case, we should probably modify the e820 map passed in 
zero page and get rid of memmap= entries.

Thanks
Vivek
