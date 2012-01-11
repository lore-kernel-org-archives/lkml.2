Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab2AKPYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 10:24:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757562Ab2AKPYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 10:24:21 -0500
From: Andrew Jones <drjones@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, arnd@arndb.de, holt@sgi.com,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake.koichi@jp.panasonic.com, jonas@southpole.se, kyle@mcmartin.ca,
        deller@gmx.de, jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com, drjones@redhat.com
Subject: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Date: Wed, 11 Jan 2012 16:16:48 +0100
Message-Id: <1326295008-29795-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6a108a14fa35 renamed CONFIG_EMBEDDED to CONFIG_EXPERT with the
justification that EMBEDDED was being used with a broader scope. It was
no longer just being used to expose standard options to embedded kernel
configs for tweaking, but rather for all "non-standard" kernel configs.
This is nice, because now developers have a way to clean up the config
menu by adding 'if EXPERT' to all entries in their Kconfig files that
should rarely have a non-default value selected (hint1: it would be nice
if developers would do this, hint2: it would also be nice if developers
would do this rather than making these types of options silent, and thus
impossible to override).

Unfortunately, EMBEDDED was also being used to modify the defaults of
some of these options to selections more appropriate for embedded
kernels. Since the renaming was a simple global search-replace, if
developers were to follow hints 1 and 2 above for non-embedded kernels,
then they may find unexpected changes in their configs after turning on
EXPERT.

This patch attempts to untangle these two, making EXPERT true to its
purpose, which is to only expose standard options for tweaking, and
EMBEDDED to resume use as a default option modifier. The patch was made
with the following four steps, which could not be split into separate
patches without breaking configs

1. Make sure EMBEDDED does nothing, i.e. s/EMBEDDED/EXPERT/. There were
only three places EMBEDDED was used.

2. Add CONFIG_EXPERT=y to all configs that had CONFIG_EMBEDDED=y (and
not CONFIG_EXPERT=y already) to make sure step1 has no effect. This step
isn't strictly necessary since EMBEDDED selects EXPERT, but I wanted the
configs expressing the new need explicitly. Only 13 *_defconfig files.

3. Move all side effects (default changes) from EXPERT to EMBEDDED

4. Add CONFIG_EMBEDDED=y to all configs that had CONFIG_EXPERT=y (and
not CONFIG_EMBEDDED=y already) to make sure step3 has no effect.

I certainly didn't test this for every touched config. However, I did
test it for one config and got the expected results;
    Before patch:
        1. diff config.orig orig.EXPERT   -- shows many changes
        2. diff config.orig orig.EMBEDDED -- shows same changes as (1)
                                             plus EMBEDDED on
    After patch:
        3. diff config.orig config.new    -- no change
        4. diff config.orig new.EXPERT    -- only 1 change, EXPERT on
        5. diff config.orig new.EMBEDDED  -- shows same changes as (2)

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/Kconfig                                  |    2 +-
 arch/arm/configs/ag5evm_defconfig                 |    1 +
 arch/arm/configs/am200epdkit_defconfig            |    1 +
 arch/arm/configs/at91sam9261_defconfig            |    1 +
 arch/arm/configs/at91sam9263_defconfig            |    1 +
 arch/arm/configs/at91sam9g45_defconfig            |    1 +
 arch/arm/configs/at91x40_defconfig                |    1 +
 arch/arm/configs/badge4_defconfig                 |    1 +
 arch/arm/configs/bcmring_defconfig                |    1 +
 arch/arm/configs/cm_x2xx_defconfig                |    1 +
 arch/arm/configs/colibri_pxa270_defconfig         |    1 +
 arch/arm/configs/collie_defconfig                 |    1 +
 arch/arm/configs/corgi_defconfig                  |    1 +
 arch/arm/configs/da8xx_omapl_defconfig            |    1 +
 arch/arm/configs/davinci_all_defconfig            |    1 +
 arch/arm/configs/dove_defconfig                   |    1 +
 arch/arm/configs/ebsa110_defconfig                |    1 +
 arch/arm/configs/edb7211_defconfig                |    1 +
 arch/arm/configs/em_x270_defconfig                |    1 +
 arch/arm/configs/ep93xx_defconfig                 |    1 +
 arch/arm/configs/eseries_pxa_defconfig            |    1 +
 arch/arm/configs/ezx_defconfig                    |    1 +
 arch/arm/configs/footbridge_defconfig             |    1 +
 arch/arm/configs/fortunet_defconfig               |    1 +
 arch/arm/configs/h5000_defconfig                  |    1 +
 arch/arm/configs/imote2_defconfig                 |    1 +
 arch/arm/configs/imx_v4_v5_defconfig              |    1 +
 arch/arm/configs/ixp2000_defconfig                |    1 +
 arch/arm/configs/ixp23xx_defconfig                |    1 +
 arch/arm/configs/ixp4xx_defconfig                 |    1 +
 arch/arm/configs/magician_defconfig               |    1 +
 arch/arm/configs/mv78xx0_defconfig                |    1 +
 arch/arm/configs/mx3_defconfig                    |    1 +
 arch/arm/configs/mx5_defconfig                    |    1 +
 arch/arm/configs/nhk8815_defconfig                |    1 +
 arch/arm/configs/omap1_defconfig                  |    1 +
 arch/arm/configs/omap2plus_defconfig              |    1 +
 arch/arm/configs/orion5x_defconfig                |    1 +
 arch/arm/configs/pcm027_defconfig                 |    1 +
 arch/arm/configs/pleb_defconfig                   |    1 +
 arch/arm/configs/pnx4008_defconfig                |    1 +
 arch/arm/configs/simpad_defconfig                 |    1 +
 arch/arm/configs/spitz_defconfig                  |    1 +
 arch/arm/configs/tct_hammer_defconfig             |    1 +
 arch/arm/configs/tegra_defconfig                  |    1 +
 arch/arm/configs/trizeps4_defconfig               |    1 +
 arch/arm/configs/u300_defconfig                   |    1 +
 arch/arm/configs/viper_defconfig                  |    1 +
 arch/arm/configs/xcep_defconfig                   |    1 +
 arch/avr32/Kconfig                                |    4 +-
 arch/blackfin/configs/BF518F-EZBRD_defconfig      |    1 +
 arch/blackfin/configs/BF526-EZBRD_defconfig       |    1 +
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig |    1 +
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig    |    1 +
 arch/blackfin/configs/BF527-EZKIT_defconfig       |    1 +
 arch/blackfin/configs/BF527-TLL6527M_defconfig    |    1 +
 arch/blackfin/configs/BF533-EZKIT_defconfig       |    1 +
 arch/blackfin/configs/BF533-STAMP_defconfig       |    1 +
 arch/blackfin/configs/BF537-STAMP_defconfig       |    1 +
 arch/blackfin/configs/BF538-EZKIT_defconfig       |    1 +
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    1 +
 arch/blackfin/configs/BF561-ACVILON_defconfig     |    1 +
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig   |    1 +
 arch/blackfin/configs/BF561-EZKIT_defconfig       |    1 +
 arch/blackfin/configs/BlackStamp_defconfig        |    1 +
 arch/blackfin/configs/CM-BF527_defconfig          |    1 +
 arch/blackfin/configs/CM-BF533_defconfig          |    1 +
 arch/blackfin/configs/CM-BF537E_defconfig         |    1 +
 arch/blackfin/configs/CM-BF537U_defconfig         |    1 +
 arch/blackfin/configs/CM-BF548_defconfig          |    1 +
 arch/blackfin/configs/CM-BF561_defconfig          |    1 +
 arch/blackfin/configs/DNP5370_defconfig           |    1 +
 arch/blackfin/configs/H8606_defconfig             |    1 +
 arch/blackfin/configs/IP0X_defconfig              |    1 +
 arch/blackfin/configs/PNAV-10_defconfig           |    1 +
 arch/blackfin/configs/SRV1_defconfig              |    1 +
 arch/blackfin/configs/TCM-BF518_defconfig         |    1 +
 arch/blackfin/configs/TCM-BF537_defconfig         |    1 +
 arch/c6x/configs/dsk6455_defconfig                |    1 +
 arch/c6x/configs/evmc6457_defconfig               |    1 +
 arch/c6x/configs/evmc6472_defconfig               |    1 +
 arch/c6x/configs/evmc6474_defconfig               |    1 +
 arch/cris/configs/artpec_3_defconfig              |    1 +
 arch/cris/configs/etrax-100lx_v2_defconfig        |    1 +
 arch/cris/configs/etraxfs_defconfig               |    1 +
 arch/frv/defconfig                                |    1 +
 arch/h8300/defconfig                              |    1 +
 arch/hexagon/configs/comet_defconfig              |    1 +
 arch/m32r/configs/m32700ut.smp_defconfig          |    1 +
 arch/m32r/configs/m32700ut.up_defconfig           |    1 +
 arch/m32r/configs/mappi.nommu_defconfig           |    1 +
 arch/m32r/configs/mappi.smp_defconfig             |    1 +
 arch/m32r/configs/mappi.up_defconfig              |    1 +
 arch/m32r/configs/mappi2.opsp_defconfig           |    1 +
 arch/m32r/configs/mappi2.vdec2_defconfig          |    1 +
 arch/m32r/configs/mappi3.smp_defconfig            |    1 +
 arch/m32r/configs/oaks32r_defconfig               |    1 +
 arch/m32r/configs/opsput_defconfig                |    1 +
 arch/m32r/configs/usrv_defconfig                  |    1 +
 arch/m68k/Kconfig.debug                           |    2 +-
 arch/m68k/configs/m5208evb_defconfig              |    1 +
 arch/m68k/configs/m5249evb_defconfig              |    1 +
 arch/m68k/configs/m5272c3_defconfig               |    1 +
 arch/m68k/configs/m5275evb_defconfig              |    1 +
 arch/m68k/configs/m5307c3_defconfig               |    1 +
 arch/m68k/configs/m5407c3_defconfig               |    1 +
 arch/microblaze/configs/mmu_defconfig             |    1 +
 arch/microblaze/configs/nommu_defconfig           |    1 +
 arch/mips/configs/ar7_defconfig                   |    1 +
 arch/mips/configs/bcm47xx_defconfig               |    1 +
 arch/mips/configs/bcm63xx_defconfig               |    1 +
 arch/mips/configs/bigsur_defconfig                |    1 +
 arch/mips/configs/capcella_defconfig              |    1 +
 arch/mips/configs/cavium-octeon_defconfig         |    1 +
 arch/mips/configs/cobalt_defconfig                |    1 +
 arch/mips/configs/db1000_defconfig                |    1 +
 arch/mips/configs/db1100_defconfig                |    1 +
 arch/mips/configs/db1200_defconfig                |    1 +
 arch/mips/configs/db1500_defconfig                |    1 +
 arch/mips/configs/db1550_defconfig                |    1 +
 arch/mips/configs/decstation_defconfig            |    1 +
 arch/mips/configs/e55_defconfig                   |    1 +
 arch/mips/configs/fuloong2e_defconfig             |    1 +
 arch/mips/configs/gpr_defconfig                   |    1 +
 arch/mips/configs/ip22_defconfig                  |    1 +
 arch/mips/configs/ip27_defconfig                  |    1 +
 arch/mips/configs/ip28_defconfig                  |    1 +
 arch/mips/configs/ip32_defconfig                  |    1 +
 arch/mips/configs/jazz_defconfig                  |    1 +
 arch/mips/configs/jmr3927_defconfig               |    1 +
 arch/mips/configs/lasat_defconfig                 |    1 +
 arch/mips/configs/lemote2f_defconfig              |    1 +
 arch/mips/configs/malta_defconfig                 |    1 +
 arch/mips/configs/markeins_defconfig              |    1 +
 arch/mips/configs/mipssim_defconfig               |    1 +
 arch/mips/configs/mpc30x_defconfig                |    1 +
 arch/mips/configs/msp71xx_defconfig               |    1 +
 arch/mips/configs/mtx1_defconfig                  |    1 +
 arch/mips/configs/nlm_xlr_defconfig               |    1 +
 arch/mips/configs/pb1100_defconfig                |    1 +
 arch/mips/configs/pb1200_defconfig                |    1 +
 arch/mips/configs/pb1500_defconfig                |    1 +
 arch/mips/configs/pb1550_defconfig                |    1 +
 arch/mips/configs/pnx8335-stb225_defconfig        |    1 +
 arch/mips/configs/pnx8550-jbs_defconfig           |    1 +
 arch/mips/configs/pnx8550-stb810_defconfig        |    1 +
 arch/mips/configs/powertv_defconfig               |    1 +
 arch/mips/configs/rb532_defconfig                 |    1 +
 arch/mips/configs/rbtx49xx_defconfig              |    1 +
 arch/mips/configs/rm200_defconfig                 |    1 +
 arch/mips/configs/sb1250-swarm_defconfig          |    1 +
 arch/mips/configs/tb0219_defconfig                |    1 +
 arch/mips/configs/tb0226_defconfig                |    1 +
 arch/mips/configs/tb0287_defconfig                |    1 +
 arch/mips/configs/workpad_defconfig               |    1 +
 arch/mips/configs/wrppmc_defconfig                |    1 +
 arch/mips/configs/yosemite_defconfig              |    1 +
 arch/mn10300/configs/asb2303_defconfig            |    1 +
 arch/mn10300/configs/asb2364_defconfig            |    1 +
 arch/openrisc/configs/or1ksim_defconfig           |    1 +
 arch/parisc/configs/a500_defconfig                |    1 +
 arch/parisc/configs/c3000_defconfig               |    1 +
 arch/powerpc/configs/40x/acadia_defconfig         |    1 +
 arch/powerpc/configs/40x/ep405_defconfig          |    1 +
 arch/powerpc/configs/40x/kilauea_defconfig        |    1 +
 arch/powerpc/configs/40x/klondike_defconfig       |    1 +
 arch/powerpc/configs/40x/makalu_defconfig         |    1 +
 arch/powerpc/configs/40x/obs600_defconfig         |    1 +
 arch/powerpc/configs/40x/walnut_defconfig         |    1 +
 arch/powerpc/configs/44x/arches_defconfig         |    1 +
 arch/powerpc/configs/44x/bamboo_defconfig         |    1 +
 arch/powerpc/configs/44x/bluestone_defconfig      |    1 +
 arch/powerpc/configs/44x/canyonlands_defconfig    |    1 +
 arch/powerpc/configs/44x/currituck_defconfig      |    1 +
 arch/powerpc/configs/44x/ebony_defconfig          |    1 +
 arch/powerpc/configs/44x/eiger_defconfig          |    1 +
 arch/powerpc/configs/44x/icon_defconfig           |    1 +
 arch/powerpc/configs/44x/iss476-smp_defconfig     |    1 +
 arch/powerpc/configs/44x/katmai_defconfig         |    1 +
 arch/powerpc/configs/44x/rainier_defconfig        |    1 +
 arch/powerpc/configs/44x/redwood_defconfig        |    1 +
 arch/powerpc/configs/44x/sam440ep_defconfig       |    1 +
 arch/powerpc/configs/44x/sequoia_defconfig        |    1 +
 arch/powerpc/configs/44x/taishan_defconfig        |    1 +
 arch/powerpc/configs/44x/warp_defconfig           |    1 +
 arch/powerpc/configs/52xx/cm5200_defconfig        |    1 +
 arch/powerpc/configs/52xx/lite5200b_defconfig     |    1 +
 arch/powerpc/configs/52xx/motionpro_defconfig     |    1 +
 arch/powerpc/configs/52xx/pcm030_defconfig        |    1 +
 arch/powerpc/configs/52xx/tqm5200_defconfig       |    1 +
 arch/powerpc/configs/83xx/asp8347_defconfig       |    1 +
 arch/powerpc/configs/83xx/kmeter1_defconfig       |    1 +
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |    1 +
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |    1 +
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |    1 +
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |    1 +
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |    1 +
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |    1 +
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |    1 +
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |    1 +
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |    1 +
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |    1 +
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |    1 +
 arch/powerpc/configs/83xx/sbc834x_defconfig       |    1 +
 arch/powerpc/configs/85xx/ksi8560_defconfig       |    1 +
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |    1 +
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |    1 +
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |    1 +
 arch/powerpc/configs/85xx/p1023rds_defconfig      |    1 +
 arch/powerpc/configs/85xx/sbc8548_defconfig       |    1 +
 arch/powerpc/configs/85xx/sbc8560_defconfig       |    1 +
 arch/powerpc/configs/85xx/socrates_defconfig      |    1 +
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |    1 +
 arch/powerpc/configs/85xx/tqm8540_defconfig       |    1 +
 arch/powerpc/configs/85xx/tqm8541_defconfig       |    1 +
 arch/powerpc/configs/85xx/tqm8548_defconfig       |    1 +
 arch/powerpc/configs/85xx/tqm8555_defconfig       |    1 +
 arch/powerpc/configs/85xx/tqm8560_defconfig       |    1 +
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig   |    1 +
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig     |    1 +
 arch/powerpc/configs/86xx/gef_sbc310_defconfig    |    1 +
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    |    1 +
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  |    1 +
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  |    1 +
 arch/powerpc/configs/86xx/sbc8641d_defconfig      |    1 +
 arch/powerpc/configs/adder875_defconfig           |    1 +
 arch/powerpc/configs/chroma_defconfig             |    1 +
 arch/powerpc/configs/corenet32_smp_defconfig      |    1 +
 arch/powerpc/configs/corenet64_smp_defconfig      |    1 +
 arch/powerpc/configs/ep8248e_defconfig            |    1 +
 arch/powerpc/configs/ep88xc_defconfig             |    1 +
 arch/powerpc/configs/gamecube_defconfig           |    1 +
 arch/powerpc/configs/holly_defconfig              |    1 +
 arch/powerpc/configs/mgcoge_defconfig             |    1 +
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |    1 +
 arch/powerpc/configs/mpc8272_ads_defconfig        |    1 +
 arch/powerpc/configs/mpc83xx_defconfig            |    1 +
 arch/powerpc/configs/mpc85xx_defconfig            |    1 +
 arch/powerpc/configs/mpc85xx_smp_defconfig        |    1 +
 arch/powerpc/configs/mpc866_ads_defconfig         |    1 +
 arch/powerpc/configs/mpc86xx_defconfig            |    1 +
 arch/powerpc/configs/mpc885_ads_defconfig         |    1 +
 arch/powerpc/configs/ppc40x_defconfig             |    1 +
 arch/powerpc/configs/ppc44x_defconfig             |    1 +
 arch/powerpc/configs/pq2fads_defconfig            |    1 +
 arch/powerpc/configs/ps3_defconfig                |    1 +
 arch/powerpc/configs/storcenter_defconfig         |    1 +
 arch/powerpc/configs/tqm8xx_defconfig             |    1 +
 arch/powerpc/configs/wii_defconfig                |    1 +
 arch/powerpc/platforms/powernv/Kconfig            |    2 +-
 arch/powerpc/platforms/pseries/Kconfig            |    2 +-
 arch/score/configs/spct6600_defconfig             |    1 +
 arch/sh/Kconfig                                   |    2 +-
 arch/xtensa/configs/iss_defconfig                 |    1 +
 arch/xtensa/configs/s6105_defconfig               |    1 +
 drivers/ata/Kconfig                               |    2 +-
 drivers/char/Kconfig                              |    3 +-
 drivers/cpufreq/Kconfig                           |    3 +-
 drivers/gpu/drm/Kconfig                           |    2 +-
 drivers/gpu/drm/drm_fb_helper.c                   |    4 +-
 drivers/gpu/drm/nouveau/Kconfig                   |    2 +-
 drivers/hid/Kconfig                               |   32 ++++++++++----------
 drivers/media/common/tuners/Kconfig               |    2 +-
 drivers/media/dvb/frontends/Kconfig               |    2 +-
 drivers/media/video/Kconfig                       |    2 +-
 drivers/pcmcia/Kconfig                            |    2 +-
 drivers/usb/core/Kconfig                          |    6 ++--
 init/Kconfig                                      |    5 +--
 lib/Kconfig.debug                                 |    2 +-
 net/rfkill/Kconfig                                |    2 +-
 usr/Kconfig                                       |    8 ++--
 271 files changed, 294 insertions(+), 48 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 24626b0..331d59f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -198,7 +198,7 @@ config VECTORS_BASE
 	  The base address of exception vectors.
 
 config ARM_PATCH_PHYS_VIRT
