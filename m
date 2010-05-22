Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab0EVUtt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 16:49:49 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:54032 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab0EVUto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 16:49:44 -0400
From: Jim Meyering <jim@meyering.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove all useless-if-before-kfree tests, and those before free
Date: Sat, 22 May 2010 22:35:48 +0200
Message-ID: <87iq6fad3v.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=


I've been using tools to automate the detection and removal of useless
if-before-free tests for some time, and have applied them to numerous
projects.  Here's a sampling of those discussions, with justification:

   http://thread.gmane.org/gmane.comp.version-control.git/74187
   http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/12712
   http://thread.gmane.org/gmane.emacs.devel/98144
   http://thread.gmane.org/gmane.comp.lib.glibc.alpha/13092

Quick summary:

This patch replaces code like this:

	if (copy)
		kfree (copy);

with this:

	kfree (copy);

The patch converts other variants, too, like "if (copy != NULL) ...".
I've performed the conversion two ways: 1) fully mechanically using spatch,
2) mostly mechanically using gnulib's useless-if-before-free

  http://git.sv.gnu.org/cgit/gnulib.git/tree/build-aux/useless-if-before-free

script to detect offenders, and the code in its comments to perform the
conversions.  Comparing the results shows nothing surprising,
other than a couple of syntax errors introduced by spatch (from
coccinelle-0.2.0-0.rc1.2.fc13.x86_64).

Here is how I used spatch:

---------------
git ls-files -z \
  |xargs -0 ~/w/co/gnulib/build-aux/useless-if-before-free -l --name=kfree \
  > knames
tr '\0' '\n' < knames > k; mv k knames
wc -l knames
131 knames
cat > if-before-kfree.cocci <<\EOF
@r@
expression E;
@@
- if (E != NULL) { kfree(E); }
+ kfree(E);
EOF

cat > if-before-free.cocci <<\EOF
@r@
expression E;
@@
- if (E != NULL) { free(E); }
+ free(E);
EOF

git ls-files -z \
  |xargs -0 ~/w/co/gnulib/build-aux/useless-if-before-free -l > fnames
tr '\0' '\n' < fnames > k; mv k fnames
wc -l fnames
14 fnames

xargs spatch -inplace -linux_spacing -sp_file if-before-kfree.cocci < knames
xargs spatch -inplace -linux_spacing -sp_file if-before-free.cocci < fnames
---------------

FYI, here are the diffs comparing the spatch-induced changes to
the ones below:

    http://meyering.net/code/spatch-vs-semiautomated--if-before-kfree.diff

If you're interested in keeping new useless-if tests from
being introduced into the code, you may want to use code
like this:

    http://git.savannah.gnu.org/cgit/gnulib.git/tree/top/maint.mk#n252

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 arch/arm/mach-omap2/pm-debug.c                     |    3 +-
 arch/arm/oprofile/common.c                         |    3 +-
 arch/arm/plat-omap/mcbsp.c                         |    3 +-
 arch/um/kernel/skas/mmu.c                          |    3 +-
 crypto/ablkcipher.c                                |    3 +-
 drivers/acpi/processor_core.c                      |    3 +-
 drivers/ata/sata_fsl.c                             |    3 +-
 drivers/block/z2ram.c                              |    5 +--
 drivers/char/hvc_iucv.c                            |    3 +-
 drivers/char/n_hdlc.c                              |   20 +++----
 drivers/char/pcmcia/ipwireless/hardware.c          |    3 +-
 drivers/crypto/talitos.c                           |    3 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |    3 +-
 drivers/gpu/drm/radeon/atom.c                      |    3 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |    6 +--
 drivers/gpu/drm/radeon/radeon_display.c            |    4 +-
 drivers/hid/hid-prodikeys.c                        |    3 +-
 drivers/hid/hid-zydacron.c                         |    3 +-
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c           |    3 +-
 drivers/media/dvb/siano/smscoreapi.c               |    3 +-
 drivers/media/video/ivtv/ivtvfb.c                  |    3 +-
 drivers/message/fusion/mptfc.c                     |    3 +-
 drivers/message/fusion/mptspi.c                    |    3 +-
 drivers/misc/sgi-xp/xpc_partition.c                |    3 +-
 drivers/mmc/card/queue.c                           |   15 ++----
 drivers/mmc/core/bus.c                             |    3 +-
 drivers/mmc/core/sdio_bus.c                        |    3 +-
 drivers/mtd/chips/cfi_cmdset_0001.c                |    3 +-
 drivers/mtd/maps/ck804xrom.c                       |    3 +-
 drivers/net/forcedeth.c                            |   12 ++---
 drivers/net/irda/kingsun-sir.c                     |    4 +-
 drivers/net/ixgbe/ixgbe_main.c                     |    3 +-
 drivers/net/myri10ge/myri10ge.c                    |    3 +-
 drivers/net/netxen/netxen_nic_main.c               |    3 +-
 drivers/net/ppp_mppe.c                             |    6 +--
 drivers/net/qla3xxx.c                              |    2 +-
 drivers/net/qlcnic/qlcnic_main.c                   |    3 +-
 drivers/net/stmmac/stmmac_main.c                   |    3 +-
 drivers/net/usb/hso.c                              |    3 +-
 drivers/net/wireless/ath/ath5k/attach.c            |    3 +-
 drivers/net/wireless/ipw2x00/libipw_module.c       |    3 +-
 drivers/net/wireless/orinoco/orinoco_usb.c         |    3 +-
 drivers/rtc/rtc-m48t59.c                           |    3 +-
 drivers/s390/char/monreader.c                      |    3 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l          |    3 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c        |   12 ++---
 drivers/scsi/aic94xx/aic94xx_init.c                |    3 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |    3 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    3 +-
 drivers/staging/comedi/drivers/das08_cs.c          |    3 +-
 drivers/staging/comedi/drivers/das16.c             |    6 +--
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    3 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |    3 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |    3 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |    3 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |    3 +-
 drivers/staging/comedi/drivers/serial2002.c        |   16 ++----
 drivers/staging/crystalhd/crystalhd_lnx.c          |    3 +-
 drivers/staging/cx25821/cx25821-audio-upstream.c   |    3 +-
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |    3 +-
 drivers/staging/cx25821/cx25821-video-upstream.c   |    3 +-
 drivers/staging/dream/camera/msm_vfe7x.c           |    3 +-
 drivers/staging/go7007/go7007-usb.c                |    6 +--
 drivers/staging/pohmelfs/config.c                  |    6 +--
 drivers/staging/rt2860/common/spectrum.c           |    6 +--
 drivers/staging/rt2860/rt_linux.c                  |    6 +--
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    3 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c  |    1 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c |    1 -
 drivers/staging/rtl8192u/ieee80211/cipher.c        |    3 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |    1 -
 drivers/staging/rtl8192u/r8192U_core.c             |    8 +--
 drivers/staging/serqt_usb2/serqt_usb2.c            |    3 +-
 drivers/staging/ti-st/bt_drv.c                     |    3 +-
 drivers/staging/usbip/stub_main.c                  |    6 +--
 drivers/staging/vme/bridges/vme_ca91cx42.c         |    3 +-
 drivers/staging/vme/bridges/vme_tsi148.c           |    3 +-
 drivers/staging/vt6655/device_main.c               |    3 +-
 drivers/staging/vt6655/hostap.c                    |    3 +-
 drivers/staging/vt6655/wpactl.c                    |    3 +-
 drivers/staging/vt6656/firmware.c                  |    6 +--
 drivers/staging/vt6656/hostap.c                    |    3 +-
 drivers/staging/vt6656/main_usb.c                  |   12 ++---
 drivers/staging/vt6656/wpactl.c                    |    3 +-
 drivers/staging/winbond/wb35reg.c                  |    3 +-
 drivers/staging/wlan-ng/prism2fw.c                 |    3 +-
 drivers/usb/serial/mos7840.c                       |    7 +--
 drivers/uwb/wlp/wlp-lc.c                           |    3 +-
 drivers/video/au1200fb.c                           |    6 +--
 drivers/video/console/softcursor.c                 |    3 +-
 drivers/video/uvesafb.c                            |   18 ++----
 fs/btrfs/free-space-cache.c                        |    6 +--
 fs/ceph/crush/crush.c                              |    2 +-
 fs/dlm/memory.c                                    |    3 +-
 fs/ecryptfs/keystore.c                             |    3 +-
 fs/ecryptfs/messaging.c                            |    6 +--
 fs/jffs2/acl.c                                     |    3 +-
 fs/jffs2/scan.c                                    |    3 +-
 fs/jffs2/xattr.c                                   |    3 +-
 fs/nfs/nfs4proc.c                                  |    3 +-
 fs/ocfs2/alloc.c                                   |    3 +-
 fs/ocfs2/cluster/heartbeat.c                       |    6 +--
 fs/ocfs2/cluster/tcp.c                             |    6 +--
 fs/ocfs2/dlm/dlmdomain.c                           |    3 +-
 fs/ocfs2/dlm/dlmrecovery.c                         |    6 +--
 fs/ocfs2/extent_map.c                              |    3 +-
 fs/ocfs2/journal.c                                 |    9 +--
 fs/ocfs2/localalloc.c                              |    6 +--
 fs/ocfs2/super.c                                   |    6 +--
 include/net/netfilter/nf_conntrack_extend.h        |    3 +-
 net/caif/cfctrl.c                                  |    3 +-
 net/tipc/name_distr.c                              |    4 +-
 scripts/dtc/data.c                                 |    3 +-
 scripts/genksyms/lex.c_shipped                     |    3 +-
 scripts/genksyms/lex.l                             |    3 +-
 scripts/kconfig/confdata.c                         |    3 +-
 scripts/kconfig/util.c                             |    3 +-
 sound/aoa/codecs/onyx.c                            |    3 +-
 sound/core/control.c                               |    3 +-
 sound/core/pcm.c                                   |    3 +-
 sound/pci/asihpi/hpifunc.c                         |    3 +-
 sound/pci/ctxfi/ctdaio.c                           |    6 +--
 sound/pci/emu10k1/emufx.c                          |    3 +-
 sound/pci/hda/hda_codec.c                          |    3 +-
 tools/perf/util/probe-event.c                      |   54 +++++++-------------
 .../perf/util/scripting-engines/trace-event-perl.c |    3 +-
 .../util/scripting-engines/trace-event-python.c    |    3 +-
 tools/perf/util/thread.c                           |    6 +--
 tools/perf/util/trace-event-parse.c                |    9 +--
 usr/gen_init_cpio.c                                |    2 +-
 131 files changed, 198 insertions(+), 402 deletions(-)

