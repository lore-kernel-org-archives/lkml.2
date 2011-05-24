Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab1EXOj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:39:27 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:51148 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932282Ab1EXOj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:39:26 -0400
Date: Tue, 24 May 2011 15:39:37 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: MIPS panic in 2.6.39 (bisected to 7eaceaccab5f)
Message-ID: <20110524143937.GB30117@linux-mips.org>
References: <4DDB5673.5060206@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDB5673.5060206@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 01:55:47AM -0500, Rob Landley wrote:

> You can reproduce this under qemu by grabbing:
> 
>   http://landley.net/aboriginal/downloads/binaries/system-image-mips.tar.bz2
> 
> If you extract that tarball and ./run-emulator.sh it should boot
> to a mips shell prompt.  Now build your own vmlinux to replace the
> kernel in there with (using the attached .config), and try again,
> you should get a panic message something like:
> 
> PID hash table entries: 512 (order: -1, 2048 bytes)
> Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
> Primary instruction cache 2kB, VIPT, 2-way, linesize 16 bytes.
> Primary data cache 2kB, 2-way, VIPT, no aliases, linesize 16 bytes
> Writing ErrCtl register=00000000
> Readback ErrCtl register=00000000
> Memory: 125836k/127004k available (2172k kernel code, 1168k reserved, 507k data, 156k init, 0k highmem)
> SLUB: Genslabs=9, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> NR_IRQS:256
> CPU 0 Unable to handle kernel paging request at virtual address 00000080, epc == 803a09b0, ra == 803a0990
> Oops[#1]:
> Cpu 0
> $ 0   : 00000000 00000050 1bdc0001 00000000
> $ 4   : 00000018 00000000 00000001 00000000
> $ 8   : fffffff8 00000001 00000000 fffffffc
> $12   : fffffffc 00000000 00000008 fffffffc
> $16   : 803bce58 803bef35 803c0000 803c0000
> $20   : 80380000 00000000 00000000 00000000
> $24   : 00000000 00000000                  
> $28   : 80382000 80383ec8 00000000 803a0990
> Hi    : 00000000
> Lo    : 00000000
> epc   : 803a09b0 arch_init_irq+0x38/0x15c
>     Not tainted
> ra    : 803a0990 arch_init_irq+0x18/0x15c
> Status: 10000002    KERNEL EXL 
> Cause : 0080000c
> BadVA : 00000080
> PrId  : 00019300 (MIPS 24Kc)
> Process swapper (pid: 0, threadinfo=80382000, task=803855c0, tls=00000000)
> Stack : 803a17d4 87804000 803bce58 803bef35 803c0000 803c0000 8039fac4 8039fac4
>         00000000 803bce58 80380f04 0000004a 8039f454 00000000 803beee0 00000000
>         00000000 00000000 00000000 00000000 00000000 80315f00 00000000 00000000
>         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>         ...
> Call Trace:
> [<803a09b0>] arch_init_irq+0x38/0x15c
> [<8039fac4>] start_kernel+0x1f0/0x33c
> [<80315f00>] kernel_entry+0x0/0x94
> 
> 
> Code: 8c437048  3c021bdc  34420001 <ac620080> 24030001  3c02803c  080e827d  ac437040  8c43701c 
> 
> 
> I bisected it the problem to commit
> 7eaceaccab5f40bbfda044629a6298616aeaed50, but have no idea what
> the actual bug is.  (Other than "a null pointer dereference from
> arch_init_irq", I just dunno _why_.)

That commit just does not seem to be the answer.

Can you provide the kernel disassembly for the arch_init_irq() function?

Also, does the problem go away if you switch from CONFIG_MIPS_MT_SMP to
CONFIG_MIPS_MT_DISABLED?  The former is designed to run on all MIPS CPUs
and on a non-MT enabled CPU core it should just disable MT and run happily
anyway.  I know there was work on MT support being done by Thiemo Seufer
and I wonder if that ever made it into qemu and if so, if qemu gets MT
right.

  Ralf
