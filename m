Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2JOIwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:52:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52205 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2JOIwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:52:16 -0400
Date: Mon, 15 Oct 2012 16:52:51 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: About reuse address space when __init func removed
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201210151652486099657@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9F8qJoc024048

Hi all,
	Today, I found some kernel message about memeleaking.As follows:
unreferenced object 0xffff8800b6e6b980 (size 64):
  comm "modprobe", pid 1137, jiffies 4294676166 (age 7326.499s)
  hex dump (first 32 bytes):
    01 04 01 00 00 00 00 00 00 00 98 b5 00 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816a3f16>] kmemleak_alloc+0x56/0xc0
    [<ffffffff8113bd43>] __kmalloc+0x173/0x310
    [<ffffffffa009a78a>] 0xffffffffa009a78a
    [<ffffffffa009ad95>] 0xffffffffa009ad95
    [<ffffffff81300985>] pci_device_probe+0x75/0xa0
    [<ffffffff814078c4>] driver_probe_device+0x84/0x380
    [<ffffffff81407c63>] __driver_attach+0xa3/0xb0
    [<ffffffff81405a96>] bus_for_each_dev+0x56/0x90
    [<ffffffff81407359>] driver_attach+0x19/0x20
    [<ffffffff81406e80>] bus_add_driver+0x1a0/0x2c0
    [<ffffffff81408195>] driver_register+0x75/0x150
    [<ffffffff812ffa1c>] __pci_register_driver+0x5c/0x70
    [<ffffffffa00a20a7>] nfsd_last_thread+0x47/0x70 [nfsd]
    [<ffffffff810001fa>] do_one_initcall+0x3a/0x170
    [<ffffffff810a7d1c>] sys_init_module+0x8c/0x200
    [<ffffffff816cc352>] system_call_fastpath+0x16/0x1b

But the problem is not memleak, but the stack.
I noticed "[<ffffffffa00a20a7>] nfsd_last_thread+0x47/0x70 [nfsd]".But the real module is mvsas.
Why the kernel print nfsd?

I added some debuginfo in func mvs_init.
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index cc59dff..d34ce01 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -821,6 +821,7 @@ static int __init mvs_init(void)
 {
        int rc;
        mvs_stt = sas_domain_attach_transport(&mvs_transport_ops);
+       printk(KERN_ERR"%s:0x%lx\n", __func__, _THIS_IP_);
        if (!mvs_stt)
                return -ENOMEM;

The result is "[    3.781487] mvs_init:0xffffffffa00a2000"

I think because the __init attribute.When mvs_init execd,those memeory removed and the address space alse removed.So after func nfsd_last_thread used those address.
Is it a bug?

Thanks!ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