diff --git a/arch/arm/mach-omap2/pm-debug.c b/arch/arm/mach-omap2/pm-debug.c
index 723b44e..4d3012b 100644
--- a/arch/arm/mach-omap2/pm-debug.c
+++ b/arch/arm/mach-omap2/pm-debug.c
@@ -289,8 +289,7 @@ static int pm_dbg_show_regs(struct seq_file *s, void *unused)
 		i++;
 	}

-	if (store != NULL)
-		kfree(store);
+	kfree(store);

 	return 0;
 }
diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 0691176..472e4d9 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -413,8 +413,7 @@ void oprofile_arch_exit(void)
 		}
 	}

-	if (counter_config)
-		kfree(counter_config);
+	kfree(counter_config);
 }
 #else
 int __init oprofile_arch_init(struct oprofile_operations *ops)
diff --git a/arch/arm/plat-omap/mcbsp.c b/arch/arm/plat-omap/mcbsp.c
index 7e669c9..ff07a9c 100644
--- a/arch/arm/plat-omap/mcbsp.c
+++ b/arch/arm/plat-omap/mcbsp.c
@@ -854,8 +854,7 @@ void omap_mcbsp_free(unsigned int id)
 	mcbsp->reg_cache = NULL;
 	spin_unlock(&mcbsp->lock);

-	if (reg_cache)
-		kfree(reg_cache);
+	kfree(reg_cache);
 }
 EXPORT_SYMBOL(omap_mcbsp_free);

diff --git a/arch/um/kernel/skas/mmu.c b/arch/um/kernel/skas/mmu.c
index 3d099f9..e36210d 100644
--- a/arch/um/kernel/skas/mmu.c
+++ b/arch/um/kernel/skas/mmu.c
@@ -151,8 +151,7 @@ void arch_exit_mmap(struct mm_struct *mm)
 {
 	pte_t *pte;

-	if (mm->context.stub_pages != NULL)
-		kfree(mm->context.stub_pages);
+	kfree(mm->context.stub_pages);
 	pte = virt_to_pte(mm, STUB_CODE);
 	if (pte != NULL)
 		pte_clear(mm, STUB_CODE, pte);
diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 98a6610..267be46 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -141,8 +141,7 @@ err:

 	if (walk->iv != req->info)
 		memcpy(req->info, walk->iv, tfm->crt_ablkcipher.ivsize);
-	if (walk->iv_buffer)
-		kfree(walk->iv_buffer);
+	kfree(walk->iv_buffer);

 	return err;
 }
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 5128435..ee9bd4a 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -164,8 +164,7 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
 	}

 exit:
-	if (buffer.pointer)
-		kfree(buffer.pointer);
+	kfree(buffer.pointer);
 	return apic_id;
 }

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index a69192b..627fd95 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1364,8 +1364,7 @@ error_exit_with_cleanup:

 	if (hcr_base)
 		iounmap(hcr_base);
-	if (host_priv)
-		kfree(host_priv);
+	kfree(host_priv);

 	return retval;
 }
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 9114654..963d256 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -397,10 +397,7 @@ static void __exit z2_exit(void)
 	    }
 	}

-	if ( z2ram_map != NULL )
-	{
-	    kfree( z2ram_map );
-	}
+	kfree( z2ram_map );
     }

     return;
diff --git a/drivers/char/hvc_iucv.c b/drivers/char/hvc_iucv.c
index 5a80ad6..8a32d76 100644
--- a/drivers/char/hvc_iucv.c
+++ b/drivers/char/hvc_iucv.c
@@ -1313,8 +1313,7 @@ out_error_memory:
 	mempool_destroy(hvc_iucv_mempool);
 	kmem_cache_destroy(hvc_iucv_buffer_cache);
 out_error:
-	if (hvc_iucv_filter)
-		kfree(hvc_iucv_filter);
+	kfree(hvc_iucv_filter);
 	hvc_iucv_devices = 0; /* ensure that we do not provide any device */
 	return rc;
 }
diff --git a/drivers/char/n_hdlc.c b/drivers/char/n_hdlc.c
index c68118e..414c691 100644
--- a/drivers/char/n_hdlc.c
+++ b/drivers/char/n_hdlc.c
@@ -260,31 +260,27 @@ static void n_hdlc_release(struct n_hdlc *n_hdlc)
 	/* Release transmit and receive buffers */
 	for(;;) {
 		buf = n_hdlc_buf_get(&n_hdlc->rx_free_buf_list);
-		if (buf) {
-			kfree(buf);
-		} else
+		if (!buf)
 			break;
+		kfree(buf);
 	}
 	for(;;) {
 		buf = n_hdlc_buf_get(&n_hdlc->tx_free_buf_list);
-		if (buf) {
-			kfree(buf);
-		} else
+		if (!buf)
 			break;
+		kfree(buf);
 	}
 	for(;;) {
 		buf = n_hdlc_buf_get(&n_hdlc->rx_buf_list);
-		if (buf) {
-			kfree(buf);
-		} else
+		if (!buf)
 			break;
+		kfree(buf);
 	}
 	for(;;) {
 		buf = n_hdlc_buf_get(&n_hdlc->tx_buf_list);
-		if (buf) {
-			kfree(buf);
-		} else
+		if (!buf)
 			break;
+		kfree(buf);
 	}
 	kfree(n_hdlc->tbuf);
 	kfree(n_hdlc);
diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index 99cffda..e1a703a 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -1732,8 +1732,7 @@ void ipwireless_hardware_free(struct ipw_hardware *hw)
 	flush_scheduled_work();

 	for (i = 0; i < NL_NUM_OF_ADDRESSES; i++)
-		if (hw->packet_assembler[i] != NULL)
-			kfree(hw->packet_assembler[i]);
+		kfree(hw->packet_assembler[i]);

 	for (i = 0; i < NL_NUM_OF_PRIORITIES; i++)
 		list_for_each_entry_safe(tp, tq, &hw->tx_queue[i], queue) {
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6a0f59d..df4995d 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2326,8 +2326,7 @@ static int talitos_remove(struct of_device *ofdev)
 		talitos_unregister_rng(dev);

 	for (i = 0; i < priv->num_channels; i++)
-		if (priv->chan[i].fifo)
-			kfree(priv->chan[i].fifo);
+		kfree(priv->chan[i].fifo);

 	kfree(priv->chan);

diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index 227feca..b3955bc 100644
--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -283,8 +283,7 @@ static void intel_dvo_enc_destroy(struct drm_encoder *encoder)
 	if (dvo) {
 		if (dvo->dev_ops->destroy)
 			dvo->dev_ops->destroy(dvo);
-		if (dvo->panel_fixed_mode)
-			kfree(dvo->panel_fixed_mode);
+		kfree(dvo->panel_fixed_mode);
 	}
 	if (intel_encoder->i2c_bus)
 		intel_i2c_destroy(intel_encoder->i2c_bus);
diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 1d56983..8a5b15d 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1304,8 +1304,7 @@ int atom_asic_init(struct atom_context *ctx)

 void atom_destroy(struct atom_context *ctx)
 {
-	if (ctx->iio)
-		kfree(ctx->iio);
+	kfree(ctx->iio);
 	kfree(ctx);
 }

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 0c7ccc6..c25f361 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -506,8 +506,7 @@ static void radeon_connector_destroy(struct drm_connector *connector)

 	if (radeon_connector->ddc_bus)
 		radeon_i2c_destroy(radeon_connector->ddc_bus);
-	if (radeon_connector->edid)
-		kfree(radeon_connector->edid);
+	kfree(radeon_connector->edid);
 	kfree(radeon_connector->con_priv);
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
@@ -946,8 +945,7 @@ static void radeon_dp_connector_destroy(struct drm_connector *connector)

 	if (radeon_connector->ddc_bus)
 		radeon_i2c_destroy(radeon_connector->ddc_bus);
-	if (radeon_connector->edid)
-		kfree(radeon_connector->edid);
+	kfree(radeon_connector->edid);
 	if (radeon_dig_connector->dp_i2c_bus)
 		radeon_i2c_destroy(radeon_dig_connector->dp_i2c_bus);
 	kfree(radeon_connector->con_priv);
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 1006549..46beef9 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -429,9 +429,7 @@ static int radeon_ddc_dump(struct drm_connector *connector)
 	if (!radeon_connector->ddc_bus)
 		return -1;
 	edid = drm_get_edid(connector, &radeon_connector->ddc_bus->adapter);
-	if (edid) {
-		kfree(edid);
-	}
+	kfree(edid);
 	return ret;
 }

diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index 845f428..3e72cea 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -848,8 +848,7 @@ static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
 err_stop:
 	hid_hw_stop(hdev);
 err_free:
-	if (pm != NULL)
-		kfree(pm);
+	kfree(pm);

 	kfree(pk);
 	return ret;
diff --git a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
index 9e8d35a..c9d71c8 100644
--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -202,8 +202,7 @@ static void zc_remove(struct hid_device *hdev)

 	hid_hw_stop(hdev);

