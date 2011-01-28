Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1A1Sst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:48:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab1A1Ssr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:48:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Max Vozeler <max@vozeler.com>
Subject: Re: [PATCH 03/20] staging/usbip: convert to kthread
Date: Fri, 28 Jan 2011 19:48:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-4-git-send-email-arnd@arndb.de> <4D4302AC.3050903@vozeler.com>
In-Reply-To: <4D4302AC.3050903@vozeler.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101281948.36678.arnd@arndb.de>
X-Provags-ID: V02:K0:39vWZOTsXCF1PtJgsTeufBrUO4THUdTi8gJmEGv/0e7
 KJ///YnMBQLC7l8hiCmoR0adaD1lhcpgxZd77OTK2a4O5m6W2H
 E+BJQtoyRNav05/t6yaqzL7YwQpNtIfxpJeX6g/GPOw59wNCIZ
 xvcdoPHIlh2ymjBZBJcqQszU4DHq48wR/s3Ygo4SomygN31Ime
 s4HeiQzs9+3b319AiyXUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 January 2011 18:53:48 Max Vozeler wrote:
> Hi Arnd,
> 
> On 26.01.2011 00:17, Arnd Bergmann wrote:
> > usbip has its own infrastructure for managing kernel
> > threads, similar to kthread. By changing it to use
> > the standard functions, we can simplify the code
> > and get rid of one of the last BKL users at the
> > same time.
> > 
> > Compile-tested only, please verify.
> 
> I started reviewing and testing, but need to 
> postpone proper testing until mid next week. I did 
> notice a few problems (see below)

Ok, thanks for the review!

> > diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
> > index b186b5f..4ee70d4 100644
> > --- a/drivers/staging/usbip/stub_dev.c
> > +++ b/drivers/staging/usbip/stub_dev.c
> > @@ -18,6 +18,7 @@
> >   */
> >  
> >  #include <linux/slab.h>
> > +#include <linux/kthread.h>
> >  
> >  #include "usbip_common.h"
> >  #include "stub.h"
> > @@ -138,7 +139,8 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
> >  
> >  		spin_unlock(&sdev->ud.lock);
> >  
> > -		usbip_start_threads(&sdev->ud);
> > +		wake_up_process(sdev->ud.tcp_rx);
> > +		wake_up_process(sdev->ud.tcp_tx);
> 
> The threads may have exited already if the
> device was in use then then shut down.
> 
> Can we create or kthread_run() the threads 
> here as I think happened before?

Certainly. I just tried to find the semantics that match the previous
behaviour the closest, but I could not find a reason why the threads
were started in a different place from where they get created.
 
> This is what I saw from a quick test:
> 
> [  405.674068] usbip 1-1:1.0: stub up
> [  405.674110] general protection fault: 0000 [#1] SMP 
> [  405.674876] last sysfs file: /sys/devices/pci0000:00/0000:00:01.2/usb1/1-1/1-1:1.0/usbip_sockfd
> [  405.676045] CPU 0 
> [  405.676045] Modules linked in: usbip(C) usbip_common_mod(C) snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 af_packet mperf microcode configfs fuse loop dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer tpm_tis tpm snd soundcore tpm_bios rtc_cmos rtc_core i2c_piix4 i2c_core virtio_net snd_page_alloc pcspkr rtc_lib floppy virtio_balloon button uhci_hcd ehci_hcd usbcore ext3 mbcache jbd fan processor virtio_blk virtio_pci virtio_ring virtio ide_pci_generic piix ide_core ata_generic ata_piix libata scsi_mod thermal thermal_sys hwmon
> [  405.676045] 
> [  405.676045] Pid: 3360, comm: usbipd Tainted: G         C  2.6.38-rc2-0.5-default+ #1 /Bochs
> [  405.676045] RIP: 0010:[<ffffffff8104c41f>]  [<ffffffff8104c41f>] task_rq_lock+0x4f/0xb0

Right, that would fit the problem you described. It could also happen if
tcp_rx is NULL at this point.

> > -void stub_tx_loop(struct usbip_task *ut)
> > +int stub_tx_loop(void *data)
> >  {
> > -	struct usbip_device *ud = container_of(ut, struct usbip_device, tcp_tx);
> > +	struct usbip_device *ud = data;
> >  	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
> >  
> > -	while (1) {
> > -		if (signal_pending(current)) {
> > -			usbip_dbg_stub_tx("signal catched\n");
> > -			break;
> > -		}
> > -
> > +	while (!kthread_should_stop()) {
> >  		if (usbip_event_happened(ud))
> >  			break;
> >  
> > @@ -371,4 +367,6 @@ void stub_tx_loop(struct usbip_task *ut)
> >  				(!list_empty(&sdev->priv_tx) ||
> >  				 !list_empty(&sdev->unlink_tx)));
> >  	}
> 
> I think this needs kthread_should_stop() as 
> condition for the wait_event_interruptible() or
> the thread may not actually stop.

Yes, good point. 

> --- a/drivers/staging/usbip/stub_tx.c
> +++ b/drivers/staging/usbip/stub_tx.c
> @@ -365,7 +365,8 @@ int stub_tx_loop(void *data)
>  
>                 wait_event_interruptible(sdev->tx_waitq,
>                                 (!list_empty(&sdev->priv_tx) ||
> -                                !list_empty(&sdev->unlink_tx)));
> +                                !list_empty(&sdev->unlink_tx)) ||
> +                               kthread_should_stop());
>         }
>  
>         return 0;

Looks good, same for the others you found.
 
> > diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
> > index f6e34e0..3f2459f 100644
> > --- a/drivers/staging/usbip/vhci_sysfs.c
> > +++ b/drivers/staging/usbip/vhci_sysfs.c
> > @@ -220,16 +220,13 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
> >  	vdev->ud.tcp_socket = socket;
> >  	vdev->ud.status     = VDEV_ST_NOTASSIGNED;
> >  
> > +	wake_up_process(vdev->ud.tcp_rx);
> > +	wake_up_process(vdev->ud.tcp_tx);
> > +
> >  	spin_unlock(&vdev->ud.lock);
> >  	spin_unlock(&the_controller->lock);
> >  	/* end the lock */
> 
> Is it ok to call wake_up_process() while holding
> the spinlocks? (I don't know - just noticed the
> comment which used to be there)

I'm pretty sure you can call it almost everywhere, yes.

> > @@ -238,4 +234,6 @@ void vhci_tx_loop(struct usbip_task *ut)
> >  
> >  		usbip_dbg_vhci_tx("pending urbs ?, now wake up\n");
> >  	}
> > +
> > +	return 0;
> >  }
> 
> I need to leave now for the next couple of days,
> so this is a bit rushed.
> 
> I can take a closer look and do tests in different
> setups during the next week.

That would be great!

Thanks,

	Arnd