-	bool "Patch physical to virtual translations at runtime" if EMBEDDED
+	bool "Patch physical to virtual translations at runtime" if EXPERT
 	default y
 	depends on !XIP_KERNEL && MMU
 	depends on !ARCH_REALVIEW || !SPARSEMEM
diff --git a/arch/arm/configs/ag5evm_defconfig b/arch/arm/configs/ag5evm_defconfig
index 212ead3..cf7dc08 100644
--- a/arch/arm/configs/ag5evm_defconfig
+++ b/arch/arm/configs/ag5evm_defconfig
@@ -11,6 +11,7 @@ CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_DEADLINE is not set
diff --git a/arch/arm/configs/am200epdkit_defconfig b/arch/arm/configs/am200epdkit_defconfig
index f0dea52..f8e85f0 100644
--- a/arch/arm/configs/am200epdkit_defconfig
+++ b/arch/arm/configs/am200epdkit_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOCALVERSION="gum"
 CONFIG_SYSVIPC=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_EPOLL is not set
 # CONFIG_SHMEM is not set
diff --git a/arch/arm/configs/at91sam9261_defconfig b/arch/arm/configs/at91sam9261_defconfig
index ade6b2f..1d3e6d5 100644
--- a/arch/arm/configs/at91sam9261_defconfig
+++ b/arch/arm/configs/at91sam9261_defconfig
@@ -8,6 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/at91sam9263_defconfig b/arch/arm/configs/at91sam9263_defconfig
index 1cf9626..cbb2776 100644
--- a/arch/arm/configs/at91sam9263_defconfig
+++ b/arch/arm/configs/at91sam9263_defconfig
@@ -8,6 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/at91sam9g45_defconfig b/arch/arm/configs/at91sam9g45_defconfig
index 606d48f..13abee9 100644
--- a/arch/arm/configs/at91sam9g45_defconfig
+++ b/arch/arm/configs/at91sam9g45_defconfig
@@ -8,6 +8,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/at91x40_defconfig b/arch/arm/configs/at91x40_defconfig
index c55e921..3958b94 100644
--- a/arch/arm/configs/at91x40_defconfig
+++ b/arch/arm/configs/at91x40_defconfig
@@ -1,6 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/arm/configs/badge4_defconfig b/arch/arm/configs/badge4_defconfig
index 5b54abb..9845ac2 100644
--- a/arch/arm/configs/badge4_defconfig
+++ b/arch/arm/configs/badge4_defconfig
@@ -1,6 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 CONFIG_ARCH_SA1100=y
diff --git a/arch/arm/configs/bcmring_defconfig b/arch/arm/configs/bcmring_defconfig
index 795374d..eef913e 100644
--- a/arch/arm/configs/bcmring_defconfig
+++ b/arch/arm/configs/bcmring_defconfig
@@ -3,6 +3,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/arm/configs/cm_x2xx_defconfig b/arch/arm/configs/cm_x2xx_defconfig
index a93ff8d..ca5c747 100644
--- a/arch/arm/configs/cm_x2xx_defconfig
+++ b/arch/arm/configs/cm_x2xx_defconfig
@@ -7,6 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/arm/configs/colibri_pxa270_defconfig b/arch/arm/configs/colibri_pxa270_defconfig
index 2ef2c5e..5125dd3 100644
--- a/arch/arm/configs/colibri_pxa270_defconfig
+++ b/arch/arm/configs/colibri_pxa270_defconfig
@@ -9,6 +9,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/collie_defconfig b/arch/arm/configs/collie_defconfig
index 6c56ad0..2697fc3 100644
--- a/arch/arm/configs/collie_defconfig
+++ b/arch/arm/configs/collie_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_BASE_FULL is not set
 # CONFIG_EPOLL is not set
 CONFIG_SLOB=y
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defconfig
index e53c475..5af4322 100644
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/da8xx_omapl_defconfig b/arch/arm/configs/da8xx_omapl_defconfig
index 88ccde0..1964302 100644
--- a/arch/arm/configs/da8xx_omapl_defconfig
+++ b/arch/arm/configs/da8xx_omapl_defconfig
@@ -7,6 +7,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
diff --git a/arch/arm/configs/davinci_all_defconfig b/arch/arm/configs/davinci_all_defconfig
index 67b5abb6..2e4b65a 100644
--- a/arch/arm/configs/davinci_all_defconfig
+++ b/arch/arm/configs/davinci_all_defconfig
@@ -7,6 +7,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
diff --git a/arch/arm/configs/dove_defconfig b/arch/arm/configs/dove_defconfig
index 40db34c..319e3f8 100644
--- a/arch/arm/configs/dove_defconfig
+++ b/arch/arm/configs/dove_defconfig
@@ -2,6 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/ebsa110_defconfig b/arch/arm/configs/ebsa110_defconfig
index 14559db..971d988 100644
--- a/arch/arm/configs/ebsa110_defconfig
+++ b/arch/arm/configs/ebsa110_defconfig
@@ -3,6 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_ARCH_EBSA110=y
 CONFIG_PCCARD=m
