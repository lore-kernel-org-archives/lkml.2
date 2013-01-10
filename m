Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab3AJDWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 22:22:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932720Ab3AJDWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 22:22:03 -0500
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, khalid@gonehiking.org,
        horms@verge.net.au
Subject: Re: [PATCH] Only reset e820 once, even with multiple memmap=exactmap params
Date: Thu, 10 Jan 2013 04:21:49 +0100
Message-ID: <1586060.uJlkOEQfVW@hammer82.arch.suse.de>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAE9FiQW=gT86Eo0gwPHi5iFi4sg=1SHkBohBAo2KXdoB_Ouqvw@mail.gmail.com>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <201301081747.17853.trenn@suse.de> <CAE9FiQW=gT86Eo0gwPHi5iFi4sg=1SHkBohBAo2KXdoB_Ouqvw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 08, 2013 09:19:18 AM Yinghai Lu wrote:
...
> 
> that exactmap logic still have problem:
> We need to check exactmap at first, aka need to scan the whole comand line
> to see if exactmap is there at first and reset e820 tables then handle
> other memmap opt.
> 
> Also please update your patch after
> 
> tip/x86/mm2
> 
> I have one patch that process memmap= with "," there.
> 
> http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=9710f58
> 1bb4c35589ac046b0cfc0deb7f369fc85
> 
> We could put exactmap scanning in new parse_memmap_opt.

I still do not understand why:

Kexec (kexec/firmware_memmap.c) is setting up the e820 map from:
/sys/firmware/memmap/*
and pass it via bootloader structures.
And this e820 table gets immediately voided by memmap=exactmap
and a new one passed via boot parameters is set up.
If I read this correctly, this is what happens?

Can kexec simply pass the memory to use via memmap=X@Y
Then take the original e820 table, but not the usable entries (those
are coming from above memmap=X@Y).
That would mean that the kexec kernel takes all the
original ACPI, ACPI NVS, reserved, unusable (everthing but usable) entries
from the original e820 table and identifies the usable memory from
memmap boot param?

This would be much smarter than trying to pass the mmconf reserved
area and I could imagine other issues will show up if the reserved areas
do not match the original ones in the kexec kernel.

If this really can be done and memmap=exactmap was only used by kexec,
it's logic could be redefined from "drop all e820 entries" to
"drop all usable e820 entries" and no further adjustings in kexec/kernel are
needed to get mmconf working (and other issues may be avoided before
they happen). Beside that ACPI reserved aread is not needed anymore to get
passed via memmap=X#Y by kexec.

   Thomas