-	if (NULL != zc)
-		kfree(zc);
+	kfree(zc);
 }

 static const struct hid_device_id zc_devices[] = {
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
index 9cd51ac..17919eb 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
@@ -295,8 +295,7 @@ static int cinergyt2_fe_get_frontend(struct dvb_frontend *fe,
 static void cinergyt2_fe_release(struct dvb_frontend *fe)
 {
 	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	if (state != NULL)
-		kfree(state);
+	kfree(state);
 }

 static struct dvb_frontend_ops cinergyt2_fe_ops;
diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index 0c87a3c..97a8668 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -724,8 +724,7 @@ void smscore_unregister_device(struct smscore_device_t *coredev)
 		dma_free_coherent(NULL, coredev->common_buffer_size,
 			coredev->common_buffer, coredev->common_buffer_phys);

-	if (coredev->fw_buf != NULL)
-		kfree(coredev->fw_buf);
+	kfree(coredev->fw_buf);

 	list_del(&coredev->entry);
 	kfree(coredev);
diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb.c
index 49e1a28..3edf881 100644
--- a/drivers/media/video/ivtv/ivtvfb.c
+++ b/drivers/media/video/ivtv/ivtvfb.c
@@ -1125,8 +1125,7 @@ static void ivtvfb_release_buffers (struct ivtv *itv)
 		fb_dealloc_cmap(&oi->ivtvfb_info.cmap);

 	/* Release pseudo palette */
-	if (oi->ivtvfb_info.pseudo_palette)
-		kfree(oi->ivtvfb_info.pseudo_palette);
+	kfree(oi->ivtvfb_info.pseudo_palette);

 #ifdef CONFIG_MTRR
 	if (oi->fb_end_aligned_physaddr) {
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index b5f03ad..f4501dc 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -526,8 +526,7 @@ mptfc_target_destroy(struct scsi_target *starget)
 		if (ri)	/* better be! */
 			ri->starget = NULL;
 	}
-	if (starget->hostdata)
-		kfree(starget->hostdata);
+	kfree(starget->hostdata);
 	starget->hostdata = NULL;
 }

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 1abaa5d..5c81e35 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -461,8 +461,7 @@ static int mptspi_target_alloc(struct scsi_target *starget)
 static void
 mptspi_target_destroy(struct scsi_target *starget)
 {
-	if (starget->hostdata)
-		kfree(starget->hostdata);
+	kfree(starget->hostdata);
 	starget->hostdata = NULL;
 }

diff --git a/drivers/misc/sgi-xp/xpc_partition.c b/drivers/misc/sgi-xp/xpc_partition.c
index d551f09..533b386 100644
--- a/drivers/misc/sgi-xp/xpc_partition.c
+++ b/drivers/misc/sgi-xp/xpc_partition.c
@@ -98,8 +98,7 @@ xpc_get_rsvd_page_pa(int nasid)
 			len = L1_CACHE_ALIGN(len);

 		if (len > buf_len) {
-			if (buf_base != NULL)
-				kfree(buf_base);
+			kfree(buf_base);
 			buf_len = L1_CACHE_ALIGN(len);
 			buf = xpc_kmalloc_cacheline_aligned(buf_len, GFP_KERNEL,
 							    &buf_base);
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index d6ded24..8336a6f 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -204,15 +204,12 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock

 	return 0;
  free_bounce_sg:
- 	if (mq->bounce_sg)
- 		kfree(mq->bounce_sg);
+	kfree(mq->bounce_sg);
  	mq->bounce_sg = NULL;
  cleanup_queue:
- 	if (mq->sg)
-		kfree(mq->sg);
+	kfree(mq->sg);
 	mq->sg = NULL;
-	if (mq->bounce_buf)
-		kfree(mq->bounce_buf);
+	kfree(mq->bounce_buf);
 	mq->bounce_buf = NULL;
 	blk_cleanup_queue(mq->queue);
 	return ret;
@@ -235,15 +232,13 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 	blk_start_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);

- 	if (mq->bounce_sg)
- 		kfree(mq->bounce_sg);
+	kfree(mq->bounce_sg);
  	mq->bounce_sg = NULL;

 	kfree(mq->sg);
 	mq->sg = NULL;

-	if (mq->bounce_buf)
-		kfree(mq->bounce_buf);
+	kfree(mq->bounce_buf);
 	mq->bounce_buf = NULL;

 	mq->card = NULL;
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 49d9dca..cbb72f4 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -188,8 +188,7 @@ static void mmc_release_card(struct device *dev)

 	sdio_free_common_cis(card);

-	if (card->info)
-		kfree(card->info);
+	kfree(card->info);

 	kfree(card);
 }
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 4a890dc..5dda49e 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -202,8 +202,7 @@ static void sdio_release_func(struct device *dev)

 	sdio_free_func_cis(func);

-	if (func->info)
-		kfree(func->info);
+	kfree(func->info);

 	kfree(func);
 }
diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 62f3ea9..aab7b65 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -2607,8 +2607,7 @@ static void cfi_intelext_destroy(struct mtd_info *mtd)
 	kfree(cfi);
 	for (i = 0; i < mtd->numeraseregions; i++) {
 		region = &mtd->eraseregions[i];
-		if (region->lockmap)
-			kfree(region->lockmap);
+		kfree(region->lockmap);
 	}
 	kfree(mtd->eraseregions);
 }
diff --git a/drivers/mtd/maps/ck804xrom.c b/drivers/mtd/maps/ck804xrom.c
index ddb462b..bb79315 100644
--- a/drivers/mtd/maps/ck804xrom.c
+++ b/drivers/mtd/maps/ck804xrom.c
@@ -311,8 +311,7 @@ static int __devinit ck804xrom_init_one (struct pci_dev *pdev,

  out:
 	/* Free any left over map structures */
-	if (map)
-		kfree(map);
+	kfree(map);

 	/* See if I have any map structures */
 	if (list_empty(&window->maps)) {
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 268ea4d..bee1869 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -1013,10 +1013,8 @@ static void free_rings(struct net_device *dev)
 			pci_free_consistent(np->pci_dev, sizeof(struct ring_desc_ex) * (np->rx_ring_size + np->tx_ring_size),
 					    np->rx_ring.ex, np->ring_addr);
 	}
-	if (np->rx_skb)
-		kfree(np->rx_skb);
-	if (np->tx_skb)
-		kfree(np->tx_skb);
+	kfree(np->rx_skb);
+	kfree(np->tx_skb);
 }

 static int using_multi_irqs(struct net_device *dev)
@@ -4465,10 +4463,8 @@ static int nv_set_ringparam(struct net_device *dev, struct ethtool_ringparam* ri
 				pci_free_consistent(np->pci_dev, sizeof(struct ring_desc_ex) * (ring->rx_pending + ring->tx_pending),
 						    rxtx_ring, ring_addr);
 		}
-		if (rx_skbuff)
-			kfree(rx_skbuff);
-		if (tx_skbuff)
-			kfree(tx_skbuff);
+		kfree(rx_skbuff);
+		kfree(tx_skbuff);
 		goto exit;
 	}

diff --git a/drivers/net/irda/kingsun-sir.c b/drivers/net/irda/kingsun-sir.c
index cb90d64..608fa47 100644
--- a/drivers/net/irda/kingsun-sir.c
+++ b/drivers/net/irda/kingsun-sir.c
@@ -544,8 +544,8 @@ static int kingsun_probe(struct usb_interface *intf,
 	return 0;

 free_mem:
-	if (kingsun->out_buf) kfree(kingsun->out_buf);
-	if (kingsun->in_buf) kfree(kingsun->in_buf);
+	kfree(kingsun->out_buf);
+	kfree(kingsun->in_buf);
 	free_netdev(net);
 err_out1:
 	return ret;
diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 9551cbb..55085c0 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -167,8 +167,7 @@ static inline void ixgbe_disable_sriov(struct ixgbe_adapter *adapter)

 	/* take a breather then clean up driver data */
 	msleep(100);
-	if (adapter->vfinfo)
-		kfree(adapter->vfinfo);
+	kfree(adapter->vfinfo);
 	adapter->vfinfo = NULL;

 	adapter->num_vfs = 0;
diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index e0b47cc..4365156 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -4028,8 +4028,7 @@ static void myri10ge_remove(struct pci_dev *pdev)
 		mtrr_del(mgp->mtrr, mgp->iomem_base, mgp->board_span);
 #endif
 	myri10ge_free_slices(mgp);
-	if (mgp->msix_vectors != NULL)
-		kfree(mgp->msix_vectors);
+	kfree(mgp->msix_vectors);
 	dma_free_coherent(&pdev->dev, sizeof(*mgp->cmd),
 			  mgp->cmd, mgp->cmd_bus);

diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index 6ce6ce1..024e5e7 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -183,8 +183,7 @@ netxen_alloc_sds_rings(struct netxen_recv_context *recv_ctx, int count)
 static void
 netxen_free_sds_rings(struct netxen_recv_context *recv_ctx)
 {
-	if (recv_ctx->sds_rings != NULL)
-		kfree(recv_ctx->sds_rings);
+	kfree(recv_ctx->sds_rings);

 	recv_ctx->sds_rings = NULL;
 }
diff --git a/drivers/net/ppp_mppe.c b/drivers/net/ppp_mppe.c
index 6d1a1b8..8e8cf7e 100644
--- a/drivers/net/ppp_mppe.c
+++ b/drivers/net/ppp_mppe.c
@@ -238,8 +238,7 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 	return (void *)state;

 	out_free:
-	    if (state->sha1_digest)
-		kfree(state->sha1_digest);
+	    kfree(state->sha1_digest);
 	    if (state->sha1)
 		crypto_free_hash(state->sha1);
 	    if (state->arc4)
@@ -256,8 +255,7 @@ static void mppe_free(void *arg)
 {
 	struct ppp_mppe_state *state = (struct ppp_mppe_state *) arg;
 	if (state) {
-	    if (state->sha1_digest)
-		kfree(state->sha1_digest);
+	    kfree(state->sha1_digest);
 	    if (state->sha1)
 		crypto_free_hash(state->sha1);
 	    if (state->arc4)
diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index 54ebb65..3b42c57 100644
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -2749,7 +2749,7 @@ static void ql_free_buffer_queues(struct ql3_adapter *qdev)
 		       "%s: Already done.\n", qdev->ndev->name);
 		return;
 	}
-	if(qdev->lrg_buf) kfree(qdev->lrg_buf);
+	kfree(qdev->lrg_buf);
 	pci_free_consistent(qdev->pdev,
 			    qdev->lrg_buf_q_alloc_size,
 			    qdev->lrg_buf_q_alloc_virt_addr,
diff --git a/drivers/net/qlcnic/qlcnic_main.c b/drivers/net/qlcnic/qlcnic_main.c
index 23ea9ca..8222944 100644
--- a/drivers/net/qlcnic/qlcnic_main.c
+++ b/drivers/net/qlcnic/qlcnic_main.c
@@ -166,8 +166,7 @@ qlcnic_alloc_sds_rings(struct qlcnic_recv_context *recv_ctx, int count)
 static void
 qlcnic_free_sds_rings(struct qlcnic_recv_context *recv_ctx)
 {
-	if (recv_ctx->sds_rings != NULL)
-		kfree(recv_ctx->sds_rings);
+	kfree(recv_ctx->sds_rings);

 	recv_ctx->sds_rings = NULL;
 }
diff --git a/drivers/net/stmmac/stmmac_main.c b/drivers/net/stmmac/stmmac_main.c
index a31d580..df919bf 100644
--- a/drivers/net/stmmac/stmmac_main.c
+++ b/drivers/net/stmmac/stmmac_main.c
@@ -921,8 +921,7 @@ static int stmmac_release(struct net_device *dev)
 #ifdef CONFIG_STMMAC_TIMER
 	/* Stop and release the timer */
 	stmmac_close_ext_timer();
-	if (priv->tm != NULL)
-		kfree(priv->tm);
+	kfree(priv->tm);
 #endif
 	napi_disable(&priv->napi);
 	skb_queue_purge(&priv->rx_recycle);
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 9964df1..a14f8b1 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2821,8 +2821,7 @@ exit:
 		tty_unregister_device(tty_drv, serial->minor);
 		kfree(serial);
 	}
-	if (hso_dev)
-		kfree(hso_dev);
+	kfree(hso_dev);
 	return NULL;

 }
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index e0c244b..47c0faf 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -355,8 +355,7 @@ void ath5k_hw_detach(struct ath5k_hw *ah)

 	__set_bit(ATH_STAT_INVALID, ah->ah_sc->status);

