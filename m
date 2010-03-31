Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab0CaR25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 13:28:57 -0400
Received: from mail-iw0-f199.google.com ([209.85.223.199]:50853 "EHLO
	mail-iw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab0CaR2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 13:28:55 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2010 13:28:55 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v8AMDUL/MrYG8tGZTwPkU1cNBfT4V/OnEogNCci5Y199yoHOnv9UBn/iTQrhFuOGSy
         wtVC4hMUrNs0Y24Tnfxs9I+XLIM7RCk3bgn8pw7jjFTa/hsY3AmEdAOCCL+JVZPNCZ1B
         P1Bi5O8dJ7Hx58eoVwbeid83hl9yf46mSKb6I=
Date: Wed, 31 Mar 2010 19:22:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100331172208.GB5163@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <b6fcc0a1003292338yafeb3d3k37fb3fa79af5340c@mail.gmail.com> <20100330070733.GC22419@nowhere> <201003301233.40461.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003301233.40461.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 11:33:40AM +0100, Arnd Bergmann wrote:
> On Tuesday 30 March 2010, Frederic Weisbecker wrote:
> > On Tue, Mar 30, 2010 at 09:38:11AM +0300, Alexey Dobriyan wrote:
> > > On Tue, Mar 30, 2010 at 9:20 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > --- a/fs/proc/inode.c
> > > > +++ b/fs/proc/inode.c
> > > > @@ -231,9 +231,9 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
> > > >                if (rv == -ENOIOCTLCMD)
> > > >                        rv = -EINVAL;
> > > >        } else if (ioctl) {
> > > > -               lock_kernel();
> > > > +               WARN_ONCE(1, "Procfs ioctl handlers must use unlocked_ioctl, "
> > > > +                         "%pf will be called without the Bkl held\n", ioctl);
> > > >                rv = ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
> > > > -               unlock_kernel();
> > > 
> > > Then delete the branch.
> > > Or go through formal feature-removal procedure.
> > 
> > 
> > I thought about it. I even started to write something in this
> > feature-removal file but realized that I can't remove the
> > .ioctl() callback from file operations. We still need to check
> > the user hasn't made the mistake of implementing it.
> > 
> > What I can plan as a feature removal, though, is to keep the warning
> > but don't actually call the ioctl.
> 
> I believe we can actually remove ioctl from file_operations. The patch I did
> to convert all users to ".unlocked_ioctl = default_ioctl," should really catch
> all cases, and I think we can enforce this by renaming fops->ioctl to locked_ioctl
> or old_ioctl to make sure we didn't miss any, and then mandate that this one
> is only used when unlocked_ioctl is set to default_ioctl.


I just looked at the patch in question and noted that the changelog
is pretty high, but how could it be else.
Actually it's not that large, but highly spread:

 Documentation/DocBook/kernel-hacking.tmpl   |    2 +-
 Documentation/filesystems/vfs.txt           |    3 +-
 arch/arm/kernel/etm.c                       |    1 +
 arch/cris/arch-v10/drivers/ds1302.c         |    3 ++
 arch/cris/arch-v10/drivers/gpio.c           |    2 +
 arch/cris/arch-v10/drivers/i2c.c            |    2 +
 arch/cris/arch-v10/drivers/pcf8563.c        |    3 ++
 arch/cris/arch-v10/drivers/sync_serial.c    |    4 ++-
 arch/cris/arch-v32/drivers/cryptocop.c      |    4 ++-
 arch/cris/arch-v32/drivers/i2c.c            |    2 +
 arch/cris/arch-v32/drivers/mach-a3/gpio.c   |    2 +
 arch/cris/arch-v32/drivers/mach-fs/gpio.c   |    2 +
 arch/cris/arch-v32/drivers/pcf8563.c        |    5 +++-
 arch/cris/arch-v32/drivers/sync_serial.c    |    4 ++-
 arch/ia64/kernel/perfmon.c                  |    2 +
 arch/ia64/sn/kernel/sn2/sn_hwperf.c         |    2 +
 arch/m68k/bvme6000/rtc.c                    |    2 +
 arch/m68k/mvme16x/rtc.c                     |    2 +
 arch/um/drivers/harddog_kern.c              |    2 +
 arch/um/drivers/hostaudio_kern.c            |    3 ++
 arch/um/drivers/mmapper_kern.c              |    3 ++
 drivers/block/DAC960.c                      |    3 +-
 drivers/block/paride/pg.c                   |    2 +
 drivers/block/paride/pt.c                   |    2 +
 drivers/block/pktcdvd.c                     |    3 ++
 drivers/char/apm-emulation.c                |    2 +
 drivers/char/applicom.c                     |    2 +
 drivers/char/ds1302.c                       |    1 +
 drivers/char/ds1620.c                       |    2 +
 drivers/char/dtlk.c                         |    2 +
 drivers/char/generic_nvram.c                |    2 +
 drivers/char/genrtc.c                       |    2 +
 drivers/char/i8k.c                          |    2 +
 drivers/char/ip2/ip2main.c                  |    1 +
 drivers/char/ipmi/ipmi_devintf.c            |    2 +
 drivers/char/ipmi/ipmi_watchdog.c           |    2 +
 drivers/char/istallion.c                    |    1 +
 drivers/char/lp.c                           |    1 +
 drivers/char/mmtimer.c                      |    1 +
 drivers/char/nwflash.c                      |    1 +
 drivers/char/raw.c                          |    4 +++
 drivers/char/rio/rio_linux.c                |    1 +
 drivers/char/stallion.c                     |    1 +
 drivers/char/sx.c                           |    1 +
 drivers/char/uv_mmtimer.c                   |    1 +
 drivers/char/viotape.c                      |    1 +
 drivers/firewire/core-cdev.c                |    2 +
 drivers/gpu/drm/i810/i810_dma.c             |    2 +
 drivers/gpu/drm/i830/i830_dma.c             |    2 +
 drivers/hid/usbhid/hiddev.c                 |    3 +-
 drivers/hwmon/fschmd.c                      |    2 +
 drivers/ide/ide-tape.c                      |    2 +
 drivers/ieee1394/dv1394.c                   |    2 +
 drivers/ieee1394/raw1394.c                  |    2 +
 drivers/ieee1394/video1394.c                |    4 ++-
 drivers/infiniband/core/ucm.c               |    2 +
 drivers/infiniband/core/ucma.c              |    2 +
 drivers/infiniband/core/user_mad.c          |    7 +++-
 drivers/infiniband/core/uverbs_main.c       |   10 +++++--
 drivers/input/misc/hp_sdc_rtc.c             |    2 +
 drivers/input/misc/uinput.c                 |    1 +
 drivers/isdn/capi/capi.c                    |    1 +
 drivers/isdn/divert/divert_procfs.c         |    2 +
 drivers/isdn/i4l/isdn_common.c              |    1 +
 drivers/isdn/mISDN/timerdev.c               |    3 ++
 drivers/macintosh/ans-lcd.c                 |    2 +
 drivers/macintosh/nvram.c                   |    2 +
 drivers/macintosh/via-pmu.c                 |    2 +
 drivers/media/dvb/bt8xx/dst_ca.c            |    1 +
 drivers/media/dvb/dvb-core/dmxdev.c         |    3 ++
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    3 ++
 drivers/media/dvb/dvb-core/dvb_frontend.c   |    5 +++-
 drivers/media/dvb/dvb-core/dvb_net.c        |    3 ++
 drivers/media/dvb/firewire/firedtv-ci.c     |    3 ++
 drivers/media/dvb/ttpci/av7110.c            |    3 ++
 drivers/media/dvb/ttpci/av7110_av.c         |    5 +++
 drivers/media/dvb/ttpci/av7110_ca.c         |    3 ++
 drivers/media/video/cpia.c                  |    2 +
 drivers/media/video/v4l2-dev.c              |    2 +
 drivers/mtd/mtdchar.c                       |    1 +
 drivers/mtd/ubi/cdev.c                      |    2 +
 drivers/net/ppp_generic.c                   |    4 ++-
 drivers/net/wireless/airo.c                 |    9 ++++++
 drivers/net/wireless/ray_cs.c               |    3 ++
 drivers/rtc/rtc-m41t80.c                    |    1 +
 drivers/s390/char/fs3270.c                  |    1 +
 drivers/s390/char/tape_char.c               |    2 +-
 drivers/s390/cio/chsc_sch.c                 |    2 +
 drivers/s390/crypto/zcrypt_api.c            |    1 +
 drivers/s390/scsi/zfcp_cfdc.c               |    2 +
 drivers/sbus/char/envctrl.c                 |    1 +
 drivers/sbus/char/openprom.c                |    1 +
 drivers/scsi/3w-9xxx.c                      |    2 +
 drivers/scsi/3w-sas.c                       |    2 +
 drivers/scsi/3w-xxxx.c                      |    2 +
 drivers/scsi/aacraid/linit.c                |    1 +
 drivers/scsi/dpt_i2o.c                      |    2 +
 drivers/scsi/gdth.c                         |    2 +
 drivers/scsi/megaraid.c                     |    2 +
 drivers/scsi/megaraid/megaraid_mm.c         |    2 +
 drivers/scsi/megaraid/megaraid_sas.c        |    1 +
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          |    1 +
 drivers/scsi/osd/osd_uld.c                  |    2 +
 drivers/scsi/osst.c                         |    2 +
 drivers/scsi/pmcraid.c                      |    2 +
 drivers/scsi/sg.c                           |    2 +
 drivers/scsi/st.c                           |    1 +
 drivers/spi/spidev.c                        |    2 +
 drivers/staging/b3dfg/b3dfg.c               |    2 +
 drivers/staging/comedi/comedi_fops.c        |    2 +
 drivers/staging/dream/pmem.c                |    3 ++
 drivers/staging/dream/qdsp5/audio_aac.c     |    2 +
 drivers/staging/dream/qdsp5/audio_mp3.c     |    2 +
 drivers/staging/poch/poch.c                 |    3 ++
 drivers/staging/sep/sep_driver.c            |    3 ++
 drivers/staging/vme/devices/vme_user.c      |    2 +
 drivers/telephony/ixj.c                     |    1 +
 drivers/usb/class/usblp.c                   |    2 +
 drivers/usb/gadget/printer.c                |    1 +
 drivers/usb/misc/idmouse.c                  |    2 +
 drivers/usb/misc/iowarrior.c                |    1 +
 drivers/usb/misc/rio500.c                   |    1 +
 drivers/usb/misc/vstusb.c                   |    2 +
 fs/autofs/root.c                            |    1 +
 fs/autofs4/dev-ioctl.c                      |    2 +
 fs/btrfs/super.c                            |    1 +
 fs/coda/pioctl.c                            |    3 ++
 fs/coda/psdev.c                             |    2 +
 fs/ecryptfs/file.c                          |    2 +
 fs/ecryptfs/miscdev.c                       |    2 +
 fs/hfsplus/dir.c                            |    2 +
 fs/hfsplus/inode.c                          |    2 +
 fs/ioctl.c                                  |   11 ++------
 fs/ncpfs/dir.c                              |    2 +
 fs/ncpfs/file.c                             |    1 +
 fs/read_write.c                             |   34 ------------------------
 fs/smbfs/dir.c                              |    2 +
 fs/smbfs/file.c                             |    1 +
 fs/udf/dir.c                                |    2 +
 fs/udf/file.c                               |    1 +
 include/linux/fs.h                          |    5 ---
 include/linux/smp_lock.h                    |    5 +++
 lib/kernel_lock.c                           |   37 +++++++++++++++++++++++++-
 net/socket.c                                |    1 +
 sound/core/control.c                        |    2 +
 sound/core/oss/pcm_oss.c                    |    2 +
 sound/core/pcm_native.c                     |    2 +
 sound/core/seq/seq_clientmgr.c              |    2 +
 sound/oss/au1550_ac97.c                     |   30 +++++++++++----------
 sound/oss/dmasound/dmasound_core.c          |    2 +
 sound/oss/msnd_pinnacle.c                   |    2 +
 sound/oss/sh_dac_audio.c                    |    3 ++
 sound/oss/soundcard.c                       |    1 +
 sound/oss/swarm_cs4297a.c                   |    3 ++
 sound/oss/vwsnd.c                           |    2 +
 sound/soc/soc-core.c                        |    2 +
 virt/kvm/kvm_main.c                         |    4 +++
 157 files changed, 372 insertions(+), 80 deletions(-)


I wonder if we should actually just turn all these into unlocked_ioctl
directly. And then bring a warn on ioctl, and finally schedule the removal
of this callback.

What do you think?

You plan looks good but I fear this actually carries the problem forward
in that we won't be able to remove .ioctl after that.

I can handle that if you agree.

