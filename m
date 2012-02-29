Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2B2TyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:54:11 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56975 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254Ab2B2TyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:54:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jcmvbkbc@gmail.com designates 10.182.114.9 as permitted sender) smtp.mail=jcmvbkbc@gmail.com; dkim=pass header.i=jcmvbkbc@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4E4B8B.8090508@lwfinger.net>
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>
	<1329161826-11135-6-git-send-email-Larry.Finger@lwfinger.net>
	<4F4E4B8B.8090508@lwfinger.net>
Date: Wed, 29 Feb 2012 22:54:08 +0300
Message-ID: <CAMo8BfK5=YwZYepFoP5SqgDQMPvUeQobqNiBCMM5=eTwUT5e0A@mail.gmail.com>
Subject: Re: [RFC/RFT 5/5] p54spi: Load firmware from work queue and not from
 probe routine
From: Max Filippov <jcmvbkbc@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, chunkeey@web.de,
        m@bues.ch, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Drivers that load firmware from their probe routine have problems with the
>> latest versions of udev as they get timeouts while waiting for user
>> space to start. The problem is fixed by loading the firmware and starting
>> mac80211 from a delayed_work queue. By using this method, most of the
>> original code is preserved.
>>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>> ---
>> This one is compile-tested only.
>>
>> Larry
>> ---
>
>
> Any testing done here?

insmod immediately followed by rmmod causes NULL pointer dereference.
The same always happens on rmmode when the firmware image is absent:

[   52.482696] calling  p54spi_init+0x0/0x30 [p54spi] @ 941
[   52.486053] initcall p54spi_init+0x0/0x30 [p54spi] returned 0 after
3071 usecs
[   53.522430] p54spi spi2.0: request_firmware() failed: -2
[   53.522521] p54spi spi2.0: Failed to read firmware
[   56.337036] Unable to handle kernel NULL pointer dereference at
virtual address 00000044
[   56.337188] pgd = c6c2c000
[   56.337219] [00000044] *pgd=87b07831, *pte=00000000, *ppte=00000000
[   56.337341] Internal error: Oops: 17 [#1] PREEMPT
[   56.337402] Modules linked in: p54spi(-)
[   56.337493] CPU: 0    Not tainted  (3.3.0-rc3-11564-g1465640 #12)
[   56.337585] PC is at drain_workqueue+0x10/0x1b4
[   56.337677] LR is at drain_workqueue+0x10/0x1b4
[   56.337738] pc : [<c0043340>]    lr : [<c0043340>]    psr: 80000013
[   56.337768] sp : c79e3eb8  ip : 00000000  fp : bed7cc1c
[   56.337890] r10: 00000000  r9 : c79e2000  r8 : c0012a48
[   56.337951] r7 : c7863634  r6 : c7863600  r5 : bf00115c  r4 : 00000000
[   56.338043] r3 : 00000000  r2 : 00000000  r1 : c040c844  r0 : 00000001
[   56.338134] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   56.338226] Control: 00c5387d  Table: 86c2c000  DAC: 00000015
[   56.338317] Process rmmod (pid: 950, stack limit = 0xc79e2268)
[   56.338378] Stack: (0xc79e3eb8 to 0xc79e4000)
[   56.338470] 3ea0:
    00000000 bf00115c
[   56.338592] 3ec0: c7863600 c7863634 c0012a48 c79e2000 00000000
c00434f0 c7816300 bf00115c
[   56.338714] 3ee0: c7863600 c0278c38 c7816fa0 bf000ba0 c7863600
bf001ff8 bf001ff8 c01aa53c
[   56.338836] 3f00: c01aa524 c0195808 c7863600 c79e2000 bf001ff8
c01958fc bf001ff8 00000000
[   56.338989] 3f20: c03e3d44 bed7cbf8 c0012a48 c0194c88 bf002030
00000000 00000013 c0061dc8
[   56.339111] 3f40: c79cdf20 73343570 b6006970 c008577c ffffffff
c6ca0180 c79cdf20 c0086774
[   56.339233] 3f60: b6f23000 b6f22000 bed7cc1c c01466f0 c6ca01b4
00000000 b6f22000 00ca0180
[   56.339355] 3f80: bf002030 00000880 c79e3f8c 00000000 b6f233ff
00000880 bed7cbf8 bed7ce97
[   56.339508] 3fa0: 00000081 c00128a0 00000880 bed7cbf8 bed7cbf8
00000880 bed7cbec 00000000
[   56.339630] 3fc0: 00000880 bed7cbf8 bed7ce97 00000081 00000001
00000001 00011fe4 bed7cc1c
[   56.339752] 3fe0: 00000880 bed7cbf8 00009004 b6e908bc 60000010
bed7cbf8 00000000 00000000
[   56.339904] [<c0043340>] (drain_workqueue+0x10/0x1b4) from
[<c00434f0>] (destroy_workqueue+0xc/0x150)
[   56.340057] [<c00434f0>] (destroy_workqueue+0xc/0x150) from
[<c0278c38>] (ieee80211_unregister_hw+0xbc/0xe4)
[   56.340209] [<c0278c38>] (ieee80211_unregister_hw+0xbc/0xe4) from
[<bf000ba0>] (p54spi_remove+0x1c/0x58 [p54spi])
[   56.340393] [<bf000ba0>] (p54spi_remove+0x1c/0x58 [p54spi]) from
[<c01aa53c>] (spi_drv_remove+0x18/0x1c)
[   56.340576] [<c01aa53c>] (spi_drv_remove+0x18/0x1c) from
[<c0195808>] (__device_release_driver+0x7c/0xbc)
[   56.340728] [<c0195808>] (__device_release_driver+0x7c/0xbc) from
[<c01958fc>] (driver_detach+0xb4/0xdc)
[   56.340850] [<c01958fc>] (driver_detach+0xb4/0xdc) from
[<c0194c88>] (bus_remove_driver+0x8c/0xb4)
[   56.341003] [<c0194c88>] (bus_remove_driver+0x8c/0xb4) from
[<c0061dc8>] (sys_delete_module+0x1c8/0x234)
[   56.341186] [<c0061dc8>] (sys_delete_module+0x1c8/0x234) from
[<c00128a0>] (ret_fast_syscall+0x0/0x30)
[   56.341308] Code: e92d47f0 e1a04000 e3a00001 eb002dbb (e5943044)
[   56.341552] ---[ end trace 79a2a071aae86862 ]---
[   56.341644] note: rmmod[950] exited with preempt_count 1

-- 
Thanks.
-- Max
