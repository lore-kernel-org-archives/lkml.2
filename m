Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab1LFK0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:26:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137Ab1LFK0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:26:30 -0500
Date: Tue, 6 Dec 2011 11:26:28 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86-32 PAE-enabled kernel fails to boot with 64GB of RAM
Message-ID: <20111206102628.GC1342@tiehlicka.suse.cz>
References: <CACqU3MXMAP-7LtVWHENNAQSS+B0c5qVcdWq=4NFGNACxkTRYzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MXMAP-7LtVWHENNAQSS+B0c5qVcdWq=4NFGNACxkTRYzg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-12-11 02:23:26, Arnaud Lacombe wrote:
> Hi,

Hi,

> 
> I've been playing a bit with PAE and 3.2-rc3 this evening and found
> out to be unable to use the full 64GB address space. 

Quoting from Documentation/vm/highmem.txt:
"
The general recommendation is that you don't use more than 8GiB on a
32-bit machine - although more might work for you and your workload,
you're pretty much on your own - don't expect kernel developers to
really care much if things come apart.
"

> More precisely,
> the attached config, fails to detect the disk correctly:
> 
> excerpt from `dmesg.64GB.txt' (bad):
> 
> scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.14 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 107856 512-byte logical blocks: (55.2 MB/52.6 MiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
> support DPO or FUA
>  sda: unknown partition table
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> 
> excerpt from `dmesg.16GB.txt' (good):
> 
> scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.14 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 107856 512-byte logical blocks: (55.2 MB/52.6 MiB)
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
> support DPO or FUA
>  sda: sda1 sda2
> 
> The theoretical use-case I would think about is a machine running an
> x86-64 kernel with +64GB of RAM, but used to boot an x86-32 kernel
> every once in a while to do some work. I would naively expect such a
> PAE-enabled kernel to be limited to 64GB of RAM, but still be
> functional.

There are many issues with PAE. You still have a big pressure on the
lowmem (turning different CONFIG_*DEBUG like the one for SLUB doesn't
help...).

[...]
> ps: instability starts to appear consistently above 65000MB of RAM, at
> 65025MB, the kernel BUG() on the following:
> 
> PCI: Using ACPI for IRQ routing^M
> PCI: pci_cache_line_size set to 32 bytes^M
> reserve RAM buffer: 000000000009f400 - 000000000009ffff ^M
> reserve RAM buffer: 00000000dfffd000 - 00000000dfffffff ^M
> reserve RAM buffer: 0000001000100000 - 0000001003ffffff ^M
> BUG: unable to handle kernel paging request at 1f90c2f2^M
> IP: [<c1003cbf>] print_context_stack+0x6e/0x8d^M
> *pdpt = 0000000000000000 *pde = 0000000000000000 ^M
> Thread overran stack, or stack corrupted^M
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You overrun your stack...
[...]
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
