Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1HDIkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:40:33 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:57477 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1HDIk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:40:26 -0400
Date: Thu, 4 Aug 2011 11:40:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, greg@kroah.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [3.0-git16] Oops at driver_uevent_store().
Message-ID: <20110804084015.GG29013@localhost.pp.htv.fi>
References: <201108040221.p742Lk3R069631@www262.sakura.ne.jp>
 <CACqU3MWQsh2cS8ck=c1-bOy-W649j0FjtNeOQbPaijAaCQ9wgA@mail.gmail.com>
 <201108040355.p743tBkv092694@www262.sakura.ne.jp>
 <CACqU3MVbHPuOjg9cY_GWdBGz3HPw3u7R3S14OOObN8-CFXGVaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACqU3MVbHPuOjg9cY_GWdBGz3HPw3u7R3S14OOObN8-CFXGVaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 01:47:11AM -0400, Arnaud Lacombe wrote:
> Hi,
> 
> [Added Adrian Bunk to the Cc: list]

Thanks.

> 2011/8/3 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
>...
> commit 74b9a297866d0416edd0be5014cb0810de049c6a
> Author: Adrian Bunk <bunk@stusta.de>
> Date:   Mon Mar 26 21:32:27 2007 -0800
> 
>     [PATCH] drivers/eisa/pci_eisa.c:pci_eisa_init() should be init
> 
>       WARNING: drivers/built-in.o - Section mismatch: reference to
> .init.text:eisa_root_register from .text between 'pci_eisa_init' (at
> offset 0xabf670) and 'virtual_eisa_release'
> 
>     AFAIK a PCI to EISA bridge isn't anything hotpluggable, so
>     pci_eisa_init() can become __init.
> 
>     Signed-off-by: Adrian Bunk <bunk@stusta.de>
>     Cc: Greg KH <greg@kroah.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> 
> To gain a few bytes, 'pci_eisa_init' is freed, but its reference is
> kept in `pci_eisa_driver' which triggers the warning. The commit log
> points out that PCI to EISA should not be hotpluggable, so it is not
> expected to be ever executed again (which would trigger a crash).

This was not for gaining a few bytes, and I'm not exactly seeing why I'm 
to blame here, since my patch is invariant to what your patch does:

Calling pci_eisa_init outside of __init:
- might have crashed before my patch and
- after my patch and
- after your patch
since eisa_root_register() is __init.

> Marking `pci_eisa_driver' as __refdata fix the warning and leave the
> struct untouched:
> 
> diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
> index 30da70d..cdae207 100644
> --- a/drivers/eisa/pci_eisa.c
> +++ b/drivers/eisa/pci_eisa.c
> @@ -45,13 +45,13 @@ static int __init pci_eisa_init(struct pci_dev *pdev,
>         return 0;
>  }
> 
> -static struct pci_device_id __initdata pci_eisa_pci_tbl[] = {
> +static struct pci_device_id pci_eisa_pci_tbl[] = {
>         { PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>           PCI_CLASS_BRIDGE_EISA << 8, 0xffff00, 0 },
>         { 0, }
>  };
> 
> -static struct pci_driver __initdata pci_eisa_driver = {
> +static struct pci_driver __refdata pci_eisa_driver = {
>         .name           = "pci_eisa",
>         .id_table       = pci_eisa_pci_tbl,
>         .probe          = pci_eisa_init,

So the commit that broke it was not mine, but

commit 005bdad7b80ac017ca21d795639d4214b9844a84
Author: Arnaud Lacombe <lacombar@gmail.com>
Date:   Mon Jul 25 17:13:04 2011 -0700

    eisa/pci_eisa.c: fix section mismatch
    
    Fixes
    
      WARNING: vmlinux.o(.data+0x15d3ac): Section mismatch in reference from the
      The variable pci_eisa_driver references the function __init pci_eisa_init(
      If the reference is valid then annotate the variable with __init* or __ref
      *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
    
    Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
    Cc: Greg KH <greg@kroah.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>



Please don't blame me for bugs you introduced.


>  - Arnaud

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