diff --git a/arch/arm/configs/edb7211_defconfig b/arch/arm/configs/edb7211_defconfig
index d52ded35..90b8b53 100644
--- a/arch/arm/configs/edb7211_defconfig
+++ b/arch/arm/configs/edb7211_defconfig
@@ -3,6 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 CONFIG_ARCH_CLPS711X=y
 CONFIG_ARCH_EDB7211=y
diff --git a/arch/arm/configs/em_x270_defconfig b/arch/arm/configs/em_x270_defconfig
index 60a21e0..bc7b70c 100644
--- a/arch/arm/configs/em_x270_defconfig
+++ b/arch/arm/configs/em_x270_defconfig
@@ -7,6 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 8e97b2f..58ecf1d 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -5,6 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/eseries_pxa_defconfig b/arch/arm/configs/eseries_pxa_defconfig
index d68ac67..c69b4d8 100644
--- a/arch/arm/configs/eseries_pxa_defconfig
+++ b/arch/arm/configs/eseries_pxa_defconfig
@@ -3,6 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/ezx_defconfig b/arch/arm/configs/ezx_defconfig
index d95763d..4779797 100644
--- a/arch/arm/configs/ezx_defconfig
+++ b/arch/arm/configs/ezx_defconfig
@@ -8,6 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/footbridge_defconfig b/arch/arm/configs/footbridge_defconfig
index 038518a..4b05a8e 100644
--- a/arch/arm/configs/footbridge_defconfig
+++ b/arch/arm/configs/footbridge_defconfig
@@ -4,6 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 CONFIG_MODULES=y
 CONFIG_ARCH_FOOTBRIDGE=y
diff --git a/arch/arm/configs/fortunet_defconfig b/arch/arm/configs/fortunet_defconfig
index 840fced..7ead062 100644
--- a/arch/arm/configs/fortunet_defconfig
+++ b/arch/arm/configs/fortunet_defconfig
@@ -3,6 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 CONFIG_ARCH_CLPS711X=y
 CONFIG_ARCH_FORTUNET=y
diff --git a/arch/arm/configs/h5000_defconfig b/arch/arm/configs/h5000_defconfig
index 37903e3..1ae9d20 100644
--- a/arch/arm/configs/h5000_defconfig
+++ b/arch/arm/configs/h5000_defconfig
@@ -5,6 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/imote2_defconfig b/arch/arm/configs/imote2_defconfig
index fd996bb..a3e9e08 100644
--- a/arch/arm/configs/imote2_defconfig
+++ b/arch/arm/configs/imote2_defconfig
@@ -7,6 +7,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/imx_v4_v5_defconfig b/arch/arm/configs/imx_v4_v5_defconfig
index a22e930..da959e8 100644
--- a/arch/arm/configs/imx_v4_v5_defconfig
+++ b/arch/arm/configs/imx_v4_v5_defconfig
@@ -4,6 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff --git a/arch/arm/configs/ixp2000_defconfig b/arch/arm/configs/ixp2000_defconfig
index 8405ade..1d3760b 100644
--- a/arch/arm/configs/ixp2000_defconfig
+++ b/arch/arm/configs/ixp2000_defconfig
@@ -4,6 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/ixp23xx_defconfig b/arch/arm/configs/ixp23xx_defconfig
index 6887176..38b8d7f 100644
--- a/arch/arm/configs/ixp23xx_defconfig
+++ b/arch/arm/configs/ixp23xx_defconfig
@@ -4,6 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/ixp4xx_defconfig b/arch/arm/configs/ixp4xx_defconfig
index 063e2ab..572b096 100644
--- a/arch/arm/configs/ixp4xx_defconfig
+++ b/arch/arm/configs/ixp4xx_defconfig
@@ -4,6 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
index 443675d..d709761 100644
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -5,6 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index 7305ebd..2fb9f35 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -3,6 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_PROFILING=y
diff --git a/arch/arm/configs/mx3_defconfig b/arch/arm/configs/mx3_defconfig
index cb0717f..48ed244 100644
--- a/arch/arm/configs/mx3_defconfig
+++ b/arch/arm/configs/mx3_defconfig
@@ -4,6 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/mx5_defconfig b/arch/arm/configs/mx5_defconfig
index d0d8dfe..e946fd1 100644
--- a/arch/arm/configs/mx5_defconfig
+++ b/arch/arm/configs/mx5_defconfig
@@ -5,6 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_RELAY=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/nhk8815_defconfig b/arch/arm/configs/nhk8815_defconfig
index 37207d1..a67dabb 100644
--- a/arch/arm/configs/nhk8815_defconfig
+++ b/arch/arm/configs/nhk8815_defconfig
@@ -8,6 +8,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index dde2a1a..3040807 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -7,6 +7,7 @@ CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index d5f00d7..cfd96e1 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -7,6 +7,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/orion5x_defconfig b/arch/arm/configs/orion5x_defconfig
index a288d70..5b6c472 100644
--- a/arch/arm/configs/orion5x_defconfig
+++ b/arch/arm/configs/orion5x_defconfig
@@ -3,6 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=y
diff --git a/arch/arm/configs/pcm027_defconfig b/arch/arm/configs/pcm027_defconfig
index 2f136c3..61b3d90 100644
--- a/arch/arm/configs/pcm027_defconfig
+++ b/arch/arm/configs/pcm027_defconfig
@@ -8,6 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/pleb_defconfig b/arch/arm/configs/pleb_defconfig
index cb08cc5..1a241c8 100644
--- a/arch/arm/configs/pleb_defconfig
+++ b/arch/arm/configs/pleb_defconfig
@@ -4,6 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_SHMEM is not set
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/pnx4008_defconfig b/arch/arm/configs/pnx4008_defconfig
index 35a31cc..257f656 100644
--- a/arch/arm/configs/pnx4008_defconfig
+++ b/arch/arm/configs/pnx4008_defconfig
@@ -6,6 +6,7 @@ CONFIG_AUDIT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/simpad_defconfig b/arch/arm/configs/simpad_defconfig
index d335815..a6a333d 100644
--- a/arch/arm/configs/simpad_defconfig
+++ b/arch/arm/configs/simpad_defconfig
@@ -3,6 +3,7 @@ CONFIG_LOCALVERSION="oe1"
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index 7015827..75634f8 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/tct_hammer_defconfig b/arch/arm/configs/tct_hammer_defconfig
index 95c0f0d..b19cd0c 100644
--- a/arch/arm/configs/tct_hammer_defconfig
+++ b/arch/arm/configs/tct_hammer_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_BUG is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index fd5d304..611e0fa 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -11,6 +11,7 @@ CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_ELF_CORE is not set
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/trizeps4_defconfig b/arch/arm/configs/trizeps4_defconfig
index 3162173..9f74004 100644
--- a/arch/arm/configs/trizeps4_defconfig
+++ b/arch/arm/configs/trizeps4_defconfig
@@ -8,6 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/u300_defconfig b/arch/arm/configs/u300_defconfig
index 374000e..432cd78 100644
--- a/arch/arm/configs/u300_defconfig
+++ b/arch/arm/configs/u300_defconfig
@@ -4,6 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_AIO is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/viper_defconfig b/arch/arm/configs/viper_defconfig
index 1d01ddd..ffbe996 100644
--- a/arch/arm/configs/viper_defconfig
+++ b/arch/arm/configs/viper_defconfig
@@ -4,6 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=13
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_ELF_CORE is not set
 # CONFIG_SHMEM is not set
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/xcep_defconfig b/arch/arm/configs/xcep_defconfig
index 721832f..13746a1 100644
--- a/arch/arm/configs/xcep_defconfig
+++ b/arch/arm/configs/xcep_defconfig
@@ -9,6 +9,7 @@ CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 # CONFIG_SHMEM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 197e96f..65c64c6 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -1,8 +1,8 @@
 config AVR32
 	def_bool y
-	# With EXPERT=n, we get lots of stuff automatically selected
+	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
-	select EXPERT
+	select EMBEDDED
 	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
diff --git a/arch/blackfin/configs/BF518F-EZBRD_defconfig b/arch/blackfin/configs/BF518F-EZBRD_defconfig
index 0b7039c..f3eae8f 100644
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig b/arch/blackfin/configs/BF526-EZBRD_defconfig
index 5553205..4ce643d 100644
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
index d95658f..8321149 100644
--- a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
+++ b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_ELF_CORE is not set
 # CONFIG_AIO is not set
 CONFIG_SLAB=y
