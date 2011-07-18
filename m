Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1GRNIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:08:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab1GRNIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:08:50 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 00/34] System Firmware and SMBIOS Support [v3]
Date: Mon, 18 Jul 2011 09:08:14 -0400
Message-Id: <1310994528-26276-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry if anyone receives this twice.  It didn't make it to LKML the first
time.]

This change is targeted for 3.2 in order to give is "soak" time in linux-next.

DMI, or the Desktop Management Interface, provides access to OEM and hardware
specific details about the x86 or ia64 system the kernel is currently runnig
on.  DMI has been deprecated since 2003, which was the last update of the DMI
Specification.

The System Management BIOS, or SMBIOS, supercedes DMI -- the SMBIOS tables
include the possibility of a _DMI_ entry and tables.  However, in the
Linux kernel we do not access any of the DMI data and only access SMBIOS data.

Currently, the kernel uses dmi_* functions (as defined in
drivers/firmware/dmi_scan.c) to access the data.  The functions allow kernel
subsystems and modules to set specific options based on the platform and BIOS
version.

The dmi_* functions in the kernel fail in several ways.  First, as
mentioned the dmi_* functions are really accessing SMBIOS data.  The existing
code queries for the _SMB_ entry and determines data access after that.  The
existing dmi_* functions create an array of x86 and ia64 specific entries
which are defined as part of x86 and ia64 specific udev entries, and allows
drivers and subsystems to make platform specific decisions.  In addition to
the arch specific code, the dmi_* code creates a list of "devices" to which
makes updating very difficult and does not easily scale.

Another key issue with the existing code is that several drivers do their
own search through the SMBIOS, for example, see drivers/pci/hotplug/cpqphp*.c.

Three months (or so) ago I proposed a patch which was based on a simple request
from a colleague --  create a sysfs file that would export the SMBIOS version.
This simple request was not something that was easy to do given the layout of
the existing DMI code.  The request resulted in having to create a new smbios
class within the kernel, and essentially doing a separate search through
memory.

This new patchset reworks the existing DMI code into two separate layers.  It is
based off of the feedback I received previously when discussing the SMBIOS
version patch on LKML.

The first layer is the System Firmware Interface, which is based upon Alan
Cox's suggestion of a common platform driver (unfortunately, platform driver
is already defined and used within the kernel).  This is meant to be an
arch independent subsystem in the kernel for all arches.  It is a common
interface which provides access to specific system values in the kernel such
as the Chassis Manufacturer, the BIOS developer, or the BIOS date.  The
System Firmware Interface, or sysfw allows for easy updating by simply adding
fields to an array in include/linux/mod_devicetable.h.
Standard simple searching functions, sysfw_lookup() and sysfw_callback()
are provided to the kernel and modules.  sysfw_callback() is similar to
dmi_check_system() but the new function allows for exact matching which some
drivers required.

The second layer introduced in this patchset is the SMBIOS sysfw driver.  This
driver (obviously) registers with the interface and also provides it's own
interface.  The reason for the separate interface is that specific drivers
have their own need to search the SMBIOS for OEM or platform specific
information (see, for example, drivers/watchdog/hpwdt.c, or
drivers/pci/pci-label.c).  This new driver provides a function, smbios_walk()
which allows individual drivers or subsystems to traverse the SMBIOS table
looking for OEM or platform specific data.  The new SMBIOS driver can be
easily updated by adding SMBIOS structure information to the smbios_struct
union in include/linux/smbios.h.

These changes are now targeted for 3.2 and if there are no objections (there
have been none for v1 and v2) I will request a pull for linux-next during
the 3.1 merge window.

A git tree with these changes has been set up here:

git://git.kernel.org/pub/scm/linux/kernel/git/prarit/smbios.git

with the latest changes in the smbios-3.0-rc7-v3 branch.

