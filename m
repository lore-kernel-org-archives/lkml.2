Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab2J1KU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 06:20:26 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35860 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2J1KUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 06:20:15 -0400
Date: Sun, 28 Oct 2012 11:20:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Corey Minyard <cminyard@mvista.com>, minyard@acm.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH v2] Remove uninitialized_var()
Message-ID: <20121028102007.GA7547@gmail.com>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
 <1350420820-7156-5-git-send-email-minyard@acm.org>
 <20121022164902.9b204646.akpm@linux-foundation.org>
 <508AE611.3020504@mvista.com>
 <CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com>
 <20121027131203.GA27313@gmail.com>
 <20121027114836.e9a6a922.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121027114836.e9a6a922.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 27 Oct 2012 15:12:03 +0200 Ingo Molnar <mingo@kernel.org> wrote:
> 
> > There's 3 types of conversions done:
> > 
> >    uninitialized_var(x)        =>  x = 0       /* for scalar types */
> >    uninitialized_var(x)        =>  x = NULL    /* for pointers */
> >    uninitialized_var(x)        =>  x = { }     /* for structures, unions */
> 
> It's regrettable that we lose information.  
> uninitialized_var() says "this isn't needed - it's just there 
> for gcc".  The reader can of course work out the reason with 
> careful code inspection, but that's a lot more time consuming.
> 
> We could go add "/* keep gcc quiet */" to every site, or add 
> self-documenting macros for the above.

Ok, agreed - I've added /* GCC */ to every site to make people 
think about it.

I left it a bit mystic because in some cases this macro was 
mis-used not to suppress GCC being wrong, but to hide GCC being 
*right*: for example unused variable warnings in cases like:

   int uninitialized_var(var);

   #ifdef XYZ
   var = ...;
   ...
   #endif

which (ab-)use was no doubt actively dangerous beyond being 
ugly. One such example is in arch/x86/mm/numa.c. (These cases 
now turn into clear (and always harmless) compiler warnings, as 
they should.)

This further strengthens the argument that we should remove this 
whole thing.

Thanks,

	Ingo

---
Signed-off-by: Ingo Molnar <mingo@kernel.org>

 arch/arm/mach-sa1100/assabet.c              |  2 +-
 arch/ia64/kernel/process.c                  |  2 +-
 arch/ia64/mm/discontig.c                    |  2 +-
 arch/ia64/mm/tlb.c                          |  2 +-
 arch/ia64/sn/kernel/tiocx.c                 |  2 +-
 arch/ia64/sn/pci/pcibr/pcibr_provider.c     |  2 +-
 arch/powerpc/kvm/book3s_pr.c                |  2 +-
 arch/powerpc/kvm/powerpc.c                  |  2 +-
 arch/powerpc/mm/numa.c                      |  2 +-
 arch/powerpc/platforms/pseries/iommu.c      |  4 ++--
 arch/s390/kernel/smp.c                      |  2 +-
 arch/s390/mm/pgtable.c                      |  4 ++--
 arch/tile/include/asm/futex.h               |  2 +-
 arch/x86/kernel/apic/es7000_32.c            |  2 +-
 arch/x86/kernel/quirks.c                    | 10 +++++-----
 arch/x86/kvm/mmu.c                          |  2 +-
 arch/x86/kvm/paging_tmpl.h                  |  2 +-
 arch/x86/mm/numa.c                          |  2 +-
 arch/x86/xen/p2m.c                          |  8 ++++----
 arch/xtensa/variants/s6000/delay.c          |  4 ++--
 drivers/acpi/acpi_pad.c                     |  2 +-
 drivers/acpi/acpica/tbutils.c               |  2 +-
 drivers/ata/libata-scsi.c                   |  2 +-
 drivers/atm/zatm.c                          |  2 +-
 drivers/block/nvme.c                        |  2 +-
 drivers/char/mmtimer.c                      |  2 +-
 drivers/firewire/ohci.c                     | 14 +++++++-------
 drivers/gpu/drm/drm_edid.c                  |  2 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c      |  2 +-
 drivers/hid/uhid.c                          |  2 +-
 drivers/i2c/busses/i2c-mxs.c                |  2 +-
 drivers/ide/ide-acpi.c                      |  2 +-
 drivers/ide/ide-atapi.c                     |  2 +-
 drivers/ide/ide-io-std.c                    |  4 ++--
 drivers/ide/ide-io.c                        |  8 ++++----
 drivers/ide/ide-sysfs.c                     |  2 +-
 drivers/ide/ide-taskfile.c                  |  2 +-
 drivers/ide/umc8672.c                       |  2 +-
 drivers/infiniband/core/uverbs_cmd.c        |  6 +++---
 drivers/infiniband/core/verbs.c             |  4 ++--
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |  2 +-
 drivers/infiniband/hw/mlx4/qp.c             |  8 ++++----
 drivers/infiniband/hw/mthca/mthca_qp.c      | 10 +++++-----
 drivers/input/serio/serio_raw.c             |  2 +-
 drivers/iommu/intel-iommu.c                 |  2 +-
 drivers/iommu/omap-iommu-debug.c            |  2 +-
 drivers/iommu/tegra-smmu.c                  |  4 ++--
 drivers/isdn/hardware/eicon/debug.c         |  2 +-
 drivers/lguest/lguest_user.c                |  2 +-
 drivers/md/dm-ioctl.c                       |  2 +-
 drivers/md/dm-snap-persistent.c             |  2 +-
 drivers/md/dm-table.c                       |  8 ++++----
 drivers/md/raid5.c                          |  2 +-
 drivers/media/dvb-frontends/af9013.c        |  2 +-
 drivers/media/dvb-frontends/af9033.c        |  2 +-
 drivers/media/dvb-frontends/cxd2820r_core.c |  2 +-
 drivers/media/platform/omap3isp/ispqueue.c  |  2 +-
 drivers/media/tuners/tda18212.c             |  2 +-
 drivers/media/tuners/tda18218.c             |  2 +-
 drivers/media/usb/dvb-usb-v2/af9015.c       |  2 +-
 drivers/media/usb/dvb-usb/dib0700_core.c    |  2 +-
 drivers/media/usb/gspca/vicam.c             |  2 +-
 drivers/media/usb/uvc/uvc_video.c           |  8 ++++----
 drivers/memstick/host/jmb38x_ms.c           |  2 +-
 drivers/memstick/host/tifm_ms.c             |  2 +-
 drivers/mmc/host/sdhci.c                    |  4 ++--
 drivers/mtd/nand/nand_ecc.c                 |  2 +-
 drivers/mtd/nand/s3c2410.c                  |  2 +-
 drivers/mtd/ubi/attach.c                    |  2 +-
 drivers/mtd/ubi/eba.c                       |  2 +-
 drivers/mtd/ubi/wl.c                        |  2 +-
 drivers/net/dsa/mv88e6060.c                 |  2 +-
 drivers/net/dsa/mv88e6xxx.c                 |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c        |  4 ++--
 drivers/net/ethernet/neterion/s2io.c        |  2 +-
 drivers/net/ethernet/qlogic/qla3xxx.c       |  2 +-
 drivers/net/ethernet/realtek/r8169.c        |  2 +-
 drivers/net/ethernet/sis/sis900.c           |  2 +-
 drivers/net/ethernet/sun/cassini.c          |  2 +-
 drivers/net/ethernet/sun/niu.c              |  6 +++---
 drivers/net/wan/z85230.c                    |  2 +-
 drivers/net/wireless/ath/ath6kl/init.c      |  2 +-
 drivers/net/wireless/ath/ath9k/init.c       |  2 +-
 drivers/net/wireless/b43/debugfs.c          |  2 +-
 drivers/net/wireless/b43/dma.c              |  2 +-
 drivers/net/wireless/b43/lo.c               |  2 +-
 drivers/net/wireless/b43/main.c             |  2 +-
 drivers/net/wireless/b43/phy_n.c            |  2 +-
 drivers/net/wireless/b43/xmit.c             | 12 ++++++------
 drivers/net/wireless/b43legacy/debugfs.c    |  2 +-
 drivers/net/wireless/b43legacy/main.c       |  2 +-
 drivers/net/wireless/iwlegacy/3945.c        |  2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c    |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |  6 +++---
 drivers/net/xen-netback/netback.c           |  2 +-
 drivers/pci/pcie/aer/aerdrv_core.c          |  2 +-
 drivers/platform/x86/hdaps.c                |  4 ++--
 drivers/s390/cio/cio.c                      |  2 +-
 drivers/scsi/dc395x.c                       |  2 +-
 drivers/scsi/pm8001/pm8001_hwi.c            |  2 +-
 drivers/spi/spi-davinci.c                   |  2 +-
 drivers/ssb/driver_chipcommon.c             |  4 ++--
 drivers/staging/zsmalloc/zsmalloc-main.c    |  2 +-
 drivers/tty/cyclades.c                      |  2 +-
 drivers/tty/isicom.c                        |  2 +-
 drivers/usb/gadget/uvc_queue.c              |  2 +-
 drivers/usb/musb/cppi_dma.c                 |  2 +-
 drivers/usb/storage/sddr55.c                |  4 ++--
 drivers/vhost/net.c                         |  4 ++--
 drivers/vhost/vhost.c                       |  2 +-
 drivers/video/matrox/matroxfb_maven.c       |  6 +++---
 drivers/video/pm3fb.c                       |  6 +++---
 drivers/video/riva/riva_hw.c                |  4 ++--
 drivers/virtio/virtio_ring.c                |  2 +-
 fs/afs/dir.c                                |  2 +-
 fs/afs/security.c                           |  2 +-
 fs/binfmt_flat.c                            |  2 +-
 fs/dlm/netlink.c                            |  2 +-
 fs/fat/dir.c                                |  2 +-
 fs/fuse/control.c                           |  4 ++--
 fs/gfs2/recovery.c                          |  2 +-
 fs/hfsplus/unicode.c                        |  2 +-
 fs/isofs/namei.c                            |  4 ++--
 fs/jffs2/erase.c                            |  2 +-
 fs/nfsd/nfsctl.c                            |  2 +-
 fs/ocfs2/alloc.c                            |  4 ++--
 fs/ocfs2/dir.c                              | 14 +++++++-------
 fs/ocfs2/extent_map.c                       |  4 ++--
 fs/ocfs2/namei.c                            |  2 +-
 fs/ocfs2/refcounttree.c                     |  2 +-
 fs/ocfs2/stack_user.c                       |  2 +-
 fs/ocfs2/xattr.c                            |  2 +-
 fs/omfs/file.c                              |  2 +-
 fs/ubifs/budget.c                           |  2 +-
 fs/ubifs/commit.c                           |  6 +++---
 fs/ubifs/dir.c                              |  2 +-
 fs/ubifs/file.c                             |  4 ++--
 fs/ubifs/journal.c                          |  4 ++--
 fs/ubifs/lpt.c                              |  2 +-
 fs/ubifs/tnc.c                              |  6 +++---
 fs/ubifs/tnc_misc.c                         |  4 ++--
 fs/udf/balloc.c                             |  2 +-
 fs/xfs/xfs_bmap.c                           |  2 +-
 fs/xfs/xfs_file.c                           |  4 ++--
 include/linux/compiler-gcc.h                |  6 ------
 include/linux/compiler-intel.h              |  2 --
 include/linux/mm.h                          |  2 +-
 ipc/msg.c                                   |  2 +-
 kernel/async.c                              |  4 ++--
 kernel/audit.c                              |  2 +-
 kernel/debug/kdb/kdb_io.c                   |  2 +-
 kernel/events/uprobes.c                     |  2 +-
 kernel/exit.c                               |  2 +-
 kernel/futex.c                              | 10 +++++-----
 kernel/futex_compat.c                       |  2 +-
 kernel/lockdep.c                            | 14 +++++++-------
 lib/dma-debug.c                             |  2 +-
 lib/radix-tree.c                            |  4 ++--
 mm/frontswap.c                              |  2 +-
 mm/ksm.c                                    |  2 +-
 mm/memcontrol.c                             |  8 ++++----
 mm/memory.c                                 |  2 +-
 mm/mempolicy.c                              |  6 +++---
 mm/oom_kill.c                               |  2 +-
 mm/page-writeback.c                         |  4 ++--
 mm/page_alloc.c                             |  2 +-
 mm/percpu.c                                 |  2 +-
 mm/slub.c                                   |  2 +-
 mm/swap.c                                   |  4 ++--
 net/dccp/options.c                          |  2 +-
 net/ipv6/ip6_flowlabel.c                    |  2 +-
 net/netfilter/nf_conntrack_ftp.c            |  2 +-
 net/netfilter/nfnetlink_queue_core.c        |  4 ++--
 net/netfilter/xt_socket.c                   | 10 +++++-----
 net/sched/cls_flow.c                        |  2 +-
 net/sched/sch_cbq.c                         |  2 +-
 net/sched/sch_fq_codel.c                    |  2 +-
 net/sched/sch_hfsc.c                        |  2 +-
 net/sched/sch_htb.c                         |  2 +-
 net/sched/sch_sfq.c                         |  2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c    |  2 +-
 sound/core/control_compat.c                 |  2 +-
 sound/isa/sb/sb16_csp.c                     |  2 +-
 sound/usb/endpoint.c                        |  2 +-
 tools/virtio/linux/virtio.h                 |  2 --
 185 files changed, 281 insertions(+), 291 deletions(-)

diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
index 6a7ad3c..5ec34d6 100644
--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -388,7 +388,7 @@ static void __init map_sa1100_gpio_regs( void )
  */
 static void __init get_assabet_scr(void)
 {
-	unsigned long uninitialized_var(scr), i;
+	unsigned long scr = 0 /* GCC */, i;
 
 	GPDR |= 0x3fc;			/* Configure GPIO 9:2 as outputs */
 	GPSR = 0x3fc;			/* Write 0xFF to GPIO 9:2 */
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 35e106f..2c2da64 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -493,7 +493,7 @@ static void
 do_copy_task_regs (struct task_struct *task, struct unw_frame_info *info, void *arg)
 {
 	unsigned long mask, sp, nat_bits = 0, ar_rnat, urbs_end, cfm;
-	unsigned long uninitialized_var(ip);	/* GCC be quiet */
+	unsigned long ip = 0 /* GCC */;	/* GCC be quiet */
 	elf_greg_t *dst = arg;
 	struct pt_regs *pt;
 	char nat;
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index c641333..75cc8da 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -185,7 +185,7 @@ static void *per_cpu_node_setup(void *cpu_data, int node)
 void __init setup_per_cpu_areas(void)
 {
 	struct pcpu_alloc_info *ai;
-	struct pcpu_group_info *uninitialized_var(gi);
+	struct pcpu_group_info *gi = NULL /* GCC */;
 	unsigned int *cpu_map;
 	void *base;
 	unsigned long base_offset;
diff --git a/arch/ia64/mm/tlb.c b/arch/ia64/mm/tlb.c
index 7b3cdc6..e193d6c 100644
--- a/arch/ia64/mm/tlb.c
+++ b/arch/ia64/mm/tlb.c
@@ -340,7 +340,7 @@ EXPORT_SYMBOL(flush_tlb_range);
 void __devinit
 ia64_tlb_init (void)
 {
-	ia64_ptce_info_t uninitialized_var(ptce_info); /* GCC be quiet */
+	ia64_ptce_info_t ptce_info = 0 /* GCC */; /* GCC be quiet */
 	u64 tr_pgbits;
 	long status;
 	pal_vm_info_1_u_t vm_info_1;
diff --git a/arch/ia64/sn/kernel/tiocx.c b/arch/ia64/sn/kernel/tiocx.c
index 14c1711..4c9f7dc 100644
--- a/arch/ia64/sn/kernel/tiocx.c
+++ b/arch/ia64/sn/kernel/tiocx.c
@@ -371,7 +371,7 @@ static void tio_corelet_reset(nasid_t nasid, int corelet)
 
 static int is_fpga_tio(int nasid, int *bt)
 {
-	u16 uninitialized_var(ioboard_type);	/* GCC be quiet */
+	u16 ioboard_type = 0 /* GCC */;	/* GCC be quiet */
 	long rc;
 
 	rc = ia64_sn_sysctl_ioboard_get(nasid, &ioboard_type);
diff --git a/arch/ia64/sn/pci/pcibr/pcibr_provider.c b/arch/ia64/sn/pci/pcibr/pcibr_provider.c
index 8dbbef4..ffae5e5 100644
--- a/arch/ia64/sn/pci/pcibr/pcibr_provider.c
+++ b/arch/ia64/sn/pci/pcibr/pcibr_provider.c
@@ -82,7 +82,7 @@ static int sal_pcibr_error_interrupt(struct pcibus_info *soft)
 u16 sn_ioboard_to_pci_bus(struct pci_bus *pci_bus)
 {
 	long rc;
-	u16 uninitialized_var(ioboard);		/* GCC be quiet */
+	u16 ioboard = 0 /* GCC */;		/* GCC be quiet */
 	nasid_t nasid = NASID_GET(SN_PCIBUS_BUSSOFT(pci_bus)->bs_base);
 
 	rc = ia64_sn_sysctl_ioboard_get(nasid, &ioboard);
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 05c28f5..279762f 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1012,7 +1012,7 @@ int kvmppc_vcpu_run(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 #ifdef CONFIG_ALTIVEC
 	vector128 vr[32];
 	vector128 vscr;
-	unsigned long uninitialized_var(vrsave);
+	unsigned long vrsave = 0 /* GCC */;
 	int used_vr;
 #endif
 #ifdef CONFIG_VSX
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 4d213b8..6eebf3a 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -447,7 +447,7 @@ static void kvmppc_complete_dcr_load(struct kvm_vcpu *vcpu,
 static void kvmppc_complete_mmio_load(struct kvm_vcpu *vcpu,
                                       struct kvm_run *run)
 {
-	u64 uninitialized_var(gpr);
+	u64 gpr = 0 /* GCC */;
 
 	if (run->mmio.len > sizeof(gpr)) {
 		printk(KERN_ERR "bad MMIO length: %d\n", run->mmio.len);
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 59213cf..9bfd5df 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -637,7 +637,7 @@ static inline int __init read_usm_ranges(const u32 **usm)
  */
 static void __init parse_drconf_memory(struct device_node *memory)
 {
-	const u32 *uninitialized_var(dm), *usm;
+	const u32 *dm = NULL /* GCC */, *usm;
 	unsigned int n, rc, ranges, is_kexec_kdump = 0;
 	unsigned long lmb_size, base, size, sz;
 	int nid;
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 6153eea..4c692a2 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -930,8 +930,8 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	int page_shift;
 	u64 dma_addr, max_addr;
 	struct device_node *dn;
-	const u32 *uninitialized_var(ddw_avail);
-	const u32 *uninitialized_var(ddw_extensions);
+	const u32 *ddw_avail = NULL /* GCC */;
+	const u32 *ddw_extensions = NULL /* GCC */;
 	u32 ddw_restore_token = 0;
 	struct direct_window *window;
 	struct property *win64;
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index ea431e5..bc21704 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -126,7 +126,7 @@ static int pcpu_sigp_retry(struct pcpu *pcpu, u8 order, u32 parm)
 
 static inline int pcpu_stopped(struct pcpu *pcpu)
 {
-	u32 uninitialized_var(status);
+	u32 status = 0 /* GCC */;
 
 	if (__pcpu_sigp(pcpu->address, SIGP_SENSE,
 			0, &status) != SIGP_CC_STATUS_STORED)
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index c8188a1..a8e5a38 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -609,8 +609,8 @@ static inline unsigned int atomic_xor_bits(atomic_t *v, unsigned int bits)
  */
 unsigned long *page_table_alloc(struct mm_struct *mm, unsigned long vmaddr)
 {
-	unsigned long *uninitialized_var(table);
-	struct page *uninitialized_var(page);
+	unsigned long *table = NULL /* GCC */;
+	struct page *page = NULL /* GCC */;
 	unsigned int mask, bit;
 
 	if (mm_has_pgste(mm))
diff --git a/arch/tile/include/asm/futex.h b/arch/tile/include/asm/futex.h
index 5909ac3..c0278b1 100644
--- a/arch/tile/include/asm/futex.h
+++ b/arch/tile/include/asm/futex.h
@@ -111,7 +111,7 @@ static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 	int cmp = (encoded_op >> 24) & 15;
 	int oparg = (encoded_op << 8) >> 20;
 	int cmparg = (encoded_op << 20) >> 20;
-	int uninitialized_var(val), ret;
+	int val = 0 /* GCC */, ret;
 
 	__futex_prolog();
 
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 0874799..42e60e1 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -529,7 +529,7 @@ static inline int
 es7000_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 {
 	unsigned int round = 0;
-	unsigned int cpu, uninitialized_var(apicid);
+	unsigned int cpu, apicid = 0 /* GCC */;
 
 	/*
 	 * The cpus in the mask must all be on the apic cluster.
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 1b27de5..2029ac1 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -94,7 +94,7 @@ static void ich_force_hpet_resume(void)
 static void ich_force_enable_hpet(struct pci_dev *dev)
 {
 	u32 val;
-	u32 uninitialized_var(rcba);
+	u32 rcba = 0 /* GCC */;
 	int err = 0;
 
 	if (hpet_address || force_hpet_address)
@@ -184,7 +184,7 @@ static void hpet_print_force_info(void)
 static void old_ich_force_hpet_resume(void)
 {
 	u32 val;
-	u32 uninitialized_var(gen_cntl);
+	u32 gen_cntl = 0 /* GCC */;
 
 	if (!force_hpet_address || !cached_dev)
 		return;
@@ -206,7 +206,7 @@ static void old_ich_force_hpet_resume(void)
 static void old_ich_force_enable_hpet(struct pci_dev *dev)
 {
 	u32 val;
-	u32 uninitialized_var(gen_cntl);
+	u32 gen_cntl = 0 /* GCC */;
 
 	if (hpet_address || force_hpet_address)
 		return;
@@ -297,7 +297,7 @@ static void vt8237_force_hpet_resume(void)
 
 static void vt8237_force_enable_hpet(struct pci_dev *dev)
 {
-	u32 uninitialized_var(val);
+	u32 val = 0 /* GCC */;
 
 	if (hpet_address || force_hpet_address)
 		return;
@@ -424,7 +424,7 @@ static void nvidia_force_hpet_resume(void)
 
 static void nvidia_force_enable_hpet(struct pci_dev *dev)
 {
-	u32 uninitialized_var(val);
+	u32 val = 0 /* GCC */;
 
 	if (hpet_address || force_hpet_address)
 		return;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6f85fe0..5874ed7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1347,7 +1347,7 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			 struct kvm_memory_slot *slot, unsigned long data)
 {
 	u64 *sptep;
-	struct rmap_iterator uninitialized_var(iter);
+	struct rmap_iterator iter = { } /* GCC */;
 	int young = 0;
 
 	/*
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 714e2c0..c107841 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -149,7 +149,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 {
 	int ret;
 	pt_element_t pte;
-	pt_element_t __user *uninitialized_var(ptep_user);
+	pt_element_t __user *ptep_user = NULL /* GCC */;
 	gfn_t table_gfn;
 	unsigned index, pt_access, pte_access, accessed_dirty, shift;
 	gpa_t pte_gpa;
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 2d125be..bde70c5 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -490,7 +490,7 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
-	unsigned long uninitialized_var(pfn_align);
+	unsigned long pfn_align = 0 /* GCC */;
 	int i, nid;
 
 	/* Account for nodes with cpus and no memory */
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 95fb2aa..1598e3f 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -875,7 +875,7 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 {
 	unsigned long flags;
 	unsigned long pfn;
-	unsigned long uninitialized_var(address);
+	unsigned long address = 0 /* GCC */;
 	unsigned level;
 	pte_t *ptep = NULL;
 	int ret = 0;
@@ -938,7 +938,7 @@ int m2p_remove_override(struct page *page,
 	unsigned long flags;
 	unsigned long mfn;
 	unsigned long pfn;
-	unsigned long uninitialized_var(address);
+	unsigned long address = 0 /* GCC */;
 	unsigned level;
 	pte_t *ptep = NULL;
 	int ret = 0;
@@ -1079,8 +1079,8 @@ static int p2m_dump_show(struct seq_file *m, void *v)
 				[TYPE_PFN] = "pfn",
 				[TYPE_UNKNOWN] = "abnormal"};
 	unsigned long pfn, prev_pfn_type = 0, prev_pfn_level = 0;
-	unsigned int uninitialized_var(prev_level);
-	unsigned int uninitialized_var(prev_type);
+	unsigned int prev_level = 0 /* GCC */;
+	unsigned int prev_type = 0 /* GCC */;
 
 	if (!p2m_top)
 		return 0;
diff --git a/arch/xtensa/variants/s6000/delay.c b/arch/xtensa/variants/s6000/delay.c
index 54b2b57..b6b0d0a 100644
--- a/arch/xtensa/variants/s6000/delay.c
+++ b/arch/xtensa/variants/s6000/delay.c
@@ -6,8 +6,8 @@
 #define LOOPS 10
 void platform_calibrate_ccount(void)
 {
-	u32 uninitialized_var(a);
-	u32 uninitialized_var(u);
+	u32 a = 0 /* GCC */;
+	u32 u = 0 /* GCC */;
 	u32 b;
 	u32 tstamp = S6_REG_GREG1 + S6_GREG1_GLOBAL_TIMER;
 	int i = LOOPS+1;
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index af4aad6..6d9374c 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -103,7 +103,7 @@ static void round_robin_cpu(unsigned int tsk_index)
 	cpumask_var_t tmp;
 	int cpu;
 	unsigned long min_weight = -1;
-	unsigned long uninitialized_var(preferred_cpu);
+	unsigned long preferred_cpu = 0 /* GCC */;
 
 	if (!alloc_cpumask_var(&tmp, GFP_KERNEL))
 		return;
diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index b6cea30..30b8c6b 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -628,7 +628,7 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 	u32 table_count;
 	struct acpi_table_header *table;
 	acpi_physical_address address;
-	acpi_physical_address uninitialized_var(rsdt_address);
+	acpi_physical_address rsdt_address = 0 /* GCC */;
 	u32 length;
 	u8 *table_entry;
 	acpi_status status;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e3bda07..eef14eb 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -163,7 +163,7 @@ static ssize_t ata_scsi_park_show(struct device *device,
 	struct ata_link *link;
 	struct ata_device *dev;
 	unsigned long flags, now;
-	unsigned int uninitialized_var(msecs);
+	unsigned int msecs = 0 /* GCC */;
 	int rc = 0;
 
 	ap = ata_shost_to_port(sdev->host);
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index abe4e20..1d796b6 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -937,7 +937,7 @@ static int open_tx_first(struct atm_vcc *vcc)
 	    vcc->qos.txtp.max_pcr >= ATM_OC3_PCR);
 	if (unlimited && zatm_dev->ubr != -1) zatm_vcc->shaper = zatm_dev->ubr;
 	else {
-		int uninitialized_var(pcr);
+		int pcr = 0 /* GCC */;
 
 		if (unlimited) vcc->qos.txtp.max_sdu = ATM_MAX_AAL5_PDU;
 		if ((zatm_vcc->shaper = alloc_shaper(vcc->dev,&pcr,
diff --git a/drivers/block/nvme.c b/drivers/block/nvme.c
index 931769e..66da46e 100644
--- a/drivers/block/nvme.c
+++ b/drivers/block/nvme.c
@@ -1197,7 +1197,7 @@ static int nvme_user_admin_cmd(struct nvme_dev *dev,
 	struct nvme_admin_cmd cmd;
 	struct nvme_command c;
 	int status, length;
-	struct nvme_iod *uninitialized_var(iod);
+	struct nvme_iod *iod = NULL /* GCC */;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index 3d6c067..e1dde18 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -616,7 +616,7 @@ static int sgi_timer_del(struct k_itimer *timr)
 	if (timr->it.mmtimer.clock != TIMER_OFF) {
 		unsigned long expires = timr->it.mmtimer.expires;
 		struct rb_node *n = timers[nodeid].timer_head.rb_node;
-		struct mmtimer *uninitialized_var(t);
+		struct mmtimer *t = NULL /* GCC */;
 		int r = 0;
 
 		timr->it.mmtimer.clock = TIMER_OFF;
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 834e71d..ea72a20 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1103,7 +1103,7 @@ static void context_tasklet(unsigned long data)
 static int context_add_buffer(struct context *ctx)
 {
 	struct descriptor_buffer *desc;
-	dma_addr_t uninitialized_var(bus_addr);
+	dma_addr_t bus_addr = 0 /* GCC */;
 	int offset;
 
 	/*
@@ -1265,7 +1265,7 @@ static int at_context_queue_packet(struct context *ctx,
 				   struct fw_packet *packet)
 {
 	struct fw_ohci *ohci = ctx->ohci;
-	dma_addr_t d_bus, uninitialized_var(payload_bus);
+	dma_addr_t d_bus, payload_bus = 0 /* GCC */;
 	struct driver_data *driver_data;
 	struct descriptor *d, *last;
 	__le32 *header;
@@ -2438,7 +2438,7 @@ static int ohci_set_config_rom(struct fw_card *card,
 {
 	struct fw_ohci *ohci;
 	__be32 *next_config_rom;
-	dma_addr_t uninitialized_var(next_config_rom_bus);
+	dma_addr_t next_config_rom_bus = 0 /* GCC */;
 
 	ohci = fw_ohci(card);
 
@@ -2922,10 +2922,10 @@ static struct fw_iso_context *ohci_allocate_iso_context(struct fw_card *card,
 				int type, int channel, size_t header_size)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
-	struct iso_context *uninitialized_var(ctx);
-	descriptor_callback_t uninitialized_var(callback);
-	u64 *uninitialized_var(channels);
-	u32 *uninitialized_var(mask), uninitialized_var(regs);
+	struct iso_context *ctx = NULL /* GCC */;
+	descriptor_callback_t callback = 0 /* GCC */;
+	u64 *channels = NULL /* GCC */;
+	u32 *mask = NULL /* GCC */, regs = 0 /* GCC */;
 	int index, ret = -EBUSY;
 
 	spin_lock_irq(&ohci->lock);
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index fadcd44..6bb0aff 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1369,7 +1369,7 @@ static int drm_cvt_modes(struct drm_connector *connector,
 	const u8 empty[3] = { 0, 0, 0 };
 
 	for (i = 0; i < 4; i++) {
-		int uninitialized_var(width), height;
+		int width = 0 /* GCC */, height;
 		cvt = &(timing->data.other_data.data.cvt[i]);
 
 		if (!memcmp(cvt->code, empty, 3))
diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index 8e91083..9dcc386 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -103,7 +103,7 @@ static void i915_warn_stolen(struct drm_device *dev)
 static void i915_setup_compression(struct drm_device *dev, int size)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct drm_mm_node *compressed_fb, *uninitialized_var(compressed_llb);
+	struct drm_mm_node *compressed_fb, *compressed_llb = NULL /* GCC */;
 	unsigned long cfb_base;
 	unsigned long ll_base = 0;
 
diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 714cd8c..a454f65 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -154,7 +154,7 @@ static int uhid_hid_get_raw(struct hid_device *hid, unsigned char rnum,
 	struct uhid_event *ev;
 	unsigned long flags;
 	int ret;
-	size_t uninitialized_var(len);
+	size_t len = 0 /* GCC */;
 	struct uhid_feature_answer_req *req;
 
 	if (!uhid->running)
diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 1f58197..c21ad0e 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -251,7 +251,7 @@ static int mxs_i2c_wait_for_data(struct mxs_i2c_dev *i2c)
 
 static int mxs_i2c_finish_read(struct mxs_i2c_dev *i2c, u8 *buf, int len)
 {
-	u32 uninitialized_var(data);
+	u32 data = 0 /* GCC */;
 	int i;
 
 	for (i = 0; i < len; i++) {
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index f1a6796b..9320722 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -170,7 +170,7 @@ err:
 static acpi_handle ide_acpi_hwif_get_handle(ide_hwif_t *hwif)
 {
 	struct device		*dev = hwif->gendev.parent;
-	acpi_handle		uninitialized_var(dev_handle);
+	acpi_handle		dev_handle = 0 /* GCC */;
 	u64			pcidevfn;
 	acpi_handle		chan_handle;
 	int			err;
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index fac3d9d..ba48543 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -581,7 +581,7 @@ static int ide_delayed_transfer_pc(ide_drive_t *drive)
 
 static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 {
-	struct ide_atapi_pc *uninitialized_var(pc);
+	struct ide_atapi_pc *pc = NULL /* GCC */;
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
 	ide_expiry_t *expiry;
diff --git a/drivers/ide/ide-io-std.c b/drivers/ide/ide-io-std.c
index 1976397..457eea4 100644
--- a/drivers/ide/ide-io-std.c
+++ b/drivers/ide/ide-io-std.c
@@ -172,7 +172,7 @@ void ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
 	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
+		unsigned long flags = 0 /* GCC */;
 
 		if ((io_32bit & 2) && !mmio) {
 			local_irq_save(flags);
@@ -216,7 +216,7 @@ void ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
 	if (io_32bit) {
-		unsigned long uninitialized_var(flags);
+		unsigned long flags = 0 /* GCC */;
 
 		if ((io_32bit & 2) && !mmio) {
 			local_irq_save(flags);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 177db6d..a664aae 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -613,12 +613,12 @@ static int drive_is_ready(ide_drive_t *drive)
 void ide_timer_expiry (unsigned long data)
 {
 	ide_hwif_t	*hwif = (ide_hwif_t *)data;
-	ide_drive_t	*uninitialized_var(drive);
+	ide_drive_t	*drive = NULL /* GCC */;
 	ide_handler_t	*handler;
 	unsigned long	flags;
 	int		wait = -1;
 	int		plug_device = 0;
-	struct request	*uninitialized_var(rq_in_flight);
+	struct request	*rq_in_flight = NULL /* GCC */;
 
 	spin_lock_irqsave(&hwif->lock, flags);
 
@@ -771,13 +771,13 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 {
 	ide_hwif_t *hwif = (ide_hwif_t *)dev_id;
 	struct ide_host *host = hwif->host;
-	ide_drive_t *uninitialized_var(drive);
+	ide_drive_t *drive = NULL /* GCC */;
 	ide_handler_t *handler;
 	unsigned long flags;
 	ide_startstop_t startstop;
 	irqreturn_t irq_ret = IRQ_NONE;
 	int plug_device = 0;
-	struct request *uninitialized_var(rq_in_flight);
+	struct request *rq_in_flight = NULL /* GCC */;
 
 	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
 		if (hwif != host->cur_port)
diff --git a/drivers/ide/ide-sysfs.c b/drivers/ide/ide-sysfs.c
index 883ffac..8997570 100644
--- a/drivers/ide/ide-sysfs.c
+++ b/drivers/ide/ide-sysfs.c
@@ -113,7 +113,7 @@ static struct device_attribute *ide_port_attrs[] = {
 
 int ide_sysfs_register_port(ide_hwif_t *hwif)
 {
-	int i, uninitialized_var(rc);
+	int i, rc = 0 /* GCC */;
 
 	for (i = 0; ide_port_attrs[i]; i++) {
 		rc = device_create_file(hwif->portdev, ide_port_attrs[i]);
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 729428e..0b16ad3 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -226,7 +226,7 @@ void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
 	struct scatterlist *cursg = cmd->cursg;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags = 0 /* GCC */;
 	struct page *page;
 	unsigned int offset;
 	u8 *buf;
diff --git a/drivers/ide/umc8672.c b/drivers/ide/umc8672.c
index 3aa0fea..6a1c6ac 100644
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -107,7 +107,7 @@ static void umc_set_speeds(u8 speeds[])
 static void umc_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	ide_hwif_t *mate = hwif->mate;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags = 0 /* GCC */;
 	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 0cb0007..3990e0a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1386,7 +1386,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	struct ib_device	       *device;
 	struct ib_pd                   *pd = NULL;
 	struct ib_xrcd		       *xrcd = NULL;
-	struct ib_uobject	       *uninitialized_var(xrcd_uobj);
+	struct ib_uobject	       *xrcd_uobj = NULL /* GCC */;
 	struct ib_cq                   *scq = NULL, *rcq = NULL;
 	struct ib_srq                  *srq = NULL;
 	struct ib_qp                   *qp;
@@ -1573,7 +1573,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	struct ib_udata                 udata;
 	struct ib_uqp_object           *obj;
 	struct ib_xrcd		       *xrcd;
-	struct ib_uobject	       *uninitialized_var(xrcd_uobj);
+	struct ib_uobject	       *xrcd_uobj = NULL /* GCC */;
 	struct ib_qp                   *qp;
 	struct ib_qp_open_attr          attr;
 	int ret;
@@ -2475,7 +2475,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	struct ib_usrq_object           *obj;
 	struct ib_pd                    *pd;
 	struct ib_srq                   *srq;
-	struct ib_uobject               *uninitialized_var(xrcd_uobj);
+	struct ib_uobject               *xrcd_uobj = NULL /* GCC */;
 	struct ib_srq_init_attr          attr;
 	int ret;
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 30f199e..f813200 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -314,8 +314,8 @@ int ib_destroy_srq(struct ib_srq *srq)
 {
 	struct ib_pd *pd;
 	enum ib_srq_type srq_type;
-	struct ib_xrcd *uninitialized_var(xrcd);
-	struct ib_cq *uninitialized_var(cq);
+	struct ib_xrcd *xrcd = NULL /* GCC */;
+	struct ib_cq *cq = NULL /* GCC */;
 	int ret;
 
 	if (atomic_read(&srq->usecnt))
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 6de8463..9808c43 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -351,7 +351,7 @@ int iwch_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		      struct ib_send_wr **bad_wr)
 {
 	int err = 0;
-	u8 uninitialized_var(t3_wr_flit_cnt);
+	u8 t3_wr_flit_cnt = 0 /* GCC */;
 	enum t3_wr_opcode t3_wr_opcode = 0;
 	enum t3_wr_flags t3_wr_flags;
 	struct iwch_qp *qhp;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 19e0637..e1ed8c0 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2187,12 +2187,12 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	int nreq;
 	int err = 0;
 	unsigned ind;
-	int uninitialized_var(stamp);
-	int uninitialized_var(size);
-	unsigned uninitialized_var(seglen);
+	int stamp = 0 /* GCC */;
+	int size = 0 /* GCC */;
+	unsigned seglen = 0 /* GCC */;
 	__be32 dummy;
 	__be32 *lso_wqe;
-	__be32 uninitialized_var(lso_hdr_sz);
+	__be32 lso_hdr_sz = 0 /* GCC */;
 	__be32 blh;
 	int i;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 26a6845..514325e 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1617,8 +1617,8 @@ int mthca_tavor_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	 * without initializing f0 and size0, and they are in fact
 	 * never used uninitialized.
 	 */
-	int uninitialized_var(size0);
-	u32 uninitialized_var(f0);
+	int size0 = 0 /* GCC */;
+	u32 f0 = 0 /* GCC */;
 	int ind;
 	u8 op0 = 0;
 
@@ -1818,7 +1818,7 @@ int mthca_tavor_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	 * without initializing size0, and it is in fact never used
 	 * uninitialized.
 	 */
-	int uninitialized_var(size0);
+	int size0 = 0 /* GCC */;
 	int ind;
 	void *wqe;
 	void *prev_wqe;
@@ -1932,8 +1932,8 @@ int mthca_arbel_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	 * without initializing f0 and size0, and they are in fact
 	 * never used uninitialized.
 	 */
-	int uninitialized_var(size0);
-	u32 uninitialized_var(f0);
+	int size0 = 0 /* GCC */;
+	u32 f0 = 0 /* GCC */;
 	int ind;
 	u8 op0 = 0;
 
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 59df2e7..0be0db8 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -163,7 +163,7 @@ static ssize_t serio_raw_read(struct file *file, char __user *buffer,
 {
 	struct serio_raw_client *client = file->private_data;
 	struct serio_raw *serio_raw = client->serio_raw;
-	char uninitialized_var(c);
+	char c = 0 /* GCC */;
 	ssize_t read = 0;
 	int error;
 
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d4a4cd4..c2ce17f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1789,7 +1789,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			    unsigned long nr_pages, int prot)
 {
 	struct dma_pte *first_pte = NULL, *pte = NULL;
-	phys_addr_t uninitialized_var(pteval);
+	phys_addr_t pteval = 0 /* GCC */;
 	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
 	unsigned long sg_res;
 	unsigned int largepage_lvl = 0;
diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index f55fc5d..9785b59 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -220,7 +220,7 @@ static ssize_t debug_read_mmap(struct file *file, char __user *userbuf,
 	struct omap_iommu *obj = dev_to_omap_iommu(dev);
 	char *p, *buf;
 	struct iovm_struct *tmp;
-	int uninitialized_var(i);
+	int i = 0 /* GCC */;
 	ssize_t bytes;
 
 	buf = (char *)__get_free_page(GFP_KERNEL);
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index a649f14..a6606aa 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -1155,8 +1155,8 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	struct smmu_device *smmu;
 	struct device *dev = &pdev->dev;
 	int i, asids, err = 0;
-	dma_addr_t uninitialized_var(base);
-	size_t bytes, uninitialized_var(size);
+	dma_addr_t base = 0 /* GCC */;
+	size_t bytes, size = 0 /* GCC */;
 
 	if (smmu_handle)
 		return -EIO;
diff --git a/drivers/isdn/hardware/eicon/debug.c b/drivers/isdn/hardware/eicon/debug.c
index b5226af..9f801d9 100644
--- a/drivers/isdn/hardware/eicon/debug.c
+++ b/drivers/isdn/hardware/eicon/debug.c
@@ -1187,7 +1187,7 @@ int SuperTraceASSIGN(void *AdapterHandle, byte *data) {
 
 		if ((features[0] & DIVA_XDI_EXTENDED_FEATURES_VALID) &&
 		    (features[0] & DIVA_XDI_EXTENDED_FEATURE_MANAGEMENT_DMA)) {
-			dword uninitialized_var(rx_dma_magic);
+			dword rx_dma_magic = 0 /* GCC */;
 			if ((pC->dma_handle = diva_get_dma_descriptor(pC->request, &rx_dma_magic)) >= 0) {
 				pC->xbuffer[0] = LLI;
 				pC->xbuffer[1] = 8;
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index ff4a0bc..4e935bf 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -408,7 +408,7 @@ static ssize_t write(struct file *file, const char __user *in,
 	struct lguest *lg = file->private_data;
 	const unsigned long __user *input = (const unsigned long __user *)in;
 	unsigned long req;
-	struct lg_cpu *uninitialized_var(cpu);
+	struct lg_cpu *cpu = NULL /* GCC */;
 	unsigned int cpu_id = *off;
 
 	/* The first value tells us what this request is. */
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index afd9598..b7f3434 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1615,7 +1615,7 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 	int r = 0;
 	int wipe_buffer;
 	unsigned int cmd;
-	struct dm_ioctl *uninitialized_var(param);
+	struct dm_ioctl *param = NULL /* GCC */;
 	ioctl_fn fn = NULL;
 	size_t input_param_size;
 
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 3ac4156..fede76f 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -552,7 +552,7 @@ static int persistent_read_metadata(struct dm_exception_store *store,
 						    chunk_t old, chunk_t new),
 				    void *callback_context)
 {
-	int r, uninitialized_var(new_snapshot);
+	int r, new_snapshot = 0 /* GCC */;
 	struct pstore *ps = get_info(store);
 
 	/*
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 100368e..11a1bb4 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -459,7 +459,7 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		  struct dm_dev **result)
 {
 	int r;
-	dev_t uninitialized_var(dev);
+	dev_t dev = 0 /* GCC */;
 	struct dm_dev_internal *dd;
 	unsigned int major, minor;
 	struct dm_table *t = ti->table;
@@ -689,7 +689,7 @@ static int validate_hardware_logical_block_alignment(struct dm_table *table,
 	 */
 	unsigned short remaining = 0;
 
-	struct dm_target *uninitialized_var(ti);
+	struct dm_target *ti = NULL /* GCC */;
 	struct queue_limits ti_limits;
 	unsigned i = 0;
 
@@ -1230,7 +1230,7 @@ static int count_device(struct dm_target *ti, struct dm_dev *dev,
  */
 bool dm_table_has_no_data_devices(struct dm_table *table)
 {
-	struct dm_target *uninitialized_var(ti);
+	struct dm_target *ti = NULL /* GCC */;
 	unsigned i = 0, num_devices = 0;
 
 	while (i < dm_table_get_num_targets(table)) {
@@ -1253,7 +1253,7 @@ bool dm_table_has_no_data_devices(struct dm_table *table)
 int dm_calculate_queue_limits(struct dm_table *table,
 			      struct queue_limits *limits)
 {
-	struct dm_target *uninitialized_var(ti);
+	struct dm_target *ti = NULL /* GCC */;
 	struct queue_limits ti_limits;
 	unsigned i = 0;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c5439dc..fb08083 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1865,7 +1865,7 @@ static void raid5_end_write_request(struct bio *bi, int error)
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
 	int disks = sh->disks, i;
-	struct md_rdev *uninitialized_var(rdev);
+	struct md_rdev *rdev = NULL /* GCC */;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	sector_t first_bad;
 	int bad_sectors;
diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index a204f28..1af3773 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -419,7 +419,7 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 	int ret, i, len;
 	u8 buf[3], tmp;
 	u32 snr_val;
-	const struct af9013_snr *uninitialized_var(snr_lut);
+	const struct af9013_snr *snr_lut = NULL /* GCC */;
 
 	dev_dbg(&state->i2c->dev, "%s:\n", __func__);
 
diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 464ad87..d4e9b13 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -714,7 +714,7 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 	int ret, i, len;
 	u8 buf[3], tmp;
 	u32 snr_val;
-	const struct val_snr *uninitialized_var(snr_lut);
+	const struct val_snr *snr_lut = NULL /* GCC */;
 
 	/* read value */
 	ret = af9033_rd_regs(state, 0x80002c, buf, 3);
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 9b658c1..84802e3 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -567,7 +567,7 @@ static int cxd2820r_get_frontend_algo(struct dvb_frontend *fe)
 static void cxd2820r_release(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int uninitialized_var(ret); /* silence compiler warning */
+	int ret = 0 /* GCC */; /* silence compiler warning */
 
 	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
 
diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 15bf3ea..023f74e 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -1082,7 +1082,7 @@ static const struct vm_operations_struct isp_video_queue_vm_ops = {
 int omap3isp_video_queue_mmap(struct isp_video_queue *queue,
 			 struct vm_area_struct *vma)
 {
-	struct isp_video_buffer *uninitialized_var(buf);
+	struct isp_video_buffer *buf = NULL /* GCC */;
 	unsigned long size;
 	unsigned int i;
 	int ret = 0;
diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index 5d9f028..6a516af 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -277,7 +277,7 @@ struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
 {
 	struct tda18212_priv *priv = NULL;
 	int ret;
-	u8 uninitialized_var(val);
+	u8 val = 0 /* GCC */;
 
 	priv = kzalloc(sizeof(struct tda18212_priv), GFP_KERNEL);
 	if (priv == NULL)
diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
index 1819853..9486c67 100644
--- a/drivers/media/tuners/tda18218.c
+++ b/drivers/media/tuners/tda18218.c
@@ -277,7 +277,7 @@ struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, struct tda18218_config *cfg)
 {
 	struct tda18218_priv *priv = NULL;
-	u8 uninitialized_var(val);
+	u8 val = 0 /* GCC */;
 	int ret;
 	/* chip default registers values */
 	static u8 def_regs[] = {
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 3d7526e..b7e2d4a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -208,7 +208,7 @@ static int af9015_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	struct af9015_state *state = d_to_priv(d);
 	int ret = 0, i = 0;
 	u16 addr;
-	u8 uninitialized_var(mbox), addr_len;
+	u8 mbox = 0 /* GCC */, addr_len;
 	struct req_t req;
 
 /*
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index ef87229..c8d9826 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -675,7 +675,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 {
 	struct dvb_usb_device *d = purb->context;
 	struct dib0700_rc_response *poll_reply;
-	u32 uninitialized_var(keycode);
+	u32 keycode = 0 /* GCC */;
 	u8 toggle;
 
 	deb_info("%s()\n", __func__);
diff --git a/drivers/media/usb/gspca/vicam.c b/drivers/media/usb/gspca/vicam.c
index d6890bc..5f736e2 100644
--- a/drivers/media/usb/gspca/vicam.c
+++ b/drivers/media/usb/gspca/vicam.c
@@ -239,7 +239,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 {
 	int ret;
 	const struct ihex_binrec *rec;
-	const struct firmware *uninitialized_var(fw);
+	const struct firmware *fw = NULL /* GCC */;
 	u8 *firmware_buf;
 
 	ret = request_ihex_firmware(&fw, VICAM_FIRMWARE,
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 57c3076..cbe28ee 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -702,9 +702,9 @@ static void uvc_video_stats_decode(struct uvc_streaming *stream,
 	unsigned int header_size;
 	bool has_pts = false;
 	bool has_scr = false;
-	u16 uninitialized_var(scr_sof);
-	u32 uninitialized_var(scr_stc);
-	u32 uninitialized_var(pts);
+	u16 scr_sof = 0 /* GCC */;
+	u32 scr_stc = 0 /* GCC */;
+	u32 pts = 0 /* GCC */;
 
 	if (stream->stats.stream.nb_frames == 0 &&
 	    stream->stats.frame.nb_packets == 0)
@@ -1588,7 +1588,7 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 		struct usb_host_endpoint *best_ep = NULL;
 		unsigned int best_psize = UINT_MAX;
 		unsigned int bandwidth;
-		unsigned int uninitialized_var(altsetting);
+		unsigned int altsetting = 0 /* GCC */;
 		int intfnum = stream->intfnum;
 
 		/* Isochronous endpoint, select the alternate setting. */
diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index c37d375..e339ab8 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -315,7 +315,7 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 	}
 
 	while (length) {
-		unsigned int uninitialized_var(p_off);
+		unsigned int p_off = 0 /* GCC */;
 
 		if (host->req->long_data) {
 			pg = nth_page(sg_page(&host->req->sg),
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 7bafa72..eedb9fb 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -200,7 +200,7 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 		host->block_pos);
 
 	while (length) {
-		unsigned int uninitialized_var(p_off);
+		unsigned int p_off = 0 /* GCC */;
 
 		if (host->req->long_data) {
 			pg = nth_page(sg_page(&host->req->sg),
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7922adb..13186d7 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -175,7 +175,7 @@ static void sdhci_disable_card_detection(struct sdhci_host *host)
 static void sdhci_reset(struct sdhci_host *host, u8 mask)
 {
 	unsigned long timeout;
-	u32 uninitialized_var(ier);
+	u32 ier = 0 /* GCC */;
 
 	if (host->quirks & SDHCI_QUIRK_NO_CARD_NO_RESET) {
 		if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) &
@@ -311,7 +311,7 @@ static void sdhci_read_block_pio(struct sdhci_host *host)
 {
 	unsigned long flags;
 	size_t blksize, len, chunk;
-	u32 uninitialized_var(scratch);
+	u32 scratch = 0 /* GCC */;
 	u8 *buf;
 
 	DBG("PIO reading\n");
diff --git a/drivers/mtd/nand/nand_ecc.c b/drivers/mtd/nand/nand_ecc.c
index b7cfe0d..b6d29fb 100644
--- a/drivers/mtd/nand/nand_ecc.c
+++ b/drivers/mtd/nand/nand_ecc.c
@@ -167,7 +167,7 @@ void __nand_calculate_ecc(const unsigned char *buf, unsigned int eccsize,
 	/* rp0..rp15..rp17 are the various accumulated parities (per byte) */
 	uint32_t rp0, rp1, rp2, rp3, rp4, rp5, rp6, rp7;
 	uint32_t rp8, rp9, rp10, rp11, rp12, rp13, rp14, rp15, rp16;
-	uint32_t uninitialized_var(rp17);	/* to make compiler happy */
+	uint32_t rp17 = 0 /* GCC */;	/* to make compiler happy */
 	uint32_t par;		/* the cumulative parity for all data */
 	uint32_t tmppar;	/* the cumulative parity for this iteration;
 				   for rp12, rp14 and rp16 at the end of the
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 295e4be..7351a1a 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -234,7 +234,7 @@ static int s3c2410_nand_setrate(struct s3c2410_nand_info *info)
 	int tacls_max = (info->cpu_type == TYPE_S3C2412) ? 8 : 4;
 	int tacls, twrph0, twrph1;
 	unsigned long clkrate = clk_get_rate(info->clk);
-	unsigned long uninitialized_var(set), cfg, uninitialized_var(mask);
+	unsigned long set = 0 /* GCC */, cfg, mask = 0 /* GCC */;
 	unsigned long flags;
 
 	/* calculate the timing information for the controller */
diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index fec406b..84bbcd8 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -821,7 +821,7 @@ out_unlock:
 static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		    int pnum, int *vid, unsigned long long *sqnum)
 {
-	long long uninitialized_var(ec);
+	long long ec = 0 /* GCC */;
 	int err, bitflips = 0, vol_id = -1, ec_err = 0;
 
 	dbg_bld("scan PEB %d", pnum);
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 0e11671..28ab326 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -374,7 +374,7 @@ int ubi_eba_read_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 {
 	int err, pnum, scrub = 0, vol_id = vol->vol_id;
 	struct ubi_vid_hdr *vid_hdr;
-	uint32_t uninitialized_var(crc);
+	uint32_t crc = 0 /* GCC */;
 
 	err = leb_read_lock(ubi, vol_id, lnum);
 	if (err)
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index da7b449..f02e6f2 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -994,7 +994,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 				int cancel)
 {
 	int err, scrubbing = 0, torture = 0, protect = 0, erroneous = 0;
-	int vol_id = -1, uninitialized_var(lnum);
+	int vol_id = -1, lnum = 0 /* GCC */;
 #ifdef CONFIG_MTD_UBI_FASTMAP
 	int anchor = wrk->anchor;
 #endif
diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
index 325391d..926d948 100644
--- a/drivers/net/dsa/mv88e6060.c
+++ b/drivers/net/dsa/mv88e6060.c
@@ -224,7 +224,7 @@ static void mv88e6060_poll_link(struct dsa_switch *ds)
 
 	for (i = 0; i < DSA_MAX_PORTS; i++) {
 		struct net_device *dev;
-		int uninitialized_var(port_status);
+		int port_status = 0 /* GCC */;
 		int link;
 		int speed;
 		int duplex;
diff --git a/drivers/net/dsa/mv88e6xxx.c b/drivers/net/dsa/mv88e6xxx.c
index a2c62c2..adf771a 100644
--- a/drivers/net/dsa/mv88e6xxx.c
+++ b/drivers/net/dsa/mv88e6xxx.c
@@ -359,7 +359,7 @@ void mv88e6xxx_poll_link(struct dsa_switch *ds)
 
 	for (i = 0; i < DSA_MAX_PORTS; i++) {
 		struct net_device *dev;
-		int uninitialized_var(port_status);
+		int port_status = 0 /* GCC */;
 		int link;
 		int speed;
 		int duplex;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index d431070..3a4dc2e 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -1432,7 +1432,7 @@ bnx2_test_and_disable_2g5(struct bnx2 *bp)
 static void
 bnx2_enable_forced_2g5(struct bnx2 *bp)
 {
-	u32 uninitialized_var(bmcr);
+	u32 bmcr = 0 /* GCC */;
 	int err;
 
 	if (!(bp->phy_flags & BNX2_PHY_FLAG_2_5G_CAPABLE))
@@ -1476,7 +1476,7 @@ bnx2_enable_forced_2g5(struct bnx2 *bp)
 static void
 bnx2_disable_forced_2g5(struct bnx2 *bp)
 {
-	u32 uninitialized_var(bmcr);
+	u32 bmcr = 0 /* GCC */;
 	int err;
 
 	if (!(bp->phy_flags & BNX2_PHY_FLAG_2_5G_CAPABLE))
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index de50547..5d87ea5 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7331,7 +7331,7 @@ static int rx_osm_handler(struct ring_info *ring_data, struct RxD_t * rxdp)
 	int ring_no = ring_data->ring_no;
 	u16 l3_csum, l4_csum;
 	unsigned long long err = rxdp->Control_1 & RXD_T_CODE;
-	struct lro *uninitialized_var(lro);
+	struct lro *lro = NULL /* GCC */;
 	u8 err_mask;
 	struct swStat *swstats = &sp->mac_control.stats_info->sw_stat;
 
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 6407d0d..cab4178 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3778,7 +3778,7 @@ static int __devinit ql3xxx_probe(struct pci_dev *pdev,
 	struct net_device *ndev = NULL;
 	struct ql3_adapter *qdev = NULL;
 	static int cards_found;
-	int uninitialized_var(pci_using_dac), err;
+	int pci_using_dac = 0 /* GCC */, err;
 
 	err = pci_enable_device(pdev);
 	if (err) {
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index e7ff886..24d5955 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5669,7 +5669,7 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
 {
 	struct skb_shared_info *info = skb_shinfo(skb);
 	unsigned int cur_frag, entry;
-	struct TxDesc * uninitialized_var(txd);
+	struct TxDesc * txd = NULL /* GCC */;
 	struct device *d = &tp->pci_dev->dev;
 
 	entry = tp->cur_tx;
diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index fb9f6b3..a8a0054 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -1319,7 +1319,7 @@ static void sis900_timer(unsigned long data)
 	u16 status;
 
 	if (!sis_priv->autong_complete){
-		int uninitialized_var(speed), duplex = 0;
+		int speed = 0 /* GCC */, duplex = 0;
 
 		sis900_read_mode(net_dev, &speed, &duplex);
 		if (duplex){
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index c8251be..4260c4d 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -2305,7 +2305,7 @@ static int cas_rx_ringN(struct cas *cp, int ring, int budget)
 	drops = 0;
 	while (1) {
 		struct cas_rx_comp *rxc = rxcs + entry;
-		struct sk_buff *uninitialized_var(skb);
+		struct sk_buff *skb = NULL /* GCC */;
 		int type, len;
 		u64 words[4];
 		int i, dring;
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 275b430..f02457c 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -428,7 +428,7 @@ static int serdes_init_niu_1g_serdes(struct niu *np)
 	struct niu_link_config *lp = &np->link_config;
 	u16 pll_cfg, pll_sts;
 	int max_retry = 100;
-	u64 uninitialized_var(sig), mask, val;
+	u64 sig = 0 /* GCC */, mask, val;
 	u32 tx_cfg, rx_cfg;
 	unsigned long i;
 	int err;
@@ -525,7 +525,7 @@ static int serdes_init_niu_10g_serdes(struct niu *np)
 	struct niu_link_config *lp = &np->link_config;
 	u32 tx_cfg, rx_cfg, pll_cfg, pll_sts;
 	int max_retry = 100;
-	u64 uninitialized_var(sig), mask, val;
+	u64 sig = 0 /* GCC */, mask, val;
 	unsigned long i;
 	int err;
 
@@ -713,7 +713,7 @@ static int esr_write_glue0(struct niu *np, unsigned long chan, u32 val)
 
 static int esr_reset(struct niu *np)
 {
-	u32 uninitialized_var(reset);
+	u32 reset = 0 /* GCC */;
 	int err;
 
 	err = mdio_write(np, np->port, NIU_ESR_DEV_ADDR,
diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index feacc3b..95228c9 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -707,7 +707,7 @@ EXPORT_SYMBOL(z8530_nop);
 irqreturn_t z8530_interrupt(int irq, void *dev_id)
 {
 	struct z8530_dev *dev=dev_id;
-	u8 uninitialized_var(intr);
+	u8 intr = 0 /* GCC */;
 	static volatile int locker=0;
 	int work=0;
 	struct z8530_irqhandler *irqs;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index f90b5db..3149f48 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1475,7 +1475,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 
 int ath6kl_init_hw_params(struct ath6kl *ar)
 {
-	const struct ath6kl_hw *uninitialized_var(hw);
+	const struct ath6kl_hw *hw = NULL /* GCC */;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index fad3ccd..4f28bc4 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -222,7 +222,7 @@ static unsigned int ath9k_reg_rmw(void *hw_priv, u32 reg_offset, u32 set, u32 cl
 	struct ath_hw *ah = (struct ath_hw *) hw_priv;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags = 0 /* GCC */;
 	u32 val;
 
 	if (NR_CPUS > 1 && ah->config.serialize_regmode == SER_REG_MODE_ON) {
diff --git a/drivers/net/wireless/b43/debugfs.c b/drivers/net/wireless/b43/debugfs.c
index e807bd9..0c343a1 100644
--- a/drivers/net/wireless/b43/debugfs.c
+++ b/drivers/net/wireless/b43/debugfs.c
@@ -506,7 +506,7 @@ static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
 	struct b43_wldev *dev;
 	struct b43_debugfs_fops *dfops;
 	struct b43_dfs_file *dfile;
-	ssize_t uninitialized_var(ret);
+	ssize_t ret = 0 /* GCC */;
 	char *buf;
 	const size_t bufsize = 1024 * 16; /* 16 kiB buffer */
 	const size_t buforder = get_order(bufsize);
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 777cd74..a7509c1 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -50,7 +50,7 @@
 static u32 b43_dma_address(struct b43_dma *dma, dma_addr_t dmaaddr,
 			   enum b43_addrtype addrtype)
 {
-	u32 uninitialized_var(addr);
+	u32 addr = 0 /* GCC */;
 
 	switch (addrtype) {
 	case B43_DMA_ADDR_LOW:
diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index 916123a..d12c6ab 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -742,7 +742,7 @@ struct b43_lo_calib *b43_calibrate_lo_setting(struct b43_wldev *dev,
 	};
 	int max_rx_gain;
 	struct b43_lo_calib *cal;
-	struct lo_g_saved_values uninitialized_var(saved_regs);
+	struct lo_g_saved_values saved_regs = { } /* GCC */;
 	/* Values from the "TXCTL Register and Value Table" */
 	u16 txctl_reg;
 	u16 txctl_value;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c5a99c8..c27cc49 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3705,7 +3705,7 @@ static int b43_switch_band(struct b43_wl *wl, struct ieee80211_channel *chan)
 	struct b43_wldev *down_dev;
 	struct b43_wldev *d;
 	int err;
-	bool uninitialized_var(gmode);
+	bool gmode = 0 /* GCC */;
 	int prev_status;
 
 	/* Find a device and PHY which supports the band. */
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 3c35382..362c13a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4569,7 +4569,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 	u8 rfctl[2];
 	u8 afectl_core;
 	u16 tmp[6];
-	u16 uninitialized_var(cur_hpf1), uninitialized_var(cur_hpf2), cur_lna;
+	u16 cur_hpf1 = 0 /* GCC */, cur_hpf2 = 0 /* GCC */, cur_lna;
 	u32 real, imag;
 	enum ieee80211_band band;
 
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 136510e..d651431 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -427,10 +427,10 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	if ((rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
 	    (rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT)) {
 		unsigned int len;
-		struct ieee80211_hdr *uninitialized_var(hdr);
+		struct ieee80211_hdr *hdr = NULL /* GCC */;
 		int rts_rate, rts_rate_fb;
 		int rts_rate_ofdm, rts_rate_fb_ofdm;
-		struct b43_plcp_hdr6 *uninitialized_var(plcp);
+		struct b43_plcp_hdr6 *plcp = NULL /* GCC */;
 		struct ieee80211_rate *rts_cts_rate;
 
 		rts_cts_rate = ieee80211_get_rts_cts_rate(dev->wl->hw, info);
@@ -441,7 +441,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);
 
 		if (rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-			struct ieee80211_cts *uninitialized_var(cts);
+			struct ieee80211_cts *cts = NULL /* GCC */;
 
 			switch (dev->fw.hdr_format) {
 			case B43_FW_HDR_598:
@@ -463,7 +463,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 			mac_ctl |= B43_TXH_MAC_SENDCTS;
 			len = sizeof(struct ieee80211_cts);
 		} else {
-			struct ieee80211_rts *uninitialized_var(rts);
+			struct ieee80211_rts *rts = NULL /* GCC */;
 
 			switch (dev->fw.hdr_format) {
 			case B43_FW_HDR_598:
@@ -659,8 +659,8 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	const struct b43_rxhdr_fw4 *rxhdr = _rxhdr;
 	__le16 fctl;
 	u16 phystat0, phystat3;
-	u16 uninitialized_var(chanstat), uninitialized_var(mactime);
-	u32 uninitialized_var(macstat);
+	u16 chanstat = 0 /* GCC */, mactime = 0 /* GCC */;
+	u32 macstat = 0 /* GCC */;
 	u16 chanid;
 	u16 phytype;
 	int padding, rate_idx;
diff --git a/drivers/net/wireless/b43legacy/debugfs.c b/drivers/net/wireless/b43legacy/debugfs.c
index 1965edb..056b60a 100644
--- a/drivers/net/wireless/b43legacy/debugfs.c
+++ b/drivers/net/wireless/b43legacy/debugfs.c
@@ -203,7 +203,7 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 	struct b43legacy_wldev *dev;
 	struct b43legacy_debugfs_fops *dfops;
 	struct b43legacy_dfs_file *dfile;
-	ssize_t uninitialized_var(ret);
+	ssize_t ret = 0 /* GCC */;
 	char *buf;
 	const size_t bufsize = 1024 * 16; /* 16 KiB buffer */
 	const size_t buforder = get_order(bufsize);
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 18e208e..6ab55df 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2588,7 +2588,7 @@ static void b43legacy_put_phy_into_reset(struct b43legacy_wldev *dev)
 static int b43legacy_switch_phymode(struct b43legacy_wl *wl,
 				      unsigned int new_mode)
 {
-	struct b43legacy_wldev *uninitialized_var(up_dev);
+	struct b43legacy_wldev *up_dev = NULL /* GCC */;
 	struct b43legacy_wldev *down_dev;
 	int err;
 	bool gmode = false;
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 87e5398..7a61b9e 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -2092,7 +2092,7 @@ il3945_txpower_set_from_eeprom(struct il_priv *il)
 
 		/* set tx power value for all OFDM rates */
 		for (rate_idx = 0; rate_idx < IL_OFDM_RATES; rate_idx++) {
-			s32 uninitialized_var(power_idx);
+			s32 power_idx = 0 /* GCC */;
 			int rc;
 
 			/* use channel group's clip-power table,
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index eac4dc8..32d8d3c 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -2754,7 +2754,7 @@ il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 	struct ieee80211_tx_info *info;
 	struct il4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32 status = le32_to_cpu(tx_resp->u.status);
-	int uninitialized_var(tid);
+	int tid = 0 /* GCC */;
 	int sta_id;
 	int freed;
 	u8 *qc = NULL;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 4bbb711..72600b7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -643,7 +643,7 @@ static void _rtl92cu_init_chipN_one_out_ep_priority(struct ieee80211_hw *hw,
 						    bool wmm_enable,
 						    u8 queue_sel)
 {
-	u16 uninitialized_var(value);
+	u16 value = 0 /* GCC */;
 
 	switch (queue_sel) {
 	case TX_SELE_HQ:
@@ -669,8 +669,8 @@ static void _rtl92cu_init_chipN_two_out_ep_priority(struct ieee80211_hw *hw,
 								u8 queue_sel)
 {
 	u16 beQ, bkQ, viQ, voQ, mgtQ, hiQ;
-	u16 uninitialized_var(valueHi);
-	u16 uninitialized_var(valueLow);
+	u16 valueHi = 0 /* GCC */;
+	u16 valueLow = 0 /* GCC */;
 
 	switch (queue_sel) {
 	case (TX_SELE_HQ | TX_SELE_LQ):
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index f2d6b78..642f371 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -412,7 +412,7 @@ static void netbk_gop_frag_copy(struct xenvif *vif, struct sk_buff *skb,
 	 * These variables are used iff get_page_ext returns true,
 	 * in which case they are guaranteed to be initialized.
 	 */
-	unsigned int uninitialized_var(group), uninitialized_var(idx);
+	unsigned int group = 0 /* GCC */, idx = 0 /* GCC */;
 	int foreign = get_page_ext(page, &group, &idx);
 	unsigned long bytes;
 
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 06bad96..b6cb961 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -783,7 +783,7 @@ void aer_isr(struct work_struct *work)
 {
 	struct aer_rpc *rpc = container_of(work, struct aer_rpc, dpc_handler);
 	struct pcie_device *p_device = rpc->rpd;
-	struct aer_err_source uninitialized_var(e_src);
+	struct aer_err_source e_src = { } /* GCC */;
 
 	mutex_lock(&rpc->rpc_mutex);
 	while (get_e_source(rpc, &e_src))
diff --git a/drivers/platform/x86/hdaps.c b/drivers/platform/x86/hdaps.c
index 777c7e3..092aa29 100644
--- a/drivers/platform/x86/hdaps.c
+++ b/drivers/platform/x86/hdaps.c
@@ -379,7 +379,7 @@ static ssize_t hdaps_variance_show(struct device *dev,
 static ssize_t hdaps_temp1_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	u8 uninitialized_var(temp);
+	u8 temp = 0 /* GCC */;
 	int ret;
 
 	ret = hdaps_readb_one(HDAPS_PORT_TEMP1, &temp);
@@ -392,7 +392,7 @@ static ssize_t hdaps_temp1_show(struct device *dev,
 static ssize_t hdaps_temp2_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	u8 uninitialized_var(temp);
+	u8 temp = 0 /* GCC */;
 	int ret;
 
 	ret = hdaps_readb_one(HDAPS_PORT_TEMP2, &temp);
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 8e927b9..5e129d1 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -1029,7 +1029,7 @@ extern void do_reipl_asm(__u32 schid);
 /* Make sure all subchannels are quiet before we re-ipl an lpar. */
 void reipl_ccw_dev(struct ccw_dev_id *devid)
 {
-	struct subchannel_id uninitialized_var(schid);
+	struct subchannel_id schid = { } /* GCC */;
 
 	s390_reset_system(NULL, NULL);
 	if (reipl_find_schid(devid, &schid) != 0)
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 13aeca3..2f06f2d 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4268,7 +4268,7 @@ static int __devinit adapter_sg_tables_alloc(struct AdapterCtlBlk *acb)
 	const unsigned srbs_per_page = PAGE_SIZE/SEGMENTX_LEN;
 	int srb_idx = 0;
 	unsigned i = 0;
-	struct SGentry *uninitialized_var(ptr);
+	struct SGentry *ptr = NULL /* GCC */;
 
 	for (i = 0; i < DC395x_MAX_SRB_CNT; i++)
 		acb->srb_array[i].segment_x = NULL;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index bf54aaf..5b9e841 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3874,7 +3874,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha)
 {
 	struct outbound_queue_table *circularQ;
 	void *pMsg1 = NULL;
-	u8 uninitialized_var(bc);
+	u8 bc = 0 /* GCC */;
 	u32 ret = MPI_IO_STATUS_FAIL;
 	unsigned long flags;
 
diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index 147dfa8..510c7bb 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -529,7 +529,7 @@ static int davinci_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
 	u32 errors = 0;
 	struct davinci_spi_config *spicfg;
 	struct davinci_spi_platform_data *pdata;
-	unsigned uninitialized_var(rx_buf_count);
+	unsigned rx_buf_count = 0 /* GCC */;
 	void *dummy_buf = NULL;
 	struct scatterlist sg_rx, sg_tx;
 
diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
index e9d2ca1..0ac27bb 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -117,7 +117,7 @@ void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
 static enum ssb_clksrc chipco_pctl_get_slowclksrc(struct ssb_chipcommon *cc)
 {
 	struct ssb_bus *bus = cc->dev->bus;
-	u32 uninitialized_var(tmp);
+	u32 tmp = 0 /* GCC */;
 
 	if (cc->dev->id.revision < 6) {
 		if (bus->bustype == SSB_BUSTYPE_SSB ||
@@ -147,7 +147,7 @@ static enum ssb_clksrc chipco_pctl_get_slowclksrc(struct ssb_chipcommon *cc)
 /* Get maximum or minimum (depending on get_max flag) slowclock frequency. */
 static int chipco_pctl_clockfreqlimit(struct ssb_chipcommon *cc, int get_max)
 {
-	int uninitialized_var(limit);
+	int limit = 0 /* GCC */;
 	enum ssb_clksrc clocksrc;
 	int divisor = 1;
 	u32 tmp;
diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 09a9d35..08b681b 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -555,7 +555,7 @@ static void init_zspage(struct page *first_page, struct size_class *class)
 static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
 {
 	int i, error;
-	struct page *first_page = NULL, *uninitialized_var(prev_page);
+	struct page *first_page = NULL, *prev_page = NULL /* GCC */;
 
 	/*
 	 * Allocate individual pages and link them together as:
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index 0a6a0bc..8f0e232 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -3698,7 +3698,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 	struct cyclades_card *card;
 	void __iomem *addr0 = NULL, *addr2 = NULL;
 	char *card_name = NULL;
-	u32 uninitialized_var(mailbox);
+	u32 mailbox = 0 /* GCC */;
 	unsigned int device_id, nchan = 0, card_no, i, j;
 	unsigned char plx_ver;
 	int retval, irq;
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index d7492e1..cf77966 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -1551,7 +1551,7 @@ static unsigned int card_count;
 static int __devinit isicom_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
 {
-	unsigned int uninitialized_var(signature), index;
+	unsigned int signature = 0 /* GCC */, index;
 	int retval = -EPERM;
 	struct isi_board *board = NULL;
 
diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
index 104ae9c..7254fa8 100644
--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -413,7 +413,7 @@ static struct vm_operations_struct uvc_vm_ops = {
 static int
 uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 {
-	struct uvc_buffer *uninitialized_var(buffer);
+	struct uvc_buffer *buffer = NULL /* GCC */;
 	struct page *page;
 	unsigned long addr, start, size;
 	unsigned int i;
diff --git a/drivers/usb/musb/cppi_dma.c b/drivers/usb/musb/cppi_dma.c
index e19da82..2f92df7 100644
--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -1167,7 +1167,7 @@ irqreturn_t cppi_interrupt(int irq, void *dev_id)
 	struct musb_hw_ep	*hw_ep = NULL;
 	u32			rx, tx;
 	int			i, index;
-	unsigned long		uninitialized_var(flags);
+	unsigned long		flags = 0 /* GCC */;
 
 	cppi = container_of(musb->dma_controller, struct cppi, controller);
 	if (cppi->irq)
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
index d278c5a..be36bb3 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -563,8 +563,8 @@ static int sddr55_reset(struct us_data *us)
 
 static unsigned long sddr55_get_capacity(struct us_data *us) {
 
-	unsigned char uninitialized_var(manufacturerID);
-	unsigned char uninitialized_var(deviceID);
+	unsigned char manufacturerID = 0 /* GCC */;
+	unsigned char deviceID = 0 /* GCC */;
 	int result;
 	struct sddr55_card_info *info = (struct sddr55_card_info *)us->extra;
 
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7f93f34..2033b55 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -145,7 +145,7 @@ static void handle_tx(struct vhost_net *net)
 	int err, wmem;
 	size_t hdr_size;
 	struct socket *sock;
-	struct vhost_ubuf_ref *uninitialized_var(ubufs);
+	struct vhost_ubuf_ref *ubufs = NULL /* GCC */;
 	bool zcopy;
 
 	/* TODO: check that we are running from vhost_worker? */
@@ -364,7 +364,7 @@ err:
 static void handle_rx(struct vhost_net *net)
 {
 	struct vhost_virtqueue *vq = &net->dev.vqs[VHOST_NET_VQ_RX];
-	unsigned uninitialized_var(in), log;
+	unsigned in = 0 /* GCC */, log;
 	struct vhost_log *vq_log;
 	struct msghdr msg = {
 		.msg_name = NULL,
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 99ac2cb..f3c239f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -189,7 +189,7 @@ static int vhost_worker(void *data)
 {
 	struct vhost_dev *dev = data;
 	struct vhost_work *work = NULL;
-	unsigned uninitialized_var(seq);
+	unsigned seq = 0 /* GCC */;
 	mm_segment_t oldfs = get_fs();
 
 	set_fs(USER_DS);
diff --git a/drivers/video/matrox/matroxfb_maven.c b/drivers/video/matrox/matroxfb_maven.c
index 217678e..a0f6e31 100644
--- a/drivers/video/matrox/matroxfb_maven.c
+++ b/drivers/video/matrox/matroxfb_maven.c
@@ -285,7 +285,7 @@ static int matroxfb_mavenclock(const struct matrox_pll_ctl *ctl,
 		unsigned int* in, unsigned int* feed, unsigned int* post,
 		unsigned int* htotal2) {
 	unsigned int fvco;
-	unsigned int uninitialized_var(p);
+	unsigned int p = 0 /* GCC */;
 
 	fvco = matroxfb_PLL_mavenclock(&maven1000_pll, ctl, htotal, vtotal, in, feed, &p, htotal2);
 	if (!fvco)
@@ -717,8 +717,8 @@ static int maven_find_exact_clocks(unsigned int ht, unsigned int vt,
 
 	for (x = 0; x < 8; x++) {
 		unsigned int c;
-		unsigned int uninitialized_var(a), uninitialized_var(b),
-			     uninitialized_var(h2);
+		unsigned int a = 0 /* GCC */, b = 0 /* GCC */,
+			     h2 = 0 /* GCC */;
 		unsigned int h = ht + 2 + x;
 
 		if (!matroxfb_mavenclock((m->mode == MATROXFB_OUTPUT_MODE_PAL) ? &maven_PAL : &maven_NTSC, h, vt, &a, &b, &c, &h2)) {
diff --git a/drivers/video/pm3fb.c b/drivers/video/pm3fb.c
index 055e527..ecf5cb5 100644
--- a/drivers/video/pm3fb.c
+++ b/drivers/video/pm3fb.c
@@ -828,9 +828,9 @@ static void pm3fb_write_mode(struct fb_info *info)
 
 	wmb();
 	{
-		unsigned char uninitialized_var(m);	/* ClkPreScale */
-		unsigned char uninitialized_var(n);	/* ClkFeedBackScale */
-		unsigned char uninitialized_var(p);	/* ClkPostScale */
+		unsigned char m = 0 /* GCC */;	/* ClkPreScale */
+		unsigned char n = 0 /* GCC */;	/* ClkFeedBackScale */
+		unsigned char p = 0 /* GCC */;	/* ClkPostScale */
 		unsigned long pixclock = PICOS2KHZ(info->var.pixclock);
 
 		(void)pm3fb_calculate_clock(pixclock, &m, &n, &p);
diff --git a/drivers/video/riva/riva_hw.c b/drivers/video/riva/riva_hw.c
index 78fdbf5..13c7659 100644
--- a/drivers/video/riva/riva_hw.c
+++ b/drivers/video/riva/riva_hw.c
@@ -1243,8 +1243,8 @@ int CalcStateExt
 )
 {
     int pixelDepth;
-    int uninitialized_var(VClk),uninitialized_var(m),
-        uninitialized_var(n),	uninitialized_var(p);
+    int VClk = 0 /* GCC */,m = 0 /* GCC */,
+        n = 0 /* GCC */,	p = 0 /* GCC */;
 
     /*
      * Save mode parameters.
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index e639584..48c61b0 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -206,7 +206,7 @@ int virtqueue_add_buf(struct virtqueue *_vq,
 		      gfp_t gfp)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
-	unsigned int i, avail, uninitialized_var(prev);
+	unsigned int i, avail, prev = 0 /* GCC */;
 	int head;
 
 	START_USE(vq);
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index db47790..aa260c6 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -601,7 +601,7 @@ success:
 static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct afs_vnode *vnode, *dir;
-	struct afs_fid uninitialized_var(fid);
+	struct afs_fid fid = { } /* GCC */;
 	struct dentry *parent;
 	struct key *key;
 	void *dir_version;
diff --git a/fs/afs/security.c b/fs/afs/security.c
index 8d01042..2fff451 100644
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -288,7 +288,7 @@ static int afs_check_permit(struct afs_vnode *vnode, struct key *key,
 int afs_permission(struct inode *inode, int mask)
 {
 	struct afs_vnode *vnode = AFS_FS_I(inode);
-	afs_access_t uninitialized_var(access);
+	afs_access_t access = 0 /* GCC */;
 	struct key *key;
 	int ret;
 
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index e280352..fe838c1 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -127,7 +127,7 @@ static unsigned long create_flat_tables(
 	char * p = (char*)pp;
 	int argc = bprm->argc;
 	int envc = bprm->envc;
-	char uninitialized_var(dummy);
+	char dummy = 0 /* GCC */;
 
 	sp = (unsigned long *)p;
 	sp -= (envc + argc + 2) + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index 60a3278..025ebdf 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -114,7 +114,7 @@ static void fill_data(struct dlm_lock_data *data, struct dlm_lkb *lkb)
 
 void dlm_timeout_warn(struct dlm_lkb *lkb)
 {
-	struct sk_buff *uninitialized_var(send_skb);
+	struct sk_buff *send_skb = NULL /* GCC */;
 	struct dlm_lock_data *data;
 	size_t size;
 	int rv;
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 2a18234..ffd8356 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1249,7 +1249,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 	struct super_block *sb = dir->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh, *prev, *bhs[3]; /* 32*slots (672bytes) */
-	struct msdos_dir_entry *uninitialized_var(de);
+	struct msdos_dir_entry *de = NULL /* GCC */;
 	int err, free_slots, i, nr_bhs;
 	loff_t pos, i_pos;
 
diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 75a20c0..5c259bf 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -117,7 +117,7 @@ static ssize_t fuse_conn_max_background_write(struct file *file,
 					      const char __user *buf,
 					      size_t count, loff_t *ppos)
 {
-	unsigned uninitialized_var(val);
+	unsigned val = 0 /* GCC */;
 	ssize_t ret;
 
 	ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
@@ -154,7 +154,7 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
 						    const char __user *buf,
 						    size_t count, loff_t *ppos)
 {
-	unsigned uninitialized_var(val);
+	unsigned val = 0 /* GCC */;
 	ssize_t ret;
 
 	ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 963b2d7..4f79ddc 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -151,7 +151,7 @@ static int get_log_header(struct gfs2_jdesc *jd, unsigned int blk,
 			  struct gfs2_log_header_host *head)
 {
 	struct buffer_head *bh;
-	struct gfs2_log_header_host uninitialized_var(lh);
+	struct gfs2_log_header_host lh = { } /* GCC */;
 	const u32 nothing = 0;
 	u32 hash;
 	int error;
diff --git a/fs/hfsplus/unicode.c b/fs/hfsplus/unicode.c
index a32998f..f1674fc 100644
--- a/fs/hfsplus/unicode.c
+++ b/fs/hfsplus/unicode.c
@@ -350,7 +350,7 @@ int hfsplus_hash_dentry(const struct dentry *dentry, const struct inode *inode,
 	astr = str->name;
 	len = str->len;
 	while (len > 0) {
-		int uninitialized_var(dsize);
+		int dsize = 0 /* GCC */;
 		size = asc2unichar(sb, astr, len, &c);
 		astr += size;
 		len -= size;
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index c167028..9d72c9b 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -166,8 +166,8 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
 struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
 	int found;
-	unsigned long uninitialized_var(block);
-	unsigned long uninitialized_var(offset);
+	unsigned long block = 0 /* GCC */;
+	unsigned long offset = 0 /* GCC */;
 	struct inode *inode;
 	struct page *page;
 
diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
index 4a6cf28..512f38c 100644
--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -428,7 +428,7 @@ static void jffs2_mark_erased_block(struct jffs2_sb_info *c, struct jffs2_eraseb
 {
 	size_t retlen;
 	int ret;
-	uint32_t uninitialized_var(bad_offset);
+	uint32_t bad_offset = 0 /* GCC */;
 
 	switch (jffs2_block_check_erase(c, jeb, &bad_offset)) {
 	case -EAGAIN:	goto refile;
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index dab350d..7c21c93 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -315,7 +315,7 @@ static ssize_t write_unlock_fs(struct file *file, char *buf, size_t size)
 static ssize_t write_filehandle(struct file *file, char *buf, size_t size)
 {
 	char *dname, *path;
-	int uninitialized_var(maxsize);
+	int maxsize = 0 /* GCC */;
 	char *mesg = buf;
 	int len;
 	struct auth_domain *dom;
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 31b9463..9cb6011 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4671,7 +4671,7 @@ int ocfs2_insert_extent(handle_t *handle,
 			struct ocfs2_alloc_context *meta_ac)
 {
 	int status;
-	int uninitialized_var(free_records);
+	int free_records = 0 /* GCC */;
 	struct buffer_head *last_eb_bh = NULL;
 	struct ocfs2_insert_type insert = {0, };
 	struct ocfs2_extent_rec rec;
@@ -6807,7 +6807,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 {
 	int ret, i, has_data, num_pages = 0;
 	handle_t *handle;
-	u64 uninitialized_var(block);
+	u64 block = 0 /* GCC */;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8fe4e28..6495aaa 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -876,9 +876,9 @@ static int ocfs2_dx_dir_lookup(struct inode *inode,
 			       u64 *ret_phys_blkno)
 {
 	int ret = 0;
-	unsigned int cend, uninitialized_var(clen);
-	u32 uninitialized_var(cpos);
-	u64 uninitialized_var(blkno);
+	unsigned int cend, clen = 0 /* GCC */;
+	u32 cpos = 0 /* GCC */;
+	u64 blkno = 0 /* GCC */;
 	u32 name_hash = hinfo->major_hash;
 
 	ret = ocfs2_dx_dir_lookup_rec(inode, el, name_hash, &cpos, &blkno,
@@ -922,7 +922,7 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
 			       struct ocfs2_dir_lookup_result *res)
 {
 	int ret, i, found;
-	u64 uninitialized_var(phys);
+	u64 phys = 0 /* GCC */;
 	struct buffer_head *dx_leaf_bh = NULL;
 	struct ocfs2_dx_leaf *dx_leaf;
 	struct ocfs2_dx_entry *dx_entry = NULL;
@@ -4486,9 +4486,9 @@ out:
 int ocfs2_dx_dir_truncate(struct inode *dir, struct buffer_head *di_bh)
 {
 	int ret;
-	unsigned int uninitialized_var(clen);
-	u32 major_hash = UINT_MAX, p_cpos, uninitialized_var(cpos);
-	u64 uninitialized_var(blkno);
+	unsigned int clen = 0 /* GCC */;
+	u32 major_hash = UINT_MAX, p_cpos, cpos = 0 /* GCC */;
+	u64 blkno = 0 /* GCC */;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct buffer_head *dx_root_bh = NULL;
 	struct ocfs2_dx_root_block *dx_root;
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 70b5863..e67889e 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -416,7 +416,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 {
 	int i, ret, tree_height, len;
 	struct ocfs2_dinode *di;
-	struct ocfs2_extent_block *uninitialized_var(eb);
+	struct ocfs2_extent_block *eb = NULL /* GCC */;
 	struct ocfs2_extent_list *el;
 	struct ocfs2_extent_rec *rec;
 	struct buffer_head *eb_bh = NULL;
@@ -611,7 +611,7 @@ int ocfs2_get_clusters(struct inode *inode, u32 v_cluster,
 		       unsigned int *extent_flags)
 {
 	int ret;
-	unsigned int uninitialized_var(hole_len), flags = 0;
+	unsigned int hole_len = 0 /* GCC */, flags = 0;
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_extent_rec rec;
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f1fd074..c676fd3 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2234,7 +2234,7 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 	struct buffer_head *new_di_bh = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
 	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
-	u64 uninitialized_var(di_blkno), suballoc_loc;
+	u64 di_blkno = 0 /* GCC */, suballoc_loc;
 	u16 suballoc_bit;
 
 	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 30a0550..347b589 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1066,7 +1066,7 @@ static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
 				  struct buffer_head **ret_bh)
 {
 	int ret = 0, i, found;
-	u32 low_cpos, uninitialized_var(cpos_end);
+	u32 low_cpos, cpos_end = 0 /* GCC */;
 	struct ocfs2_extent_list *el;
 	struct ocfs2_extent_rec *rec = NULL;
 	struct ocfs2_extent_block *eb = NULL;
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 286edf1..f052d13 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -802,7 +802,7 @@ static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
-	struct ocfs2_live_connection *uninitialized_var(control);
+	struct ocfs2_live_connection *control = NULL /* GCC */;
 	int rc = 0;
 
 	BUG_ON(conn == NULL);
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0ba9ea1..3be02bd 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1195,7 +1195,7 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 	struct ocfs2_xattr_value_root *xv;
 	size_t size;
 	int ret = -ENODATA, name_offset, name_len, i;
-	int uninitialized_var(block_off);
+	int block_off = 0 /* GCC */;
 
 	xs->bucket = ocfs2_xattr_bucket_new(inode);
 	if (!xs->bucket) {
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 77e3cb2..15999f6 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -220,7 +220,7 @@ static int omfs_get_block(struct inode *inode, sector_t block,
 	struct buffer_head *bh;
 	sector_t next, offset;
 	int ret;
-	u64 uninitialized_var(new_block);
+	u64 new_block = 0 /* GCC */;
 	u32 max_extents;
 	int extent_count;
 	struct omfs_extent *oe;
diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index e8e01d7..c227dfc 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -437,7 +437,7 @@ static int calc_dd_growth(const struct ubifs_info *c,
  */
 int ubifs_budget_space(struct ubifs_info *c, struct ubifs_budget_req *req)
 {
-	int uninitialized_var(cmt_retries), uninitialized_var(wb_retries);
+	int cmt_retries = 0 /* GCC */, wb_retries = 0 /* GCC */;
 	int err, idx_growth, data_growth, dd_growth, retried = 0;
 
 	ubifs_assert(req->new_page <= 1);
diff --git a/fs/ubifs/commit.c b/fs/ubifs/commit.c
index ff82293..2f91ddd 100644
--- a/fs/ubifs/commit.c
+++ b/fs/ubifs/commit.c
@@ -568,11 +568,11 @@ out:
  */
 int dbg_check_old_index(struct ubifs_info *c, struct ubifs_zbranch *zroot)
 {
-	int lnum, offs, len, err = 0, uninitialized_var(last_level), child_cnt;
+	int lnum, offs, len, err = 0, last_level = 0 /* GCC */, child_cnt;
 	int first = 1, iip;
 	struct ubifs_debug_info *d = c->dbg;
-	union ubifs_key uninitialized_var(lower_key), upper_key, l_key, u_key;
-	unsigned long long uninitialized_var(last_sqnum);
+	union ubifs_key lower_key = { } /* GCC */, upper_key, l_key, u_key;
+	unsigned long long last_sqnum = 0 /* GCC */;
 	struct ubifs_idx_node *idx;
 	struct list_head list;
 	struct idx_node *i;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index e271fba..0930d43 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -969,7 +969,7 @@ static int ubifs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1,
 			.dirtied_ino_d = ALIGN(old_inode_ui->data_len, 8) };
 	struct timespec time;
-	unsigned int uninitialized_var(saved_nlink);
+	unsigned int saved_nlink = 0 /* GCC */;
 
 	/*
 	 * Budget request settings: deletion direntry, new direntry, removing
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 5bc7781..04b3639 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -225,7 +225,7 @@ static int write_begin_slow(struct address_space *mapping,
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	struct ubifs_budget_req req = { .new_page = 1 };
-	int uninitialized_var(err), appending = !!(pos + len > inode->i_size);
+	int err = 0 /* GCC */, appending = !!(pos + len > inode->i_size);
 	struct page *page;
 
 	dbg_gen("ino %lu, pos %llu, len %u, i_size %lld",
@@ -428,7 +428,7 @@ static int ubifs_write_begin(struct file *file, struct address_space *mapping,
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	struct ubifs_inode *ui = ubifs_inode(inode);
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	int uninitialized_var(err), appending = !!(pos + len > inode->i_size);
+	int err = 0 /* GCC */, appending = !!(pos + len > inode->i_size);
 	int skipped_read = 0;
 	struct page *page;
 
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index afaad07..6e1e1af 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -931,7 +931,7 @@ int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
 	int aligned_dlen1, aligned_dlen2, plen = UBIFS_INO_NODE_SZ;
 	int last_reference = !!(new_inode && new_inode->i_nlink == 0);
 	int move = (old_dir != new_dir);
-	struct ubifs_inode *uninitialized_var(new_ui);
+	struct ubifs_inode *new_ui = NULL /* GCC */;
 
 	dbg_jnl("dent '%.*s' in dir ino %lu to dent '%.*s' in dir ino %lu",
 		old_dentry->d_name.len, old_dentry->d_name.name,
@@ -1145,7 +1145,7 @@ int ubifs_jnl_truncate(struct ubifs_info *c, const struct inode *inode,
 	union ubifs_key key, to_key;
 	struct ubifs_ino_node *ino;
 	struct ubifs_trun_node *trun;
-	struct ubifs_data_node *uninitialized_var(dn);
+	struct ubifs_data_node *dn = NULL /* GCC */;
 	int err, dlen, len, lnum, offs, bit, sz, sync = IS_SYNC(inode);
 	struct ubifs_inode *ui = ubifs_inode(inode);
 	ino_t inum = inode->i_ino;
diff --git a/fs/ubifs/lpt.c b/fs/ubifs/lpt.c
index d46b19e..a9add35 100644
--- a/fs/ubifs/lpt.c
+++ b/fs/ubifs/lpt.c
@@ -285,7 +285,7 @@ uint32_t ubifs_unpack_bits(uint8_t **addr, int *pos, int nrbits)
 	const int k = 32 - nrbits;
 	uint8_t *p = *addr;
 	int b = *pos;
-	uint32_t uninitialized_var(val);
+	uint32_t val = 0 /* GCC */;
 	const int bytes = (nrbits + b + 7) >> 3;
 
 	ubifs_assert(nrbits > 0);
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 349f31a..658f8bc 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -898,7 +898,7 @@ static int fallible_resolve_collision(struct ubifs_info *c,
 				      const struct qstr *nm, int adding)
 {
 	struct ubifs_znode *o_znode = NULL, *znode = *zn;
-	int uninitialized_var(o_n), err, cmp, unsure = 0, nn = *n;
+	int o_n = 0 /* GCC */, err, cmp, unsure = 0, nn = *n;
 
 	cmp = fallible_matches_name(c, &znode->zbranch[nn], nm);
 	if (unlikely(cmp < 0))
@@ -1519,8 +1519,8 @@ out:
  */
 int ubifs_tnc_get_bu_keys(struct ubifs_info *c, struct bu_info *bu)
 {
-	int n, err = 0, lnum = -1, uninitialized_var(offs);
-	int uninitialized_var(len);
+	int n, err = 0, lnum = -1, offs = 0 /* GCC */;
+	int len = 0 /* GCC */;
 	unsigned int block = key_block(c, &bu->key);
 	struct ubifs_znode *znode;
 
diff --git a/fs/ubifs/tnc_misc.c b/fs/ubifs/tnc_misc.c
index f6bf899..3e91303 100644
--- a/fs/ubifs/tnc_misc.c
+++ b/fs/ubifs/tnc_misc.c
@@ -136,8 +136,8 @@ int ubifs_search_zbranch(const struct ubifs_info *c,
 			 const struct ubifs_znode *znode,
 			 const union ubifs_key *key, int *n)
 {
-	int beg = 0, end = znode->child_cnt, uninitialized_var(mid);
-	int uninitialized_var(cmp);
+	int beg = 0, end = znode->child_cnt, mid = 0 /* GCC */;
+	int cmp = 0 /* GCC */;
 	const struct ubifs_zbranch *zbr = &znode->zbranch[0];
 
 	ubifs_assert(end > beg);
diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 1ba2baa..819ec1a 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -645,7 +645,7 @@ static int udf_table_new_block(struct super_block *sb,
 	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
 	uint32_t newblock = 0, adsize;
 	uint32_t elen, goal_elen = 0;
-	struct kernel_lb_addr eloc, uninitialized_var(goal_eloc);
+	struct kernel_lb_addr eloc, goal_eloc = { } /* GCC */;
 	struct extent_position epos, goal_epos;
 	int8_t etype;
 	struct udf_inode_info *iinfo = UDF_I(table);
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 848ffa7..8ec055a 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2218,7 +2218,7 @@ xfs_bmap_rtalloc(
 	 * pick an extent that will space things out in the rt area.
 	 */
 	if (ap->eof && ap->offset == 0) {
-		xfs_rtblock_t uninitialized_var(rtx); /* realtime extent no */
+		xfs_rtblock_t rtx = 0 /* GCC */; /* realtime extent no */
 
 		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
 		if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aa473fa..a36bf7b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1185,7 +1185,7 @@ xfs_seek_data(
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	loff_t			uninitialized_var(offset);
+	loff_t			offset = 0 /* GCC */;
 	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
 	xfs_filblks_t		end;
@@ -1287,7 +1287,7 @@ xfs_seek_hole(
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	loff_t			uninitialized_var(offset);
+	loff_t			offset = 0 /* GCC */;
 	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
 	xfs_filblks_t		end;
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 6a6d7ae..0342b94 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -103,10 +103,4 @@
 #define __noclone	/* not needed */
 #endif
 
-/*
- * A trick to suppress uninitialized variable warning without generating any
- * code
- */
-#define uninitialized_var(x) x = x
-
 #define __always_inline		inline __attribute__((always_inline))
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index d8e636e..cba9593 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -27,5 +27,3 @@
 #define __must_be_array(a) 0
 
 #endif
-
-#define uninitialized_var(x) x
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fa06804..84d663b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -337,7 +337,7 @@ static inline void compound_unlock(struct page *page)
 
 static inline unsigned long compound_lock_irqsave(struct page *page)
 {
-	unsigned long uninitialized_var(flags);
+	unsigned long flags = 0 /* GCC */;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	local_irq_save(flags);
 	compound_lock(page);
diff --git a/ipc/msg.c b/ipc/msg.c
index a71af5a..1633d80 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -412,7 +412,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 		       struct msqid_ds __user *buf, int version)
 {
 	struct kern_ipc_perm *ipcp;
-	struct msqid64_ds uninitialized_var(msqid64);
+	struct msqid64_ds msqid64 = { } /* GCC */;
 	struct msg_queue *msq;
 	int err;
 
diff --git a/kernel/async.c b/kernel/async.c
index 9d31183..dceea1c 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -119,7 +119,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
 	unsigned long flags;
-	ktime_t uninitialized_var(calltime), delta, rettime;
+	ktime_t calltime = { } /* GCC */, delta, rettime;
 	struct async_domain *running = entry->running;
 
 	/* 1) move self to the running queue */
@@ -302,7 +302,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
  */
 void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain *running)
 {
-	ktime_t uninitialized_var(starttime), delta, endtime;
+	ktime_t starttime = { } /* GCC */, delta, endtime;
 
 	if (!running)
 		return;
diff --git a/kernel/audit.c b/kernel/audit.c
index 40414e9..293d5c4 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1124,7 +1124,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 {
 	struct audit_buffer	*ab	= NULL;
 	struct timespec		t;
-	unsigned int		uninitialized_var(serial);
+	unsigned int		serial = 0 /* GCC */;
 	int reserve;
 	unsigned long timeout_start = jiffies;
 
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 14ff484..59c7566 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -562,7 +562,7 @@ int vkdb_printf(const char *fmt, va_list ap)
 	char *moreprompt = "more> ";
 	struct console *c = console_drivers;
 	static DEFINE_SPINLOCK(kdb_printf_lock);
-	unsigned long uninitialized_var(flags);
+	unsigned long flags = 0 /* GCC */;
 
 	preempt_disable();
 	saved_trap_printk = kdb_trap_printk;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 5cc4e7e..c524959 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1449,7 +1449,7 @@ static void handle_swbp(struct pt_regs *regs)
 	struct uprobe_task *utask;
 	struct uprobe *uprobe;
 	unsigned long bp_vaddr;
-	int uninitialized_var(is_swbp);
+	int is_swbp = 0 /* GCC */;
 
 	bp_vaddr = uprobe_get_swbp_addr(regs);
 	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
diff --git a/kernel/exit.c b/kernel/exit.c
index 346616c..1c571b9 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -96,7 +96,7 @@ static void __exit_signal(struct task_struct *tsk)
 	struct signal_struct *sig = tsk->signal;
 	bool group_dead = thread_group_leader(tsk);
 	struct sighand_struct *sighand;
-	struct tty_struct *uninitialized_var(tty);
+	struct tty_struct *tty = NULL /* GCC */;
 
 	sighand = rcu_dereference_check(tsk->sighand,
 					lockdep_tasklist_lock_is_held());
diff --git a/kernel/futex.c b/kernel/futex.c
index 3717e7b..311f06f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -867,7 +867,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 {
 	struct task_struct *new_owner;
 	struct futex_pi_state *pi_state = this->pi_state;
-	u32 uninitialized_var(curval), newval;
+	u32 curval = 0 /* GCC */, newval;
 
 	if (!pi_state)
 		return -EINVAL;
@@ -929,7 +929,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 
 static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
 {
-	u32 uninitialized_var(oldval);
+	u32 oldval = 0 /* GCC */;
 
 	/*
 	 * There is no waiter, so we unlock the futex. The owner died
@@ -1589,7 +1589,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
 	struct task_struct *oldowner = pi_state->owner;
-	u32 uval, uninitialized_var(curval), newval;
+	u32 uval, curval = 0 /* GCC */, newval;
 	int ret;
 
 	/* Owner died? */
@@ -2488,7 +2488,7 @@ err_unlock:
  */
 int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
 {
-	u32 uval, uninitialized_var(nval), mval;
+	u32 uval, nval = 0 /* GCC */, mval;
 
 retry:
 	if (get_user(uval, uaddr))
@@ -2562,7 +2562,7 @@ void exit_robust_list(struct task_struct *curr)
 	struct robust_list_head __user *head = curr->robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
 	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
-	unsigned int uninitialized_var(next_pi);
+	unsigned int next_pi = 0 /* GCC */;
 	unsigned long futex_offset;
 	int rc;
 
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 83e368b..15cecaa 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -51,7 +51,7 @@ void compat_exit_robust_list(struct task_struct *curr)
 	struct compat_robust_list_head __user *head = curr->compat_robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
 	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
-	unsigned int uninitialized_var(next_pi);
+	unsigned int next_pi = 0 /* GCC */;
 	compat_uptr_t uentry, next_uentry, upending;
 	compat_long_t futex_offset;
 	int rc;
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 7981e5b..9d3e9f9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1231,7 +1231,7 @@ static int noop_count(struct lock_list *entry, void *data)
 unsigned long __lockdep_count_forward_deps(struct lock_list *this)
 {
 	unsigned long  count = 0;
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry = NULL /* GCC */;
 
 	__bfs_forwards(this, (void *)&count, noop_count, &target_entry);
 
@@ -1257,7 +1257,7 @@ unsigned long lockdep_count_forward_deps(struct lock_class *class)
 unsigned long __lockdep_count_backward_deps(struct lock_list *this)
 {
 	unsigned long  count = 0;
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry = NULL /* GCC */;
 
 	__bfs_backwards(this, (void *)&count, noop_count, &target_entry);
 
@@ -1551,8 +1551,8 @@ check_usage(struct task_struct *curr, struct held_lock *prev,
 {
 	int ret;
 	struct lock_list this, that;
-	struct lock_list *uninitialized_var(target_entry);
-	struct lock_list *uninitialized_var(target_entry1);
+	struct lock_list *target_entry = NULL /* GCC */;
+	struct lock_list *target_entry1 = NULL /* GCC */;
 
 	this.parent = NULL;
 
@@ -1808,7 +1808,7 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	struct lock_list *entry;
 	int ret;
 	struct lock_list this;
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry = NULL /* GCC */;
 	/*
 	 * Static variable, serialized by the graph_lock().
 	 *
@@ -2344,7 +2344,7 @@ check_usage_forwards(struct task_struct *curr, struct held_lock *this,
 {
 	int ret;
 	struct lock_list root;
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry = NULL /* GCC */;
 
 	root.parent = NULL;
 	root.class = hlock_class(this);
@@ -2368,7 +2368,7 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 {
 	int ret;
 	struct lock_list root;
-	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *target_entry = NULL /* GCC */;
 
 	root.parent = NULL;
 	root.class = hlock_class(this);
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index d84beb9..ac9457d 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -725,7 +725,7 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
 static int dma_debug_device_change(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct dma_debug_entry *uninitialized_var(entry);
+	struct dma_debug_entry *entry = NULL /* GCC */;
 	int count;
 
 	if (global_disable)
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index e796429..2892342 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -563,7 +563,7 @@ void *radix_tree_tag_clear(struct radix_tree_root *root,
 	struct radix_tree_node *node = NULL;
 	struct radix_tree_node *slot = NULL;
 	unsigned int height, shift;
-	int uninitialized_var(offset);
+	int offset = 0 /* GCC */;
 
 	height = root->height;
 	if (index > radix_tree_maxindex(height))
@@ -1313,7 +1313,7 @@ void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
 	struct radix_tree_node *to_free;
 	unsigned int height, shift;
 	int tag;
-	int uninitialized_var(offset);
+	int offset = 0 /* GCC */;
 
 	height = root->height;
 	if (index > radix_tree_maxindex(height))
diff --git a/mm/frontswap.c b/mm/frontswap.c
index 2890e67..5df135c 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -318,7 +318,7 @@ static int __frontswap_shrink(unsigned long target_pages,
 void frontswap_shrink(unsigned long target_pages)
 {
 	unsigned long pages_to_unuse = 0;
-	int uninitialized_var(type), ret;
+	int type = 0 /* GCC */, ret;
 
 	/*
 	 * we don't want to hold swap_lock while doing a very
diff --git a/mm/ksm.c b/mm/ksm.c
index ae539f0..e1a3611 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1431,7 +1431,7 @@ next_mm:
 static void ksm_do_scan(unsigned int scan_npages)
 {
 	struct rmap_item *rmap_item;
-	struct page *uninitialized_var(page);
+	struct page *page = NULL /* GCC */;
 
 	while (scan_npages-- && likely(!freezing(current))) {
 		cond_resched();
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7acf43b..2dc6890 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -948,7 +948,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	}
 
 	while (!memcg) {
-		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
+		struct mem_cgroup_reclaim_iter *iter = NULL /* GCC */;
 		struct cgroup_subsys_state *css;
 
 		if (reclaim) {
@@ -1993,7 +1993,7 @@ void mem_cgroup_update_page_stat(struct page *page,
 {
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc = lookup_page_cgroup(page);
-	unsigned long uninitialized_var(flags);
+	unsigned long flags = 0 /* GCC */;
 
 	if (mem_cgroup_disabled())
 		return;
@@ -2529,7 +2529,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 				       bool lrucare)
 {
 	struct page_cgroup *pc = lookup_page_cgroup(page);
-	struct zone *uninitialized_var(zone);
+	struct zone *zone = NULL /* GCC */;
 	struct lruvec *lruvec;
 	bool was_on_lru = false;
 	bool anon;
@@ -2706,7 +2706,7 @@ static int mem_cgroup_move_parent(struct page *page,
 {
 	struct mem_cgroup *parent;
 	unsigned int nr_pages;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags = 0 /* GCC */;
 	int ret;
 
 	/* Is ROOT ? */
diff --git a/mm/memory.c b/mm/memory.c
index fb135ba..bbba0b0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2354,7 +2354,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 	pte_t *pte;
 	int err;
 	pgtable_t token;
-	spinlock_t *uninitialized_var(ptl);
+	spinlock_t *ptl = NULL /* GCC */;
 
 	pte = (mm == &init_mm) ?
 		pte_alloc_kernel(pmd, addr) :
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d04a8a5..6b303eb 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1089,7 +1089,7 @@ out:
 static struct page *new_vma_page(struct page *page, unsigned long private, int **x)
 {
 	struct vm_area_struct *vma = (struct vm_area_struct *)private;
-	unsigned long uninitialized_var(address);
+	unsigned long address = 0 /* GCC */;
 
 	while (vma) {
 		address = page_address_in_vma(page, vma);
@@ -1427,7 +1427,7 @@ SYSCALL_DEFINE5(get_mempolicy, int __user *, policy,
 		unsigned long, addr, unsigned long, flags)
 {
 	int err;
-	int uninitialized_var(pval);
+	int pval = 0 /* GCC */;
 	nodemask_t nodes;
 
 	if (nmask != NULL && maxnode < MAX_NUMNODES)
@@ -2431,7 +2431,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 {
 	struct mempolicy *new = NULL;
 	unsigned short mode;
-	unsigned short uninitialized_var(mode_flags);
+	unsigned short mode_flags = 0 /* GCC */;
 	nodemask_t nodes;
 	char *nodelist = strchr(str, ':');
 	char *flags = strchr(str, '=');
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 79e0f3e..98194d1 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -696,7 +696,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	struct task_struct *p;
 	unsigned long totalpages;
 	unsigned long freed = 0;
-	unsigned int uninitialized_var(points);
+	unsigned int points = 0 /* GCC */;
 	enum oom_constraint constraint = CONSTRAINT_NONE;
 	int killed = 0;
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 830893b..3fabc1e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -244,7 +244,7 @@ void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 {
 	unsigned long background;
 	unsigned long dirty;
-	unsigned long uninitialized_var(available_memory);
+	unsigned long available_memory = 0 /* GCC */;
 	struct task_struct *tsk;
 
 	if (!vm_dirty_bytes || !dirty_background_bytes)
@@ -1713,7 +1713,7 @@ int write_cache_pages(struct address_space *mapping,
 	int done = 0;
 	struct pagevec pvec;
 	int nr_pages;
-	pgoff_t uninitialized_var(writeback_index);
+	pgoff_t writeback_index = 0 /* GCC */;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5b74de6..c3f26b4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -532,7 +532,7 @@ static inline void __free_one_page(struct page *page,
 {
 	unsigned long page_idx;
 	unsigned long combined_idx;
-	unsigned long uninitialized_var(buddy_idx);
+	unsigned long buddy_idx = 0 /* GCC */;
 	struct page *buddy;
 
 	if (unlikely(PageCompound(page)))
diff --git a/mm/percpu.c b/mm/percpu.c
index ddc5efb..aedf182 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1445,7 +1445,7 @@ static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 	const size_t static_size = __per_cpu_end - __per_cpu_start;
 	int nr_groups = 1, nr_units = 0;
 	size_t size_sum, min_unit_size, alloc_size;
-	int upa, max_upa, uninitialized_var(best_upa);	/* units_per_alloc */
+	int upa, max_upa, best_upa = 0 /* GCC */;	/* units_per_alloc */
 	int last_allocs, group, unit;
 	unsigned int cpu, tcpu;
 	struct pcpu_alloc_info *ai;
diff --git a/mm/slub.c b/mm/slub.c
index a0d6984..7dfcbf4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2463,7 +2463,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 	struct page new;
 	unsigned long counters;
 	struct kmem_cache_node *n = NULL;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags = 0 /* GCC */;
 
 	stat(s, FREE_SLOWPATH);
 
diff --git a/mm/swap.c b/mm/swap.c
index 6310dc2..526107c 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -673,7 +673,7 @@ void release_pages(struct page **pages, int nr, int cold)
 	LIST_HEAD(pages_to_free);
 	struct zone *zone = NULL;
 	struct lruvec *lruvec;
-	unsigned long uninitialized_var(flags);
+	unsigned long flags = 0 /* GCC */;
 
 	for (i = 0; i < nr; i++) {
 		struct page *page = pages[i];
@@ -739,7 +739,7 @@ EXPORT_SYMBOL(__pagevec_release);
 void lru_add_page_tail(struct page *page, struct page *page_tail,
 		       struct lruvec *lruvec)
 {
-	int uninitialized_var(active);
+	int active = 0 /* GCC */;
 	enum lru_list lru;
 	const int file = 0;
 
diff --git a/net/dccp/options.c b/net/dccp/options.c
index a58e0b6..e1adc67 100644
--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -60,7 +60,7 @@ int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
 					(dh->dccph_doff * 4);
 	struct dccp_options_received *opt_recv = &dp->dccps_options_received;
 	unsigned char opt, len;
-	unsigned char *uninitialized_var(value);
+	unsigned char *value = NULL /* GCC */;
 	u32 elapsed_time;
 	__be32 opt_val;
 	int rc;
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index 90bbefb..4d00011 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -476,7 +476,7 @@ static inline void fl_link(struct ipv6_pinfo *np, struct ipv6_fl_socklist *sfl,
 
 int ipv6_flowlabel_opt(struct sock *sk, char __user *optval, int optlen)
 {
-	int uninitialized_var(err);
+	int err = 0 /* GCC */;
 	struct net *net = sock_net(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct in6_flowlabel_req freq;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 1ce3bef..d64afd8 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -358,7 +358,7 @@ static int help(struct sk_buff *skb,
 	int ret;
 	u32 seq;
 	int dir = CTINFO2DIR(ctinfo);
-	unsigned int uninitialized_var(matchlen), uninitialized_var(matchoff);
+	unsigned int matchlen = 0 /* GCC */, matchoff = 0 /* GCC */;
 	struct nf_ct_ftp_master *ct_ftp_info = nfct_help_data(ct);
 	struct nf_conntrack_expect *exp;
 	union nf_inet_addr *daddr;
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index e12d44e..1b82378 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -235,7 +235,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	struct net_device *indev;
 	struct net_device *outdev;
 	struct nf_conn *ct = NULL;
-	enum ip_conntrack_info uninitialized_var(ctinfo);
+	enum ip_conntrack_info ctinfo = 0 /* GCC */;
 
 	size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
@@ -751,7 +751,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 	struct nfqnl_instance *queue;
 	unsigned int verdict;
 	struct nf_queue_entry *entry;
-	enum ip_conntrack_info uninitialized_var(ctinfo);
+	enum ip_conntrack_info ctinfo = 0 /* GCC */;
 	struct nf_conn *ct = NULL;
 
 	queue = instance_lookup(queue_num);
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 63b2bdb..f215085 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -108,9 +108,9 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 	const struct iphdr *iph = ip_hdr(skb);
 	struct udphdr _hdr, *hp = NULL;
 	struct sock *sk;
-	__be32 uninitialized_var(daddr), uninitialized_var(saddr);
-	__be16 uninitialized_var(dport), uninitialized_var(sport);
-	u8 uninitialized_var(protocol);
+	__be32 daddr = 0 /* GCC */, saddr = 0 /* GCC */;
+	__be16 dport = 0 /* GCC */, sport = 0 /* GCC */;
+	u8 protocol = 0 /* GCC */;
 #ifdef XT_SOCKET_HAVE_CONNTRACK
 	struct nf_conn const *ct;
 	enum ip_conntrack_info ctinfo;
@@ -262,8 +262,8 @@ socket_mt6_v1(const struct sk_buff *skb, struct xt_action_param *par)
 	struct udphdr _hdr, *hp = NULL;
 	struct sock *sk;
 	struct in6_addr *daddr = NULL, *saddr = NULL;
-	__be16 uninitialized_var(dport), uninitialized_var(sport);
-	int thoff = 0, uninitialized_var(tproto);
+	__be16 dport = 0 /* GCC */, sport = 0 /* GCC */;
+	int thoff = 0, tproto = 0 /* GCC */;
 	const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
 
 	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index ce82d0c..3fad376 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -211,7 +211,7 @@ static u32 flow_get_skgid(const struct sk_buff *skb)
 
 static u32 flow_get_vlan_tag(const struct sk_buff *skb)
 {
-	u16 uninitialized_var(tag);
+	u16 tag = 0 /* GCC */;
 
 	if (vlan_get_tag(skb, &tag) < 0)
 		return 0;
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 564b9fc..d1b3fee 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -373,7 +373,7 @@ static int
 cbq_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 {
 	struct cbq_sched_data *q = qdisc_priv(sch);
-	int uninitialized_var(ret);
+	int ret = 0 /* GCC */;
 	struct cbq_class *cl = cbq_classify(skb, sch, &ret);
 
 #ifdef CONFIG_NET_CLS_ACT
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 4e606fc..8152ca1 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -172,7 +172,7 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 	unsigned int idx;
 	struct fq_codel_flow *flow;
-	int uninitialized_var(ret);
+	int ret = 0 /* GCC */;
 
 	idx = fq_codel_classify(skb, sch, &ret);
 	if (idx == 0) {
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 6c2ec45..a7bbdcd 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1587,7 +1587,7 @@ static int
 hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 {
 	struct hfsc_class *cl;
-	int uninitialized_var(err);
+	int err = 0 /* GCC */;
 
 	cl = hfsc_classify(skb, sch, &err);
 	if (cl == NULL) {
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 9d75b77..c082ff0 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -548,7 +548,7 @@ static inline void htb_deactivate(struct htb_sched *q, struct htb_class *cl)
 
 static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 {
-	int uninitialized_var(ret);
+	int ret = 0 /* GCC */;
 	struct htb_sched *q = qdisc_priv(sch);
 	struct htb_class *cl = htb_classify(skb, sch, &ret);
 
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index d3a1bc2..5081d00 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -373,7 +373,7 @@ sfq_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 	unsigned int hash;
 	sfq_index x, qlen;
 	struct sfq_slot *slot;
-	int uninitialized_var(ret);
+	int ret = 0 /* GCC */;
 	struct sk_buff *head;
 	int delta;
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 62e4f9b..0934667 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -831,7 +831,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	struct rdma_conn_param conn_param;
 	struct ib_qp_init_attr qp_attr;
 	struct ib_device_attr devattr;
-	int uninitialized_var(dma_mr_acc);
+	int dma_mr_acc = 0 /* GCC */;
 	int need_dma_mr;
 	int ret;
 	int i;
diff --git a/sound/core/control_compat.c b/sound/core/control_compat.c
index 2bb95a7..2bbf2a8 100644
--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -223,7 +223,7 @@ static int copy_ctl_value_from_user(struct snd_card *card,
 				    int *typep, int *countp)
 {
 	int i, type, size;
-	int uninitialized_var(count);
+	int count = 0 /* GCC */;
 	unsigned int indirect;
 
 	if (copy_from_user(&data->id, &data32->id, sizeof(data->id)))
diff --git a/sound/isa/sb/sb16_csp.c b/sound/isa/sb/sb16_csp.c
index c1aa21e..203977d 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -116,7 +116,7 @@ static void info_read(struct snd_info_entry *entry, struct snd_info_buffer *buff
 int snd_sb_csp_new(struct snd_sb *chip, int device, struct snd_hwdep ** rhwdep)
 {
 	struct snd_sb_csp *p;
-	int uninitialized_var(version);
+	int version = 0 /* GCC */;
 	int err;
 	struct snd_hwdep *hw;
 
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 7f78c6d..a945dae 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -300,7 +300,7 @@ static void queue_pending_output_urbs(struct snd_usb_endpoint *ep)
 	while (test_bit(EP_FLAG_RUNNING, &ep->flags)) {
 
 		unsigned long flags;
-		struct snd_usb_packet_info *uninitialized_var(packet);
+		struct snd_usb_packet_info *packet = NULL /* GCC */;
 		struct snd_urb_ctx *ctx = NULL;
 		struct urb *urb;
 		int err, i;
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index 81847dd..2b2e271 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -105,8 +105,6 @@ static inline void kfree(void *p)
 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 	(type *)( (char *)__mptr - offsetof(type,member) );})
 
-#define uninitialized_var(x) x = x
-
 # ifndef likely
 #  define likely(x)	(__builtin_expect(!!(x), 1))
 # endif
