Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2LPQDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 11:03:21 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47417 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2LPQDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 11:03:19 -0500
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 17:03:18 +0100
X-Google-Sender-Auth: Xz1fMq2xhYN45fZJo8SQBkavK20
Message-ID: <CAMuHMdVPBUzN8fsNHFzrEqev9BsvVCVR2fWySCOecjVA-J1qjg@mail.gmail.com>
Subject: dma_mmap_coherent / ARCH_HAS_DMA_MMAP_COHERENT
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux-Arch <linux-arch@vger.kernel.org>
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit
declaration of function ‘dma_mmap_coherent’
drivers/media/v4l2-core/videobuf2-dma-contig.c: In function
‘vb2_dc_get_base_sgt’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit
declaration of function ‘dma_get_sgtable’
make[6]: *** [drivers/media/v4l2-core/videobuf2-dma-contig.o] Error 1
make[6]: Target `__build' not remade because of errors.
make[5]: *** [drivers/media/v4l2-core] Error 2

Both dma_mmap_coherent() and dma_get_sgtable() are defined in
include/asm-generic/dma-mapping-common.h only, which is included by
<asm/dma-mapping.h> on alpha, arm, arm64, hexagon, ia64, microblaze, mips,
openrisc, powerpc, s390, sh, sparc, tile, unicore32, x86.
Should the remaining architectures include this, too?
Should it be moved to <linux/dma-mapping.h>?

Furthermore, there's ARCH_HAS_DMA_MMAP_COHERENT, which is defined
by powerpc only:
arch/powerpc/include/asm/dma-mapping.h:#define ARCH_HAS_DMA_MMAP_COHERENT

and handled in some fishy way in sound/core/pcm_native.c:

#ifndef ARCH_HAS_DMA_MMAP_COHERENT
/* This should be defined / handled globally! */
#ifdef CONFIG_ARM
#define ARCH_HAS_DMA_MMAP_COHERENT
#endif
#endif

/*
 * mmap the DMA buffer on RAM
 */
int snd_pcm_lib_default_mmap(struct snd_pcm_substream *substream,
                             struct vm_area_struct *area)
{
        area->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
#ifdef ARCH_HAS_DMA_MMAP_COHERENT
        if (!substream->ops->page &&
            substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV)
                return dma_mmap_coherent(substream->dma_buffer.dev.dev,
                                         area,
                                         substream->runtime->dma_area,
                                         substream->runtime->dma_addr,
                                         area->vm_end - area->vm_start);
#elif defined(CONFIG_MIPS) && defined(CONFIG_DMA_NONCOHERENT)
        if (substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV &&
            !plat_device_is_coherent(substream->dma_buffer.dev.dev))
                area->vm_page_prot = pgprot_noncached(area->vm_page_prot);
#endif /* ARCH_HAS_DMA_MMAP_COHERENT */
        /* mmap with fault handler */
        area->vm_ops = &snd_pcm_vm_ops_data_fault;
        return 0;
}
EXPORT_SYMBOL_GPL(snd_pcm_lib_default_mmap);

What's up here?

Thx!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
