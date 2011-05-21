Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1EURKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 13:10:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65077 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab1EURK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 13:10:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] arch/c6x: new architecture port for linux
Date: Sat, 21 May 2011 19:10:25 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
In-Reply-To: <1305144843-5058-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211910.26025.arnd@arndb.de>
X-Provags-ID: V02:K0:wxC98mgfK0Qcl84jDqqgGiCEpMPNmurCgc9FhcMEr1/
 2ijOXY5ywY9Xo9KLAcjqPiE0RfgMQbUK8qW5sURo+SsgJXUxwn
 9MPrMl/cGkexVaEVYdgzKeNFOBjTa5Ki9S/sXgqlTFmngjbC5I
 7wDQjVEfK/IjQ+7rKPvcciUJ2LfIELPXMXl9Ad77/duMai8qVM
 Pzt90+OWpeKC+sbvq4EYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 May 2011 22:13:47 Mark Salter wrote:
> and the GIT tree holding the attached patches is at:
> 
>   git@linux-c6x.org:/git/projects/linux-c6x-upstreaming.git
> 
> TIA for any feedback and/or guidance on this port.
> 

I've taken a very brief look at the repository. These
are the things that stood out at first, in no particular
order:

- You need to reduce the size of the defconfig files using
  'make gendefconfig'

- arch/c6x/drivers/ should not exist, just move the drivers
  into the respective driver hierarchy (drivers/gpio, ...)

- Do not register static platform devices, they are deprecated.
  For devices that are always there, use platform_device_create_simple.
  For devices that depend on the specific SoC, use a flattened
  device tree to describe the hierarchy of devices.

- Replace your board files with device tree files written
  in DTS language as on powerpc, microblaze, etc. Hardcoding
  board stuff in the kernel is not the way to go for new
  architectures, as we are migrating the existing ones away
  from that.

- The CIO console driver should be coverted to use hvc_console.

- Any header file that only includes the asm-generic version
  can now use generic infrastructure to generate the header,
  so you can remove these files.

- arch/c6x/lib/misc.c appears to be misplaced. Why would you
  define abort(), exit() and alloca()? Leftover from the
  proprietary compiler?

- Do you really need a.out.h?

- your asm/atomic.h and asm/bitops.h look like they should use
  the generic version.

- struct clk support is currently undergoing a rewrite, you should
  use the new version once it shows up. If it doesn't work for
  you, complain now so we can fix it before it gets merged.

- I would guess that you don't support ISA dma, so don't try to use
  asm/dma.h.

- gemac.h and gmdio.h should probably live in the same directory
  as the driver using them, not in asm/.

- You are rather inconsistent using MMIO pointer access. You should
  always use proper accessors like readl/writel, and use sparse
  to check that all mmio pointers are marked as __iomem.
  Check all uses of 'volatile' in the code, most of them are wrong
  and should be '__iomem' instead. See 
  Documentation/volatile-considered-harmful.txt

- Fix your readl/writel implementations to do the correct casts
  from __iomem pointers.

- Do not use __raw_readl/__raw_writel.

- Remove your IO_ADDRESS(), __REG, VULP, __SYSREG and __SYSREGA.
  Replace them with proper use of ioremap().

- Your inb/outb implementations are completely wrong. If you don't
  support PCI, best just replace them with BUG(). Set IO_SPACE_LIMIT
  to zero to enforce that no driver uses them.

- Go through your machdep.h and make sure that all pointers are
  actually used, e.g. mach_floppy_eject /sounds/ like you wouldn't
  need it in 2011.

- You have an asm/pci.h but no host implementation. Why is that?

- Why do you have both pll.h and clk.h? Don't they do the same thing?

- Use the common asm-generic/unistd.h instead of your own! A significant
  number of the syscalls you define are not needed at all. This will
  also simplify merging into glibc.

- Rewrite your ptrace.c to use regsets and the common infrastructure
  from kernel/ptrace.c.

- I recommend to split your device drivers into separate git branches
  in your repository, to make it easier to see what is coming up,
  and to allow merging branches at a time. Not required, but it will
  make your life easier.

That's all from me for now. When we have resolved these issues, the
next step would be to create a multi-patch series (e.g. ~20 patches
for arch/c6x/*) split into one patch per topic, and review them
on the linux-arch and linux-kernel mailing lists. 

	Arnd