-	if (ah->ah_rf_banks != NULL)
-		kfree(ah->ah_rf_banks);
+	kfree(ah->ah_rf_banks);

 	ath5k_eeprom_detach(ah);

diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index 5596540..b160d82 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -99,8 +99,7 @@ static inline void libipw_networks_free(struct libipw_device *ieee)
 	int i;

 	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
-		if (ieee->networks[i]->ibss_dfs)
-			kfree(ieee->networks[i]->ibss_dfs);
+		kfree(ieee->networks[i]->ibss_dfs);
 		kfree(ieee->networks[i]);
 	}
 }
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 78f089b..92d2fc3 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1510,8 +1510,7 @@ static inline void ezusb_delete(struct ezusb_priv *upriv)
 	mutex_unlock(&upriv->mtx);

 	kfree(upriv->read_urb->transfer_buffer);
-	if (upriv->bap_buf != NULL)
-		kfree(upriv->bap_buf);
+	kfree(upriv->bap_buf);
 	if (upriv->read_urb != NULL)
 		usb_free_urb(upriv->read_urb);
 	if (upriv->dev) {
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index be8359f..becffa2 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -506,8 +506,7 @@ out:
 		free_irq(m48t59->irq, &pdev->dev);
 	if (m48t59->ioaddr)
 		iounmap(m48t59->ioaddr);
-	if (m48t59)
-		kfree(m48t59);
+	kfree(m48t59);
 	return ret;
 }

diff --git a/drivers/s390/char/monreader.c b/drivers/s390/char/monreader.c
index 2ed3f82..b8450e1 100644
--- a/drivers/s390/char/monreader.c
+++ b/drivers/s390/char/monreader.c
@@ -174,8 +174,7 @@ static void mon_free_mem(struct mon_private *monpriv)
 	int i;

 	for (i = 0; i < MON_MSGLIM; i++)
-		if (monpriv->msg_array[i])
-			kfree(monpriv->msg_array[i]);
+		kfree(monpriv->msg_array[i]);
 	kfree(monpriv);
 }

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
index 93c8667..1ffe8fa 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -606,8 +606,7 @@ yywrap()

 	yy_delete_buffer(YY_CURRENT_BUFFER);
 	(void)fclose(yyin);
-	if (yyfilename != NULL)
-		free(yyfilename);
+	free(yyfilename);
 	yyfilename = NULL;
 	include = include_stack.slh_first;
 	if (include != NULL) {
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
index 078ed60..5b9edb6 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
@@ -95,12 +95,10 @@ symbol_delete(symbol_t *symbol)
 	case SCBLOC:
 	case SRAMLOC:
 	case REGISTER:
-		if (symbol->info.rinfo != NULL)
-			free(symbol->info.rinfo);
+		free(symbol->info.rinfo);
 		break;
 	case ALIAS:
-		if (symbol->info.ainfo != NULL)
-			free(symbol->info.ainfo);
+		free(symbol->info.ainfo);
 		break;
 	case MASK:
 	case FIELD:
@@ -113,12 +111,10 @@ symbol_delete(symbol_t *symbol)
 		break;
 	case DOWNLOAD_CONST:
 	case CONST:
-		if (symbol->info.cinfo != NULL)
-			free(symbol->info.cinfo);
+		free(symbol->info.cinfo);
 		break;
 	case LABEL:
-		if (symbol->info.linfo != NULL)
-			free(symbol->info.linfo);
+		free(symbol->info.linfo);
 		break;
 	case UNINITIALIZED:
 	default:
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 24ac231..d6b3959 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -599,8 +599,7 @@ static void asd_destroy_ha_caches(struct asd_ha_struct *asd_ha)
 	if (asd_ha->hw_prof.scb_ext)
 		asd_free_coherent(asd_ha, asd_ha->hw_prof.scb_ext);

-	if (asd_ha->hw_prof.ddb_bitmap)
-		kfree(asd_ha->hw_prof.ddb_bitmap);
+	kfree(asd_ha->hw_prof.ddb_bitmap);
 	asd_ha->hw_prof.ddb_bitmap = NULL;

 	for (i = 0; i < ASD_MAX_PHYS; i++) {
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index dcf0882..f1e44af 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1070,8 +1070,7 @@ lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
 	return 0; /* call job done later */

 job_error:
-	if (dd_data != NULL)
-		kfree(dd_data);
+	kfree(dd_data);

 	job->dd_data = NULL;
 	return rc;
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index cfeb11f..d8d4ed6 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -719,8 +719,7 @@ static void das16cs_pcmcia_detach(struct pcmcia_device *link)
 	((struct local_info_t *)link->priv)->stop = 1;
 	das16cs_pcmcia_release(link);
 	/* This points to the parent struct local_info_t struct */
-	if (link->priv)
-		kfree(link->priv);
+	kfree(link->priv);
 }				/* das16cs_pcmcia_detach */


diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 8761a6d..fb561ab 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -206,8 +206,7 @@ static void das08_pcmcia_detach(struct pcmcia_device *link)
 	das08_pcmcia_release(link);

 	/* This points to the parent struct local_info_t struct */
-	if (link->priv)
-		kfree(link->priv);
+	kfree(link->priv);

 }				/* das08_pcmcia_detach */

diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index ccee4f1..72df3d5 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -1695,10 +1695,8 @@ static int das16_detach(struct comedi_device *dev)
 		}
 		if (devpriv->dma_chan)
 			free_dma(devpriv->dma_chan);
-		if (devpriv->user_ai_range_table)
-			kfree(devpriv->user_ai_range_table);
-		if (devpriv->user_ao_range_table)
-			kfree(devpriv->user_ao_range_table);
+		kfree(devpriv->user_ai_range_table);
+		kfree(devpriv->user_ao_range_table);
 	}

 	if (dev->irq)
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 9bff34c..5a636a1 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -468,8 +468,7 @@ static int a2150_detach(struct comedi_device *dev)
 	if (devpriv) {
 		if (devpriv->dma)
 			free_dma(devpriv->dma);
-		if (devpriv->dma_buffer)
-			kfree(devpriv->dma_buffer);
+		kfree(devpriv->dma_buffer);
 	}

 	return 0;
diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 6ec77bf..701abd9 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -537,8 +537,7 @@ static void dio700_cs_detach(struct pcmcia_device *link)
 	dio700_release(link);

 	/* This points to the parent struct local_info_t struct */
-	if (link->priv)
-		kfree(link->priv);
+	kfree(link->priv);

 }				/* dio700_cs_detach */

diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index e4865b1..0b65f24 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -289,8 +289,7 @@ static void dio24_cs_detach(struct pcmcia_device *link)
 	dio24_release(link);

 	/* This points to the parent local_info_t struct */
-	if (link->priv)
-		kfree(link->priv);
+	kfree(link->priv);

 }				/* dio24_cs_detach */

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 67c8a53..2e77946 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -790,8 +790,7 @@ int labpc_common_detach(struct comedi_device *dev)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);

 	/* only free stuff if it has been allocated by _attach */
-	if (devpriv->dma_buffer)
-		kfree(devpriv->dma_buffer);
+	kfree(devpriv->dma_buffer);
 	if (devpriv->dma_chan)
 		free_dma(devpriv->dma_chan);
 	if (dev->irq)
diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index a91db6c..78eb254 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -1076,8 +1076,7 @@ static void daqp_cs_detach(struct pcmcia_device *link)

 	/* Unlink device structure, and free it */
 	dev_table[dev->table_index] = NULL;
-	if (dev)
-		kfree(dev);
+	kfree(dev);

 }				/* daqp_cs_detach */

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index 0792617..95f975c 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -632,15 +632,11 @@ static void serial_2002_open(struct comedi_device *dev)
 				s = &dev->subdevices[i];
 				s->n_chan = chan;
 				s->maxdata = 0;
-				if (s->maxdata_list) {
-					kfree(s->maxdata_list);
-				}
+				kfree(s->maxdata_list);
 				s->maxdata_list = maxdata_list =
 				    kmalloc(sizeof(unsigned int) * s->n_chan,
 					    GFP_KERNEL);
-				if (s->range_table_list) {
-					kfree(s->range_table_list);
-				}
+				kfree(s->range_table_list);
 				if (range) {
 					s->range_table = 0;
 					s->range_table_list = range_table_list =
@@ -881,12 +877,8 @@ static int serial2002_detach(struct comedi_device *dev)
 	printk("comedi%d: serial2002: remove\n", dev->minor);
 	for (i = 0; i < 4; i++) {
 		s = &dev->subdevices[i];
-		if (s->maxdata_list) {
-			kfree(s->maxdata_list);
-		}
-		if (s->range_table_list) {
-			kfree(s->range_table_list);
-		}
+		kfree(s->maxdata_list);
+		kfree(s->range_table_list);
 	}
 	return 0;
 }
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index a4ec891..da77bc6 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -435,8 +435,7 @@ static void __devexit chd_dec_release_chdev(struct crystalhd_adp *adp)
 	/* Clear iodata pool.. */
 	do {
 		temp = chd_dec_alloc_iodata(adp, 0);
-		if (temp)
-			kfree(temp);
+		kfree(temp);
 	} while (temp);

 	crystalhd_delete_elem_pool(adp);
diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index eb39d13..6a1b4a8 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -248,8 +248,7 @@ void cx25821_stop_upstream_audio(struct cx25821_dev *dev)
 		dev->_irq_audio_queues = NULL;
 	}

-	if (dev->_audiofilename != NULL)
-		kfree(dev->_audiofilename);
+	kfree(dev->_audiofilename);
 }

 void cx25821_free_mem_upstream_audio(struct cx25821_dev *dev)
diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index 343df66..ce381fc 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -235,8 +235,7 @@ void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
 		dev->_irq_queues_ch2 = NULL;
 	}

-	if (dev->_filename_ch2 != NULL)
-		kfree(dev->_filename_ch2);
+	kfree(dev->_filename_ch2);

 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp & 0xFFFFFE00);
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 7a3dad9..f6f41f3 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -283,8 +283,7 @@ void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev)
 		dev->_irq_queues = NULL;
 	}

-	if (dev->_filename != NULL)
-		kfree(dev->_filename);
+	kfree(dev->_filename);

 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp & 0xFFFFFE00);
