Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1A1RyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:54:24 -0500
Received: from mail.nusquama.org ([85.131.211.20]:57129 "EHLO
	mail.nusquama.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755362Ab1A1RyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:54:22 -0500
Message-ID: <4D4302AC.3050903@vozeler.com>
Date: Fri, 28 Jan 2011 19:53:48 +0200
From: Max Vozeler <max@vozeler.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101110 Icedove/3.1.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Subject: Re: [PATCH 03/20] staging/usbip: convert to kthread
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-4-git-send-email-arnd@arndb.de>
In-Reply-To: <1295993854-4971-4-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 26.01.2011 00:17, Arnd Bergmann wrote:
> usbip has its own infrastructure for managing kernel
> threads, similar to kthread. By changing it to use
> the standard functions, we can simplify the code
> and get rid of one of the last BKL users at the
> same time.
> 
> Compile-tested only, please verify.

I started reviewing and testing, but need to 
postpone proper testing until mid next week. I did 
notice a few problems (see below)

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
> ---
>  drivers/staging/usbip/Kconfig        |    2 +-
>  drivers/staging/usbip/stub.h         |    4 +-
>  drivers/staging/usbip/stub_dev.c     |   13 +++--
>  drivers/staging/usbip/stub_rx.c      |   13 ++---
>  drivers/staging/usbip/stub_tx.c      |   14 ++---
>  drivers/staging/usbip/usbip_common.c |  105 ----------------------------------
>  drivers/staging/usbip/usbip_common.h |   20 +------
>  drivers/staging/usbip/usbip_event.c  |   31 +++-------
>  drivers/staging/usbip/vhci.h         |    4 +-
>  drivers/staging/usbip/vhci_hcd.c     |   10 ++-
>  drivers/staging/usbip/vhci_rx.c      |   16 ++---
>  drivers/staging/usbip/vhci_sysfs.c   |    9 +--
>  drivers/staging/usbip/vhci_tx.c      |   14 ++---
>  13 files changed, 58 insertions(+), 197 deletions(-)

What is not to like :)

> diff --git a/drivers/staging/usbip/Kconfig b/drivers/staging/usbip/Kconfig
> index b11ec37..2c1d10a 100644
> --- a/drivers/staging/usbip/Kconfig
> +++ b/drivers/staging/usbip/Kconfig
> @@ -1,6 +1,6 @@
>  config USB_IP_COMMON
>  	tristate "USB IP support (EXPERIMENTAL)"
> -	depends on USB && NET && EXPERIMENTAL && BKL
> +	depends on USB && NET && EXPERIMENTAL
>  	default N
>  	---help---
>  	  This enables pushing USB packets over IP to allow remote
> diff --git a/drivers/staging/usbip/stub.h b/drivers/staging/usbip/stub.h
> index 30dbfb6..5b44e7b 100644
> --- a/drivers/staging/usbip/stub.h
> +++ b/drivers/staging/usbip/stub.h
> @@ -94,13 +94,13 @@ extern struct kmem_cache *stub_priv_cache;
>  
>  /* stub_tx.c */
>  void stub_complete(struct urb *);
> -void stub_tx_loop(struct usbip_task *);
> +int stub_tx_loop(void *data);
>  
>  /* stub_dev.c */
>  extern struct usb_driver stub_driver;
>  
>  /* stub_rx.c */
> -void stub_rx_loop(struct usbip_task *);
> +int stub_rx_loop(void *data);
>  void stub_enqueue_ret_unlink(struct stub_device *, __u32, __u32);
>  
>  /* stub_main.c */
> diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
> index b186b5f..4ee70d4 100644
> --- a/drivers/staging/usbip/stub_dev.c
> +++ b/drivers/staging/usbip/stub_dev.c
> @@ -18,6 +18,7 @@
>   */
>  
>  #include <linux/slab.h>
> +#include <linux/kthread.h>
>  
>  #include "usbip_common.h"
>  #include "stub.h"
> @@ -138,7 +139,8 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
>  
>  		spin_unlock(&sdev->ud.lock);
>  
> -		usbip_start_threads(&sdev->ud);
> +		wake_up_process(sdev->ud.tcp_rx);
> +		wake_up_process(sdev->ud.tcp_tx);