diff --git a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
index 498f64a..1a05bec 100644
--- a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index 72e0317..5f3517d 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF527-TLL6527M_defconfig b/arch/blackfin/configs/BF527-TLL6527M_defconfig
index cd0636b..044c033 100644
--- a/arch/blackfin/configs/BF527-TLL6527M_defconfig
+++ b/arch/blackfin/configs/BF527-TLL6527M_defconfig
@@ -7,6 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 2f075e0..968c03c 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
index ab38a82..eeda711 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
index 5c802d6..1468e87 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig b/arch/blackfin/configs/BF538-EZKIT_defconfig
index 972aa62..e79b658 100644
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index 7a1e3bf..f32e1d9 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -5,6 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF561-ACVILON_defconfig b/arch/blackfin/configs/BF561-ACVILON_defconfig
index 0fdc4ec..990ab18 100644
--- a/arch/blackfin/configs/BF561-ACVILON_defconfig
+++ b/arch/blackfin/configs/BF561-ACVILON_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
index 78adbbf..c1ea89a 100644
--- a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
index d3cd0f5..bafa645 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
index 7b982d0..6c9fba4 100644
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -7,6 +7,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/CM-BF527_defconfig b/arch/blackfin/configs/CM-BF527_defconfig
index c280a50..6289ecb 100644
--- a/arch/blackfin/configs/CM-BF527_defconfig
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -9,6 +9,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/CM-BF533_defconfig b/arch/blackfin/configs/CM-BF533_defconfig
index c940a1e..ab484cd 100644
--- a/arch/blackfin/configs/CM-BF533_defconfig
+++ b/arch/blackfin/configs/CM-BF533_defconfig
@@ -8,6 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF537E_defconfig b/arch/blackfin/configs/CM-BF537E_defconfig
index 2e47df7..4428e85 100644
--- a/arch/blackfin/configs/CM-BF537E_defconfig
+++ b/arch/blackfin/configs/CM-BF537E_defconfig
@@ -9,6 +9,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF537U_defconfig b/arch/blackfin/configs/CM-BF537U_defconfig
index 6da629f..dad5af2 100644
--- a/arch/blackfin/configs/CM-BF537U_defconfig
+++ b/arch/blackfin/configs/CM-BF537U_defconfig
@@ -9,6 +9,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF548_defconfig b/arch/blackfin/configs/CM-BF548_defconfig
index 349922b..54d649c 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -9,6 +9,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF561_defconfig b/arch/blackfin/configs/CM-BF561_defconfig
index 0456dea..a9bd4a9 100644
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -9,6 +9,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/DNP5370_defconfig b/arch/blackfin/configs/DNP5370_defconfig
index 89162d0..0fe299f 100644
--- a/arch/blackfin/configs/DNP5370_defconfig
+++ b/arch/blackfin/configs/DNP5370_defconfig
@@ -6,6 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLOB=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_CFQ is not set
diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
index a26436b..71f4b69 100644
--- a/arch/blackfin/configs/H8606_defconfig
+++ b/arch/blackfin/configs/H8606_defconfig
@@ -3,6 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/IP0X_defconfig b/arch/blackfin/configs/IP0X_defconfig
index 6479915..a585d6d 100644
--- a/arch/blackfin/configs/IP0X_defconfig
+++ b/arch/blackfin/configs/IP0X_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
index 8fd9b44..346971bc 100644
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -3,6 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/SRV1_defconfig b/arch/blackfin/configs/SRV1_defconfig
index 0520c16..adc6ad9 100644
--- a/arch/blackfin/configs/SRV1_defconfig
+++ b/arch/blackfin/configs/SRV1_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/TCM-BF518_defconfig b/arch/blackfin/configs/TCM-BF518_defconfig
index e4ed865..fd80357 100644
--- a/arch/blackfin/configs/TCM-BF518_defconfig
+++ b/arch/blackfin/configs/TCM-BF518_defconfig
@@ -8,6 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/TCM-BF537_defconfig b/arch/blackfin/configs/TCM-BF537_defconfig
index c1f45f1..8befd6b 100644
--- a/arch/blackfin/configs/TCM-BF537_defconfig
+++ b/arch/blackfin/configs/TCM-BF537_defconfig
@@ -9,6 +9,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/c6x/configs/dsk6455_defconfig b/arch/c6x/configs/dsk6455_defconfig
index 4663487..94dda56 100644
--- a/arch/c6x/configs/dsk6455_defconfig
+++ b/arch/c6x/configs/dsk6455_defconfig
@@ -11,6 +11,7 @@ CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_FUTEX is not set
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_MODULES=y
diff --git a/arch/c6x/configs/evmc6457_defconfig b/arch/c6x/configs/evmc6457_defconfig
index bba40e1..0bb129c 100644
--- a/arch/c6x/configs/evmc6457_defconfig
+++ b/arch/c6x/configs/evmc6457_defconfig
@@ -11,6 +11,7 @@ CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_FUTEX is not set
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_MODULES=y
diff --git a/arch/c6x/configs/evmc6472_defconfig b/arch/c6x/configs/evmc6472_defconfig
index 8c46155..fdcfe18 100644
--- a/arch/c6x/configs/evmc6472_defconfig
+++ b/arch/c6x/configs/evmc6472_defconfig
@@ -11,6 +11,7 @@ CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_FUTEX is not set
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_MODULES=y
diff --git a/arch/c6x/configs/evmc6474_defconfig b/arch/c6x/configs/evmc6474_defconfig
index 15533f6..c1f71643 100644
--- a/arch/c6x/configs/evmc6474_defconfig
+++ b/arch/c6x/configs/evmc6474_defconfig
@@ -11,6 +11,7 @@ CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_FUTEX is not set
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_MODULES=y
diff --git a/arch/cris/configs/artpec_3_defconfig b/arch/cris/configs/artpec_3_defconfig
index 71854d4..e66469c 100644
--- a/arch/cris/configs/artpec_3_defconfig
+++ b/arch/cris/configs/artpec_3_defconfig
@@ -3,6 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/cris/configs/etrax-100lx_v2_defconfig b/arch/cris/configs/etrax-100lx_v2_defconfig
index a85aabf..29c4fb1 100644
--- a/arch/cris/configs/etrax-100lx_v2_defconfig
+++ b/arch/cris/configs/etrax-100lx_v2_defconfig
@@ -3,6 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/cris/configs/etraxfs_defconfig b/arch/cris/configs/etraxfs_defconfig
index 87c7227..5c640e6 100644
--- a/arch/cris/configs/etraxfs_defconfig
+++ b/arch/cris/configs/etraxfs_defconfig
@@ -3,6 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/frv/defconfig b/arch/frv/defconfig
index b1b7926..a9bd57c 100644
--- a/arch/frv/defconfig
+++ b/arch/frv/defconfig
@@ -4,6 +4,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 CONFIG_MMU=y
 CONFIG_FRV_OUTOFLINE_ATOMIC_OPS=y
diff --git a/arch/h8300/defconfig b/arch/h8300/defconfig
index 042425a..f13c53a 100644
--- a/arch/h8300/defconfig
+++ b/arch/h8300/defconfig
@@ -2,6 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
diff --git a/arch/hexagon/configs/comet_defconfig b/arch/hexagon/configs/comet_defconfig
index e324f65..5c41d56 100644
--- a/arch/hexagon/configs/comet_defconfig
+++ b/arch/hexagon/configs/comet_defconfig
@@ -16,6 +16,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
diff --git a/arch/m32r/configs/m32700ut.smp_defconfig b/arch/m32r/configs/m32700ut.smp_defconfig
index a3d727e..354f483 100644
--- a/arch/m32r/configs/m32700ut.smp_defconfig
+++ b/arch/m32r/configs/m32700ut.smp_defconfig
@@ -6,6 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/m32700ut.up_defconfig b/arch/m32r/configs/m32700ut.up_defconfig
index b833416..c62bb11 100644
--- a/arch/m32r/configs/m32700ut.up_defconfig
+++ b/arch/m32r/configs/m32700ut.up_defconfig
@@ -6,6 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi.nommu_defconfig b/arch/m32r/configs/mappi.nommu_defconfig
index 7c90ce2..990b9dd 100644
--- a/arch/m32r/configs/mappi.nommu_defconfig
+++ b/arch/m32r/configs/mappi.nommu_defconfig
@@ -4,6 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi.smp_defconfig b/arch/m32r/configs/mappi.smp_defconfig
index 367d07c..51ce966 100644
--- a/arch/m32r/configs/mappi.smp_defconfig
+++ b/arch/m32r/configs/mappi.smp_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi.up_defconfig b/arch/m32r/configs/mappi.up_defconfig
index cb11384..7175dbb 100644
--- a/arch/m32r/configs/mappi.up_defconfig
+++ b/arch/m32r/configs/mappi.up_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi2.opsp_defconfig b/arch/m32r/configs/mappi2.opsp_defconfig
index 3bff779..4aaf457 100644
--- a/arch/m32r/configs/mappi2.opsp_defconfig
+++ b/arch/m32r/configs/mappi2.opsp_defconfig
@@ -5,6 +5,7 @@ CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi2.vdec2_defconfig b/arch/m32r/configs/mappi2.vdec2_defconfig
index 75246c9..b2fc459 100644
--- a/arch/m32r/configs/mappi2.vdec2_defconfig
+++ b/arch/m32r/configs/mappi2.vdec2_defconfig
@@ -5,6 +5,7 @@ CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi3.smp_defconfig b/arch/m32r/configs/mappi3.smp_defconfig
index 27cefd4..a80c7dd 100644
--- a/arch/m32r/configs/mappi3.smp_defconfig
+++ b/arch/m32r/configs/mappi3.smp_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/oaks32r_defconfig b/arch/m32r/configs/oaks32r_defconfig
index 5087a51..3253a93 100644
--- a/arch/m32r/configs/oaks32r_defconfig
+++ b/arch/m32r/configs/oaks32r_defconfig
@@ -3,6 +3,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/opsput_defconfig b/arch/m32r/configs/opsput_defconfig
index 50c6f52..6916d49 100644
--- a/arch/m32r/configs/opsput_defconfig
+++ b/arch/m32r/configs/opsput_defconfig
@@ -5,6 +5,7 @@ CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/usrv_defconfig b/arch/m32r/configs/usrv_defconfig
index a3cfaae..132daf3 100644
--- a/arch/m32r/configs/usrv_defconfig
+++ b/arch/m32r/configs/usrv_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/m68k/Kconfig.debug b/arch/m68k/Kconfig.debug
index 87233ac..d8b5abb 100644
--- a/arch/m68k/Kconfig.debug
+++ b/arch/m68k/Kconfig.debug
@@ -11,7 +11,7 @@ config BOOTPARAM_STRING
 	depends on BOOTPARAM
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED
+	bool "Early printk" if EXPERT
 	depends on MVME16x || MAC
 	default y
 	help
diff --git a/arch/m68k/configs/m5208evb_defconfig b/arch/m68k/configs/m5208evb_defconfig
index c161682..0013a4b 100644
--- a/arch/m68k/configs/m5208evb_defconfig
+++ b/arch/m68k/configs/m5208evb_defconfig
@@ -3,6 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68k/configs/m5249evb_defconfig b/arch/m68k/configs/m5249evb_defconfig
index a6599e4..ee52889 100644
--- a/arch/m68k/configs/m5249evb_defconfig
+++ b/arch/m68k/configs/m5249evb_defconfig
@@ -3,6 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68k/configs/m5272c3_defconfig b/arch/m68k/configs/m5272c3_defconfig
index 3fa60a5..238efed 100644
--- a/arch/m68k/configs/m5272c3_defconfig
+++ b/arch/m68k/configs/m5272c3_defconfig
@@ -3,6 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68k/configs/m5275evb_defconfig b/arch/m68k/configs/m5275evb_defconfig
index 33c32ae..87c1acc 100644
--- a/arch/m68k/configs/m5275evb_defconfig
+++ b/arch/m68k/configs/m5275evb_defconfig
@@ -3,6 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68k/configs/m5307c3_defconfig b/arch/m68k/configs/m5307c3_defconfig
index 43795f4..7bb04e7 100644
--- a/arch/m68k/configs/m5307c3_defconfig
+++ b/arch/m68k/configs/m5307c3_defconfig
@@ -3,6 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68k/configs/m5407c3_defconfig b/arch/m68k/configs/m5407c3_defconfig
index 72746c5..c9f1d4c 100644
--- a/arch/m68k/configs/m5407c3_defconfig
+++ b/arch/m68k/configs/m5407c3_defconfig
@@ -3,6 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/configs/mmu_defconfig
index b3f5eec..7a560a3 100644
--- a/arch/microblaze/configs/mmu_defconfig
+++ b/arch/microblaze/configs/mmu_defconfig
@@ -8,6 +8,7 @@ CONFIG_INITRAMFS_SOURCE="rootfs.cpio"
 CONFIG_INITRAMFS_COMPRESSION_GZIP=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
