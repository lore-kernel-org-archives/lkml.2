Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0KXNgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:36:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43141 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0KXNgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:36:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=HYdtujrn5v0ix+iiT00SvpG0EbNZErZ38KPaMTO0wWj5NUwpenQji/kvp/25ET5Dc0
         gyCT2ONfTgnB8IxYzpbJMsv2o8RxnxV0Lu55BSAzCcs71Czz+O3nqozdlebYLNYMQseG
         frY8rSiPWylor9Z99MvoZ/c9XKmmgOtRl51W4=
Message-ID: <4CED14C1.4050703@suse.cz>
Date: Wed, 24 Nov 2010 14:36:01 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: bjorn.helgaas@hp.com
CC: David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
        abelay@mit.edu, Chris Wilson <chris@chris-wilson.co.uk>
Subject: resource map sanity check conflict
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with 2.6.37-rc2 with some unrelated patches the following WARNING is
generated:

pnp 00:0a: [mem 0xfed40000-0xfed44fff]
pnp 00:0a: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
...
resource map sanity check conflict: 0xfed40000 0xfed44fff 0xfed44000
0xfed44fff Intel Flush Page
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:98 __ioremap_caller+0x353/0x380()
Hardware name: 766929G
Info: mapping multiple BARs. Your kernel is fine.
Modules linked in: snd tpm_tis(+) snd_page_alloc e1000e(+) rfkill pcspkr
iTCO_wdt soundcore yenta_socket pcmcia_rsrc pcmcia_core
iTCO_vendor_support battery sg tpm tpm_bios ac i915 drm_kms_helper drm
i2c_algo_bit button video ext4 crc16 jbd2 fan processor ata_generic
thermal thermal_sys
Pid: 382, comm: modprobe Not tainted 2.6.37-rc2-0.0.0.4ae942e-desktop #1
Call Trace:
 [<ffffffff81005ac9>] dump_trace+0x79/0x340
 [<ffffffff8151e921>] dump_stack+0x69/0x6f
 [<ffffffff81057d2b>] warn_slowpath_common+0x7b/0xc0
 [<ffffffff81057e25>] warn_slowpath_fmt+0x45/0x50
 [<ffffffff81032453>] __ioremap_caller+0x353/0x380
 [<ffffffffa02c68d7>] tpm_tis_init+0x57/0x660 [tpm_tis]
 [<ffffffff812e8f29>] pnp_device_probe+0x69/0xe0
 [<ffffffff8132afc4>] really_probe+0x64/0x200
 [<ffffffff8132b343>] driver_probe_device+0x43/0xa0
 [<ffffffff8132b433>] __driver_attach+0x93/0xa0
 [<ffffffff8132a02e>] bus_for_each_dev+0x4e/0x80
 [<ffffffff8132a978>] bus_add_driver+0x148/0x2f0
 [<ffffffff8132b68a>] driver_register+0x6a/0x130
 [<ffffffff810002da>] do_one_initcall+0x3a/0x170
 [<ffffffff8109629a>] sys_init_module+0xba/0x210
 [<ffffffff8100307b>] system_call_fastpath+0x16/0x1b
 [<00007f5b8a330eda>] 0x7f5b8a330eda
---[ end trace 1409850b53f9aab2 ]---
tpm_tis 00:0a: 1.2 TPM (device-id 0x3203, rev-id 9)


/proc/iomem:
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:02
  fed40000-fed4bfff : PCI Bus 0000:00
    fed44000-fed44fff : Intel Flush Page
    fed45000-fed4bfff : pnp 00:02


Is it a result of the past resource handling rewrote?

It seems like pci_bus_alloc_resource in
intel_alloc_chipset_flush_resource chooses a weird place to put the
mapping in.

dmesg:
https://bugzillafiles.novell.org/attachment.cgi?id=401414
lspci -vvnnxxx:
https://bugzillafiles.novell.org/attachment.cgi?id=401643
/proc/iomem:
https://bugzillafiles.novell.org/attachment.cgi?id=401476

regards,
-- 
js
suse labs
