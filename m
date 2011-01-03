Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab1ACNuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:50:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab1ACNuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=Sq1L4rYgkTXuIuB/2ZKKrXb5KAABoD+o/zMztTk5hyqybr6abU9y2V8W2GtCZIueOV
         GGCDWPfojx6sg6PjLQ9S/KJqVzFwW3hdfm88VwSuhKwgRwOgBg6QV86s8GRI/G8bcmFo
         3WhYoQJH1oNdhoUbjGGGoFmfzGd0rLGHDeceI=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCHSET] workqueue: update workqueue users - replace create_workqueue()
Date: Mon,  3 Jan 2011 14:49:23 +0100
Message-Id: <1294062595-30097-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset examines each user of create_workqueue() and update them
to better fit the new workqueue implementation.  For backward
compatibility, create_workqueue() is mapped to

 alloc_workqueue(@name, WQ_MEM_RECLAIM, 1)

but for a lot of its users, WQ_MEM_RECLAIM is not required,
@max_active of 1 is unnecessarily strict, or the dedicated workqueue
simply isn't needed.

* As the system workqueues can now host higher concurrency, a lot of
  users can drop dedicated workqueues and use the system ones.

* There are cases where keeping dedicated workqueues are necessary.
  e.g. They are depended upon during memory reclaim, need to be
  highpri or CPU intensive, serve work items which free themselves
  (and thus work items can't be explicitly queued), or need to limit
  max concurrency level from workqueue.  In these cases,
  alloc_workqueue() calls with better fitting parameters are used.

* This patchset mostly concentrates on converting create_workqueue()
  users but it also updates general workqueue usages when it makes
  sense to update them together.  Please read description of each
  patch for deatils.

This simplifies code, removes unnecessary rescuer kernel thread and
makes workqueue utilized more efficiently.

This patchset contains the following 32 patches.

 0001-arm-omap-use-system_wq-in-mailbox.patch
 0002-powerpc-cell-use-system_wq-in-cpufreq_spudemand.patch
 0003-block-make-kblockd_workqueue-smarter.patch
 0004-bio-integrity-mark-kintegrityd_wq-highpri-and-CPU-in.patch
 0005-crypto-mark-crypto-workqueues-CPU_INTENSIVE.patch
 0006-acpi-kacpi-_wq-don-t-need-WQ_MEM_RECLAIM.patch
 0007-cpufreq-use-system_wq-instead-of-dedicated-workqueue.patch
 0008-drm-nouveau-use-system_wq-instead-of-dev_priv-wq.patch
 0009-drm-radeon-use-system_wq-instead-of-dev_priv-wq.patch
 0010-input-tps6507x-ts-use-system_wq-instead-of-dedicated.patch
 0011-v4l-cx18-update-workqueue-usage.patch
 0012-i2o-use-alloc_workqueue-instead-of-create_workqueue.patch
 0013-misc-iwmc3200top-use-system_wq-instead-of-dedicated-.patch
 0014-wireless-ipw2x00-use-system_wq-instead-of-dedicated-.patch
 0015-wireless-libertas-_tf-use-system_wq-instead-of-dedic.patch
 0016-scsi-be2iscsi-qla2xxx-convert-to-alloc_workqueue.patch
 0017-scsi-ibmvstgt-use-system_wq-instead-of-vtgtd-workque.patch
 0018-scsi-scsi_tgt_lib-scsi_tgtd-isn-t-used-in-memory-rec.patch
 0019-usb-ueagle-atm-use-system_wq-instead-of-dedicated-wo.patch
 0020-video-msm_fb-use-system_wq-instead-of-dedicated-work.patch
 0021-fs-aio-aio_wq-isn-t-used-in-memory-reclaim-path.patch
 0022-ceph-fsc-_wq-s-aren-t-used-in-memory-reclaim-path.patch
 0023-net-ceph-make-ceph_msgr_wq-non-reentrant.patch
 0024-dlm-dlm-workqueues-aren-t-used-in-memory-reclaim-pat.patch
 0025-ext4-convert-to-alloc_workqueue.patch
 0026-ocfs2-use-system_wq-instead-of-ocfs2_quota_wq.patch
 0027-reiserfs-make-commit_wq-use-the-default-concurrency-.patch
 0028-xfs-convert-to-alloc_workqueue.patch
 0029-net-9p-use-system_wq-instead-of-p9_mux_wq.patch
 0030-net-9p-replace-p9_poll_task-with-a-work.patch
 0031-rds-ib-use-system_wq-instead-of-rds_ib_fmr_wq.patch
 0032-rxrpc-rxrpc_workqueue-isn-t-used-during-memory-recla.patch

The patches are based on 2.6.37-rc8 (b518a649) and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.g replace-create_workqueue

 arch/arm/plat-omap/mailbox.c                    |   10 -
 arch/powerpc/platforms/cell/cpufreq_spudemand.c |   20 --
 block/blk-core.c                                |    4
 crypto/crypto_wq.c                              |    3
 crypto/pcrypt.c                                 |    3
 drivers/acpi/osl.c                              |    6
 drivers/cpufreq/cpufreq_conservative.c          |   22 --
 drivers/cpufreq/cpufreq_ondemand.c              |   20 --
 drivers/gpu/drm/nouveau/nouveau_drv.h           |    1
 drivers/gpu/drm/nouveau/nouveau_irq.c           |    9 -
 drivers/gpu/drm/nouveau/nouveau_state.c         |   19 +-
 drivers/gpu/drm/nouveau/nv50_display.c          |    4
 drivers/gpu/drm/radeon/evergreen.c              |    2
 drivers/gpu/drm/radeon/r100.c                   |    2
 drivers/gpu/drm/radeon/r600.c                   |    2
 drivers/gpu/drm/radeon/radeon.h                 |    1
 drivers/gpu/drm/radeon/radeon_device.c          |    6
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |    5
 drivers/gpu/drm/radeon/radeon_pm.c              |   47 +----
 drivers/gpu/drm/radeon/rs600.c                  |    2
 drivers/input/touchscreen/tps6507x-ts.c         |   12 -
 drivers/media/video/cx18/cx18-driver.c          |   24 --
 drivers/media/video/cx18/cx18-driver.h          |    3
 drivers/media/video/cx18/cx18-streams.h         |    3
 drivers/message/i2o/driver.c                    |    3
 drivers/misc/iwmc3200top/iwmc3200top.h          |    4
 drivers/misc/iwmc3200top/main.c                 |   14 -
 drivers/net/wireless/ipw2x00/ipw2100.c          |   70 +++-----
 drivers/net/wireless/ipw2x00/ipw2100.h          |    1
 drivers/net/wireless/ipw2x00/ipw2200.c          |  196 ++++++++++--------------
 drivers/net/wireless/ipw2x00/ipw2200.h          |    2
 drivers/net/wireless/libertas/if_sdio.c         |   10 -
 drivers/net/wireless/libertas_tf/cmd.c          |    6
 drivers/net/wireless/libertas_tf/libertas_tf.h  |    2
 drivers/net/wireless/libertas_tf/main.c         |   16 -
 drivers/scsi/be2iscsi/be_main.c                 |    2
 drivers/scsi/ibmvscsi/ibmvstgt.c                |   15 -
 drivers/scsi/qla2xxx/qla_os.c                   |    2
 drivers/scsi/scsi_tgt_lib.c                     |    2
 drivers/usb/atm/ueagle-atm.c                    |   19 --
 drivers/video/msm/msm_fb.c                      |   11 -
 fs/aio.c                                        |    4
 fs/bio-integrity.c                              |    7
 fs/ceph/super.c                                 |   10 -
 fs/dlm/lowcomms.c                               |   19 --
 fs/ext4/super.c                                 |    7
 fs/ocfs2/quota.h                                |    3
 fs/ocfs2/quota_global.c                         |   27 ---
 fs/ocfs2/super.c                                |    7
 fs/reiserfs/journal.c                           |    2
 fs/xfs/linux-2.6/xfs_buf.c                      |    5
 fs/xfs/xfs_mru_cache.c                          |    2
 include/linux/ceph/messenger.h                  |    5
 net/9p/trans_fd.c                               |   52 +-----
 net/ceph/messenger.c                            |   46 -----
 net/rds/ib.c                                    |    9 -
 net/rds/ib.h                                    |    2
 net/rds/ib_rdma.c                               |   27 ---
 net/rxrpc/af_rxrpc.c                            |    2
 59 files changed, 270 insertions(+), 571 deletions(-)

--
tejun