diff --git a/drivers/staging/dream/camera/msm_vfe7x.c b/drivers/staging/dream/camera/msm_vfe7x.c
index 198656a..f3e93dd 100644
--- a/drivers/staging/dream/camera/msm_vfe7x.c
+++ b/drivers/staging/dream/camera/msm_vfe7x.c
@@ -680,8 +680,7 @@ config_send:
 				cmd_data, vfecmd->length);

 config_done:
-	if (cmd_data_alloc != NULL)
-		kfree(cmd_data_alloc);
+	kfree(cmd_data_alloc);

 config_failure:
 	kfree(scfg);
diff --git a/drivers/staging/go7007/go7007-usb.c b/drivers/staging/go7007/go7007-usb.c
index 20ed930..5918adf 100644
--- a/drivers/staging/go7007/go7007-usb.c
+++ b/drivers/staging/go7007/go7007-usb.c
@@ -1247,15 +1247,13 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 		vurb = usb->video_urbs[i];
 		if (vurb) {
 			usb_kill_urb(vurb);
-			if (vurb->transfer_buffer)
-				kfree(vurb->transfer_buffer);
+			kfree(vurb->transfer_buffer);
 			usb_free_urb(vurb);
 		}
 		aurb = usb->audio_urbs[i];
 		if (aurb) {
 			usb_kill_urb(aurb);
-			if (aurb->transfer_buffer)
-				kfree(aurb->transfer_buffer);
+			kfree(aurb->transfer_buffer);
 			usb_free_urb(aurb);
 		}
 	}
diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
index 8c8d1c2..dbec44d 100644
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -603,11 +603,9 @@ void pohmelfs_config_exit(void)

 		list_del(&g->group_entry);

-		if (g->hash_string)
-			kfree(g->hash_string);
+		kfree(g->hash_string);

-		if (g->cipher_string)
-			kfree(g->cipher_string);
+		kfree(g->cipher_string);

 		kfree(g);
 	}
diff --git a/drivers/staging/rt2860/common/spectrum.c b/drivers/staging/rt2860/common/spectrum.c
index 2d5f847..bc94679 100644
--- a/drivers/staging/rt2860/common/spectrum.c
+++ b/drivers/staging/rt2860/common/spectrum.c
@@ -416,8 +416,7 @@ void MeasureReqTabExit(struct rt_rtmp_adapter *pAd)
 {
 	NdisFreeSpinLock(&pAd->CommonCfg.MeasureReqTabLock);

-	if (pAd->CommonCfg.pMeasureReqTab)
-		kfree(pAd->CommonCfg.pMeasureReqTab);
+	kfree(pAd->CommonCfg.pMeasureReqTab);
 	pAd->CommonCfg.pMeasureReqTab = NULL;

 	return;
@@ -614,8 +613,7 @@ void TpcReqTabExit(struct rt_rtmp_adapter *pAd)
 {
 	NdisFreeSpinLock(&pAd->CommonCfg.TpcReqTabLock);

-	if (pAd->CommonCfg.pTpcReqTab)
-		kfree(pAd->CommonCfg.pTpcReqTab);
+	kfree(pAd->CommonCfg.pTpcReqTab);
 	pAd->CommonCfg.pTpcReqTab = NULL;

 	return;
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index 0029b2d..a21d2d6 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -242,8 +242,7 @@ void RTMPFreeAdapter(struct rt_rtmp_adapter *pAd)

 	os_cookie = (struct os_cookie *)pAd->OS_Cookie;

-	if (pAd->BeaconBuf)
-		kfree(pAd->BeaconBuf);
+	kfree(pAd->BeaconBuf);

 	NdisFreeSpinLock(&pAd->MgmtRingLock);

@@ -265,8 +264,7 @@ void RTMPFreeAdapter(struct rt_rtmp_adapter *pAd)
 	release_firmware(pAd->firmware);

 	vfree(pAd);		/* pci_free_consistent(os_cookie->pci_dev,sizeof(struct rt_rtmp_adapter),pAd,os_cookie->pAd_pa); */
-	if (os_cookie)
-		kfree(os_cookie);
+	kfree(os_cookie);
 }

 BOOLEAN OS_Need_Clone_Packet(void)
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 1b838a2..cad25e0 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -2604,8 +2604,7 @@ void ieee80211_softmac_free(struct ieee80211_device *ieee)
 	cancel_delayed_work(&ieee->GPIOChangeRFWorkItem);

 	destroy_workqueue(ieee->wq);
-	if(NULL != ieee->pDot11dInfo)
-		kfree(ieee->pDot11dInfo);
+	kfree(ieee->pDot11dInfo);
 	up(&ieee->wx_sem);
 }

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
index 07d8dbc..ca414a9 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -735,7 +735,6 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 		ieee->wpa_ie_len = len;
 	}
 	else{
-		if (ieee->wpa_ie)
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = NULL;
 		ieee->wpa_ie_len = 0;
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
index 4971b1c..d3fa83f 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
@@ -987,7 +987,6 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 		ieee->wpa_ie_len = len;
 	}
 	else{
-		if (ieee->wpa_ie)
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = NULL;
 		ieee->wpa_ie_len = 0;
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
index 2ce5bd5..42f699b 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
@@ -775,7 +775,6 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 		ieee->wpa_ie_len = len;
 	}
 	else{
-		if (ieee->wpa_ie)
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = NULL;
 		ieee->wpa_ie_len = 0;
diff --git a/drivers/staging/rtl8192u/ieee80211/cipher.c b/drivers/staging/rtl8192u/ieee80211/cipher.c
index 0b9e8a4..69dcc31 100644
--- a/drivers/staging/rtl8192u/ieee80211/cipher.c
+++ b/drivers/staging/rtl8192u/ieee80211/cipher.c
@@ -294,6 +294,5 @@ out:

 void crypto_exit_cipher_ops(struct crypto_tfm *tfm)
 {
-	if (tfm->crt_cipher.cit_iv)
-		kfree(tfm->crt_cipher.cit_iv);
+	kfree(tfm->crt_cipher.cit_iv);
 }
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
index fb78ed2..48ec8fc 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -855,7 +855,6 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 		ieee->wpa_ie_len = len;
 	}
 	else{
-		if (ieee->wpa_ie)
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = NULL;
 		ieee->wpa_ie_len = 0;
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 2bede27..f0e4dd7 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2260,12 +2260,8 @@ short rtl8192_usb_initendpoints(struct net_device *dev)


 destroy:
-	if (priv->pp_rxskb) {
-		kfree(priv->pp_rxskb);
-	}
-	if (priv->rx_urb) {
-		kfree(priv->rx_urb);
-	}
+	kfree(priv->pp_rxskb);
+	kfree(priv->rx_urb);

 	priv->pp_rxskb = NULL;
 	priv->rx_urb = NULL;
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 27841ef..2be2d88 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -1098,8 +1098,7 @@ static void qt_close(struct usb_serial_port *port)

 	if (qt_port->write_urb) {
 		/* if this urb had a transfer buffer already (old tx) free it */
-		if (qt_port->write_urb->transfer_buffer != NULL)
-			kfree(qt_port->write_urb->transfer_buffer);
+		kfree(qt_port->write_urb->transfer_buffer);
 		usb_free_urb(qt_port->write_urb);
 	}

diff --git a/drivers/staging/ti-st/bt_drv.c b/drivers/staging/ti-st/bt_drv.c
index d8420b5..91d18f8 100644
--- a/drivers/staging/ti-st/bt_drv.c
+++ b/drivers/staging/ti-st/bt_drv.c
@@ -376,8 +376,7 @@ static void hci_st_destruct(struct hci_dev *hdev)
 	BT_DRV_DBG("%s", hdev->name);

 	/* free hci_st memory */
-	if (hdev->driver_data != NULL)
-		kfree(hdev->driver_data);
+	kfree(hdev->driver_data);

 	BTDRV_API_EXIT(0);
 	return;
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index 6665cef..1d606bd 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -224,11 +224,9 @@ void stub_device_cleanup_urbs(struct stub_device *sdev)

 		kmem_cache_free(stub_priv_cache, priv);

-		if (urb->transfer_buffer != NULL)
-			kfree(urb->transfer_buffer);
+		kfree(urb->transfer_buffer);

-		if (urb->setup_packet != NULL)
-			kfree(urb->setup_packet);
+		kfree(urb->setup_packet);

 		usb_free_urb(urb);
 	}
diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 0c82eb4..58e0b92 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -516,8 +516,7 @@ static int ca91cx42_alloc_resource(struct vme_master_resource *image,
 	if (existing_size != 0) {
 		iounmap(image->kern_base);
 		image->kern_base = NULL;
-		if (image->bus_resource.name != NULL)
-			kfree(image->bus_resource.name);
+		kfree(image->bus_resource.name);
 		release_resource(&(image->bus_resource));
 		memset(&(image->bus_resource), 0, sizeof(struct resource));
 	}
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index abe88a3..7ea2981 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -817,8 +817,7 @@ static int tsi148_alloc_resource(struct vme_master_resource *image,
 	if (existing_size != 0) {
 		iounmap(image->kern_base);
 		image->kern_base = NULL;
-		if (image->bus_resource.name != NULL)
-			kfree(image->bus_resource.name);
+		kfree(image->bus_resource.name);
 		release_resource(&(image->bus_resource));
 		memset(&(image->bus_resource), 0, sizeof(struct resource));
 	}
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index e49bb25..eae6586 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -3059,8 +3059,7 @@ else {
 }

 error1:
-  if(buffer)
-  	 kfree(buffer);
+  kfree(buffer);

   if(filp_close(filp,NULL))
        printk("Config_FileOperation:close file fail\n");
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index 195cc36..8cb5836 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -860,8 +860,7 @@ int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 	}

  out:
-	if (param != NULL)
-		kfree(param);
+	kfree(param);

 	return ret;
 }
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 22c2fab..7d30d80 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -982,8 +982,7 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 	}

 out:
-	if (param != NULL)
-		kfree(param);
+	kfree(param);

 	return ret;
 }
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index e1f96d7..8df200c 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -803,16 +803,14 @@ FIRMWAREbDownload(

             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Download firmware...%d %zu\n", ii, sizeof(abyFirmware));
             if (NdisStatus != STATUS_SUCCESS) {
-                if (pBuffer)
-                    kfree(pBuffer);
+                kfree(pBuffer);
                 spin_lock_irq(&pDevice->lock);
                 return (FALSE);
             }
         }
     }

-    if (pBuffer)
-        kfree(pBuffer);
+    kfree(pBuffer);

     spin_lock_irq(&pDevice->lock);
     return (TRUE);
diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index f70e922..51b5adf 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -858,8 +858,7 @@ int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 	}

  out:
