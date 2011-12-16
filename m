Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1LPGB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 01:01:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1LPGBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 01:01:13 -0500
Date: Fri, 16 Dec 2011 11:30:48 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Miche Baker-Harvey <miche@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
Subject: Re: [PATCH v3 2/3] hvc_init(): Enforce one-time initialization.
Message-ID: <20111216060048.GA12211@amit-x200.redhat.com>
References: <20111108214504.28884.61814.stgit@miche.sea.corp.google.com>
 <874nybqo0o.fsf@rustcorp.com.au>
 <CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
 <20111123103852.GG16665@amit-x200.redhat.com>
 <CAB8RdaoDxMCgTjuGP70bGrsrtgh=USYtU3Spo5OPtVMYAM5EzQ@mail.gmail.com>
 <20111129142149.GE2822@amit-x200.redhat.com>
 <CAB8RdapuPRym2dH_9mgmGdzpCxnP1KpS+hS8JJ-geVkga5fMcw@mail.gmail.com>
 <CAB8Rdapfuf5XH+X9gsUL+CJ9gTQcSNfq4Dj9DoYWQeFgD04ODQ@mail.gmail.com>
 <20111205105452.GB27683@amit-x200.redhat.com>
 <CAB8Rdar=qOokxZkjQVRmo=zN_f75jPwzU+6=WBRo0g+P7w+pAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB8Rdar=qOokxZkjQVRmo=zN_f75jPwzU+6=WBRo0g+P7w+pAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 06 Dec 2011 [09:05:38], Miche Baker-Harvey wrote:
> Amit,
> 
> Ah, indeed.  I am not using MSI-X, so virtio_pci::vp_try_to_find_vqs()
> calls vp_request_intx() and sets up an interrupt callback.  From
> there, when an interrupt occurs, the stack looks something like this:
> 
> virtio_pci::vp_interrupt()
>   virtio_pci::vp_vring_interrupt()
>     virtio_ring::vring_interrupt()
>       vq->vq.callback()  <-- in this case, that's virtio_console::control_intr()
>         workqueue::schedule_work()
>           workqueue::queue_work()
>             queue_work_on(get_cpu())  <-- queues the work on the current CPU.
> 
> I'm not doing anything to keep multiple control message from being
> sent concurrently to the guest, and we will take those interrupts on
> any CPU. I've confirmed that the two instances of
> handle_control_message() are occurring on different CPUs.

Hi Miche,

Here's a quick-and-dirty hack that should help.  I've not tested this,
and it's not yet signed-off-by.  Let me know if this helps.

>From 16708fa247c0dd34aa55d78166d65e463f9be6d6 Mon Sep 17 00:00:00 2001
Message-Id: <16708fa247c0dd34aa55d78166d65e463f9be6d6.1324015123.git.amit.shah@redhat.com>
From: Amit Shah <amit.shah@redhat.com>
Date: Fri, 16 Dec 2011 11:27:04 +0530
Subject: [PATCH 1/1] virtio: console: Serialise control work

We currently allow multiple instances of the control work handler to run
in parallel.  This isn't expected to work; serialise access by disabling
interrupts on new packets from the Host and enable them when all the
existing ones are consumed.
---
 drivers/char/virtio_console.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 8e3c46d..72d396c 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1466,6 +1466,7 @@ static void control_work_handler(struct work_struct *work)
 	portdev = container_of(work, struct ports_device, control_work);
 	vq = portdev->c_ivq;
 
+ start:
 	spin_lock(&portdev->cvq_lock);
 	while ((buf = virtqueue_get_buf(vq, &len))) {
 		spin_unlock(&portdev->cvq_lock);
@@ -1483,6 +1484,10 @@ static void control_work_handler(struct work_struct *work)
 		}
 	}
 	spin_unlock(&portdev->cvq_lock);
+	if (unlikely(!virtqueue_enable_cb(vq))) {
+		virtqueue_disable_cb(vq);
+		goto start;
+	}
 }
 
 static void out_intr(struct virtqueue *vq)
@@ -1533,6 +1538,7 @@ static void control_intr(struct virtqueue *vq)
 {
 	struct ports_device *portdev;
 
+	virtqueue_disable_cb(vq);
 	portdev = vq->vdev->priv;
 	schedule_work(&portdev->control_work);
 }
-- 
1.7.7.4



		Amit
