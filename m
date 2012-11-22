Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab2KVVNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:13:52 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:43510 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2KVSqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:46:02 -0500
From: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
To: rob.herring@calxeda.com, robherring2@gmail.com,
        francescolavra.fl@gmail.com, anton.vorontsov@linaro.org
Cc: lee.jones@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com,
        "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
Subject: [PATCH 0/4] Implement device tree support for ab8500 BM Devices
Date: Fri, 23 Nov 2012 00:13:43 +0530
Message-Id: <1353609827-8218-1-git-send-email-rajanikanth.hv@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>

This patch-set adds device tree binding for ab8500 battery-managed
devices. Removes the redundant platform structure maintained
across bm devices and implements common DT probe routine across all the
modules.

Test status:
a) Tested across 'legacy platform data' and DT binding support
	a.1) ab8500_charger driver fails to get regulator in the
		legacy platform mode.
b) Interrupt numbers assigned differs between legacy and FDT mode.
    (a) Legacy platform_data Mode:
    root@ME:/ cat /proc/interrupts
               CPU0       CPU1
    483:          0          0    ab8500  ab8500-ponkey-dbf
    484:          0          0    ab8500  ab8500-ponkey-dbr
    485:          0          0    ab8500  BATT_OVV
    494:          0          1    ab8500
    495:          0          0    ab8500  ab8500-rtc
    501:          0         13    ab8500  NCONV_ACCU
    503:          7         22    ab8500  CCEOC
    504:          0          1    ab8500  CC_INT_CALIB
    505:          0          0    ab8500  LOW_BAT_F
    516:          0         34    ab8500  ab8500-gpadc
    556:          0          0    ab8500  usb-link-status
    
    (b) FDT Mode:
    root@ME:/ cat /proc/interrupts
               CPU0       CPU1
      6:          0          0    ab8500  ab8500-ponkey-dbf
      7:          0          0    ab8500  ab8500-ponkey-dbr
      8:          0          0    ab8500  BATT_OVV
    162:          0          7    ab8500  ab8500-gpadc
    163:          0          1    ab8500
    164:          0          0    ab8500  ab8500-rtc
    484:          0          0    ab8500  usb-link-status
    499:          0          4    ab8500  NCONV_ACCU
    500:          0          0    ab8500  LOW_BAT_F
    502:          0          1    ab8500  CC_INT_CALIB
    503:          0          6    ab8500  CCEOC

c) Event handlers across bm-modules have been verified only
   during 'battery discharge process' as 'battery charging process'
   depends on ab8500-usb code

d) observed nested IRQ issue, log below:

root@ME:/ ------------[ cut here ]------------
WARNING: at /home/rhv00000/linaro_work/linux/kernel/irq/manage.c:635 irq_nested_primary_handler+0x20/0x28()
Primary handler called for nested irq 193
Modules linked in:
[<c0014884>] (unwind_backtrace+0x0/0xf8) from [<c001cbb4>] (warn_slowpath_common+0x4c/0x64)
[<c001cbb4>] (warn_slowpath_common+0x4c/0x64) from [<c001cc60>] (warn_slowpath_fmt+0x30/0x40)
[<c001cc60>] (warn_slowpath_fmt+0x30/0x40) from [<c0060f00>] (irq_nested_primary_handler+0x20/0x28)
[<c0060f00>] (irq_nested_primary_handler+0x20/0x28) from [<c0060b80>] (handle_irq_event_percpu+0x50/0x194)
[<c0060b80>] (handle_irq_event_percpu+0x50/0x194) from [<c0060d00>] (handle_irq_event+0x3c/0x5c)
[<c0060d00>] (handle_irq_event+0x3c/0x5c) from [<c0063034>] (handle_simple_irq+0x8c/0xc4)
[<c0063034>] (handle_simple_irq+0x8c/0xc4) from [<c0062d84>] (resend_irqs+0x40/0x68)
[<c0062d84>] (resend_irqs+0x40/0x68) from [<c00236d8>] (tasklet_action+0x84/0x120)
[<c00236d8>] (tasklet_action+0x84/0x120) from [<c0023ae4>] (__do_softirq+0xd8/0x198)
[<c0023ae4>] (__do_softirq+0xd8/0x198) from [<c0023ed4>] (irq_exit+0x90/0x98)
[<c0023ed4>] (irq_exit+0x90/0x98) from [<c000f2cc>] (handle_IRQ+0x50/0xb0)
[<c000f2cc>] (handle_IRQ+0x50/0xb0) from [<c00084f0>] (gic_handle_irq+0x28/0x5c)
[<c00084f0>] (gic_handle_irq+0x28/0x5c) from [<c000df80>] (__irq_svc+0x40/0x70)
Exception stack(0xebc5dea8 to 0xebc5def0)
dea0:                   c0f45340 ebc4cf00 00000000 1f321f32 eb196600 ebc4cf00
dec0: c05a3340 00000002 ebc4c600 00000000 eb1b2c00 ebc5df0c 00000000 ebc5def0
dee0: c0040c7c c02ca5ec 60000013 ffffffff
[<c000df80>] (__irq_svc+0x40/0x70) from [<c02ca5ec>] (_raw_spin_unlock_irq+0x28/0x50)
[<c02ca5ec>] (_raw_spin_unlock_irq+0x28/0x50) from [<c0040c7c>] (finish_task_switch+0x28/0xf0)
[<c0040c7c>] (finish_task_switch+0x28/0xf0) from [<c02c93f0>] (__schedule+0x254/0x548)
[<c02c93f0>] (__schedule+0x254/0x548) from [<c0040088>] (smpboot_thread_fn+0x11c/0x250)
[<c0040088>] (smpboot_thread_fn+0x11c/0x250) from [<c0037fc8>] (kthread+0xa4/0xb0)
[<c0037fc8>] (kthread+0xa4/0xb0) from [<c000e418>] (ret_from_fork+0x14/0x3c)
---[ end trace 1b75b31a2719ed1e ]---

Rajanikanth H.V (4):
  mfd: ab8500: add devicetree support for fuelgauge
  mfd: ab8500: add devicetree support for btemp
  mfd: ab8500: add devicetree support for charger
  mfd: ab8500: add devicetree support for chargalg

 Documentation/devicetree/bindings/mfd/ab8500.txt   |   27 +-
 .../bindings/power_supply/ab8500/btemp.txt         |   16 +
 .../bindings/power_supply/ab8500/chargalg.txt      |   16 +
 .../bindings/power_supply/ab8500/charger.txt       |   25 +
 .../devicetree/bindings/power_supply/ab8500/fg.txt |   58 +++
 arch/arm/boot/dts/dbx5x0.dtsi                      |   26 +
 drivers/mfd/ab8500-core.c                          |   20 +
 drivers/power/Kconfig                              |    6 -
 drivers/power/Makefile                             |    2 +-
 drivers/power/ab8500_bmdata.c                      |  514 ++++++++++++++++++++
 drivers/power/ab8500_btemp.c                       |   75 +--
 drivers/power/ab8500_charger.c                     |   83 ++--
 drivers/power/ab8500_fg.c                          |   81 +--
 drivers/power/abx500_chargalg.c                    |   57 ++-
 include/linux/mfd/abx500.h                         |   34 +-
 15 files changed, 879 insertions(+), 161 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/chargalg.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/charger.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
 create mode 100644 drivers/power/ab8500_bmdata.c

-- 
1.7.10.4