The threads may have exited already if the
device was in use then then shut down.

Can we create or kthread_run() the threads 
here as I think happened before?

This is what I saw from a quick test:

[  405.674068] usbip 1-1:1.0: stub up
[  405.674110] general protection fault: 0000 [#1] SMP 
[  405.674876] last sysfs file: /sys/devices/pci0000:00/0000:00:01.2/usb1/1-1/1-1:1.0/usbip_sockfd
[  405.676045] CPU 0 
[  405.676045] Modules linked in: usbip(C) usbip_common_mod(C) snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 af_packet mperf microcode configfs fuse loop dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer tpm_tis tpm snd soundcore tpm_bios rtc_cmos rtc_core i2c_piix4 i2c_core virtio_net snd_page_alloc pcspkr rtc_lib floppy virtio_balloon button uhci_hcd ehci_hcd usbcore ext3 mbcache jbd fan processor virtio_blk virtio_pci virtio_ring virtio ide_pci_generic piix ide_core ata_generic ata_piix libata scsi_mod thermal thermal_sys hwmon
[  405.676045] 
[  405.676045] Pid: 3360, comm: usbipd Tainted: G         C  2.6.38-rc2-0.5-default+ #1 /Bochs
[  405.676045] RIP: 0010:[<ffffffff8104c41f>]  [<ffffffff8104c41f>] task_rq_lock+0x4f/0xb0
[  405.676045] RSP: 0018:ffff88003b687db8  EFLAGS: 00010006
[  405.676045] RAX: 6b6b6b6b6b6b6b6b RBX: 00000000001d54c0 RCX: 0000000000000001
[  405.676045] RDX: ffff880037da1310 RSI: 0000000000000000 RDI: ffffffff8104c41a
[  405.676045] RBP: ffff88003b687dd8 R08: 0000000000000000 R09: 0000000000000001
[  405.676045] R10: 0000000000000008 R11: 0000000000000001 R12: ffff880038fdd2d0
[  405.676045] R13: ffff88003b687e10 R14: 00000000001d54c0 R15: 000000000000000f
[  405.676045] FS:  00007f6a43816700(0000) GS:ffff88003e200000(0000) knlGS:0000000000000000
[  405.676045] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  405.676045] CR2: 00007fae487ab000 CR3: 000000003b439000 CR4: 00000000000006f0
[  405.676045] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  405.676045] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  405.676045] Process usbipd (pid: 3360, threadinfo ffff88003b686000, task ffff880037da1310)
[  405.676045] Stack:
[  405.676045]  ffff880038fdd2d0 ffff880039be54b0 0000000000000000 0000000000000000
[  405.676045]  ffff88003b687e48 ffffffff8105985c ffff880037da1380 ffffffffa013f0a2
[  405.676045]  ffff88003b687e38 0000000000000246 0000000000000002 0000000000000286
[  405.676045] Call Trace:
[  405.676045]  [<ffffffff8105985c>] try_to_wake_up+0x3c/0x430
[  405.676045]  [<ffffffffa013f0a2>] ? store_sockfd+0xa2/0x1a0 [usbip]
[  405.676045]  [<ffffffff81059ca5>] wake_up_process+0x15/0x20
[  405.676045]  [<ffffffffa013f0ab>] store_sockfd+0xab/0x1a0 [usbip]
[  405.676045]  [<ffffffff8130b390>] dev_attr_store+0x20/0x30
[  405.676045]  [<ffffffff811c4186>] sysfs_write_file+0xe6/0x170
[  405.676045]  [<ffffffff81156e80>] vfs_write+0xd0/0x1a0
[  405.676045]  [<ffffffff81157054>] sys_write+0x54/0xa0
[  405.676045]  [<ffffffff8100bf42>] system_call_fastpath+0x16/0x1b

