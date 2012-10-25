Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2JYHRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:17:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63498 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2JYHR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:17:28 -0400
MIME-Version: 1.0
In-Reply-To: <20121024152740.GA25303@otc-wbsnb-06>
References: <20121024152740.GA25303@otc-wbsnb-06>
Date: Thu, 25 Oct 2012 10:17:27 +0300
X-Google-Sender-Auth: fFOljKxG6oXpFLzZzkqTB6e0WpY
Message-ID: <CAOJsxLFD36jYiyE5sfN+uPT5G9G9ttf=K2UB=abEjBiTFNeehA@mail.gmail.com>
Subject: Re: [BUG] lkvm crash on crashkernel boot
From: Pekka Enberg <penberg@kernel.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Asias He <asias.hejun@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 6:27 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Hi,
>
> I've tried to play with kexec using lkvm. Unfortunately, lkvm crashes when
> I try to switch to crashkernel.
>
> I use Linus tree + penberg/kvmtool/next + one x86 mm patch[1].
>
> Kernel is defconfig + kvmconfig. I use the same kernel image for system and
> crash env.
>
> Host:
>
> % lkvm run --cpus 1 -m 1024 --params 'crashkernel=256M loglevel=8'
>
> Guest:
>
> # kexec -p bzImage --reuse-cmdline
> # echo c > /proc/sysrq-trigger
> ...
> [    0.947984] loop: module loaded
> [    0.950078] virtio-pci 0000:00:01.0: irq 40 for MSI/MSI-X
> [    0.950925] virtio-pci 0000:00:01.0: irq 41 for MSI/MSI-X
> [    0.952944] virtio-pci 0000:00:01.0: irq 42 for MSI/MSI-X
> zsh: segmentation fault (core dumped)  lkvm run --cpus 1 -m 1024 --params 'crashkernel=256M loglevel=8'

This seems to work OK on my machine.

> Guest kernel is somewhere in virtio_net initialization (for the second
> time). I'm too lazy to find exact line.
>
> Backtrace:
>
> 0  irq__add_msix_route (kvm=kvm@entry=0xbf8010, msg=0xe3d090) at x86/irq.c:210
> #1  0x000000000041b3bf in virtio_pci__specific_io_out.isra.5 (offset=<optimized out>,
>     data=<optimized out>, kvm=0xbf8010) at virtio/pci.c:150
> #2  virtio_pci__io_out.9406 (ioport=<optimized out>, kvm=0xbf8010, port=<optimized out>,
>     data=<optimized out>, size=<optimized out>) at virtio/pci.c:208
> #3  0x000000000040f8c3 in kvm__emulate_io (count=<optimized out>, size=2, direction=1,
>     data=<optimized out>, port=25108, kvm=0xbf8010) at ioport.c:165
> #4  kvm_cpu__start (cpu=<optimized out>) at x86/include/kvm/kvm-cpu-arch.h:41
> #5  0x0000000000416ca2 in kvm_cpu_thread.2824 (arg=<optimized out>) at builtin-run.c:176
> #6  0x00007f701ebd0b50 in start_thread (arg=<optimized out>) at pthread_create.c:304
> #7  0x00007f701e1fe70d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:112
> #8  0x0000000000000000 in ?? ()

Looks like vpci->msix_table might not be initialized properly. Sasha,
Asias, care to take a look at this?

                        Pekka