diff --git a/arch/microblaze/configs/nommu_defconfig b/arch/microblaze/configs/nommu_defconfig
index 0249e4b..64414e8 100644
--- a/arch/microblaze/configs/nommu_defconfig
+++ b/arch/microblaze/configs/nommu_defconfig
@@ -7,6 +7,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
diff --git a/arch/mips/configs/ar7_defconfig b/arch/mips/configs/ar7_defconfig
index 6cd5a51..913c3f0 100644
--- a/arch/mips/configs/ar7_defconfig
+++ b/arch/mips/configs/ar7_defconfig
@@ -15,6 +15,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
index ad15fb1..36c906b 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -21,6 +21,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/bcm63xx_defconfig b/arch/mips/configs/bcm63xx_defconfig
index 9190051..7d36d40 100644
--- a/arch/mips/configs/bcm63xx_defconfig
+++ b/arch/mips/configs/bcm63xx_defconfig
@@ -11,6 +11,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_TINY_RCU=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index 1cdff6b..213082b 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -27,6 +27,7 @@ CONFIG_NET_NS=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/capcella_defconfig b/arch/mips/configs/capcella_defconfig
index 5135dc0..ca651b1 100644
--- a/arch/mips/configs/capcella_defconfig
+++ b/arch/mips/configs/capcella_defconfig
@@ -5,6 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/cavium-octeon_defconfig b/arch/mips/configs/cavium-octeon_defconfig
index 75165df..94e0e8d 100644
--- a/arch/mips/configs/cavium-octeon_defconfig
+++ b/arch/mips/configs/cavium-octeon_defconfig
@@ -16,6 +16,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/cobalt_defconfig b/arch/mips/configs/cobalt_defconfig
index 5419adb..22aa808 100644
--- a/arch/mips/configs/cobalt_defconfig
+++ b/arch/mips/configs/cobalt_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/mips/configs/db1000_defconfig b/arch/mips/configs/db1000_defconfig
index 4044c9e..13154ec 100644
--- a/arch/mips/configs/db1000_defconfig
+++ b/arch/mips/configs/db1000_defconfig
@@ -12,6 +12,7 @@ CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mips/configs/db1100_defconfig b/arch/mips/configs/db1100_defconfig
index c6b4993..f8c4354 100644
--- a/arch/mips/configs/db1100_defconfig
+++ b/arch/mips/configs/db1100_defconfig
@@ -12,6 +12,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/db1200_defconfig b/arch/mips/configs/db1200_defconfig
index 1f69249..6e5ea5ad 100644
--- a/arch/mips/configs/db1200_defconfig
+++ b/arch/mips/configs/db1200_defconfig
@@ -13,6 +13,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/db1500_defconfig b/arch/mips/configs/db1500_defconfig
index b6e21c7..8a46684 100644
--- a/arch/mips/configs/db1500_defconfig
+++ b/arch/mips/configs/db1500_defconfig
@@ -11,6 +11,7 @@ CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mips/configs/db1550_defconfig b/arch/mips/configs/db1550_defconfig
index 798a553..96e2446 100644
--- a/arch/mips/configs/db1550_defconfig
+++ b/arch/mips/configs/db1550_defconfig
@@ -12,6 +12,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index 87d0340..41921fe 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -5,6 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/e55_defconfig b/arch/mips/configs/e55_defconfig
index 0126e66..133bd10 100644
--- a/arch/mips/configs/e55_defconfig
+++ b/arch/mips/configs/e55_defconfig
@@ -5,6 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index e5b73de..79b6a2c 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -18,6 +18,7 @@ CONFIG_USER_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/gpr_defconfig b/arch/mips/configs/gpr_defconfig
index 48a40ae..1409ec4 100644
--- a/arch/mips/configs/gpr_defconfig
+++ b/arch/mips/configs/gpr_defconfig
@@ -12,6 +12,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
index d160656..6ef6ffbd 100644
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -18,6 +18,7 @@ CONFIG_USER_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 0e36abc..bd02c80 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -16,6 +16,7 @@ CONFIG_CPUSETS=y
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/ip28_defconfig b/arch/mips/configs/ip28_defconfig
index 4dbf626..679e034 100644
--- a/arch/mips/configs/ip28_defconfig
+++ b/arch/mips/configs/ip28_defconfig
@@ -9,6 +9,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 7bbd521..1ad898a 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -11,6 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
index 92a60ae..6d75f4e 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -11,6 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/jmr3927_defconfig b/arch/mips/configs/jmr3927_defconfig
index db5705e..58fada1 100644
--- a/arch/mips/configs/jmr3927_defconfig
+++ b/arch/mips/configs/jmr3927_defconfig
@@ -5,6 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/lasat_defconfig b/arch/mips/configs/lasat_defconfig
index d9f3db2..d053edd 100644
--- a/arch/mips/configs/lasat_defconfig
+++ b/arch/mips/configs/lasat_defconfig
@@ -9,6 +9,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index b6acd2f..922783a 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -22,6 +22,7 @@ CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 5527abb..2d922e6 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -16,6 +16,7 @@ CONFIG_IPC_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/markeins_defconfig b/arch/mips/configs/markeins_defconfig
index 9c9a123..5990c9a 100644
--- a/arch/mips/configs/markeins_defconfig
+++ b/arch/mips/configs/markeins_defconfig
@@ -10,6 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/mipssim_defconfig b/arch/mips/configs/mipssim_defconfig
index b5ad738..9da3603 100644
--- a/arch/mips/configs/mipssim_defconfig
+++ b/arch/mips/configs/mipssim_defconfig
@@ -8,6 +8,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/mpc30x_defconfig b/arch/mips/configs/mpc30x_defconfig
index c16de98..9d24a39 100644
--- a/arch/mips/configs/mpc30x_defconfig
+++ b/arch/mips/configs/mpc30x_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/msp71xx_defconfig b/arch/mips/configs/msp71xx_defconfig
index d1142e9..774ecfe 100644
--- a/arch/mips/configs/msp71xx_defconfig
+++ b/arch/mips/configs/msp71xx_defconfig
@@ -9,6 +9,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SHMEM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 807c97e..54c8afa 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -12,6 +12,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff --git a/arch/mips/configs/nlm_xlr_defconfig b/arch/mips/configs/nlm_xlr_defconfig
index e4b399f..0613915 100644
--- a/arch/mips/configs/nlm_xlr_defconfig
+++ b/arch/mips/configs/nlm_xlr_defconfig
@@ -28,6 +28,7 @@ CONFIG_RD_LZMA=y
 CONFIG_INITRAMFS_COMPRESSION_GZIP=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_ELF_CORE is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pb1100_defconfig b/arch/mips/configs/pb1100_defconfig