>  		spin_lock(&sdev->ud.lock);
>  		sdev->ud.status = SDEV_ST_USED;
> @@ -218,7 +220,8 @@ static void stub_shutdown_connection(struct usbip_device *ud)
>  	}
>  
>  	/* 1. stop threads */
> -	usbip_stop_threads(ud);
> +	kthread_stop(ud->tcp_rx);
> +	kthread_stop(ud->tcp_tx);
>  
>  	/* 2. close the socket */
>  	/*
> @@ -333,8 +336,8 @@ static struct stub_device *stub_device_alloc(struct usb_interface *interface)
>  	 */
>  	sdev->devid     = (busnum << 16) | devnum;
>  
> -	usbip_task_init(&sdev->ud.tcp_rx, "stub_rx", stub_rx_loop);
> -	usbip_task_init(&sdev->ud.tcp_tx, "stub_tx", stub_tx_loop);
> +	sdev->ud.tcp_rx = kthread_create(stub_rx_loop, &sdev->ud, "stub_rx");
> +	sdev->ud.tcp_tx = kthread_create(stub_tx_loop, &sdev->ud, "stub_tx");

>  	sdev->ud.side = USBIP_STUB;
>  	sdev->ud.status = SDEV_ST_AVAILABLE;
> @@ -537,7 +540,7 @@ static void stub_disconnect(struct usb_interface *interface)
>  	stub_remove_files(&interface->dev);
>  
>  	/*If usb reset called from event handler*/
> -	if (busid_priv->sdev->ud.eh.thread == current) {
> +	if (busid_priv->sdev->ud.eh == current) {
>  		busid_priv->interf_count--;
>  		return;
>  	}
> diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
> index 3de6fd2..4ecc2bb 100644
> --- a/drivers/staging/usbip/stub_rx.c
> +++ b/drivers/staging/usbip/stub_rx.c
> @@ -18,6 +18,7 @@
>   */
>  
>  #include <linux/slab.h>
> +#include <linux/kthread.h>
>  
>  #include "usbip_common.h"
>  #include "stub.h"
> @@ -616,19 +617,15 @@ static void stub_rx_pdu(struct usbip_device *ud)
>  
>  }
>  
> -void stub_rx_loop(struct usbip_task *ut)
> +int stub_rx_loop(void *data)
>  {
> -	struct usbip_device *ud = container_of(ut, struct usbip_device, tcp_rx);
> -
> -	while (1) {
> -		if (signal_pending(current)) {
> -			usbip_dbg_stub_rx("signal caught!\n");
> -			break;
> -		}
> +	struct usbip_device *ud = data;
>  
> +	while (!kthread_should_stop()) {
>  		if (usbip_event_happened(ud))
>  			break;
>  
>  		stub_rx_pdu(ud);
>  	}
> +	return 0;
>  }
> diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
> index d7136e2..2477481 100644
> --- a/drivers/staging/usbip/stub_tx.c
> +++ b/drivers/staging/usbip/stub_tx.c
> @@ -18,6 +18,7 @@
>   */
>  
>  #include <linux/slab.h>
> +#include <linux/kthread.h>
>  
>  #include "usbip_common.h"
>  #include "stub.h"
> @@ -333,17 +334,12 @@ static int stub_send_ret_unlink(struct stub_device *sdev)
>  
>  /*-------------------------------------------------------------------------*/
>  
> -void stub_tx_loop(struct usbip_task *ut)
> +int stub_tx_loop(void *data)
>  {
> -	struct usbip_device *ud = container_of(ut, struct usbip_device, tcp_tx);
> +	struct usbip_device *ud = data;
>  	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
>  
> -	while (1) {
> -		if (signal_pending(current)) {
> -			usbip_dbg_stub_tx("signal catched\n");
> -			break;
> -		}
> -
> +	while (!kthread_should_stop()) {
>  		if (usbip_event_happened(ud))
>  			break;
>  
> @@ -371,4 +367,6 @@ void stub_tx_loop(struct usbip_task *ut)
>  				(!list_empty(&sdev->priv_tx) ||
>  				 !list_empty(&sdev->unlink_tx)));
>  	}

I think this needs kthread_should_stop() as 
condition for the wait_event_interruptible() or
the thread may not actually stop.

--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -365,7 +365,8 @@ int stub_tx_loop(void *data)
 
                wait_event_interruptible(sdev->tx_waitq,
                                (!list_empty(&sdev->priv_tx) ||
-                                !list_empty(&sdev->unlink_tx)));
+                                !list_empty(&sdev->unlink_tx)) ||
+                               kthread_should_stop());
        }
 
        return 0;

> diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
> index 210ef16..337abc4 100644
> --- a/drivers/staging/usbip/usbip_common.c
> +++ b/drivers/staging/usbip/usbip_common.c
> @@ -18,7 +18,6 @@
>   */
>  
>  #include <linux/kernel.h>
> -#include <linux/smp_lock.h>
>  #include <linux/file.h>
>  #include <linux/tcp.h>
>  #include <linux/in.h>
> @@ -349,110 +348,6 @@ void usbip_dump_header(struct usbip_header *pdu)
>  }
>  EXPORT_SYMBOL_GPL(usbip_dump_header);
>  
> -
> -/*-------------------------------------------------------------------------*/
> -/* thread routines */
> -
> -int usbip_thread(void *param)
> -{
> -	struct usbip_task *ut = param;
> -
> -	if (!ut)
> -		return -EINVAL;
> -
> -	lock_kernel();
> -	daemonize(ut->name);
> -	allow_signal(SIGKILL);
> -	ut->thread = current;
> -	unlock_kernel();
> -
> -	/* srv.rb must wait for rx_thread starting */
> -	complete(&ut->thread_done);
> -
> -	/* start of while loop */
> -	ut->loop_ops(ut);
> -
> -	/* end of loop */
> -	ut->thread = NULL;
> -
> -	complete_and_exit(&ut->thread_done, 0);
> -}
> -
> -static void stop_rx_thread(struct usbip_device *ud)
> -{
> -	if (ud->tcp_rx.thread != NULL) {
> -		send_sig(SIGKILL, ud->tcp_rx.thread, 1);
> -		wait_for_completion(&ud->tcp_rx.thread_done);
> -		usbip_udbg("rx_thread for ud %p has finished\n", ud);
> -	}
> -}
> -
> -static void stop_tx_thread(struct usbip_device *ud)
> -{
> -	if (ud->tcp_tx.thread != NULL) {
> -		send_sig(SIGKILL, ud->tcp_tx.thread, 1);
> -		wait_for_completion(&ud->tcp_tx.thread_done);
> -		usbip_udbg("tx_thread for ud %p has finished\n", ud);
> -	}
> -}
> -
> -int usbip_start_threads(struct usbip_device *ud)
> -{
> -	/*
> -	 * threads are invoked per one device (per one connection).
> -	 */
> -	struct task_struct *th;
> -	int err = 0;
> -
> -	th = kthread_run(usbip_thread, (void *)&ud->tcp_rx, "usbip");
> -	if (IS_ERR(th)) {
> -		printk(KERN_WARNING
> -			"Unable to start control thread\n");
> -		err = PTR_ERR(th);
> -		goto ust_exit;
> -	}
> -
> -	th = kthread_run(usbip_thread, (void *)&ud->tcp_tx, "usbip");
> -	if (IS_ERR(th)) {
> -		printk(KERN_WARNING
> -			"Unable to start control thread\n");
> -		err = PTR_ERR(th);
> -		goto tx_thread_err;
> -	}
> -
> -	/* confirm threads are starting */
> -	wait_for_completion(&ud->tcp_rx.thread_done);
> -	wait_for_completion(&ud->tcp_tx.thread_done);
> -
> -	return 0;
> -
> -tx_thread_err:
> -	stop_rx_thread(ud);
> -
> -ust_exit:
> -	return err;
> -}
> -EXPORT_SYMBOL_GPL(usbip_start_threads);
> -
> -void usbip_stop_threads(struct usbip_device *ud)
> -{
> -	/* kill threads related to this sdev, if v.c. exists */
> -	stop_rx_thread(ud);
> -	stop_tx_thread(ud);
> -}
> -EXPORT_SYMBOL_GPL(usbip_stop_threads);
> -
> -void usbip_task_init(struct usbip_task *ut, char *name,
> -		void (*loop_ops)(struct usbip_task *))
> -{
> -	ut->thread = NULL;
> -	init_completion(&ut->thread_done);
> -	ut->name = name;
> -	ut->loop_ops = loop_ops;
> -}
> -EXPORT_SYMBOL_GPL(usbip_task_init);
> -
> -
>  /*-------------------------------------------------------------------------*/
>  /* socket routines */
>  
> diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
> index d280e23..9f809c3 100644
> --- a/drivers/staging/usbip/usbip_common.h
> +++ b/drivers/staging/usbip/usbip_common.h
> @@ -307,13 +307,6 @@ void usbip_dump_header(struct usbip_header *pdu);
>  
>  struct usbip_device;
>  
> -struct usbip_task {
> -	struct task_struct *thread;
> -	struct completion thread_done;
> -	char *name;
> -	void (*loop_ops)(struct usbip_task *);
> -};
> -
>  enum usbip_side {
>  	USBIP_VHCI,
>  	USBIP_STUB,
> @@ -346,8 +339,8 @@ struct usbip_device {
>  
>  	struct socket *tcp_socket;
>  
> -	struct usbip_task tcp_rx;
> -	struct usbip_task tcp_tx;
> +	struct task_struct *tcp_rx;
> +	struct task_struct *tcp_tx;
>  
>  	/* event handler */
>  #define USBIP_EH_SHUTDOWN	(1 << 0)
> @@ -367,7 +360,7 @@ struct usbip_device {
>  #define	VDEV_EVENT_ERROR_MALLOC	(USBIP_EH_SHUTDOWN | USBIP_EH_UNUSABLE)
>  
>  	unsigned long event;
> -	struct usbip_task eh;
> +	struct task_struct *eh;
>  	wait_queue_head_t eh_waitq;
>  
>  	struct eh_ops {
> @@ -378,13 +371,6 @@ struct usbip_device {
>  };
>  
>  
> -void usbip_task_init(struct usbip_task *ut, char *,
> -				void (*loop_ops)(struct usbip_task *));
> -
> -int usbip_start_threads(struct usbip_device *ud);
> -void usbip_stop_threads(struct usbip_device *ud);
> -int usbip_thread(void *param);
> -
>  void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
>  								int pack);
>  
> diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
> index af3832b..89aecec 100644
> --- a/drivers/staging/usbip/usbip_event.c
> +++ b/drivers/staging/usbip/usbip_event.c
> @@ -62,16 +62,11 @@ static int event_handler(struct usbip_device *ud)
>  	return 0;
>  }
>  
> -static void event_handler_loop(struct usbip_task *ut)
> +static int event_handler_loop(void *data)
>  {
> -	struct usbip_device *ud = container_of(ut, struct usbip_device, eh);
> -
> -	while (1) {
> -		if (signal_pending(current)) {
> -			usbip_dbg_eh("signal catched!\n");
> -			break;
> -		}
> +	struct usbip_device *ud = data;
>  
> +	while (!kthread_should_stop()) {
>  		if (event_handler(ud) < 0)
>  			break;
>  
> @@ -79,38 +74,30 @@ static void event_handler_loop(struct usbip_task *ut)
>  					usbip_event_happened(ud));
>  		usbip_dbg_eh("wakeup\n");
>  	}
> +	return 0;
>  }

Same here, I think this is needed:

--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -71,7 +71,9 @@ static int event_handler_loop(void *data)
                        break;
 
                wait_event_interruptible(ud->eh_waitq,
-                                       usbip_event_happened(ud));
+                                       usbip_event_happened(ud) ||
+                                       kthread_should_stop());
+
                usbip_dbg_eh("wakeup\n");
        }
        return 0;

