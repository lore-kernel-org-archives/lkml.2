Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab2KZVFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:05:21 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53539 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2KZVFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:05:19 -0500
Subject: [PATCH 0/5] Alter stealtime reporting in KVM
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com
Date: Mon, 26 Nov 2012 15:05:07 -0600
Message-ID: <20121126210432.407.50742.stgit@lambeau>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12112621-5816-0000-0000-0000058E79E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of where you have a system that is running in a
capped or overcommitted environment the user may see steal time
being reported in accounting tools such as top or vmstat.  This can
cause confusion for the end user.  To ease the confusion this patch set
adds the idea of consigned (expected steal) time.  The host will separate
the consigned time from the steal time.  The consignment limit passed to the
host will be the amount of steal time expected within a fixed period of
time.  Any other steal time accruing during that period will show as the
traditional steal time.

---

Michael Wolf (5):
      Alter the amount of steal time reported by the guest.
      Expand the steal time msr to also contain the consigned time.
      Add the code to send the consigned time from the host to the guest
      Add a timer to allow the separation of consigned from steal time.
      Add an ioctl to communicate the consign limit to the host.


 CREDITS                                            |    5 
 Documentation/arm64/memory.txt                     |   12 
 Documentation/cgroups/memory.txt                   |    4 
 .../devicetree/bindings/net/mdio-gpio.txt          |    9 
 Documentation/filesystems/proc.txt                 |   16 
 Documentation/hwmon/fam15h_power                   |    2 
 Documentation/kernel-parameters.txt                |   20 
 Documentation/networking/netdev-features.txt       |    2 
 Documentation/scheduler/numa-problem.txt           |   20 
 MAINTAINERS                                        |   87 +
 Makefile                                           |    2 
 arch/alpha/kernel/osf_sys.c                        |    6 
 arch/arm/boot/Makefile                             |   10 
 arch/arm/boot/dts/tegra30.dtsi                     |    4 
 arch/arm/include/asm/io.h                          |    4 
 arch/arm/include/asm/sched_clock.h                 |    2 
 arch/arm/include/asm/vfpmacros.h                   |   12 
 arch/arm/include/uapi/asm/hwcap.h                  |    3 
 arch/arm/kernel/sched_clock.c                      |   18 
 arch/arm/mach-at91/at91rm9200_devices.c            |    2 
 arch/arm/mach-at91/at91sam9260_devices.c           |    2 
 arch/arm/mach-at91/at91sam9261_devices.c           |    2 
 arch/arm/mach-at91/at91sam9263_devices.c           |    2 
 arch/arm/mach-at91/at91sam9g45_devices.c           |   12 
 arch/arm/mach-davinci/dm644x.c                     |    3 
 arch/arm/mach-highbank/system.c                    |    3 
 arch/arm/mach-imx/clk-gate2.c                      |    2 
 arch/arm/mach-imx/ehci-imx25.c                     |    2 
 arch/arm/mach-imx/ehci-imx35.c                     |    2 
 arch/arm/mach-omap2/board-igep0020.c               |    5 
 arch/arm/mach-omap2/clockdomains44xx_data.c        |    2 
 arch/arm/mach-omap2/devices.c                      |   79 +
 arch/arm/mach-omap2/omap_hwmod.c                   |   63 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   36 
 arch/arm/mach-omap2/twl-common.c                   |    3 
 arch/arm/mach-omap2/vc.c                           |    2 
 arch/arm/mach-pxa/hx4700.c                         |    8 
 arch/arm/mach-pxa/spitz_pm.c                       |    8 
 arch/arm/mm/alignment.c                            |    2 
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |    6 
 arch/arm/tools/Makefile                            |    2 
 arch/arm/vfp/vfpmodule.c                           |    9 
 arch/arm/xen/enlighten.c                           |   11 
 arch/arm/xen/hypercall.S                           |   14 
 arch/arm64/Kconfig                                 |    1 
 arch/arm64/include/asm/elf.h                       |    5 
 arch/arm64/include/asm/fpsimd.h                    |    5 
 arch/arm64/include/asm/io.h                        |   10 
 arch/arm64/include/asm/pgtable-hwdef.h             |    6 
 arch/arm64/include/asm/pgtable.h                   |   40 -
 arch/arm64/include/asm/processor.h                 |    2 
 arch/arm64/include/asm/unistd.h                    |    1 
 arch/arm64/kernel/perf_event.c                     |   10 
 arch/arm64/kernel/process.c                        |   18 
 arch/arm64/kernel/smp.c                            |    3 
 arch/arm64/mm/init.c                               |    2 
 arch/frv/Kconfig                                   |    1 
 arch/frv/boot/Makefile                             |   10 
 arch/frv/include/asm/unistd.h                      |    1 
 arch/frv/kernel/entry.S                            |   28 
 arch/frv/kernel/process.c                          |    5 
 arch/frv/mb93090-mb00/pci-dma-nommu.c              |    1 
 arch/h8300/include/asm/cache.h                     |    3 
 arch/ia64/mm/init.c                                |    1 
 arch/m68k/include/asm/signal.h                     |    6 
 arch/mips/cavium-octeon/executive/cvmx-l2c.c       |  900 ------------
 arch/unicore32/include/asm/byteorder.h             |   24 
 arch/unicore32/include/asm/kvm_para.h              |    1 
 arch/unicore32/include/asm/sigcontext.h            |   29 
 arch/unicore32/include/asm/unistd.h                |   14 
 arch/x86/include/asm/kvm_host.h                    |   11 
 arch/x86/include/asm/kvm_para.h                    |    3 
 arch/x86/include/asm/paravirt.h                    |    4 
 arch/x86/include/asm/paravirt_types.h              |    2 
 arch/x86/kernel/kvm.c                              |    8 
 arch/x86/kernel/paravirt.c                         |    4 
 arch/x86/kvm/x86.c                                 |   50 +
 fs/proc/stat.c                                     |    9 
 include/linux/kernel_stat.h                        |    2 
 include/linux/kvm_host.h                           |    2 
 include/linux/raid/md_p.h                          |  301 ----
 include/uapi/linux/kvm.h                           |    2 
 kernel/sched/core.c                                |   10 
 kernel/sched/cputime.c                             |   21 
 kernel/sched/sched.h                               |    2 
 tools/perf/builtin-test.c                          | 1559 --------------------
 tools/perf/util/dso-test-data.c                    |  153 --
 tools/perf/util/parse-events-test.c                | 1116 --------------
 tools/testing/selftests/epoll/Makefile             |   11 
 tools/testing/selftests/epoll/test_epoll.c         |  344 ----
 virt/kvm/kvm_main.c                                |    7 
 91 files changed, 574 insertions(+), 4694 deletions(-)
 delete mode 100644 arch/mips/cavium-octeon/executive/cvmx-l2c.c
 delete mode 100644 arch/unicore32/include/asm/byteorder.h
 delete mode 100644 arch/unicore32/include/asm/kvm_para.h
 delete mode 100644 arch/unicore32/include/asm/sigcontext.h
 delete mode 100644 arch/unicore32/include/asm/unistd.h
 delete mode 100644 include/linux/raid/md_p.h
 delete mode 100644 tools/perf/builtin-test.c
 delete mode 100644 tools/perf/util/dso-test-data.c
 delete mode 100644 tools/perf/util/parse-events-test.c
 delete mode 100644 tools/testing/selftests/epoll/Makefile
 delete mode 100644 tools/testing/selftests/epoll/test_epoll.c

-- 
Signature

