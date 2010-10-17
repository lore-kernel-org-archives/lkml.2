Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0JQS2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:28:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59004 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab0JQS2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:28:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ISrzLE1qU/i8chIcG7ZyYu3/JMz+D3o9nosOwbeb9Wl+HRDFKDmKh9Xv1n6RI61wq6
         pH66eI6dZzEn/1QHU8B7xOKLXGStrXrFfMZbx+97wgAGgNBRgmAb2dLAP9qXPGC+G37a
         S7CPd1HCCStz9FEAiiw1is6Ahhw0sAH7UqJZc=
MIME-Version: 1.0
In-Reply-To: <20100831083844.043619334@linux.vnet.ibm.com>
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 17 Oct 2010 14:28:11 -0400
Message-ID: <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
Subject: Re: [PATCH 2/2] initramfs: Fix initramfs size calculation
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: mmarek@suse.cz, Sam Ravnborg <sam@ravnborg.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 04:23, Hendrik Brueckner wrote:
> --- a/usr/initramfs_data.S
> +++ b/usr/initramfs_data.S
> @@ -28,4 +24,14 @@ SECTIONS
>  #include <linux/stringify.h>
>
>  .section .init.ramfs,"a"
> +__irf_start:
>  .incbin __stringify(INITRAMFS_IMAGE)
> +__irf_end:
> +.section .init.ramfs.info,"a"
> +.globl __initramfs_size
> +__initramfs_size:
> +#ifdef CONFIG_32BIT
> +       .long __irf_end - __irf_start
> +#else
> +       .quad __irf_end - __irf_start
> +#endif

i'm pretty sure this breaks on every symbol-prefixed arch.  at least,
it broke every Blackfin board:
init/built-in.o: In function `populate_rootfs':
init/initramfs.c:(.init.text+0x2548): undefined reference to `__initramfs_size'
init/initramfs.c:(.init.text+0x254e): undefined reference to `__initramfs_size'
make: *** [.tmp_vmlinux1] Error 1

look at VMLINUX_SYMBOL() in the vmlinux.lds.h file
-mike