Prarit Bhargava (34):
  System Firmware Interface
  New SMBIOS driver for x86 and ia64.
  arch specific changes for SMBIOS and System Firmware
  drivers/acpi changes for SMBIOS and System Firmware interface
  drivers/ata changes for SMBIOS and System Firmware
  drivers/floppy changes for SMBIOS and System Firmware
  drivers/char changes for SMBIOS and System Firmware
  drivers/crypto changes for SMBIOS and System Firmware
  drivers/gpio changes for SMBIOS and System Firmware
  drivers/gpu changes for SMBIOS and System Firmware
  drivers/hwmon changes for SMBIOS and System Firmware
  drivers/i2c changes for SMBIOS and System Firmware
  drivers/ide changes for SMBIOS and System Firmware
  drivers/input changes for SMBIOS and System Firmware
  drivers/leds changes for SMBIOS and System Firmware
  drivers/media changes for SMBIOS and System Firmware
  drivers/misc changes for SMBIOS and System Firmware
  drivers/mtd changes for SMBIOS and System Firmware
  drivers/net changes for SMBIOS and System Firmware
  drivers/pci changes for SMBIOS and System Firmware
  drivers/platform changes for SMBIOS and System  Firmware
  drivers/pnp changes for SMBIOS and System Firmware
  drivers/power changes for SMBIOS and System Firmware
  drivers/rtc changes for SMBIOS and System Firmware
  drivers/staging changes for SMBIOS and System Firmware
  drivers/tty changes for SMBIOS and System Firmware
  drivers/usb changes for SMBIOS and System Firmware
  drivers/video changes for SMBIOS and System Firmware
  drivers/w1 changes for SMBIOS and System Firmware
  drivers/watchdog changes for SMBIOS and System Firmware
  include/linux/acpi.h changes for SMBIOS and System Firmware
  Kernel panic changes for SMBIOS and System Firmware
  sound/pci/hda changes for SMBIOS and System Firmware
  Remove old DMI & SMBIOS code and make SMBIOS default on

 Documentation/ABI/obsolete/sysfs-dmi           |   40 ++
 Documentation/ABI/testing/sysfw-smbios         |   36 ++
 arch/ia64/Kconfig                              |    5 +
 arch/ia64/include/asm/dmi.h                    |   12 -
 arch/ia64/include/asm/smbios.h                 |   12 +
 arch/ia64/kernel/setup.c                       |    8 +-
 arch/x86/Kconfig                               |    9 +-
 arch/x86/include/asm/dmi.h                     |   19 -
 arch/x86/include/asm/mmconfig.h                |    4 +-
 arch/x86/include/asm/pci_x86.h                 |    6 +-
 arch/x86/include/asm/smbios.h                  |   19 +
 arch/x86/kernel/acpi/boot.c                    |  177 +++---
 arch/x86/kernel/acpi/sleep.c                   |    1 -
 arch/x86/kernel/apic/apic.c                    |   20 +-
 arch/x86/kernel/apic/bigsmp_32.c               |   37 +-
 arch/x86/kernel/apm_32.c                       |  391 ++++++++-----
 arch/x86/kernel/cpu/amd.c                      |    2 +-
 arch/x86/kernel/cpu/vmware.c                   |   17 +-
 arch/x86/kernel/io_delay.c                     |   42 +-
 arch/x86/kernel/mmconf-fam10h_64.c             |   28 +-
 arch/x86/kernel/probe_roms.c                   |    1 -
 arch/x86/kernel/process.c                      |    8 +-
 arch/x86/kernel/reboot.c                       |  132 +++--
 arch/x86/kernel/setup.c                        |   14 +-
 arch/x86/kernel/tsc.c                          |   16 +-
 arch/x86/pci/acpi.c                            |   18 +-
 arch/x86/pci/broadcom_bus.c                    |    1 -
 arch/x86/pci/common.c                          |  163 +++---
 arch/x86/pci/direct.c                          |    7 +-
 arch/x86/pci/fixup.c                           |   33 +-
 arch/x86/pci/init.c                            |    4 +-
 arch/x86/pci/irq.c                             |   26 +-
 arch/x86/pci/mmconfig-shared.c                 |   10 +-
 arch/x86/pci/mrst.c                            |    1 -
 drivers/acpi/battery.c                         |    5 +-
 drivers/acpi/blacklist.c                       |  125 ++--
 drivers/acpi/bus.c                             |   16 +-
 drivers/acpi/ec.c                              |  101 +++-
 drivers/acpi/osl.c                             |   17 +-
 drivers/acpi/pci_irq.c                         |   33 +-
 drivers/acpi/pci_slot.c                        |   12 +-
 drivers/acpi/processor_core.c                  |   25 +-
 drivers/acpi/processor_driver.c                |    1 -
 drivers/acpi/processor_idle.c                  |   51 ++-
 drivers/acpi/scan.c                            |    4 +-
 drivers/acpi/sleep.c                           |   46 +-
 drivers/acpi/thermal.c                         |   42 +-
 drivers/acpi/video.c                           |   28 +-
 drivers/acpi/video_detect.c                    |    3 +-
 drivers/ata/acard-ahci.c                       |    1 -
 drivers/ata/ahci.c                             |  177 +++---
 drivers/ata/ata_piix.c                         |  154 +++---
 drivers/ata/pata_ali.c                         |   18 +-
 drivers/ata/pata_cs5530.c                      |   12 +-
 drivers/ata/pata_rdc.c                         |    1 -
 drivers/ata/pata_sch.c                         |    1 -
 drivers/ata/pata_via.c                         |   14 +-
 drivers/ata/sata_sil.c                         |   19 +-
 drivers/block/floppy.c                         |    1 -
 drivers/char/i8k.c                             |   75 ++--
 drivers/char/ipmi/ipmi_si_intf.c               |  159 +++---
 drivers/char/sonypi.c                          |   16 +-
 drivers/cpufreq/acpi-cpufreq.c                 |   16 +-
 drivers/cpufreq/powernow-k7.c                  |   14 +-
 drivers/crypto/amcc/crypto4xx_sa.c             |    1 -
 drivers/crypto/hifn_795x.c                     |    1 -
 drivers/firmware/Kconfig                       |   65 ++-
 drivers/firmware/Makefile                      |    8 +-
 drivers/firmware/dmi-id.c                      |  245 --------
 drivers/firmware/dmi-sysfs.c                   |  696 ----------------------
 drivers/firmware/dmi_scan.c                    |  751 ------------------------
 drivers/firmware/smbios-sysfs.c                |  705 ++++++++++++++++++++++
 drivers/firmware/smbios.c                      |  687 ++++++++++++++++++++++
 drivers/firmware/sysfw-sysfs.c                 |  306 ++++++++++
 drivers/firmware/sysfw.c                       |  168 ++++++
 drivers/gpio/basic_mmio_gpio.c                 |    1 -
 drivers/gpu/drm/i915/intel_lvds.c              |   81 ++--
 drivers/gpu/vga/vga_switcheroo.c               |    1 -
 drivers/hwmon/abituguru.c                      |   18 +-
 drivers/hwmon/abituguru3.c                     |   75 ++--
 drivers/hwmon/acpi_power_meter.c               |   15 +-
 drivers/hwmon/adcxx.c                          |    1 -
 drivers/hwmon/applesmc.c                       |   73 ++-
 drivers/hwmon/asus_atk0110.c                   |   10 +-
 drivers/hwmon/fschmd.c                         |  104 ++--
 drivers/hwmon/it87.c                           |   42 +-
 drivers/hwmon/lm70.c                           |    1 -
 drivers/i2c/busses/i2c-i801.c                  |   76 +--
 drivers/i2c/busses/i2c-nforce2.c               |   12 +-
 drivers/i2c/busses/i2c-piix4.c                 |   24 +-
 drivers/ide/alim15x3.c                         |   18 +-
 drivers/ide/ide-acpi.c                         |   16 +-
 drivers/ide/ide-gd.c                           |   10 +-
 drivers/ide/via82cxxx.c                        |   14 +-
 drivers/input/keyboard/atkbd.c                 |   80 ++--
 drivers/input/misc/wistron_btns.c              |  239 ++++----
 drivers/input/mouse/lifebook.c                 |   42 +-
 drivers/input/mouse/synaptics.c                |   44 +-
 drivers/input/serio/i8042-x86ia64io.h          |  367 ++++++------
 drivers/input/tablet/wacom.h                   |    1 -
 drivers/input/touchscreen/htcpen.c             |   13 +-
 drivers/leds/leds-clevo-mail.c                 |   78 ++--
 drivers/leds/leds-ss4200.c                     |   23 +-
 drivers/media/dvb/firewire/firedtv-fw.c        |    1 -
 drivers/media/dvb/firewire/firedtv.h           |    1 -
 drivers/media/video/cafe_ccic.c                |   14 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.c |   46 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.h |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c |  102 ++--
 drivers/media/video/gspca/m5602/m5602_s5k4aa.h |    2 +-
 drivers/media/video/gspca/sn9c20x.c            |   30 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.h  |    1 -
 drivers/misc/eeprom/at24.c                     |    1 -
 drivers/misc/lis3lv02d/lis3lv02d.c             |    1 -
 drivers/misc/pch_phub.c                        |   14 +-
 drivers/mtd/devices/m25p80.c                   |    1 -
 drivers/net/skge.c                             |   11 +-
 drivers/net/via-rhine.c                        |   18 +-
 drivers/net/wireless/wl1251/sdio.c             |    1 -
 drivers/pci/dmar.c                             |   14 +-
 drivers/pci/hotplug/cpqphp.h                   |   81 +---
 drivers/pci/hotplug/cpqphp_core.c              |  207 +------
 drivers/pci/intel-iommu.c                      |   20 +-
 drivers/pci/pci-label.c                        |   82 ++--
 drivers/pci/pci.h                              |    2 +-
 drivers/pci/pcie/portdrv_pci.c                 |   26 +-
 drivers/pci/quirks.c                           |   29 +-
 drivers/platform/x86/acer-wmi.c                |  119 ++--
 drivers/platform/x86/acerhdf.c                 |   18 +-
 drivers/platform/x86/asus-laptop.c             |   29 +-
 drivers/platform/x86/compal-laptop.c           |  106 ++--
 drivers/platform/x86/dell-laptop.c             |   66 ++-
 drivers/platform/x86/dell-wmi.c                |   15 +-
 drivers/platform/x86/eeepc-laptop.c            |   58 ++-
 drivers/platform/x86/eeepc-wmi.c               |   30 +-
 drivers/platform/x86/fujitsu-laptop.c          |   41 +-
 drivers/platform/x86/hdaps.c                   |   76 ++--
 drivers/platform/x86/hp_accel.c                |   98 ++--
 drivers/platform/x86/ibm_rtl.c                 |   21 +-
 drivers/platform/x86/intel_oaktrail.c          |   15 +-
 drivers/platform/x86/msi-laptop.c              |  115 ++--
 drivers/platform/x86/samsung-laptop.c          |  183 +++---
 drivers/platform/x86/sony-laptop.c             |   16 +-
 drivers/platform/x86/thinkpad_acpi.c           |   64 +--
 drivers/pnp/pnpacpi/core.c                     |    1 -
 drivers/pnp/pnpbios/core.c                     |   20 +-
 drivers/power/max17042_battery.c               |    1 -
 drivers/rtc/rtc-cmos.c                         |    1 -
 drivers/rtc/rtc-mrst.c                         |    1 -
 drivers/staging/hv/hv_mouse.c                  |    1 -
 drivers/staging/hv/hv_timesource.c             |   18 +-
 drivers/staging/hv/hv_util.c                   |   17 +-
 drivers/staging/hv/netvsc_drv.c                |   17 +-
 drivers/staging/hv/vmbus_drv.c                 |    1 -
 drivers/tty/serial/pch_uart.c                  |   16 +-
 drivers/usb/host/pci-quirks.c                  |   19 +-
 drivers/usb/host/uhci-hcd.c                    |    2 +-
 drivers/usb/host/uhci-pci.c                    |   15 +-
 drivers/video/aty/atyfb_base.c                 |   18 +-
 drivers/video/backlight/kb3886_bl.c            |   13 +-
 drivers/video/efifb.c                          |  124 ++--
 drivers/w1/masters/ds2490.c                    |    1 -
 drivers/watchdog/hpwdt.c                       |   16 +-
 drivers/watchdog/ibmasr.c                      |    9 +-
 drivers/watchdog/sbc_fitpc2_wdt.c              |   22 +-
 include/linux/acpi.h                           |    2 +-
 include/linux/dmi.h                            |  139 -----
 include/linux/mod_devicetable.h                |   73 ++-
 include/linux/smbios.h                         |  243 ++++++++
 include/linux/sysfw.h                          |  113 ++++
 init/main.c                                    |    3 +
 kernel/panic.c                                 |    4 +-
 scripts/mod/file2alias.c                       |   52 +-
 sound/pci/hda/patch_sigmatel.c                 |   29 +-
 174 files changed, 5506 insertions(+), 4880 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-dmi
 create mode 100644 Documentation/ABI/testing/sysfw-smbios
 delete mode 100644 arch/ia64/include/asm/dmi.h
 create mode 100644 arch/ia64/include/asm/smbios.h
 delete mode 100644 arch/x86/include/asm/dmi.h
 create mode 100644 arch/x86/include/asm/smbios.h
 delete mode 100644 drivers/firmware/dmi-id.c
 delete mode 100644 drivers/firmware/dmi-sysfs.c
 delete mode 100644 drivers/firmware/dmi_scan.c
 create mode 100644 drivers/firmware/smbios-sysfs.c
 create mode 100644 drivers/firmware/smbios.c
 create mode 100644 drivers/firmware/sysfw-sysfs.c
 create mode 100644 drivers/firmware/sysfw.c
 delete mode 100644 include/linux/dmi.h
 create mode 100644 include/linux/smbios.h
 create mode 100644 include/linux/sysfw.h