-	if (param != NULL)
-		kfree(param);
+	kfree(param);

 	return ret;
 }
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 098b045..344c245 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -858,8 +858,7 @@ static void device_free_tx_bufs(PSDevice pDevice)
             usb_kill_urb(pTxContext->pUrb);
             usb_free_urb(pTxContext->pUrb);
         }
-        if (pTxContext)
-            kfree(pTxContext);
+        kfree(pTxContext);
     }
     return;
 }
@@ -882,8 +881,7 @@ static void device_free_rx_bufs(PSDevice pDevice)
         if (pRCB->skb)
             dev_kfree_skb(pRCB->skb);
     }
-    if (pDevice->pRCBMem)
-        kfree(pDevice->pRCBMem);
+    kfree(pDevice->pRCBMem);

     return;
 }
@@ -900,8 +898,7 @@ static void usb_device_reset(PSDevice pDevice)

 static void device_free_int_bufs(PSDevice pDevice)
 {
-    if (pDevice->intBuf.pDataBuf != NULL)
-        kfree(pDevice->intBuf.pDataBuf);
+    kfree(pDevice->intBuf.pDataBuf);
     return;
 }

@@ -1542,8 +1539,7 @@ error2:
   */

 if(result!=0) {
-    if(buffer)
-  	 kfree(buffer);
+    kfree(buffer);
     buffer=NULL;
 }
   return buffer;
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 961f583..3522b9b 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -1003,8 +1003,7 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 	}

 out:
-	if (param != NULL)
-		kfree(param);
+	kfree(param);

 	return ret;
 }
diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index 7707223..72ed8b5 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -67,8 +67,7 @@ unsigned char Wb35Reg_BurstWrite(struct hw_data *pHwData, u16 RegisterNo, u32 *p
 	} else {
 		if (urb)
 			usb_free_urb(urb);
-		if (reg_queue)
-			kfree(reg_queue);
+		kfree(reg_queue);
 		return false;
 	}
    return false;
diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index d20c879..3446a9d 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -444,8 +444,7 @@ void free_chunks(imgchunk_t *fchunk, unsigned int *nfchunks)
 {
 	int i;
 	for (i = 0; i < *nfchunks; i++) {
-		if (fchunk[i].data != NULL)
-			kfree(fchunk[i].data);
+		kfree(fchunk[i].data);
 	}
 	*nfchunks = 0;
 	memset(fchunk, 0, sizeof(*fchunk));
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index f8424d1..382738b 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1215,9 +1215,7 @@ static void mos7840_close(struct usb_serial_port *port)
 	/* Freeing Write URBs */
 	for (j = 0; j < NUM_URBS; ++j) {
 		if (mos7840_port->write_urb_pool[j]) {
-			if (mos7840_port->write_urb_pool[j]->transfer_buffer)
-				kfree(mos7840_port->write_urb_pool[j]->
-				      transfer_buffer);
+			kfree(mos7840_port->write_urb_pool[j]->transfer_buffer);

 			usb_free_urb(mos7840_port->write_urb_pool[j]);
 		}
@@ -1254,8 +1252,7 @@ static void mos7840_close(struct usb_serial_port *port)

 	if (mos7840_port->write_urb) {
 		/* if this urb had a transfer buffer already (old tx) free it */
-		if (mos7840_port->write_urb->transfer_buffer != NULL)
-			kfree(mos7840_port->write_urb->transfer_buffer);
+		kfree(mos7840_port->write_urb->transfer_buffer);
 		usb_free_urb(mos7840_port->write_urb);
 	}

diff --git a/drivers/uwb/wlp/wlp-lc.c b/drivers/uwb/wlp/wlp-lc.c
index 7f6a630..80d6ce8 100644
--- a/drivers/uwb/wlp/wlp-lc.c
+++ b/drivers/uwb/wlp/wlp-lc.c
@@ -539,8 +539,7 @@ void wlp_remove(struct wlp *wlp)
 	uwb_notifs_deregister(wlp->rc, &wlp->uwb_notifs_handler);
 	wlp_eda_release(&wlp->eda);
 	mutex_lock(&wlp->mutex);
-	if (wlp->dev_info != NULL)
-		kfree(wlp->dev_info);
+	kfree(wlp->dev_info);
 	mutex_unlock(&wlp->mutex);
 	wlp->rc = NULL;
 }
diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
index e77e8e4..58e689b 100644
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1709,8 +1709,7 @@ failed:
 				fbdev->fb_mem, fbdev->fb_phys);
 	if (fbdev->fb_info.cmap.len != 0)
 		fb_dealloc_cmap(&fbdev->fb_info.cmap);
-	if (fbdev->fb_info.pseudo_palette)
-		kfree(fbdev->fb_info.pseudo_palette);
+	kfree(fbdev->fb_info.pseudo_palette);
 	if (plane == 0)
 		free_irq(AU1200_LCD_INT, (void*)dev);
 	return ret;
@@ -1739,8 +1738,7 @@ static int au1200fb_drv_remove(struct platform_device *dev)
 					fbdev->fb_mem, fbdev->fb_phys);
 		if (fbdev->fb_info.cmap.len != 0)
 			fb_dealloc_cmap(&fbdev->fb_info.cmap);
-		if (fbdev->fb_info.pseudo_palette)
-			kfree(fbdev->fb_info.pseudo_palette);
+		kfree(fbdev->fb_info.pseudo_palette);
 	}

 	free_irq(AU1200_LCD_INT, (void *)dev);
diff --git a/drivers/video/console/softcursor.c b/drivers/video/console/softcursor.c
index 25f835b..46dd8f5 100644
--- a/drivers/video/console/softcursor.c
+++ b/drivers/video/console/softcursor.c
@@ -35,8 +35,7 @@ int soft_cursor(struct fb_info *info, struct fb_cursor *cursor)
 	dsize = s_pitch * cursor->image.height;

 	if (dsize + sizeof(struct fb_image) != ops->cursor_size) {
-		if (ops->cursor_src != NULL)
-			kfree(ops->cursor_src);
+		kfree(ops->cursor_src);
 		ops->cursor_size = dsize + sizeof(struct fb_image);

 		ops->cursor_src = kmalloc(ops->cursor_size, GFP_ATOMIC);
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 7b8839e..23194af 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -236,8 +236,7 @@ out:
 static void uvesafb_free(struct uvesafb_ktask *task)
 {
 	if (task) {
-		if (task->done)
-			kfree(task->done);
+		kfree(task->done);
 		kfree(task);
 	}
 }
@@ -1319,8 +1318,7 @@ setmode:
 				FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
 	info->fix.line_length = mode->bytes_per_scan_line;

-out:	if (crtc != NULL)
-		kfree(crtc);
+out:	kfree(crtc);
 	uvesafb_free(task);

 	return err;
@@ -1797,8 +1795,7 @@ out_mode:
 	fb_destroy_modedb(info->monspecs.modedb);
 	fb_dealloc_cmap(&info->cmap);
 out:
-	if (par->vbe_modes)
-		kfree(par->vbe_modes);
+	kfree(par->vbe_modes);

 	framebuffer_release(info);
 	return err;
@@ -1820,12 +1817,9 @@ static int uvesafb_remove(struct platform_device *dev)
 		fb_dealloc_cmap(&info->cmap);

 		if (par) {
-			if (par->vbe_modes)
-				kfree(par->vbe_modes);
-			if (par->vbe_state_orig)
-				kfree(par->vbe_state_orig);
-			if (par->vbe_state_saved)
-				kfree(par->vbe_state_saved);
+			kfree(par->vbe_modes);
+			kfree(par->vbe_state_orig);
+			kfree(par->vbe_state_saved);
 		}

 		framebuffer_release(info);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index f488fac..feea513 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -598,8 +598,7 @@ new_bitmap:

 out:
 	if (info) {
-		if (info->bitmap)
-			kfree(info->bitmap);
+		kfree(info->bitmap);
 		kfree(info);
 	}

@@ -904,8 +903,7 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 	while ((node = rb_last(&block_group->free_space_offset)) != NULL) {
 		info = rb_entry(node, struct btrfs_free_space, offset_index);
 		unlink_free_space(block_group, info);
-		if (info->bitmap)
-			kfree(info->bitmap);
+		kfree(info->bitmap);
 		kfree(info);
 		if (need_resched()) {
 			spin_unlock(&block_group->tree_lock);
diff --git a/fs/ceph/crush/crush.c b/fs/ceph/crush/crush.c
index fabd302..acc0a08 100644
--- a/fs/ceph/crush/crush.c
+++ b/fs/ceph/crush/crush.c
@@ -4,7 +4,7 @@
 #else
 # include <stdlib.h>
 # include <assert.h>
-# define kfree(x) do { if (x) free(x); } while (0)
+# define kfree(x) free(x)
 # define BUG_ON(x) assert(!(x))
 #endif

diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index 8e0d00d..6f1edc7 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -82,8 +82,7 @@ void dlm_free_lkb(struct dlm_lkb *lkb)
 		struct dlm_user_args *ua;
 		ua = lkb->lkb_ua;
 		if (ua) {
-			if (ua->lksb.sb_lvbptr)
-				kfree(ua->lksb.sb_lvbptr);
+			kfree(ua->lksb.sb_lvbptr);
 			kfree(ua);
 		}
 	}
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 89c5476..fadc03c 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1077,8 +1077,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 				  crypt_stat->key_size);
 	}
 out:
-	if (msg)
-		kfree(msg);
+	kfree(msg);
 	return rc;
 }

diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index 2d8dbce..a74dd34 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -97,8 +97,7 @@ static void ecryptfs_msg_ctx_free_to_alloc(struct ecryptfs_msg_ctx *msg_ctx)
 void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx)
 {
 	list_move(&(msg_ctx->node), &ecryptfs_msg_ctx_free_list);
-	if (msg_ctx->msg)
-		kfree(msg_ctx->msg);
+	kfree(msg_ctx->msg);
 	msg_ctx->msg = NULL;
 	msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_FREE;
 }
@@ -541,8 +540,7 @@ void ecryptfs_release_messaging(void)
 		mutex_lock(&ecryptfs_msg_ctx_lists_mux);
 		for (i = 0; i < ecryptfs_message_buf_len; i++) {
 			mutex_lock(&ecryptfs_msg_ctx_arr[i].mux);
-			if (ecryptfs_msg_ctx_arr[i].msg)
-				kfree(ecryptfs_msg_ctx_arr[i].msg);
+			kfree(ecryptfs_msg_ctx_arr[i].msg);
 			mutex_unlock(&ecryptfs_msg_ctx_arr[i].mux);
 		}
 		kfree(ecryptfs_msg_ctx_arr);
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index a33aab6..39d0cbf 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -190,8 +190,7 @@ static struct posix_acl *jffs2_get_acl(struct inode *inode, int type)
 	} else {
 		acl = ERR_PTR(rc);
 	}