index 75eb1b1..4048739 100644
--- a/arch/mips/configs/pb1100_defconfig
+++ b/arch/mips/configs/pb1100_defconfig
@@ -12,6 +12,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pb1200_defconfig b/arch/mips/configs/pb1200_defconfig
index dcbe270..96e49b9 100644
--- a/arch/mips/configs/pb1200_defconfig
+++ b/arch/mips/configs/pb1200_defconfig
@@ -13,6 +13,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pb1500_defconfig b/arch/mips/configs/pb1500_defconfig
index fa00487..b132464 100644
--- a/arch/mips/configs/pb1500_defconfig
+++ b/arch/mips/configs/pb1500_defconfig
@@ -12,6 +12,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pb1550_defconfig b/arch/mips/configs/pb1550_defconfig
index e83d649..c521844 100644
--- a/arch/mips/configs/pb1550_defconfig
+++ b/arch/mips/configs/pb1550_defconfig
@@ -12,6 +12,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pnx8335-stb225_defconfig b/arch/mips/configs/pnx8335-stb225_defconfig
index f292576..7cb92c6 100644
--- a/arch/mips/configs/pnx8335-stb225_defconfig
+++ b/arch/mips/configs/pnx8335-stb225_defconfig
@@ -12,6 +12,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/pnx8550-jbs_defconfig b/arch/mips/configs/pnx8550-jbs_defconfig
index 1d1f206..33402d9 100644
--- a/arch/mips/configs/pnx8550-jbs_defconfig
+++ b/arch/mips/configs/pnx8550-jbs_defconfig
@@ -7,6 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/pnx8550-stb810_defconfig b/arch/mips/configs/pnx8550-stb810_defconfig
index 15c66a5..89bdbfc 100644
--- a/arch/mips/configs/pnx8550-stb810_defconfig
+++ b/arch/mips/configs/pnx8550-stb810_defconfig
@@ -7,6 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/powertv_defconfig b/arch/mips/configs/powertv_defconfig
index 3b0b6e8..1810e2f 100644
--- a/arch/mips/configs/powertv_defconfig
+++ b/arch/mips/configs/powertv_defconfig
@@ -15,6 +15,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
index 55902d9..f34c063 100644
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -14,6 +14,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mips/configs/rbtx49xx_defconfig b/arch/mips/configs/rbtx49xx_defconfig
index 9cba856..7875faf 100644
--- a/arch/mips/configs/rbtx49xx_defconfig
+++ b/arch/mips/configs/rbtx49xx_defconfig
@@ -13,6 +13,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 2c0230e..d22e55d 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -13,6 +13,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/sb1250-swarm_defconfig b/arch/mips/configs/sb1250-swarm_defconfig
index 5b0463e..1f3bc1b 100644
--- a/arch/mips/configs/sb1250-swarm_defconfig
+++ b/arch/mips/configs/sb1250-swarm_defconfig
@@ -16,6 +16,7 @@ CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/tb0219_defconfig b/arch/mips/configs/tb0219_defconfig
index 30036b4..b07b1f2 100644
--- a/arch/mips/configs/tb0219_defconfig
+++ b/arch/mips/configs/tb0219_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/tb0226_defconfig b/arch/mips/configs/tb0226_defconfig
index 81bfa1d..94a67f9 100644
--- a/arch/mips/configs/tb0226_defconfig
+++ b/arch/mips/configs/tb0226_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/tb0287_defconfig b/arch/mips/configs/tb0287_defconfig
index c415c4f..8bc7745 100644
--- a/arch/mips/configs/tb0287_defconfig
+++ b/arch/mips/configs/tb0287_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/workpad_defconfig b/arch/mips/configs/workpad_defconfig
index ee4b2be..0e96e97 100644
--- a/arch/mips/configs/workpad_defconfig
+++ b/arch/mips/configs/workpad_defconfig
@@ -5,6 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/wrppmc_defconfig b/arch/mips/configs/wrppmc_defconfig
index 44a451b..ede4674 100644
--- a/arch/mips/configs/wrppmc_defconfig
+++ b/arch/mips/configs/wrppmc_defconfig
@@ -8,6 +8,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_EPOLL is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/yosemite_defconfig b/arch/mips/configs/yosemite_defconfig
index f72d305..1a7342a 100644
--- a/arch/mips/configs/yosemite_defconfig
+++ b/arch/mips/configs/yosemite_defconfig
@@ -9,6 +9,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mn10300/configs/asb2303_defconfig b/arch/mn10300/configs/asb2303_defconfig
index 1fd41ec..d9797db 100644
--- a/arch/mn10300/configs/asb2303_defconfig
+++ b/arch/mn10300/configs/asb2303_defconfig
@@ -5,6 +5,7 @@ CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mn10300/configs/asb2364_defconfig b/arch/mn10300/configs/asb2364_defconfig
index fbb96ae..c0c61ad 100644
--- a/arch/mn10300/configs/asb2364_defconfig
+++ b/arch/mn10300/configs/asb2364_defconfig
@@ -15,6 +15,7 @@ CONFIG_RESOURCE_COUNTERS=y
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
diff --git a/arch/openrisc/configs/or1ksim_defconfig b/arch/openrisc/configs/or1ksim_defconfig
index ea172bd..a6a9fe8 100644
--- a/arch/openrisc/configs/or1ksim_defconfig
+++ b/arch/openrisc/configs/or1ksim_defconfig
@@ -3,6 +3,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/parisc/configs/a500_defconfig b/arch/parisc/configs/a500_defconfig
index b647b18..258419c 100644
--- a/arch/parisc/configs/a500_defconfig
+++ b/arch/parisc/configs/a500_defconfig
@@ -9,6 +9,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff --git a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
index 311ca36..d51d745 100644
--- a/arch/parisc/configs/c3000_defconfig
+++ b/arch/parisc/configs/c3000_defconfig
@@ -7,6 +7,7 @@ CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff --git a/arch/powerpc/configs/40x/acadia_defconfig b/arch/powerpc/configs/40x/acadia_defconfig
index ed3bab7..53d246a 100644
--- a/arch/powerpc/configs/40x/acadia_defconfig
+++ b/arch/powerpc/configs/40x/acadia_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/ep405_defconfig b/arch/powerpc/configs/40x/ep405_defconfig
index 17582a3..dcf789a 100644
--- a/arch/powerpc/configs/40x/ep405_defconfig
+++ b/arch/powerpc/configs/40x/ep405_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/kilauea_defconfig b/arch/powerpc/configs/40x/kilauea_defconfig
index f2d4be9..c3b388e 100644
--- a/arch/powerpc/configs/40x/kilauea_defconfig
+++ b/arch/powerpc/configs/40x/kilauea_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/klondike_defconfig b/arch/powerpc/configs/40x/klondike_defconfig
index c0d228d..25eda96 100644
--- a/arch/powerpc/configs/40x/klondike_defconfig
+++ b/arch/powerpc/configs/40x/klondike_defconfig
@@ -7,6 +7,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/40x/makalu_defconfig b/arch/powerpc/configs/40x/makalu_defconfig
index 42b9793..6b31344 100644
--- a/arch/powerpc/configs/40x/makalu_defconfig
+++ b/arch/powerpc/configs/40x/makalu_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/obs600_defconfig b/arch/powerpc/configs/40x/obs600_defconfig
index 91c110d..261c41c 100644
--- a/arch/powerpc/configs/40x/obs600_defconfig
+++ b/arch/powerpc/configs/40x/obs600_defconfig
@@ -5,6 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/40x/walnut_defconfig b/arch/powerpc/configs/40x/walnut_defconfig
index aa1a4ca..ab92342 100644
--- a/arch/powerpc/configs/40x/walnut_defconfig
+++ b/arch/powerpc/configs/40x/walnut_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/44x/arches_defconfig b/arch/powerpc/configs/44x/arches_defconfig
index 329f9a3..f146a29 100644
--- a/arch/powerpc/configs/44x/arches_defconfig
+++ b/arch/powerpc/configs/44x/arches_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/bamboo_defconfig b/arch/powerpc/configs/44x/bamboo_defconfig
index cef7d62..bd42f31 100644
--- a/arch/powerpc/configs/44x/bamboo_defconfig
+++ b/arch/powerpc/configs/44x/bamboo_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/bluestone_defconfig b/arch/powerpc/configs/44x/bluestone_defconfig
index 20c8d26..dcd2803 100644
--- a/arch/powerpc/configs/44x/bluestone_defconfig
+++ b/arch/powerpc/configs/44x/bluestone_defconfig
@@ -5,6 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_PCI_QUIRKS is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/powerpc/configs/44x/canyonlands_defconfig b/arch/powerpc/configs/44x/canyonlands_defconfig
index d5be93e..616b36e 100644
--- a/arch/powerpc/configs/44x/canyonlands_defconfig
+++ b/arch/powerpc/configs/44x/canyonlands_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/currituck_defconfig b/arch/powerpc/configs/44x/currituck_defconfig
index 4192322..61a89d2 100644
--- a/arch/powerpc/configs/44x/currituck_defconfig
+++ b/arch/powerpc/configs/44x/currituck_defconfig
@@ -6,6 +6,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_SPARSE_IRQ=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=y
diff --git a/arch/powerpc/configs/44x/ebony_defconfig b/arch/powerpc/configs/44x/ebony_defconfig
index f9269fc..1590325 100644
--- a/arch/powerpc/configs/44x/ebony_defconfig
+++ b/arch/powerpc/configs/44x/ebony_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/44x/eiger_defconfig b/arch/powerpc/configs/44x/eiger_defconfig
index 9be0890..9e0b2e8 100644
--- a/arch/powerpc/configs/44x/eiger_defconfig
+++ b/arch/powerpc/configs/44x/eiger_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/icon_defconfig b/arch/powerpc/configs/44x/icon_defconfig
index 82f7303..458f706 100644
--- a/arch/powerpc/configs/44x/icon_defconfig
+++ b/arch/powerpc/configs/44x/icon_defconfig
@@ -7,6 +7,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/iss476-smp_defconfig b/arch/powerpc/configs/44x/iss476-smp_defconfig
index ca00cf7..ab37c10 100644
--- a/arch/powerpc/configs/44x/iss476-smp_defconfig
+++ b/arch/powerpc/configs/44x/iss476-smp_defconfig
@@ -8,6 +8,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_PROFILING=y
diff --git a/arch/powerpc/configs/44x/katmai_defconfig b/arch/powerpc/configs/44x/katmai_defconfig
index 109562c..9ce4221 100644
--- a/arch/powerpc/configs/44x/katmai_defconfig
+++ b/arch/powerpc/configs/44x/katmai_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/rainier_defconfig b/arch/powerpc/configs/44x/rainier_defconfig
index 21c33fa..1754335 100644
--- a/arch/powerpc/configs/44x/rainier_defconfig
+++ b/arch/powerpc/configs/44x/rainier_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/redwood_defconfig b/arch/powerpc/configs/44x/redwood_defconfig
index 4880281..8bffc3d 100644
--- a/arch/powerpc/configs/44x/redwood_defconfig
+++ b/arch/powerpc/configs/44x/redwood_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/sam440ep_defconfig b/arch/powerpc/configs/44x/sam440ep_defconfig
index ca088cd..32dead8 100644
--- a/arch/powerpc/configs/44x/sam440ep_defconfig
+++ b/arch/powerpc/configs/44x/sam440ep_defconfig
@@ -7,6 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/sequoia_defconfig b/arch/powerpc/configs/44x/sequoia_defconfig
index b7a653b..c030f9b 100644
--- a/arch/powerpc/configs/44x/sequoia_defconfig
+++ b/arch/powerpc/configs/44x/sequoia_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/taishan_defconfig b/arch/powerpc/configs/44x/taishan_defconfig
index 30de97f..3fbe667 100644
--- a/arch/powerpc/configs/44x/taishan_defconfig
+++ b/arch/powerpc/configs/44x/taishan_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/warp_defconfig b/arch/powerpc/configs/44x/warp_defconfig
index 105bc56..2c07050 100644
--- a/arch/powerpc/configs/44x/warp_defconfig
+++ b/arch/powerpc/configs/44x/warp_defconfig
@@ -9,6 +9,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/52xx/cm5200_defconfig b/arch/powerpc/configs/52xx/cm5200_defconfig
index 69b57da..05bd5f4 100644
--- a/arch/powerpc/configs/52xx/cm5200_defconfig
+++ b/arch/powerpc/configs/52xx/cm5200_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/52xx/lite5200b_defconfig b/arch/powerpc/configs/52xx/lite5200b_defconfig
index f3638ae..670c182 100644
--- a/arch/powerpc/configs/52xx/lite5200b_defconfig
+++ b/arch/powerpc/configs/52xx/lite5200b_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/52xx/motionpro_defconfig b/arch/powerpc/configs/52xx/motionpro_defconfig
index 0c7de96..265befa 100644
--- a/arch/powerpc/configs/52xx/motionpro_defconfig
+++ b/arch/powerpc/configs/52xx/motionpro_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/52xx/pcm030_defconfig b/arch/powerpc/configs/52xx/pcm030_defconfig
index 22e7195..d75f8b5 100644
--- a/arch/powerpc/configs/52xx/pcm030_defconfig
+++ b/arch/powerpc/configs/52xx/pcm030_defconfig
@@ -9,6 +9,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
diff --git a/arch/powerpc/configs/52xx/tqm5200_defconfig b/arch/powerpc/configs/52xx/tqm5200_defconfig
index 716a37b..0c39153 100644
--- a/arch/powerpc/configs/52xx/tqm5200_defconfig
+++ b/arch/powerpc/configs/52xx/tqm5200_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/83xx/asp8347_defconfig b/arch/powerpc/configs/83xx/asp8347_defconfig
index d2762d9..657147f 100644
--- a/arch/powerpc/configs/83xx/asp8347_defconfig
+++ b/arch/powerpc/configs/83xx/asp8347_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/kmeter1_defconfig b/arch/powerpc/configs/83xx/kmeter1_defconfig
index 07e1bba..ca4be7d 100644
--- a/arch/powerpc/configs/83xx/kmeter1_defconfig
+++ b/arch/powerpc/configs/83xx/kmeter1_defconfig
@@ -5,6 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_SPARSE_IRQ=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
index 126ef1b..f845710 100644
--- a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
index abcf00a..58c003d 100644
--- a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig b/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
index a5699a1..f11f31c 100644
--- a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig b/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
index b4da1a7..15697a1 100644
--- a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig b/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
index 291f822..5f58476 100644
--- a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig b/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
index f8b228a..6272057 100644
--- a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_mds_defconfig b/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
index 99660c0..39fab3d 100644
--- a/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig b/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
index 10b5c4c..43384bb 100644
--- a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig b/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
index 45925d7..7f92bad 100644
--- a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
+++ b/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc837x_mds_defconfig b/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
index f367985..bdee39f 100644
--- a/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig b/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
index 414eda3..e2c2beb 100644
--- a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/sbc834x_defconfig b/arch/powerpc/configs/83xx/sbc834x_defconfig
index 6d6463f..5c2cc33 100644
--- a/arch/powerpc/configs/83xx/sbc834x_defconfig
+++ b/arch/powerpc/configs/83xx/sbc834x_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/85xx/ksi8560_defconfig b/arch/powerpc/configs/85xx/ksi8560_defconfig
index 8f7c106..a153334 100644
--- a/arch/powerpc/configs/85xx/ksi8560_defconfig
+++ b/arch/powerpc/configs/85xx/ksi8560_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_KSI8560=y
 CONFIG_CPM2=y
diff --git a/arch/powerpc/configs/85xx/mpc8540_ads_defconfig b/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
index 11662c2..8d79180 100644
--- a/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
+++ b/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC8540_ADS=y
 CONFIG_NO_HZ=y
diff --git a/arch/powerpc/configs/85xx/mpc8560_ads_defconfig b/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
index ebe9b30..8866235 100644
--- a/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
+++ b/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC8560_ADS=y
 CONFIG_BINFMT_MISC=y
diff --git a/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig b/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
index eb25229..92080d3 100644
--- a/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
+++ b/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC85xx_CDS=y
 CONFIG_NO_HZ=y
