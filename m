Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab0FCAfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:35:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55700 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431Ab0FCAfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qo4HG+f/60IXHciT1p497nHWkMfRwf5VHAXDA0LTJjp1MSdhJ6e8fnRZTcF1kN0wLI
         AcXmYUbFDzXzEkow3Gp9mXdfQC3CGmzApMuMhthpczN45pMOrwGL/fzJNfNAQL8l563F
         zNJi00is0Ih2zThzvXoWDLQTnFN8QXDEq4DtM=
Date: Thu, 3 Jun 2010 02:35:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC 1/5] BKL: autoconvert trivial users to private mutex
Message-ID: <20100603003512.GC5164@nowhere>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de> <1275523999-27462-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275523999-27462-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 02:13:15AM +0200, Arnd Bergmann wrote:
> All these files use the big kernel lock in a trivial
> way to serialize their private file operations,
> typically resulting from an earlier semi-automatic
> pushdown from VFS.
> 
> None of these drivers appears to want to lock against
> other code, and they all use the BKL as the top-level
> lock in their file operations, meaning that there
> is no lock-order inversion problem.
> 
> Consequently, we can remove the BKL completely,
> replacing it with a per-file mutex in every case.
> Using a scripted approach means we can avoid
> typos.
> 
> file=$1
> name=$2
> if grep -q lock_kernel ${file} ; then
>     if grep -q 'include.*linux.mutex.h' ${file} ; then
>             sed -i '/include.*<linux\/smp_lock.h>/d' ${file}
>     else
>             sed -i 's/include.*<linux\/smp_lock.h>.*$/include <linux\/mutex.h>/g' ${file}
>     fi
>     sed -i ${file} \
>         -e "/^#include.*linux.mutex.h/,$ {
>                 1,/^\(static\|int\|long\)/ {
>                      /^\(static\|int\|long\)/istatic DEFINE_MUTEX(${name}_mutex);
> 
> } }"  \
>     -e "s/\(un\)*lock_kernel\>[ ]*()/mutex_\1lock(\&${name}_mutex)/g" \
>     -e '/[      ]*cycle_kernel_lock();/d'
> else
>     sed -i -e '/include.*\<smp_lock.h\>/d' ${file}  \
>                 -e '/cycle_kernel_lock()/d'
> fi
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/cris/arch-v10/drivers/eeprom.c        |    2 -
>  arch/cris/arch-v10/drivers/i2c.c           |    2 -
>  arch/cris/arch-v32/drivers/cryptocop.c     |    2 -
>  arch/cris/arch-v32/drivers/i2c.c           |    2 -
>  drivers/block/paride/pg.c                  |    7 ++--
>  drivers/block/paride/pt.c                  |   19 ++++++------
>  drivers/char/apm-emulation.c               |   11 ++++---
>  drivers/char/applicom.c                    |    9 +++--
>  drivers/char/ds1302.c                      |   15 +++++----
>  drivers/char/ds1620.c                      |    8 ++--
>  drivers/char/dsp56k.c                      |   27 +++++++++--------
>  drivers/char/dtlk.c                        |    8 ++--
>  drivers/char/generic_nvram.c               |    7 ++--
>  drivers/char/genrtc.c                      |   13 ++++----
>  drivers/char/i8k.c                         |    7 ++--
>  drivers/char/ip2/ip2main.c                 |    8 ++--
>  drivers/char/ipmi/ipmi_devintf.c           |   14 ++++----
>  drivers/char/ipmi/ipmi_watchdog.c          |    8 ++--
>  drivers/char/lp.c                          |   15 +++++----
>  drivers/char/mbcs.c                        |    8 ++--
>  drivers/char/mmtimer.c                     |    7 ++--
>  drivers/char/mwave/mwavedd.c               |   44 ++++++++++++++--------------
>  drivers/char/nvram.c                       |   11 ++++---
>  drivers/char/nwflash.c                     |   12 ++++----
>  drivers/char/pcmcia/cm4000_cs.c            |   11 ++++---
>  drivers/char/pcmcia/cm4040_cs.c            |    7 ++--
>  drivers/char/ppdev.c                       |    8 ++--
>  drivers/char/rio/rio_linux.c               |    7 ++--
>  drivers/char/snsc.c                        |    9 +++--
>  drivers/char/toshiba.c                     |    9 +++--
>  drivers/char/viotape.c                     |   11 ++++---
>  drivers/char/xilinx_hwicap/xilinx_hwicap.c |    6 ++--
>  drivers/hwmon/fschmd.c                     |    6 ++--
>  drivers/hwmon/w83793.c                     |    6 ++--
>  drivers/input/misc/hp_sdc_rtc.c            |    7 ++--
>  drivers/isdn/capi/capi.c                   |    6 ++--
>  drivers/isdn/divert/divert_procfs.c        |    7 ++--
>  drivers/isdn/hardware/eicon/divamnt.c      |    7 ++--
>  drivers/isdn/hardware/eicon/divasi.c       |    2 -
>  drivers/isdn/hardware/eicon/divasmain.c    |    2 -
>  drivers/isdn/hysdn/hysdn_procconf.c        |   21 +++++++------
>  drivers/isdn/hysdn/hysdn_proclog.c         |   15 +++++----
>  drivers/isdn/i4l/isdn_common.c             |   27 +++++++++--------
>  drivers/isdn/mISDN/timerdev.c              |    7 ++--
>  drivers/macintosh/adb.c                    |   10 +++---
>  drivers/macintosh/smu.c                    |    6 ++--
>  drivers/macintosh/via-pmu.c                |   11 ++++---
>  drivers/media/dvb/bt8xx/dst_ca.c           |    7 ++--
>  drivers/media/video/cx88/cx88-blackbird.c  |   13 ++++----
>  drivers/media/video/dabusb.c               |   18 ++++++------
>  drivers/media/video/se401.c                |    9 +++--
>  drivers/media/video/stradis.c              |    9 +++--
>  drivers/media/video/stv680.c               |    6 ++--
>  drivers/media/video/usbvideo/vicam.c       |   14 ++++----
>  drivers/message/fusion/mptctl.c            |   15 +++++----
>  drivers/message/i2o/i2o_config.c           |   23 +++++++-------
>  drivers/misc/phantom.c                     |   11 ++++---
>  drivers/mtd/mtdchar.c                      |   15 +++++----
>  drivers/net/ppp_generic.c                  |   19 ++++++------
>  drivers/net/wan/cosa.c                     |   10 +++---
>  drivers/pci/hotplug/cpqphp_sysfs.c         |   13 ++++----
>  drivers/rtc/rtc-m41t80.c                   |   13 ++++----
>  drivers/sbus/char/display7seg.c            |    8 ++--
>  drivers/sbus/char/envctrl.c                |    2 -
>  drivers/sbus/char/flash.c                  |   15 +++++----
>  drivers/sbus/char/openprom.c               |   15 +++++----
>  drivers/sbus/char/uctrl.c                  |    7 ++--
>  drivers/scsi/3w-9xxx.c                     |    7 ++--
>  drivers/scsi/3w-sas.c                      |    7 ++--
>  drivers/scsi/3w-xxxx.c                     |    9 ++---
>  drivers/scsi/aacraid/linit.c               |   15 +++++----
>  drivers/scsi/ch.c                          |    8 ++--
>  drivers/scsi/dpt_i2o.c                     |   18 ++++++------
>  drivers/scsi/gdth.c                        |   11 ++++---
>  drivers/scsi/megaraid.c                    |    8 ++--
>  drivers/scsi/megaraid/megaraid_mm.c        |    8 ++--
>  drivers/scsi/megaraid/megaraid_sas.c       |    2 -
>  drivers/scsi/mpt2sas/mpt2sas_ctl.c         |   11 ++++---
>  drivers/scsi/osst.c                        |   15 +++++----
>  drivers/scsi/scsi_tgt_if.c                 |    2 -
>  drivers/staging/crystalhd/crystalhd_lnx.c  |    9 +++--
>  drivers/staging/dt3155/dt3155_drv.c        |    7 ++--
>  drivers/staging/vme/devices/vme_user.c     |    7 ++--
>  drivers/telephony/ixj.c                    |    7 ++--
>  drivers/usb/gadget/printer.c               |    7 ++--
>  drivers/usb/misc/iowarrior.c               |   15 +++++----
>  drivers/usb/misc/rio500.c                  |   15 +++++----
>  drivers/usb/misc/usblcd.c                  |   16 +++++-----
>  drivers/watchdog/cpwd.c                    |   15 +++++----
>  fs/hfsplus/ioctl.c                         |   11 ++++---
>  net/wanrouter/wanmain.c                    |    7 ++--
>  net/wanrouter/wanproc.c                    |    7 ++--
>  92 files changed, 496 insertions(+), 464 deletions(-)



Nice.

If you could split the patchset, even by grouping some drivers
from the same family in the same patches, I can host the orphans.

