Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab1HDDz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 23:55:29 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57046 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab1HDDzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 23:55:24 -0400
X-Nat-Received: from [202.181.97.72]:49213 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1312430111.6800
Message-Id: <201108040355.p743tBkv092694@www262.sakura.ne.jp>
Subject: Re: [3.0-git16] Oops at driver_uevent_store().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: lacombar@gmail.com
Cc: greg@kroah.com, akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Aug 2011 12:55:11 +0900
References: <201108040221.p742Lk3R069631@www262.sakura.ne.jp> <CACqU3MWQsh2cS8ck=c1-bOy-W649j0FjtNeOQbPaijAaCQ9wgA@mail.gmail.com>
In-Reply-To: <CACqU3MWQsh2cS8ck=c1-bOy-W649j0FjtNeOQbPaijAaCQ9wgA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04082011 #5783366, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaud Lacombe wrote:
> Looking more closely, I'd say I have been too eager in the marking.
> The warning concern `pci_eisa_driver', not `pci_eisa_pci_tbl' which is
> also referenced by MODULE_DEVICE_TABLE().
> 
> Does removing the annotation from `pci_eisa_pci_tbl' fix the BUG ?
No.

-static struct pci_device_id __initdata pci_eisa_pci_tbl[] = {
+static struct pci_device_id pci_eisa_pci_tbl[] = {

did not help.

Printing dmesg in verbose showed below three lines.

[    0.262828] EISA bus registered
[    6.291117] EISA: Probing bus 0 at eisa.0
[    6.295445] EISA: Cannot allocate resource for mainboard

Manual printk() tracing showed below callchain.

virtual_eisa_root_init() calls eisa_root_register().
  eisa_root_register() calls eisa_probe().
    eisa_probe() returns -EBUSY since root->force_probe == 0.
  eisa_root_register() calls release_resource() and returns -EBUSY.
virtual_eisa_root_init() calls platform_device_unregister() and returns -1.

Also, eisa_root_register() in pci_eisa_init() is not called.

So, it seems that something is wrong with cleanup.
pci_unregister_driver() is missing?
