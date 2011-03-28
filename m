Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1C1DaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 23:30:22 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44591 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab1C1DaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 23:30:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=lJzPZGzgAAQUE3DYh8G+rmrZinSmzBuy3D8mEPHCmN1tNex1gxQ4l1WgJ1fQ8Srf39
         69VFzrq+mA210q8h3O9TirAVolYmB/cwIFfWipiQht74na45NXxjO2OvOTlRuUD6ojF1
         YzPtCvPhy2mD2bnKzlrNdTeMpoizTEgEamL64=
MIME-Version: 1.0
Date: Mon, 28 Mar 2011 11:30:09 +0800
Message-ID: <AANLkTikmmjPx=QUAx380gxg2dtiDeynsAUdYh3+_-JxY@mail.gmail.com>
Subject: 8139too: del_timer_sync WARNING of in interrupt
From: Dave Young <hidave.darkstar@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, yong.zhang0@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got a lot of warnings about del_timer_sync called in interrupt like following:

[237232.529021] ------------[ cut here ]------------
[237232.529111] WARNING: at kernel/timer.c:1012 del_timer_sync+0xae/0xc6()
[237232.529198] Hardware name: OptiPlex 780
[237232.529286] Modules linked in: tun snd_pcm_oss snd_mixer_oss
kvm_intel kvm snd_hda_codec_analog dell_wmi sparse_keymap
snd_hda_intel snd_hda_codec snd_hwdep wmi 8139too snd_pcm snd_timer
snd_page_alloc e1000e
[237232.529557] Pid: 0, comm: kworker/0:0 Tainted: G        W
2.6.38-04148-g054cfaa #149
[237232.529712] Call Trace:
[237232.529790]  <IRQ>  [<ffffffff810487ea>] ? del_timer_sync+0xae/0xc6
[237232.529876]  [<ffffffff8103b478>] ? warn_slowpath_common+0x80/0x99
[237232.529958]  [<ffffffff8103b4a6>] ? warn_slowpath_null+0x15/0x17
[237232.530039]  [<ffffffff810487ea>] ? del_timer_sync+0xae/0xc6
[237232.530120]  [<ffffffff8104873c>] ? del_timer_sync+0x0/0xc6
[237232.530201]  [<ffffffff814bcf84>] ? linkwatch_schedule_work+0x81/0x9f
[237232.530283]  [<ffffffff814bd06f>] ? linkwatch_fire_event+0xcd/0xd2
[237232.530364]  [<ffffffff814c6ca1>] ? netif_carrier_on+0x2a/0x3e
[237232.530446]  [<ffffffff81368f33>] ? mii_check_media+0x80/0x1a8
[237232.530530]  [<ffffffffa006a175>] ? rtl8139_interrupt+0x234/0x511 [8139too]
[237232.530612]  [<ffffffff81066b81>] ? trace_hardirqs_off+0xd/0xf
[237232.530694]  [<ffffffff81099b5f>] ? handle_irq_event_percpu+0x5f/0x1ad
[237232.530775]  [<ffffffff81099d14>] ? handle_irq_event+0x47/0x68
[237232.530856]  [<ffffffff8109c02b>] ? handle_fasteoi_irq+0x82/0xab
[237232.530939]  [<ffffffff81003b00>] ? handle_irq+0x86/0x8e
[237232.531019]  [<ffffffff81003494>] ? do_IRQ+0x4b/0xb2
[237232.531100]  [<ffffffff8157c3d3>] ? ret_from_intr+0x0/0x1a
[237232.531180]  <EOI>  [<ffffffff810087c6>] ? mwait_idle+0xa4/0xeb
[237232.531264]  [<ffffffff810087cf>] ? mwait_idle+0xad/0xeb
[237232.531345]  [<ffffffff810087c6>] ? mwait_idle+0xa4/0xeb
[237232.531426]  [<ffffffff81001e67>] ? cpu_idle+0x64/0x9a
[237232.531507]  [<ffffffff81575ae0>] ? start_secondary+0x1f2/0x1f4
[237232.531587] ---[ end trace c18fe5c80f501bd9 ]---

The actual call path is:

linkwatch_schedule_work
  -->cancel_delayed_work
    -->del_timer_sync

A real bug?

-- 
Regards
dave