The event handler also needs to get a chance to
run the shutdown functions before it exists. 

This was implicitly the case before.

@@ -67,14 +67,14 @@ static int event_handler_loop(void *data)
        struct usbip_device *ud = data;
 
        while (!kthread_should_stop()) {
-               if (event_handler(ud) < 0)
-                       break;
-
                wait_event_interruptible(ud->eh_waitq,
                                        usbip_event_happened(ud) ||
                                        kthread_should_stop());
 
                usbip_dbg_eh("wakeup\n");
+
+               if (event_handler(ud) < 0)
+                       break;
        }
        return 0;
 }

>  int usbip_start_eh(struct usbip_device *ud)
>  {
> -	struct usbip_task *eh = &ud->eh;
> -	struct task_struct *th;
> -
>  	init_waitqueue_head(&ud->eh_waitq);
>  	ud->event = 0;
>  
> -	usbip_task_init(eh, "usbip_eh", event_handler_loop);
> -
> -	th = kthread_run(usbip_thread, (void *)eh, "usbip");
> -	if (IS_ERR(th)) {
> +	ud->eh = kthread_run(event_handler_loop, ud, "usbip_eh");
> +	if (IS_ERR(ud->eh)) {
>  		printk(KERN_WARNING
>  			"Unable to start control thread\n");
> -		return PTR_ERR(th);
> +		return PTR_ERR(ud->eh);
>  	}
> -
> -	wait_for_completion(&eh->thread_done);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(usbip_start_eh);
>  
>  void usbip_stop_eh(struct usbip_device *ud)
>  {
> -	struct usbip_task *eh = &ud->eh;
> -
> -	if (eh->thread == current)
> +	if (ud->eh == current)
>  		return; /* do not wait for myself */
>  
> -	wait_for_completion(&eh->thread_done);
> +	kthread_stop(ud->eh);
>  	usbip_dbg_eh("usbip_eh has finished\n");
>  }
>  EXPORT_SYMBOL_GPL(usbip_stop_eh);
> diff --git a/drivers/staging/usbip/vhci.h b/drivers/staging/usbip/vhci.h
> index 41a1fe5..ed51983 100644
> --- a/drivers/staging/usbip/vhci.h
> +++ b/drivers/staging/usbip/vhci.h
> @@ -116,8 +116,8 @@ extern struct attribute_group dev_attr_group;
>  /* vhci_hcd.c */
>  void rh_port_connect(int rhport, enum usb_device_speed speed);
>  void rh_port_disconnect(int rhport);
> -void vhci_rx_loop(struct usbip_task *ut);
> -void vhci_tx_loop(struct usbip_task *ut);
> +int vhci_rx_loop(void *data);
> +int vhci_tx_loop(void *data);
>  
>  #define hardware		(&the_controller->pdev.dev)
>  
> diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
> index 08bd26a..f048b47 100644
> --- a/drivers/staging/usbip/vhci_hcd.c
> +++ b/drivers/staging/usbip/vhci_hcd.c
> @@ -18,6 +18,7 @@
>   */
>  
>  #include <linux/slab.h>
> +#include <linux/kthread.h>
>  
>  #include "usbip_common.h"
>  #include "vhci.h"
> @@ -840,7 +841,10 @@ static void vhci_shutdown_connection(struct usbip_device *ud)
>  		kernel_sock_shutdown(ud->tcp_socket, SHUT_RDWR);
>  	}
>  
> -	usbip_stop_threads(&vdev->ud);
> +	/* kill threads related to this sdev, if v.c. exists */
> +	kthread_stop(vdev->ud.tcp_rx);
> +	kthread_stop(vdev->ud.tcp_tx);
> +
>  	usbip_uinfo("stop threads\n");
>  
>  	/* active connection is closed */
> @@ -907,8 +911,8 @@ static void vhci_device_init(struct vhci_device *vdev)
>  {
>  	memset(vdev, 0, sizeof(*vdev));
>  
> -	usbip_task_init(&vdev->ud.tcp_rx, "vhci_rx", vhci_rx_loop);
> -	usbip_task_init(&vdev->ud.tcp_tx, "vhci_tx", vhci_tx_loop);
> +	vdev->ud.tcp_rx = kthread_create(vhci_rx_loop, &vdev->ud, "vhci_rx");
> +	vdev->ud.tcp_tx = kthread_create(vhci_tx_loop, &vdev->ud, "vhci_tx");
>  
>  	vdev->ud.side   = USBIP_VHCI;
>  	vdev->ud.status = VDEV_ST_NULL;
> diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
> index 8147d72..b03b277 100644
> --- a/drivers/staging/usbip/vhci_rx.c
> +++ b/drivers/staging/usbip/vhci_rx.c
> @@ -18,6 +18,7 @@
>   */
>  
>  #include <linux/slab.h>
> +#include <linux/kthread.h>
>  
>  #include "usbip_common.h"
>  #include "vhci.h"
> @@ -235,22 +236,17 @@ static void vhci_rx_pdu(struct usbip_device *ud)
>  
>  /*-------------------------------------------------------------------------*/
>  
> -void vhci_rx_loop(struct usbip_task *ut)
> +int vhci_rx_loop(void *data)
>  {
> -	struct usbip_device *ud = container_of(ut, struct usbip_device, tcp_rx);
> -
> -
> -	while (1) {
> -		if (signal_pending(current)) {
> -			usbip_dbg_vhci_rx("signal catched!\n");
> -			break;
> -		}
> +	struct usbip_device *ud = data;
>  
>  
> +	while (!kthread_should_stop()) {
>  		if (usbip_event_happened(ud))
>  			break;
>  
>  		vhci_rx_pdu(ud);
>  	}
> -}
>  
> +	return 0;
> +}
> diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
> index f6e34e0..3f2459f 100644
> --- a/drivers/staging/usbip/vhci_sysfs.c
> +++ b/drivers/staging/usbip/vhci_sysfs.c
> @@ -220,16 +220,13 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
>  	vdev->ud.tcp_socket = socket;
>  	vdev->ud.status     = VDEV_ST_NOTASSIGNED;
>  
> +	wake_up_process(vdev->ud.tcp_rx);
> +	wake_up_process(vdev->ud.tcp_tx);
> +
>  	spin_unlock(&vdev->ud.lock);
>  	spin_unlock(&the_controller->lock);
>  	/* end the lock */

Is it ok to call wake_up_process() while holding
the spinlocks? (I don't know - just noticed the
comment which used to be there)

> -	/*
> -	 * this function will sleep, so should be out of the lock. but, it's ok
> -	 * because we already marked vdev as being used. really?
> -	 */
> -	usbip_start_threads(&vdev->ud);
> -
>  	rh_port_connect(rhport, speed);
>  
>  	return count;
> diff --git a/drivers/staging/usbip/vhci_tx.c b/drivers/staging/usbip/vhci_tx.c
> index e1c1f71..6d065b9 100644
> --- a/drivers/staging/usbip/vhci_tx.c
> +++ b/drivers/staging/usbip/vhci_tx.c
> @@ -18,6 +18,7 @@
>   */
>  
>  #include <linux/slab.h>
> +#include <linux/kthread.h>
>  
>  #include "usbip_common.h"
>  #include "vhci.h"
> @@ -215,17 +216,12 @@ static int vhci_send_cmd_unlink(struct vhci_device *vdev)
>  
>  /*-------------------------------------------------------------------------*/
>  
> -void vhci_tx_loop(struct usbip_task *ut)
> +int vhci_tx_loop(void *data)
>  {
> -	struct usbip_device *ud = container_of(ut, struct usbip_device, tcp_tx);
> +	struct usbip_device *ud = data;
>  	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
>  
> -	while (1) {
> -		if (signal_pending(current)) {
> -			usbip_uinfo("vhci_tx signal catched\n");
> -			break;
> -		}
> -
> +	while (!kthread_should_stop()) {
>  		if (vhci_send_cmd_submit(vdev) < 0)
>  			break;
>  

vhci_tx_loop() also needs the kthread_should_stop
in its wait_event_interruptible, I think.

--- a/drivers/staging/usbip/vhci_tx.c
+++ b/drivers/staging/usbip/vhci_tx.c
@@ -230,7 +230,8 @@ int vhci_tx_loop(void *data)
 
                wait_event_interruptible(vdev->waitq_tx,
                                (!list_empty(&vdev->priv_tx) ||
-                                !list_empty(&vdev->unlink_tx)));
+                                !list_empty(&vdev->unlink_tx)) ||
+                               kthread_should_stop());
 
                usbip_dbg_vhci_tx("pending urbs ?, now wake up\n");
        }

> @@ -238,4 +234,6 @@ void vhci_tx_loop(struct usbip_task *ut)
>  
>  		usbip_dbg_vhci_tx("pending urbs ?, now wake up\n");
>  	}
> +
> +	return 0;
>  }

I need to leave now for the next couple of days,
so this is a bit rushed.

I can take a closer look and do tests in different
setups during the next week.

	Max
