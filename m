Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab1HDFrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 01:47:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39374 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1HDFrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 01:47:12 -0400
MIME-Version: 1.0
In-Reply-To: <201108040355.p743tBkv092694@www262.sakura.ne.jp>
References: <201108040221.p742Lk3R069631@www262.sakura.ne.jp>
	<CACqU3MWQsh2cS8ck=c1-bOy-W649j0FjtNeOQbPaijAaCQ9wgA@mail.gmail.com>
	<201108040355.p743tBkv092694@www262.sakura.ne.jp>
Date: Thu, 4 Aug 2011 01:47:11 -0400
Message-ID: <CACqU3MVbHPuOjg9cY_GWdBGz3HPw3u7R3S14OOObN8-CFXGVaw@mail.gmail.com>
Subject: Re: [3.0-git16] Oops at driver_uevent_store().
From: Arnaud Lacombe <lacombar@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: greg@kroah.com, akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Added Adrian Bunk to the Cc: list]

2011/8/3 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
> Arnaud Lacombe wrote:
>> Looking more closely, I'd say I have been too eager in the marking.
>> The warning concern `pci_eisa_driver', not `pci_eisa_pci_tbl' which is
>> also referenced by MODULE_DEVICE_TABLE().
>>
>> Does removing the annotation from `pci_eisa_pci_tbl' fix the BUG ?
> No.
>
ok, I had to enable DEBUG_PAGEALLOC to trigger the crash.

> -static struct pci_device_id __initdata pci_eisa_pci_tbl[] = {
> +static struct pci_device_id pci_eisa_pci_tbl[] = {
>
> did not help.
>
> Printing dmesg in verbose showed below three lines.
>
> [    0.262828] EISA bus registered
> [    6.291117] EISA: Probing bus 0 at eisa.0
> [    6.295445] EISA: Cannot allocate resource for mainboard
>
> Manual printk() tracing showed below callchain.
>
> virtual_eisa_root_init() calls eisa_root_register().
>  eisa_root_register() calls eisa_probe().
>    eisa_probe() returns -EBUSY since root->force_probe == 0.
>  eisa_root_register() calls release_resource() and returns -EBUSY.
> virtual_eisa_root_init() calls platform_device_unregister() and returns -1.
>
> Also, eisa_root_register() in pci_eisa_init() is not called.
>
I'd guess you just have no PCI-EISA bridge in your VM. The trace you
point out should only indicate that you have no EISA device either, as
the comment a bit before point out:

        /* First try to get hold of slot 0. If there is no device
         * here, simply fail, unless root->force_probe is set. */


> So, it seems that something is wrong with cleanup.
> pci_unregister_driver() is missing?
>
The crash happens when sysfs tries to access the device_driver inside
'pci_eisa_driver'. I'd argue that the root of the problem is commit
74b9a297866d which created the inconsistency at the first place:

commit 74b9a297866d0416edd0be5014cb0810de049c6a
Author: Adrian Bunk <bunk@stusta.de>
Date:   Mon Mar 26 21:32:27 2007 -0800

    [PATCH] drivers/eisa/pci_eisa.c:pci_eisa_init() should be init

      WARNING: drivers/built-in.o - Section mismatch: reference to
.init.text:eisa_root_register from .text between 'pci_eisa_init' (at
offset 0xabf670) and 'virtual_eisa_release'

    AFAIK a PCI to EISA bridge isn't anything hotpluggable, so
    pci_eisa_init() can become __init.

    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Cc: Greg KH <greg@kroah.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


To gain a few bytes, 'pci_eisa_init' is freed, but its reference is
kept in `pci_eisa_driver' which triggers the warning. The commit log
points out that PCI to EISA should not be hotpluggable, so it is not
expected to be ever executed again (which would trigger a crash).

Marking `pci_eisa_driver' as __refdata fix the warning and leave the
struct untouched:

diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
index 30da70d..cdae207 100644
--- a/drivers/eisa/pci_eisa.c
+++ b/drivers/eisa/pci_eisa.c
@@ -45,13 +45,13 @@ static int __init pci_eisa_init(struct pci_dev *pdev,
        return 0;
 }

-static struct pci_device_id __initdata pci_eisa_pci_tbl[] = {
+static struct pci_device_id pci_eisa_pci_tbl[] = {
        { PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
          PCI_CLASS_BRIDGE_EISA << 8, 0xffff00, 0 },
        { 0, }
 };

-static struct pci_driver __initdata pci_eisa_driver = {
+static struct pci_driver __refdata pci_eisa_driver = {
        .name           = "pci_eisa",
        .id_table       = pci_eisa_pci_tbl,
        .probe          = pci_eisa_init,


 - Arnaud