diff --git a/arch/powerpc/configs/85xx/p1023rds_defconfig b/arch/powerpc/configs/85xx/p1023rds_defconfig
index c091aaf..7e2fcd0 100644
--- a/arch/powerpc/configs/85xx/p1023rds_defconfig
+++ b/arch/powerpc/configs/85xx/p1023rds_defconfig
@@ -15,6 +15,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
diff --git a/arch/powerpc/configs/85xx/sbc8548_defconfig b/arch/powerpc/configs/85xx/sbc8548_defconfig
index 5b2b651..56ffd59 100644
--- a/arch/powerpc/configs/85xx/sbc8548_defconfig
+++ b/arch/powerpc/configs/85xx/sbc8548_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_SBC8548=y
diff --git a/arch/powerpc/configs/85xx/sbc8560_defconfig b/arch/powerpc/configs/85xx/sbc8560_defconfig
index f7fdb03..7fb5778 100644
--- a/arch/powerpc/configs/85xx/sbc8560_defconfig
+++ b/arch/powerpc/configs/85xx/sbc8560_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_SBC8560=y
diff --git a/arch/powerpc/configs/85xx/socrates_defconfig b/arch/powerpc/configs/85xx/socrates_defconfig
index 77506b5..245a096 100644
--- a/arch/powerpc/configs/85xx/socrates_defconfig
+++ b/arch/powerpc/configs/85xx/socrates_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/stx_gp3_defconfig b/arch/powerpc/configs/85xx/stx_gp3_defconfig
index 5d4db15..de8459e 100644
--- a/arch/powerpc/configs/85xx/stx_gp3_defconfig
+++ b/arch/powerpc/configs/85xx/stx_gp3_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/85xx/tqm8540_defconfig b/arch/powerpc/configs/85xx/tqm8540_defconfig
index ddcb9f3..7ddfe92 100644
--- a/arch/powerpc/configs/85xx/tqm8540_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8540_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/tqm8541_defconfig b/arch/powerpc/configs/85xx/tqm8541_defconfig
index 981abd6..fc2cfd1 100644
--- a/arch/powerpc/configs/85xx/tqm8541_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8541_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/tqm8548_defconfig b/arch/powerpc/configs/85xx/tqm8548_defconfig
index 37b3d72..5cebe92 100644
--- a/arch/powerpc/configs/85xx/tqm8548_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8548_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/85xx/tqm8555_defconfig b/arch/powerpc/configs/85xx/tqm8555_defconfig
index 3593b32..372ab90 100644
--- a/arch/powerpc/configs/85xx/tqm8555_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8555_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/tqm8560_defconfig b/arch/powerpc/configs/85xx/tqm8560_defconfig
index de413ac..e7d6c22 100644
--- a/arch/powerpc/configs/85xx/tqm8560_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8560_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
index 1cd6fcb..9798270 100644
--- a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
+++ b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
@@ -12,6 +12,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
index d41857a..d0022d5 100644
--- a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
+++ b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
@@ -12,6 +12,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc310_defconfig b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
index 38303ec..5c0825c 100644
--- a/arch/powerpc/configs/86xx/gef_sbc310_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
@@ -12,6 +12,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc610_defconfig b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
index 9853397..dabcd2c 100644
--- a/arch/powerpc/configs/86xx/gef_sbc610_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
@@ -12,6 +12,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
index 0db9ba0..8c1e751 100644
--- a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
@@ -7,6 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_ELF_CORE is not set
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig b/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
index f51c7eb..3c27bbd 100644
--- a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
@@ -11,6 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/86xx/sbc8641d_defconfig b/arch/powerpc/configs/86xx/sbc8641d_defconfig
index 0a92ca0..6c0c08e 100644
--- a/arch/powerpc/configs/86xx/sbc8641d_defconfig
+++ b/arch/powerpc/configs/86xx/sbc8641d_defconfig
@@ -12,6 +12,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/adder875_defconfig b/arch/powerpc/configs/adder875_defconfig
index 6912874..5d0be7a 100644
--- a/arch/powerpc/configs/adder875_defconfig
+++ b/arch/powerpc/configs/adder875_defconfig
@@ -5,6 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/chroma_defconfig b/arch/powerpc/configs/chroma_defconfig
index acf7fb2..bf0eac0 100644
--- a/arch/powerpc/configs/chroma_defconfig
+++ b/arch/powerpc/configs/chroma_defconfig
@@ -32,6 +32,7 @@ CONFIG_RD_LZMA=y
 CONFIG_INITRAMFS_COMPRESSION_GZIP=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_PERF_COUNTERS=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=y
diff --git a/arch/powerpc/configs/corenet32_smp_defconfig b/arch/powerpc/configs/corenet32_smp_defconfig
index f8aef20..f7994f0 100644
--- a/arch/powerpc/configs/corenet32_smp_defconfig
+++ b/arch/powerpc/configs/corenet32_smp_defconfig
@@ -14,6 +14,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_PERF_EVENTS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/corenet64_smp_defconfig b/arch/powerpc/configs/corenet64_smp_defconfig
index 7ed8d4c..ec1d491 100644
--- a/arch/powerpc/configs/corenet64_smp_defconfig
+++ b/arch/powerpc/configs/corenet64_smp_defconfig
@@ -12,6 +12,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/ep8248e_defconfig b/arch/powerpc/configs/ep8248e_defconfig
index fceffb3..b193cd7 100644
--- a/arch/powerpc/configs/ep8248e_defconfig
+++ b/arch/powerpc/configs/ep8248e_defconfig
@@ -3,6 +3,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 # CONFIG_IOSCHED_CFQ is not set
diff --git a/arch/powerpc/configs/ep88xc_defconfig b/arch/powerpc/configs/ep88xc_defconfig
index 219fd47..171ef77 100644
--- a/arch/powerpc/configs/ep88xc_defconfig
+++ b/arch/powerpc/configs/ep88xc_defconfig
@@ -5,6 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/gamecube_defconfig b/arch/powerpc/configs/gamecube_defconfig
index e74d3a4..22e4c34 100644
--- a/arch/powerpc/configs/gamecube_defconfig
+++ b/arch/powerpc/configs/gamecube_defconfig
@@ -7,6 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_ELF_CORE is not set
 CONFIG_PERF_COUNTERS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/powerpc/configs/holly_defconfig b/arch/powerpc/configs/holly_defconfig
index 94ebfee..1ab9a7e 100644
--- a/arch/powerpc/configs/holly_defconfig
+++ b/arch/powerpc/configs/holly_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_MODULES=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_PPC_CHRP is not set
diff --git a/arch/powerpc/configs/mgcoge_defconfig b/arch/powerpc/configs/mgcoge_defconfig
index 0d36b0e..7dc4519 100644
--- a/arch/powerpc/configs/mgcoge_defconfig
+++ b/arch/powerpc/configs/mgcoge_defconfig
@@ -11,6 +11,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 # CONFIG_IOSCHED_CFQ is not set
 # CONFIG_PPC_PMAC is not set
diff --git a/arch/powerpc/configs/mpc7448_hpc2_defconfig b/arch/powerpc/configs/mpc7448_hpc2_defconfig
index 75f0bbf..25e5f3f 100644
--- a/arch/powerpc/configs/mpc7448_hpc2_defconfig
+++ b/arch/powerpc/configs/mpc7448_hpc2_defconfig
@@ -5,6 +5,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff --git a/arch/powerpc/configs/mpc8272_ads_defconfig b/arch/powerpc/configs/mpc8272_ads_defconfig
index 6a22400..faa3a96 100644
--- a/arch/powerpc/configs/mpc8272_ads_defconfig
+++ b/arch/powerpc/configs/mpc8272_ads_defconfig
@@ -3,6 +3,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff --git a/arch/powerpc/configs/mpc83xx_defconfig b/arch/powerpc/configs/mpc83xx_defconfig
index 5aac9a8..5b4dc10 100644
--- a/arch/powerpc/configs/mpc83xx_defconfig
+++ b/arch/powerpc/configs/mpc83xx_defconfig
@@ -4,6 +4,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
index f37a2ab..7187f33 100644
--- a/arch/powerpc/configs/mpc85xx_defconfig
+++ b/arch/powerpc/configs/mpc85xx_defconfig
@@ -10,6 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/mpc85xx_smp_defconfig b/arch/powerpc/configs/mpc85xx_smp_defconfig
index abdcd31..fca1887 100644
--- a/arch/powerpc/configs/mpc85xx_smp_defconfig
+++ b/arch/powerpc/configs/mpc85xx_smp_defconfig
@@ -12,6 +12,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/mpc866_ads_defconfig b/arch/powerpc/configs/mpc866_ads_defconfig
index 5c25882..e8a6836 100644
--- a/arch/powerpc/configs/mpc866_ads_defconfig
+++ b/arch/powerpc/configs/mpc866_ads_defconfig
@@ -5,6 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BUG is not set
diff --git a/arch/powerpc/configs/mpc86xx_defconfig b/arch/powerpc/configs/mpc86xx_defconfig
index a1cc817..4adcb0c 100644
--- a/arch/powerpc/configs/mpc86xx_defconfig
+++ b/arch/powerpc/configs/mpc86xx_defconfig
@@ -11,6 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
index 9e146cd..938bae9 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -5,6 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/ppc40x_defconfig b/arch/powerpc/configs/ppc40x_defconfig
index 1eb19ac..ddebe39 100644
--- a/arch/powerpc/configs/ppc40x_defconfig
+++ b/arch/powerpc/configs/ppc40x_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/ppc44x_defconfig b/arch/powerpc/configs/ppc44x_defconfig
index 3b98d73..844f59a 100644
--- a/arch/powerpc/configs/ppc44x_defconfig
+++ b/arch/powerpc/configs/ppc44x_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/pq2fads_defconfig b/arch/powerpc/configs/pq2fads_defconfig
index baad8db..63db6ec 100644
--- a/arch/powerpc/configs/pq2fads_defconfig
+++ b/arch/powerpc/configs/pq2fads_defconfig
@@ -4,6 +4,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index ded8678..bb90cec 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -10,6 +10,7 @@ CONFIG_SPARSE_IRQ=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PERF_EVENTS is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/powerpc/configs/storcenter_defconfig b/arch/powerpc/configs/storcenter_defconfig
index ebb2a66..55d838c 100644
--- a/arch/powerpc/configs/storcenter_defconfig
+++ b/arch/powerpc/configs/storcenter_defconfig
@@ -2,6 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/tqm8xx_defconfig b/arch/powerpc/configs/tqm8xx_defconfig
index 8616fde..c2d7612 100644
--- a/arch/powerpc/configs/tqm8xx_defconfig
+++ b/arch/powerpc/configs/tqm8xx_defconfig
@@ -6,6 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/wii_defconfig b/arch/powerpc/configs/wii_defconfig
index 175295f..7f7cf36 100644
--- a/arch/powerpc/configs/wii_defconfig
+++ b/arch/powerpc/configs/wii_defconfig
@@ -8,6 +8,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_ELF_CORE is not set
 CONFIG_PERF_COUNTERS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
index 74fea5c..ad8eeb6 100644
--- a/arch/powerpc/platforms/powernv/Kconfig
+++ b/arch/powerpc/platforms/powernv/Kconfig
@@ -5,7 +5,7 @@ config PPC_POWERNV
 	select PPC_XICS
 	select PPC_ICP_NATIVE
 	select PPC_P7_NAP
-	select PPC_PCI_CHOICE if EMBEDDED
+	select PPC_PCI_CHOICE if EXPERT
 	default y
 
 config PPC_POWERNV_RTAS
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index ae7b6d4..26fe320 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -31,7 +31,7 @@ config PPC_SPLPAR
 config EEH
 	bool "PCI Extended Error Handling (EEH)" if EXPERT
 	depends on PPC_PSERIES && PCI
-	default y if !EXPERT
+	default y if !EMBEDDED
 
 config PSERIES_MSI
        bool
diff --git a/arch/score/configs/spct6600_defconfig b/arch/score/configs/spct6600_defconfig
index df1edbf..ef40deb 100644
--- a/arch/score/configs/spct6600_defconfig
+++ b/arch/score/configs/spct6600_defconfig
@@ -10,6 +10,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 3c8db65..366351c 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -1,6 +1,6 @@
 config SUPERH
 	def_bool y
