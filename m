Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195Ab2JYTeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:34:21 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46145 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab2JYTeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:34:19 -0400
MIME-Version: 1.0
In-Reply-To: <20121025121645.GA28475@otc-wbsnb-06>
References: <20121024152740.GA25303@otc-wbsnb-06> <CAOJsxLFD36jYiyE5sfN+uPT5G9G9ttf=K2UB=abEjBiTFNeehA@mail.gmail.com>
 <20121025121645.GA28475@otc-wbsnb-06>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 25 Oct 2012 15:33:58 -0400
Message-ID: <CA+1xoqdN0AhLTczH6u1KngiOA61Ej1tL+v-FHAajqYO3tyGSwg@mail.gmail.com>
Subject: Re: [BUG] lkvm crash on crashkernel boot
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 8:16 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> On Thu, Oct 25, 2012 at 10:17:27AM +0300, Pekka Enberg wrote:
>> On Wed, Oct 24, 2012 at 6:27 PM, Kirill A. Shutemov
>> <kirill.shutemov@linux.intel.com> wrote:
>> > Hi,
>> >
>> > I've tried to play with kexec using lkvm. Unfortunately, lkvm crashes when
>> > I try to switch to crashkernel.
>> >
>> > I use Linus tree + penberg/kvmtool/next + one x86 mm patch[1].
>> >
>> > Kernel is defconfig + kvmconfig. I use the same kernel image for system and
>> > crash env.
>> >
>> > Host:
>> >
>> > % lkvm run --cpus 1 -m 1024 --params 'crashkernel=256M loglevel=8'
>> >
>> > Guest:
>> >
>> > # kexec -p bzImage --reuse-cmdline
>> > # echo c > /proc/sysrq-trigger
>> > ...
>> > [    0.947984] loop: module loaded
>> > [    0.950078] virtio-pci 0000:00:01.0: irq 40 for MSI/MSI-X
>> > [    0.950925] virtio-pci 0000:00:01.0: irq 41 for MSI/MSI-X
>> > [    0.952944] virtio-pci 0000:00:01.0: irq 42 for MSI/MSI-X
>> > zsh: segmentation fault (core dumped)  lkvm run --cpus 1 -m 1024 --params 'crashkernel=256M loglevel=8'
>>
>> This seems to work OK on my machine.
>>
>> > Guest kernel is somewhere in virtio_net initialization (for the second
>> > time). I'm too lazy to find exact line.
>> >
>> > Backtrace:
>> >
>> > 0  irq__add_msix_route (kvm=kvm@entry=0xbf8010, msg=0xe3d090) at x86/irq.c:210
>> > #1  0x000000000041b3bf in virtio_pci__specific_io_out.isra.5 (offset=<optimized out>,
>> >     data=<optimized out>, kvm=0xbf8010) at virtio/pci.c:150
>> > #2  virtio_pci__io_out.9406 (ioport=<optimized out>, kvm=0xbf8010, port=<optimized out>,
>> >     data=<optimized out>, size=<optimized out>) at virtio/pci.c:208
>> > #3  0x000000000040f8c3 in kvm__emulate_io (count=<optimized out>, size=2, direction=1,
>> >     data=<optimized out>, port=25108, kvm=0xbf8010) at ioport.c:165
>> > #4  kvm_cpu__start (cpu=<optimized out>) at x86/include/kvm/kvm-cpu-arch.h:41
>> > #5  0x0000000000416ca2 in kvm_cpu_thread.2824 (arg=<optimized out>) at builtin-run.c:176
>> > #6  0x00007f701ebd0b50 in start_thread (arg=<optimized out>) at pthread_create.c:304
>> > #7  0x00007f701e1fe70d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:112
>> > #8  0x0000000000000000 in ?? ()
>>
>> Looks like vpci->msix_table might not be initialized properly. Sasha,
>> Asias, care to take a look at this?
>
> vec is 0xFFFF in virtio_pci__specific_io_out() on crash.
>
> Let's add proper bounds checking there. It doesn't not solves the issue
> with booting crashkernel, but fix lkvm crash.
>
> With the patch below I've got:
>
> [    0.988004] NET: Registered protocol family 17
> [    0.988550] 9pnet: Installing 9P2000 support
> [    0.989006] virtio-pci 0000:00:02.0: irq 40 for MSI/MSI-X
> [    0.989889] virtio-pci 0000:00:02.0: irq 41 for MSI/MSI-X
> [    0.991117] virtio-pci 0000:00:02.0: irq 40 for MSI/MSI-X
> [    0.991716] virtio-pci 0000:00:02.0: irq 41 for MSI/MSI-X
> [    0.993028] 9pnet_virtio: probe of virtio1 failed with error -2
> [    0.993811] virtio-pci 0000:00:03.0: irq 40 for MSI/MSI-X
> [    0.993895] virtio-pci 0000:00:03.0: irq 41 for MSI/MSI-X
> [    0.995186] virtio-pci 0000:00:03.0: irq 40 for MSI/MSI-X
> [    0.995899] virtio-pci 0000:00:03.0: irq 41 for MSI/MSI-X
> [    0.997030] 9pnet_virtio: probe of virtio2 failed with error -2
> [    0.997891] Key type dns_resolver registered
> [    0.998536] PM: Hibernation image not present or could not be loaded.
> [    0.998902] registered taskstats version 1
> [    1.001163]   Magic number: 0:241:128
> [    1.001887] console [netcon0] enabled
> [    1.002881] netconsole: network logging started
> [    1.175863] Switching to clocksource tsc
> [   13.017445] ALSA device list:
> [   13.017834]   No soundcards found.
> [   13.018382] md: Waiting for all devices to be available before
> autodetect
> [   13.019090] md: If you don't use raid, use raid=noautodetect
> [   13.019867] md: Autodetecting RAID arrays.
> [   13.020280] md: Scanned 0 and added 0 devices.
> [   13.020728] md: autorun ...
> [   13.021008] md: ... autorun DONE.
> [   13.021405] 9pnet_virtio: no channels available
> [   13.021958] VFS: Cannot open root device "root" or unknown-block(0,0):
> error -2
> [   13.022749] Please append a correct "root=" boot option; here are the
> available partitions:
> [   13.023641] Kernel panic - not syncing: VFS: Unable to mount root fs on
> unknown-block(0,0)
> [   13.024462] Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc2+ #20
> [   13.024638] Call Trace:
> [   13.024638]  [<ffffffff8174ae94>] panic+0xb6/0x1b5
> [   13.024638]  [<ffffffff81cc7e0c>] mount_block_root+0x183/0x221
> [   13.024638]  [<ffffffff81cc7fa4>] mount_root+0xfa/0x105
> [   13.024638]  [<ffffffff81cc80ec>] prepare_namespace+0x13d/0x16a
> [   13.024638]  [<ffffffff81729ee6>] kernel_init+0x1c6/0x2e0
> [   13.024638]  [<ffffffff81cc75af>] ? do_early_param+0x8c/0x8c
> [   13.024638]  [<ffffffff81729d20>] ? rest_init+0x70/0x70
> [   13.024638]  [<ffffffff8175db2c>] ret_from_fork+0x7c/0xb0
> [   13.024638]  [<ffffffff81729d20>] ? rest_init+0x70/0x70
> [   13.024638] Rebooting in 1 seconds..  Warning: serial8250__exit failed.
>
>
>   # KVM session ended normally.
>
> diff --git a/tools/kvm/virtio/pci.c b/tools/kvm/virtio/pci.c
> index b6ac571..b5c0dfb 100644
> --- a/tools/kvm/virtio/pci.c
> +++ b/tools/kvm/virtio/pci.c
> @@ -145,15 +145,21 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
>         if (type == VIRTIO_PCI_O_MSIX) {
>                 switch (offset) {
>                 case VIRTIO_MSI_CONFIG_VECTOR:
> -                       vec = vpci->config_vector = ioport__read16(data);
> +                       vec = ioport__read16(data);
> +                       if (vec >= sizeof(vpci->msix_table))
> +                               return false;
>
> +                       vpci->config_vector = vec;
>                         gsi = irq__add_msix_route(kvm, &vpci->msix_table[vec].msg);
>
>                         vpci->config_gsi = gsi;
>                         break;
>                 case VIRTIO_MSI_QUEUE_VECTOR:
> -                       vec = vpci->vq_vector[vpci->queue_selector] = ioport__read16(data);
> +                       vec = ioport__read16(data);
> +                       if (vec >= sizeof(vpci->msix_table))
> +                               return false;
>
> +                       vpci->vq_vector[vpci->queue_selector] = vec;
>                         gsi = irq__add_msix_route(kvm, &vpci->msix_table[vec].msg);
>                         vpci->gsis[vpci->queue_selector] = gsi;
>                         if (vdev->ops->notify_vq_gsi)
> --
>  Kirill A. Shutemov

I think we're seeing that because we don't handle VIRTIO_MSI_NO_VECTOR properly.

We need to deal with the ability to remove GSI & friends as well. I've
added it to my workqueue (unless someone deals with it first).


Thanks,
Sasha