-	if (value)
-		kfree(value);
+	kfree(value);
 	if (!IS_ERR(acl))
 		set_cached_acl(inode, type, acl);
 	return acl;
diff --git a/fs/jffs2/scan.c b/fs/jffs2/scan.c
index 46f870d..54a9044 100644
--- a/fs/jffs2/scan.c
+++ b/fs/jffs2/scan.c
@@ -272,8 +272,7 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 	else
 		c->mtd->unpoint(c->mtd, 0, c->mtd->size);
 #endif
-	if (s)
-		kfree(s);
+	kfree(s);

 	return ret;
 }
diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index a2d58c9..6776207 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -744,8 +744,7 @@ void jffs2_clear_xattr_subsystem(struct jffs2_sb_info *c)
 	for (i=0; i < XATTRINDEX_HASHSIZE; i++) {
 		list_for_each_entry_safe(xd, _xd, &c->xattrindex[i], xindex) {
 			list_del(&xd->xindex);
-			if (xd->xname)
-				kfree(xd->xname);
+			kfree(xd->xname);
 			jffs2_free_xattr_datum(xd);
 		}
 	}
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 70015dd..dd50876 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2260,8 +2260,7 @@ static int nfs4_get_referral(struct inode *dir, const struct qstr *name, struct
 out:
 	if (page)
 		__free_page(page);
-	if (locations)
-		kfree(locations);
+	kfree(locations);
 	return status;
 }

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 215e12c..f91b59e 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6778,8 +6778,7 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 		mlog_errno(ret);

 out:
-	if (pages)
-		kfree(pages);
+	kfree(pages);

 	return ret;
 }
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 41d5f1f..6ca0b69 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1060,8 +1060,7 @@ static void o2hb_region_release(struct config_item *item)
 	struct page *page;
 	struct o2hb_region *reg = to_o2hb_region(item);

-	if (reg->hr_tmp_block)
-		kfree(reg->hr_tmp_block);
+	kfree(reg->hr_tmp_block);

 	if (reg->hr_slot_data) {
 		for (i = 0; i < reg->hr_num_pages; i++) {
@@ -1075,8 +1074,7 @@ static void o2hb_region_release(struct config_item *item)
 	if (reg->hr_bdev)
 		blkdev_put(reg->hr_bdev, FMODE_READ|FMODE_WRITE);

-	if (reg->hr_slots)
-		kfree(reg->hr_slots);
+	kfree(reg->hr_slots);

 	spin_lock(&o2hb_live_lock);
 	list_del(&reg->hr_all_item);
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index aa75ca3..915d462 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1083,10 +1083,8 @@ out:
 	o2net_debug_del_nst(&nst); /* must be before dropping sc and node */
 	if (sc)
 		sc_put(sc);
-	if (vec)
-		kfree(vec);
-	if (msg)
-		kfree(msg);
+	kfree(vec);
+	kfree(msg);
 	o2net_complete_nsw(nn, &nsw, 0, 0, 0);
 	return ret;
 }
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 6b5a492..e1de97c 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -306,8 +306,7 @@ static void dlm_free_ctxt_mem(struct dlm_ctxt *dlm)
 	if (dlm->master_hash)
 		dlm_free_pagevec((void **)dlm->master_hash, DLM_HASH_PAGES);

-	if (dlm->name)
-		kfree(dlm->name);
+	kfree(dlm->name);

 	kfree(dlm);
 }
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index f8b75ce..e2a82c2 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1492,10 +1492,8 @@ leave:

 	dlm_put(dlm);
 	if (ret < 0) {
-		if (buf)
-			kfree(buf);
-		if (item)
-			kfree(item);
+		kfree(buf);
+		kfree(item);
 	}

 	mlog_exit(ret);
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 09e3fdf..5f2a184 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -282,8 +282,7 @@ search:
 	spin_unlock(&oi->ip_lock);

 out:
-	if (new_emi)
-		kfree(new_emi);
+	kfree(new_emi);
 }

 static int ocfs2_last_eb_is_empty(struct inode *inode,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 47878cf..682f6a0 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1276,11 +1276,9 @@ static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
 		/* Though we wish to avoid it, we are in fact safe in
 		 * skipping local alloc cleanup as fsck.ocfs2 is more
 		 * than capable of reclaiming unused space. */
-		if (la_dinode)
-			kfree(la_dinode);
+		kfree(la_dinode);

-		if (tl_dinode)
-			kfree(tl_dinode);
+		kfree(tl_dinode);

 		if (qrec)
 			ocfs2_free_quota_recovery(qrec);
@@ -1452,8 +1450,7 @@ bail:

 	mutex_unlock(&osb->recovery_lock);

-	if (rm_quota)
-		kfree(rm_quota);
+	kfree(rm_quota);

 	mlog_exit(status);
 	/* no one is callint kthread_stop() for us so the kthread() api
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 3d74196..c8c5a75 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -473,8 +473,7 @@ out:
 	if (local_alloc_inode)
 		iput(local_alloc_inode);

-	if (alloc_copy)
-		kfree(alloc_copy);
+	kfree(alloc_copy);

 	mlog_exit_void();
 }
@@ -1311,8 +1310,7 @@ bail:
 	if (main_bm_inode)
 		iput(main_bm_inode);

-	if (alloc_copy)
-		kfree(alloc_copy);
+	kfree(alloc_copy);

 	if (ac)
 		ocfs2_free_alloc_context(ac);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2c26ce2..f021a5f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2451,8 +2451,7 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 		mlog_errno(status);

 finally:
-	if (local_alloc)
-		kfree(local_alloc);
+	kfree(local_alloc);

 	mlog_exit(status);
 	return status;
@@ -2480,8 +2479,7 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 	 * we free it here.
 	 */
 	kfree(osb->journal);
-	if (osb->local_alloc_copy)
-		kfree(osb->local_alloc_copy);
+	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
 	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
 	memset(osb, 0, sizeof(struct ocfs2_super));
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 32d15bd..2c8796a 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -56,8 +56,7 @@ static inline void nf_ct_ext_destroy(struct nf_conn *ct)
  */
 static inline void nf_ct_ext_free(struct nf_conn *ct)
 {
-	if (ct->ext)
-		kfree(ct->ext);
+	kfree(ct->ext);
 }

 /* Add this type, returns pointer to data or NULL. */
diff --git a/net/caif/cfctrl.c b/net/caif/cfctrl.c
index 0ffe1e1..72b41eb 100644
--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -587,8 +587,7 @@ static int cfctrl_recv(struct cflayer *layer, struct cfpkt *pkt)
 							  client_layer : NULL);
 			}

-			if (req != NULL)
-				kfree(req);
+			kfree(req);
 		}
 		break;
 	case CFCTRL_CMD_LINK_DESTROY:
diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 6ac3c54..adc492a 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -231,9 +231,7 @@ static void node_is_down(struct publication *publ)
 		    publ->type, publ->lower, publ->node, publ->ref, publ->key);
 	}

-	if (p) {
-		kfree(p);
-	}
+	kfree(p);
 }

 /**
diff --git a/scripts/dtc/data.c b/scripts/dtc/data.c
index fe555e8..8373df0 100644
--- a/scripts/dtc/data.c
+++ b/scripts/dtc/data.c
@@ -32,8 +32,7 @@ void data_free(struct data d)
 		m = nm;
 	}

-	if (d.val)
-		free(d.val);
+	free(d.val);
 }

 struct data data_grow_for(struct data d, int xlen)
diff --git a/scripts/genksyms/lex.c_shipped b/scripts/genksyms/lex.c_shipped
index 2ac23bc..571cabd 100644
--- a/scripts/genksyms/lex.c_shipped
+++ b/scripts/genksyms/lex.c_shipped
@@ -2311,8 +2311,7 @@ repeat:

       /* Save the filename and line number for later error messages.  */

-      if (cur_filename)
-	free(cur_filename);
+      free(cur_filename);

       file = strchr(yytext, '\"')+1;
       e = strchr(file, '\"');
diff --git a/scripts/genksyms/lex.l b/scripts/genksyms/lex.l
index fe50ff9..b120089 100644
--- a/scripts/genksyms/lex.l
+++ b/scripts/genksyms/lex.l
@@ -151,8 +151,7 @@ repeat:

       /* Save the filename and line number for later error messages.  */

-      if (cur_filename)
-	free(cur_filename);
+      free(cur_filename);

       file = strchr(yytext, '\"')+1;
       e = strchr(file, '\"');
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c4dec80..884058d 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -206,8 +206,7 @@ load:
 		case S_INT:
 		case S_HEX:
 		case S_STRING:
-			if (sym->def[def].val)
-				free(sym->def[def].val);
+			free(sym->def[def].val);
 		default:
 			sym->def[def].val = NULL;
 			sym->def[def].tri = no;
diff --git a/scripts/kconfig/util.c b/scripts/kconfig/util.c
index 25d1ec4..f201f8a 100644
--- a/scripts/kconfig/util.c
+++ b/scripts/kconfig/util.c
@@ -94,8 +94,7 @@ struct gstr str_assign(const char *s)
 /* Free storage for growable string */
 void str_free(struct gstr *gs)
 {
-	if (gs->s)
-		free(gs->s);
+	free(gs->s);
 	gs->s = NULL;
 	gs->len = 0;
 }
diff --git a/sound/aoa/codecs/onyx.c b/sound/aoa/codecs/onyx.c
index 91852e4..ca7f9bc 100644
--- a/sound/aoa/codecs/onyx.c
+++ b/sound/aoa/codecs/onyx.c
@@ -1112,8 +1112,7 @@ static int onyx_i2c_remove(struct i2c_client *client)

 	aoa_codec_unregister(&onyx->codec);
 	of_node_put(onyx->codec.node);
-	if (onyx->codec_info)
-		kfree(onyx->codec_info);
+	kfree(onyx->codec_info);
 	i2c_set_clientdata(client, onyx);
 	kfree(onyx);
 	return 0;
diff --git a/sound/core/control.c b/sound/core/control.c
index 070aab4..2a66e57 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -946,8 +946,7 @@ static int snd_ctl_elem_user_tlv(struct snd_kcontrol *kcontrol,
 static void snd_ctl_elem_user_free(struct snd_kcontrol *kcontrol)
 {
 	struct user_element *ue = kcontrol->private_data;
-	if (ue->tlv_data)
-		kfree(ue->tlv_data);
+	kfree(ue->tlv_data);
 	kfree(ue);
 }

diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index cbe815d..bb4bd8e 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -920,8 +920,7 @@ void snd_pcm_detach_substream(struct snd_pcm_substream *substream)
 		       PAGE_ALIGN(sizeof(struct snd_pcm_mmap_control)));
 	kfree(runtime->hw_constraints.rules);
 #ifdef CONFIG_SND_PCM_XRUN_DEBUG
