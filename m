Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1BVVQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:16:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42929 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1BVVQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:16:53 -0500
MIME-Version: 1.0
In-Reply-To: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 22 Feb 2011 14:16:31 -0700
X-Google-Sender-Auth: J6exoXtcplQwxTvwLL5rCpZtTO8
Message-ID: <AANLkTi=rvMEbu6ZqHMrin5wRcbO4024Ub93NmfKru+iQ@mail.gmail.com>
Subject: Re: Device tree on x86, part v4
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 1:07 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> This patchset introduces device tree support on x86. The device tree is
> passed by the bootloader via setup_data. It is used as an additional
> source of information and does not replace the "traditional" x86 boot
> page.
> Right now we get the the following information from it:
> - hpet location
> - apic & ioapic location
> - ioapic's interrupt routing
> - legacy devices which are not initialized by bios
> - devices which are behind a bus which does not support enumeration like
>  i2c

Looks good; ship it!

g.

>
> History:
> - v1 initial post
> - v2: Benh took my device tree apart so once this got fixed I refactor a
>      lot of code. Here are the changes:
>      - device tree is unflattenend before kmalloc() is working,
>        alloc_bootmem() is used for that.
>      - irq_host got renamed to irq_domain. This custom implementation
>        will leave once the powerpc implementation is in generic shape
>      - of_irq_map_pci() is moved from ppc & microblaze into drivers/of
>        and used also by x86 instead of a tiny subset of it. Bridges are
>        not handled at all on x86 (I don't have any so for so I worry
>        later)
>      - the device tree is relocated from its initial location. That
>        means that the boot loader does not need to know anything about
>        kernel's memory layout.
> - v3: - rebase on top of current tip. The OLPC merged some OF defines
>        which are mostly nops so I replaced them with the code I have.
>        irq_create_of_mapping() requires now an irq chip to work. Those
>        things are moved into prom.c which is enabled by CONFIG_X86_OF.
>        This probably breaks OLPC but I don't know what they need in the
>        end.
>      - Fixed up Grant's review comments. The most noticeable is the i2c
>        controller node which has now three child nodes, representing the
>        three controllers indentified by the bar number. Each pci bar
>        matches via address translation the correct device tree node.
> - v4: - rebased on top of tip's x86/platform branch.
>      - added some documentation about the new compatible properties.
>      - merged the two rtc commits.
>      - renamed prom.c to devicetree.c
>      - renamed CONFIG_X86_OF to CONFIG_USE_OF
>      - intel,ce4100-immr become intel,ce4100-cp
>      - "standard" hardware like hpet has "ce4100" in its property. If
>        further HW is compatible with it, can reuse the property string.
>      - converted interrupt map to device nodes with an interrupt property.
>
> The series is based on the tip tree and is also available at
>  git://git.linutronix.de/users/bigeasy/soda.git ce_of_v4
>
> Sebastian Andrzej Siewior (11):
>      x86/e820: remove conditional early mapping in parse_e820_ext
>      x86: Add device tree support
>      x86/dtb: Add a device tree for CE4100
>      x86/dtb: add irq domain abstraction
>      x86/dtb: add early parsing of IO APIC
>      x86/dtb: add support hpet
>      x86/dtb: add support for PCI devices backed by dtb nodes
>      x86/dtb: Add generic bus probe
>      x86/ioapic: Add OF bindings for IO-APIC
>      x86/ce4100: use OF for ioapic
>      rtc/cmos: add OF bindings
>
> .../devicetree/bindings/i2c/ce4100-i2c.txt         |   93 +++++
> Documentation/devicetree/bindings/rtc/rtc-cmos.txt |   28 ++
> Documentation/devicetree/bindings/x86/ce4100.txt   |   38 ++
> .../devicetree/bindings/x86/interrupt.txt          |   29 ++
> Documentation/devicetree/bindings/x86/timer.txt    |    6 +
> Documentation/devicetree/booting-without-of.txt    |   20 +
> arch/x86/Kconfig                                   |    7 +
> arch/x86/include/asm/bootparam.h                   |    1 +
> arch/x86/include/asm/e820.h                        |    2 +-
> arch/x86/include/asm/io_apic.h                     |    7 +
> arch/x86/include/asm/irq.h                         |    3 -
> arch/x86/include/asm/irq_controller.h              |   12 +
> arch/x86/include/asm/prom.h                        |   72 ++++-
> arch/x86/kernel/Makefile                           |    1 +
> arch/x86/kernel/apic/io_apic.c                     |   99 +++++
> arch/x86/kernel/devicetree.c                       |  337 +++++++++++++++
> arch/x86/kernel/e820.c                             |    8 +-
> arch/x86/kernel/irq.c                              |    9 -
> arch/x86/kernel/irqinit.c                          |    9 +-
> arch/x86/kernel/rtc.c                              |    3 +
> arch/x86/kernel/setup.c                            |   22 +-
> arch/x86/platform/ce4100/ce4100.c                  |   24 +-
> arch/x86/platform/ce4100/falconfalls.dts           |  430 ++++++++++++++++++++
> drivers/of/Kconfig                                 |    2 +-
> drivers/of/of_pci.c                                |    1 +
> drivers/rtc/rtc-cmos.c                             |   45 ++
> include/linux/of.h                                 |   12 +
> 27 files changed, 1287 insertions(+), 33 deletions(-)
> create mode 100644 Documentation/devicetree/bindings/i2c/ce4100-i2c.txt
> create mode 100644 Documentation/devicetree/bindings/rtc/rtc-cmos.txt
> create mode 100644 Documentation/devicetree/bindings/x86/ce4100.txt
> create mode 100644 Documentation/devicetree/bindings/x86/interrupt.txt
> create mode 100644 Documentation/devicetree/bindings/x86/timer.txt
> create mode 100644 arch/x86/include/asm/irq_controller.h
> create mode 100644 arch/x86/kernel/devicetree.c
> create mode 100644 arch/x86/platform/ce4100/falconfalls.dts
>
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
