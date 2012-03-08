Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab2CHTEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:04:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab2CHTEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:04:50 -0500
Date: Thu, 8 Mar 2012 19:57:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: ping: drivers/staging/usbip/ abuses task_is_dead/exit_state
Message-ID: <20120308185739.GA18935@redhat.com>
References: <20110919214531.GA18085@sergelap> <20110920122202.GA26504@redhat.com> <20110920124419.GA10759@hallyn.com> <20110920134108.GA30749@redhat.com> <20110920143920.GA15859@redhat.com> <20110920143942.GB15859@redhat.com> <20110920151410.GA16569@redhat.com> <20110920183810.GA25159@suse.de> <20120306173925.GA17551@redhat.com> <20120306193040.GD21503@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306193040.GD21503@distanz.ch>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06, Tobias Klauser wrote:
>
> On 2012-03-06 at 18:39:25 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > OK, since nobody cares, probably I should make the patch even if I don't
> > understand this code at all and can't test the change.
> >
> > But, Tobias, may be you can explain what this task_is_dead() check was
> > supposed to do?
>
> As mentioned in the commit message, this was needed for me to work
> around a NULL pointer dereference I got during unbinding

Where? OK, I guess you do not remember the trace ;)

> (I only
> experienced this behaviour on the nios2 platform though, couldn't
> reproduce it on e.g. x86_64).

OK,

> I wasn't really familiar with the codebase of usbip (and still am not)
> but came up with the fix by more or less blindly copying what the
> opposite side is checking for in stub_shutdown_connection(). This fixed
> the behaviour for me and seemed legitimate as it was done equally there.

But this looks "obviously wrong", and afaics just hides the problem.
Not to mention this check is racy, it is simply unsafe to dereference
this task_struct if the kthread has already exited.

At first glance we need something like the patch below (and stub_dev.c
needs the same fix). It assumes that:

	- vhci_shutdown_connection() is the only caller of kthread_stop(),
	  iow nobody else does kthread_stop(tcp_*x)

	- we can't leak the task_struct, vhci_shutdown_connection() should
	  be called in any case at some point.

I'll try to grep more, but perhaps you can ack my understanding?

Oleg.

--- x/drivers/staging/usbip/vhci_sysfs.c
+++ x/drivers/staging/usbip/vhci_sysfs.c
@@ -155,6 +155,16 @@ static int valid_args(__u32 rhport, enum
 	return 0;
 }
 
+#define kthread_get_run(threadfn, data, namefmt, ...)			   \
+({									   \
+	struct task_struct *__k						   \
+		= kthread_create(threadfn, data, namefmt, ## __VA_ARGS__); \
+	if (!IS_ERR(__k)) {						   \
+		get_task_struct(__k);
+		wake_up_process(__k);					   \
+	}								   \
+	__k;								   \
+})
 /*
  * To start a new USB/IP attachment, a userland program needs to setup a TCP
  * connection and then write its socket descriptor with remote device
@@ -222,8 +232,8 @@ static ssize_t store_attach(struct devic
 	spin_unlock(&the_controller->lock);
 	/* end the lock */
 
-	vdev->ud.tcp_rx = kthread_run(vhci_rx_loop, &vdev->ud, "vhci_rx");
-	vdev->ud.tcp_tx = kthread_run(vhci_tx_loop, &vdev->ud, "vhci_tx");
+	vdev->ud.tcp_rx = kthread_get_run(vhci_rx_loop, &vdev->ud, "vhci_rx");
+	vdev->ud.tcp_tx = kthread_get_run(vhci_tx_loop, &vdev->ud, "vhci_tx");
 
 	rh_port_connect(rhport, speed);
 
--- x/drivers/staging/usbip/vhci_hcd.c
+++ x/drivers/staging/usbip/vhci_hcd.c
@@ -860,10 +860,14 @@ static void vhci_shutdown_connection(str
 	}
 
 	/* kill threads related to this sdev, if v.c. exists */
-	if (vdev->ud.tcp_rx && !task_is_dead(vdev->ud.tcp_rx))
+	if (vdev->ud.tcp_rx) {
 		kthread_stop(vdev->ud.tcp_rx);
-	if (vdev->ud.tcp_tx && !task_is_dead(vdev->ud.tcp_tx))
+		put_task_struct(vdev->ud.tcp_rx);
+	}
+	if (vdev->ud.tcp_tx) {
 		kthread_stop(vdev->ud.tcp_tx);
+		put_task_struct(vdev->ud.tcp_tx);
+	}
 
 	pr_info("stop threads\n");
 