-	if (runtime->hwptr_log)
-		kfree(runtime->hwptr_log);
+	kfree(runtime->hwptr_log);
 #endif
 	kfree(runtime);
 	substream->runtime = NULL;
diff --git a/sound/pci/asihpi/hpifunc.c b/sound/pci/asihpi/hpifunc.c
index eda26b3..b4bddce 100644
--- a/sound/pci/asihpi/hpifunc.c
+++ b/sound/pci/asihpi/hpifunc.c
@@ -3266,8 +3266,7 @@ u16 hpi_entity_find_next(struct hpi_entity *container_entity,

 void hpi_entity_free(struct hpi_entity *entity)
 {
-	if (entity != NULL)
-		kfree(entity);
+	kfree(entity);
 }

 static u16 hpi_entity_alloc_and_copy(struct hpi_entity *src,
diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index af56eb9..0bc1c8e 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -583,10 +583,8 @@ static int get_daio_rsc(struct daio_mgr *mgr,
 	return 0;

 error:
-	if (dao)
-		kfree(dao);
-	else if (dai)
-		kfree(dai);
+	kfree(dao);
+	kfree(dai);

 	spin_lock_irqsave(&mgr->mgr_lock, flags);
 	daio_mgr_put_rsc(&mgr->mgr, desc->type);
diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
index 4b302d8..7b7e57b 100644
--- a/sound/pci/emu10k1/emufx.c
+++ b/sound/pci/emu10k1/emufx.c
@@ -768,8 +768,7 @@ static void snd_emu10k1_ctl_private_free(struct snd_kcontrol *kctl)
 	kctl->private_value = 0;
 	list_del(&ctl->list);
 	kfree(ctl);
-	if (kctl->tlv.p)
-		kfree(kctl->tlv.p);
+	kfree(kctl->tlv.p);
 }

 static int snd_emu10k1_add_controls(struct snd_emu10k1 *emu,
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index a3d638c..b14a40d 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -510,8 +510,7 @@ static int snd_hda_bus_free(struct hda_bus *bus)
 		return 0;
 	if (bus->workq)
 		flush_workqueue(bus->workq);
-	if (bus->unsol)
-		kfree(bus->unsol);
+	kfree(bus->unsol);
 	list_for_each_entry_safe(codec, n, &bus->codec_list, list) {
 		snd_hda_codec_free(codec);
 	}
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 914c670..b8effd0 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -847,8 +847,7 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 error:
 	pr_debug("Failed to synthesize perf probe point: %s",
 		 strerror(-ret));
-	if (buf)
-		free(buf);
+	free(buf);
 	return NULL;
 }

@@ -1028,34 +1027,24 @@ void clear_perf_probe_event(struct perf_probe_event *pev)
 	struct perf_probe_arg_field *field, *next;
 	int i;

-	if (pev->event)
-		free(pev->event);
-	if (pev->group)
-		free(pev->group);
-	if (pp->file)
-		free(pp->file);
-	if (pp->function)
-		free(pp->function);
-	if (pp->lazy_line)
-		free(pp->lazy_line);
+	free(pev->event);
+	free(pev->group);
+	free(pp->file);
+	free(pp->function);
+	free(pp->lazy_line);
 	for (i = 0; i < pev->nargs; i++) {
-		if (pev->args[i].name)
-			free(pev->args[i].name);
-		if (pev->args[i].var)
-			free(pev->args[i].var);
-		if (pev->args[i].type)
-			free(pev->args[i].type);
+		free(pev->args[i].name);
+		free(pev->args[i].var);
+		free(pev->args[i].type);
 		field = pev->args[i].field;
 		while (field) {
 			next = field->next;
-			if (field->name)
-				free(field->name);
+			free(field->name);
 			free(field);
 			field = next;
 		}
 	}
-	if (pev->args)
-		free(pev->args);
+	free(pev->args);
 	memset(pev, 0, sizeof(*pev));
 }

@@ -1064,19 +1053,13 @@ void clear_kprobe_trace_event(struct kprobe_trace_event *tev)
 	struct kprobe_trace_arg_ref *ref, *next;
 	int i;

-	if (tev->event)
-		free(tev->event);
-	if (tev->group)
-		free(tev->group);
-	if (tev->point.symbol)
-		free(tev->point.symbol);
+	free(tev->event);
+	free(tev->group);
+	free(tev->point.symbol);
 	for (i = 0; i < tev->nargs; i++) {
-		if (tev->args[i].name)
-			free(tev->args[i].name);
-		if (tev->args[i].value)
-			free(tev->args[i].value);
-		if (tev->args[i].type)
-			free(tev->args[i].type);
+		free(tev->args[i].name);
+		free(tev->args[i].value);
+		free(tev->args[i].type);
 		ref = tev->args[i].ref;
 		while (ref) {
 			next = ref->next;
@@ -1084,8 +1067,7 @@ void clear_kprobe_trace_event(struct kprobe_trace_event *tev)
 			ref = next;
 		}
 	}
-	if (tev->args)
-		free(tev->args);
+	free(tev->args);
 	memset(tev, 0, sizeof(*tev));
 }

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index b059dc5..7ec19bd 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -191,8 +191,7 @@ static void define_event_symbols(struct event *event,
 		zero_flag_atom = 0;
 		break;
 	case PRINT_FIELD:
-		if (cur_field_name)
-			free(cur_field_name);
+		free(cur_field_name);
 		cur_field_name = strdup(args->field.name);
 		break;
 	case PRINT_FLAGS:
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 81f39ca..8b81c26 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -148,8 +148,7 @@ static void define_event_symbols(struct event *event,
 		zero_flag_atom = 0;
 		break;
 	case PRINT_FIELD:
-		if (cur_field_name)
-			free(cur_field_name);
+		free(cur_field_name);
 		cur_field_name = strdup(args->field.name);
 		break;
 	case PRINT_FLAGS:
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 1f7ecd4..ec6c4fd 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -57,8 +57,7 @@ int thread__set_comm(struct thread *self, const char *comm)
 {
 	int err;

-	if (self->comm)
-		free(self->comm);
+	free(self->comm);
 	self->comm = strdup(comm);
 	err = self->comm == NULL ? -ENOMEM : 0;
 	if (!err) {
@@ -135,8 +134,7 @@ int thread__fork(struct thread *self, struct thread *parent)
 	int i;

 	if (parent->comm_set) {
-		if (self->comm)
-			free(self->comm);
+		free(self->comm);
 		self->comm = strdup(parent->comm);
 		if (!self->comm)
 			return -ENOMEM;
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 73a0222..33cd08b 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -386,8 +386,7 @@ static void free_arg(struct print_arg *arg)

 	switch (arg->type) {
 	case PRINT_ATOM:
-		if (arg->atom.atom)
-			free(arg->atom.atom);
+		free(arg->atom.atom);
 		break;
 	case PRINT_NULL:
 	case PRINT_FIELD ... PRINT_OP:
@@ -583,8 +582,7 @@ static enum event_type __read_token(char **tok)

 static void free_token(char *tok)
 {
-	if (tok)
-		free(tok);
+	free(tok);
 }

 static enum event_type read_token(char **tok)
@@ -981,8 +979,7 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 fail:
 	free_token(token);
 fail_expect:
-	if (field)
-		free(field);
+	free(field);
 	return -1;
 }

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index b2b3c2d..eb530b4 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -368,7 +368,7 @@ static int cpio_mkfile(const char *name, const char *location,
 	rc = 0;
 	
 error:
-	if (filebuf) free(filebuf);
+	free(filebuf);
 	if (file >= 0) close(file);
 	return rc;
 }
-- 
1.7.1.342.g1c280

--=-=-=
Content-Type: application/pgp-signature
Content-Transfer-Encoding: base64

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0KVmVyc2lvbjogR251UEcgdjIuMC4xMC1zdm40
ODY3IChHTlUvTGludXgpCgppUUljQkFFQkNBQUdCUUpMK0VBcEFBb0pFTmQvL2VHNXE1b1dYQjRQ
L1JkOHptYkRuU29ZOTBQeXZQakg4YVRtClJsRk1tcWR5NGlCZk1FYWowblFncUs5YWdLRkQ2MXBa
WTFidnB3eDJBblM3TzlIRnJ6SXBERXhUb0JBZit0cFYKb2czditFQURkcHhYT2t4b3NZaDJEeTBL
RE9KMVl2dTRWME5DWTVDWFJqTW9aUmlBWFZBWndITmVoV29JVlM0VgpRNXkrbkhYSGhNUFFra1ZO
cGtFN3UwTkUyQUx0eGFmRHRLM01IZ2lCZkVuZlZseEpsaVZ1Ri9wNmxjQTY0dmJnCm5KZWxTMkYz
clNLV3daOWhJNjJEVWVmYTNheEc4MXZZV0lSUmtVbGdJNFFFQjgzZWYzbU5XWnNIZGtFV1FyaDgK
Vy96QjN0UVhDR0ppWGVHNytOVDJLTFJBQ2pJbFduSDlZVldLYmtUUHdZelRIVUY0ZEE0d1lCM3J0
d0F3T2MwMApSOFZ6VUhaTFAyZDl3a2E0S0d5SlYyTVZ1SG95bzBITURGdE10bTlpSTNST2dkdkZr
RzE4emxFVy8yMXJsTXFICmQ0STBUbjNXMHVCcjJzZ1FHVmtmZlFsNndyRHp5aUxleTZwKzBTaVNn
L3p1ajduV1NPTUlYYW1BOVNkYjJCSXYKbVpOV3RBNldjdlFxd2RxOTdKeTg3S0J5dUFFTXB3dHhO
aEI5Y0U1OTVGZmZaOUFzQ24yUVZKOTJXY3BkbDIzdApKbCtFT1NDbUdMSzhoaGtxMzFlYUN1ZlV5
OFR3MnZwTXA1SGR3bDVwQmQ5alhPZmlmTmM2U0NxK2NKZm03ODNzCjZ4TFg1QVVGRmVqaHRXQ2dH
NytwaWg3SVQycHlreFNlK1B3SFFRUFZLMWkwZ0RXZGFmaDNycnppT0p2MWE2azQKQ2VjRTZVQ0o2
SG00MnIrZEVkY3gKPWsxbHoKLS0tLS1FTkQgUEdQIFNJR05BVFVSRS0tLS0t
--=-=-=--