-	select EXPERT
+	select EMBEDDED
 	select CLKDEV_LOOKUP
 	select HAVE_IDE if HAS_IOPORT
 	select HAVE_MEMBLOCK
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index f932b30..559d167 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -55,6 +55,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 550e8ed..76a91f2 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -54,6 +54,7 @@ CONFIG_INITRAMFS_SOURCE=""
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
 CONFIG_EXPERT=y
+CONFIG_EMBEDDED=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 6bdedd7..bac4412 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -811,7 +811,7 @@ config PATA_PCMCIA
 
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
-	depends on EXPERT || PPC || HAVE_PATA_PLATFORM
+	depends on EMBEDDED || PPC || HAVE_PATA_PLATFORM
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 4364303..ca65b75 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -52,8 +52,7 @@ config SGI_MBCS
 source "drivers/tty/serial/Kconfig"
 
 config TTY_PRINTK
-	bool "TTY driver to output user messages via printk"
-	depends on EXPERT
+	bool "TTY driver to output user messages via printk" if EXPERT
 	default n
 	---help---
 	  If you say Y here, the support for writing user messages (i.e.
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index e24a2a1..f102ea0 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -59,8 +59,7 @@ config CPU_FREQ_DEFAULT_GOV_PERFORMANCE
 	  the CPU.
 
 config CPU_FREQ_DEFAULT_GOV_POWERSAVE
-	bool "powersave"
-	depends on EXPERT
+	bool "powersave" if EXPERT
 	select CPU_FREQ_GOV_POWERSAVE
 	help
 	  Use the CPUFreq governor 'powersave' as default. This sets
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 2418429..7fb34a8 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -22,7 +22,7 @@ config DRM_KMS_HELPER
 	tristate
 	depends on DRM
 	select FB
-	select FRAMEBUFFER_CONSOLE if !EXPERT
+	select FRAMEBUFFER_CONSOLE if !EMBEDDED
 	select FRAMEBUFFER_CONSOLE_DETECT_PRIMARY if FRAMEBUFFER_CONSOLE
 	help
 	  FB and CRTC helpers for KMS drivers.
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index aada26f..c943fce 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1441,11 +1441,11 @@ int drm_fb_helper_hotplug_event(struct drm_fb_helper *fb_helper)
 }
 EXPORT_SYMBOL(drm_fb_helper_hotplug_event);
 
-/* The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EXPERT)
+/* The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EMBEDDED)
  * but the module doesn't depend on any fb console symbols.  At least
  * attempt to load fbcon to avoid leaving the system without a usable console.
  */
-#if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EXPERT)
+#if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EMBEDDED)
 static int __init drm_fb_helper_modinit(void)
 {
 	const char *name = "fbcon";
diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index ca16399..f78725d 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -8,7 +8,7 @@ config DRM_NOUVEAU
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select FB
-	select FRAMEBUFFER_CONSOLE if !EXPERT
+	select FRAMEBUFFER_CONSOLE if !EMBEDDED
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
 	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
 	select ACPI_WMI if ACPI
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index a421abd..73c2d39 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -63,7 +63,7 @@ menu "Special HID drivers"
 config HID_A4TECH
 	tristate "A4 tech mice" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for A4 tech X5 and WOP-35 / Trust 450L mice.
 
@@ -84,7 +84,7 @@ config HID_ACRUX_FF
 config HID_APPLE
 	tristate "Apple {i,Power,Mac}Books" if EXPERT
 	depends on (USB_HID || BT_HIDP)
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for some Apple devices which less or more break
 	HID specification.
@@ -95,21 +95,21 @@ config HID_APPLE
 config HID_BELKIN
 	tristate "Belkin Flip KVM and Wireless keyboard" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
 config HID_CHERRY
 	tristate "Cherry Cymotion keyboard" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for Cherry Cymotion keyboard.
 
 config HID_CHICONY
 	tristate "Chicony Tactical pad" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for Chicony Tactical pad.
 
@@ -131,7 +131,7 @@ config HID_PRODIKEYS
 config HID_CYPRESS
 	tristate "Cypress mouse and barcode readers" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for cypress mouse and barcode readers.
 
@@ -173,7 +173,7 @@ config HID_ELECOM
 config HID_EZKEY
 	tristate "Ezkey BTC 8193 keyboard" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for Ezkey BTC 8193 keyboard.
 
@@ -202,7 +202,7 @@ config HID_KEYTOUCH
 config HID_KYE
 	tristate "Kye/Genius Ergo Mouse" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for Kye/Genius Ergo Mouse.
 
@@ -233,7 +233,7 @@ config HID_TWINHAN
 config HID_KENSINGTON
 	tristate "Kensington Slimblade Trackball" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for Kensington Slimblade Trackball.
 
@@ -246,7 +246,7 @@ config HID_LCPOWER
 config HID_LOGITECH
 	tristate "Logitech devices" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
 
@@ -320,14 +320,14 @@ config HID_MAGICMOUSE
 config HID_MICROSOFT
 	tristate "Microsoft non-fully HID-compliant devices" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for Microsoft devices that are not fully compliant with HID standard.
 
 config HID_MONTEREY
 	tristate "Monterey Genius KB29E keyboard" if EXPERT
 	depends on USB_HID
-	default !EXPERT
+	default !EMBEDDED
 	---help---
 	Support for Monterey Genius KB29E.
 
@@ -431,7 +431,7 @@ config HID_PICOLCD
 
 config HID_PICOLCD_FB
 	bool "Framebuffer support" if EXPERT
-	default !EXPERT
+	default !EMBEDDED
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=FB || FB=y
 	select FB_DEFERRED_IO
@@ -445,7 +445,7 @@ config HID_PICOLCD_FB
 
 config HID_PICOLCD_BACKLIGHT
 	bool "Backlight control" if EXPERT
-	default !EXPERT
+	default !EMBEDDED
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=y
 	---help---
@@ -454,7 +454,7 @@ config HID_PICOLCD_BACKLIGHT
 
 config HID_PICOLCD_LCD
 	bool "Contrast control" if EXPERT
-	default !EXPERT
+	default !EMBEDDED
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=LCD_CLASS_DEVICE || LCD_CLASS_DEVICE=y
 	---help---
@@ -462,7 +462,7 @@ config HID_PICOLCD_LCD
 
 config HID_PICOLCD_LEDS
 	bool "GPO via leds class" if EXPERT
-	default !EXPERT
+	default !EMBEDDED
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=LEDS_CLASS || LEDS_CLASS=y
 	---help---
diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 996302a..dc1683f 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -35,7 +35,7 @@ config MEDIA_TUNER
 config MEDIA_TUNER_CUSTOMISE
 	bool "Customize analog and hybrid tuner modules to build"
 	depends on MEDIA_TUNER
-	default y if EXPERT
+	default y if EMBEDDED
 	help
 	  This allows the user to deselect tuner drivers unnecessary
 	  for their hardware from the build. Use this option with care
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index 4a2d2e6..e736719 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -1,7 +1,7 @@
 config DVB_FE_CUSTOMISE
 	bool "Customise the frontend modules to build"
 	depends on DVB_CORE
-	default y if EXPERT
+	default y if EMBEDDED
 	help
 	  This allows the user to select/deselect frontend drivers for their
 	  hardware from the build.
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index b303a3f..b4c8576 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -100,7 +100,7 @@ config VIDEO_FIXED_MINOR_RANGES
 
 config VIDEO_HELPER_CHIPS_AUTO
 	bool "Autoselect pertinent encoders/decoders and other helper chips"
-	default y if !EXPERT
+	default y if !EMBEDDED
 	---help---
 	  Most video cards may require additional modules to encode or
 	  decode audio/video standards. This option will autoselect
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 6e318ce..5e52381 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -69,7 +69,7 @@ comment "PC-card bridges"
 config YENTA
 	tristate "CardBus yenta-compatible bridge support"
 	depends on PCI
-	select CARDBUS if !EXPERT
+	select CARDBUS if !EMBEDDED
 	select PCCARD_NONSTATIC if PCMCIA != n
 	---help---
 	  This option enables support for CardBus host bridges.  Virtually
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index 18d02e3..bcc2477 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -123,9 +123,9 @@ config USB_OTG
 
 config USB_OTG_WHITELIST
 	bool "Rely on OTG Targeted Peripherals List"
-	depends on USB_OTG || EXPERT
+	depends on USB_OTG || EMBEDDED
 	default y if USB_OTG
-	default n if EXPERT
+	default n if EMBEDDED
 	help
 	  If you say Y here, the "otg_whitelist.h" file will be used as a
 	  product whitelist, so USB peripherals not listed there will be
@@ -141,7 +141,7 @@ config USB_OTG_WHITELIST
 
 config USB_OTG_BLACKLIST_HUB
 	bool "Disable external hubs"
-	depends on USB_OTG || EXPERT
+	depends on USB_OTG || EMBEDDED
 	help
 	  If you say Y here, then Linux will refuse to enumerate
 	  external hubs.  OTG hosts are allowed to reduce hardware
diff --git a/init/Kconfig b/init/Kconfig
index a075765..69b76b0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -786,7 +786,7 @@ endif # CGROUPS
 
 menuconfig NAMESPACES
 	bool "Namespaces support" if EXPERT
-	default !EXPERT
+	default !EMBEDDED
 	help
 	  Provides the way to make tasks work with different objects using
 	  the same id. For example same IPC id may refer to different objects
@@ -1259,8 +1259,7 @@ config SLUB
 	   a slab allocator.
 
 config SLOB
-	depends on EXPERT
-	bool "SLOB (Simple Allocator)"
+	bool "SLOB (Simple Allocator)" if EXPERT
 	help
 	   SLOB replaces the stock allocator with a drastically simpler
 	   allocator. SLOB is generally more space efficient but
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 82928f5..ec1023d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -771,7 +771,7 @@ config DEBUG_WRITECOUNT
 
 config DEBUG_MEMORY_INIT
 	bool "Debug memory initialisation" if EXPERT
-	default !EXPERT
+	default !EMBEDDED
 	help
 	  Enable this for additional checks during memory initialisation.
 	  The sanity checks verify aspects of the VM such as the memory model
diff --git a/net/rfkill/Kconfig b/net/rfkill/Kconfig
index 78efe89..6ac80dd 100644
--- a/net/rfkill/Kconfig
+++ b/net/rfkill/Kconfig
@@ -21,7 +21,7 @@ config RFKILL_INPUT
 	bool "RF switch input support" if EXPERT
 	depends on RFKILL
 	depends on INPUT = y || RFKILL = INPUT
-	default y if !EXPERT
+	default y if !EMBEDDED
 
 config RFKILL_REGULATOR
 	tristate "Generic rfkill regulator driver"
diff --git a/usr/Kconfig b/usr/Kconfig
index 65b845b..115654f 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -56,7 +56,7 @@ config RD_GZIP
 
 config RD_BZIP2
 	bool "Support initial ramdisks compressed using bzip2" if EXPERT
-	default !EXPERT
+	default !EMBEDDED
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_BZIP2
 	help
@@ -65,7 +65,7 @@ config RD_BZIP2
 
 config RD_LZMA
 	bool "Support initial ramdisks compressed using LZMA" if EXPERT
-	default !EXPERT
+	default !EMBEDDED
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZMA
 	help
@@ -74,7 +74,7 @@ config RD_LZMA
 
 config RD_XZ
 	bool "Support initial ramdisks compressed using XZ" if EXPERT
-	default !EXPERT
+	default !EMBEDDED
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_XZ
 	help
@@ -83,7 +83,7 @@ config RD_XZ
 
 config RD_LZO
 	bool "Support initial ramdisks compressed using LZO" if EXPERT
-	default !EXPERT
+	default !EMBEDDED
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZO
 	help
-- 
1.7.7.5

