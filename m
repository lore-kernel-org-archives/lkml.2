Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1AXQJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:09:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52690 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab1AXQJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:09:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Sr+ceBbxylEmIwOQJDQfkLn6XDb2GMe3H9MOeZAVCnhAW1SQoZ7XY6t6N1ej496Eil
         28XHjWrrdfY20kt9dby6VeOxb/OnBNJ0Zb921QVO3/QaUyuy3n8zirqEm5L9RPc/LPj4
         tYYWmObU2qzxIB2c4jUJr4wauwBT/F0CI9HG4=
MIME-Version: 1.0
In-Reply-To: <1294062595-30097-18-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-18-git-send-email-tj@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 24 Jan 2011 17:09:18 +0100
X-Google-Sender-Auth: d5BVv9h-V9V82xy5kShgzQiGxSY
Message-ID: <AANLkTi=Fg8wjf-XfVsq0X4RWx7i8F1V7gC6-8Y5LPbnL@mail.gmail.com>
Subject: Re: [PATCH 17/32] scsi/ibmvstgt: use system_wq instead of vtgtd workqueue
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 2:49 PM, Tejun Heo <tj@kernel.org> wrote:
>
> The target driver is not in the memory reclaim path and doesn't need a
> dedicated workqueue.  Drop vtgtd and use system_wq instead.  The used
> work item is sync flushed on removal.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: linux-scsi@vger.kernel.org
> ---
> Only compile tested.  Please feel free to take it into the subsystem
> tree or simply ack - I'll route it through the wq tree.
>
> Thanks.
>
>  drivers/scsi/ibmvscsi/ibmvstgt.c |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
> index 2256bab..47fc632 100644
> --- a/drivers/scsi/ibmvscsi/ibmvstgt.c
> +++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
> @@ -74,7 +74,6 @@ struct vio_port {
>        struct srp_rport *rport;
>  };
>
> -static struct workqueue_struct *vtgtd;
>  static struct scsi_transport_template *ibmvstgt_transport_template;
>
>  /*
> @@ -546,7 +545,7 @@ static irqreturn_t ibmvstgt_interrupt(int dummy, void *data)
>        struct vio_port *vport = target_to_port(target);
>
>        vio_disable_interrupts(vport->dma_dev);
> -       queue_work(vtgtd, &vport->crq_work);
> +       schedule_work(&vport->crq_work);
>
>        return IRQ_HANDLED;
>  }
> @@ -900,6 +899,7 @@ static int ibmvstgt_remove(struct vio_dev *dev)
>        crq_queue_destroy(target);
>        srp_remove_host(shost);
>        scsi_remove_host(shost);
> +       flush_work_sync(&vport->crq_work);
>        scsi_tgt_free_queue(shost);
>        srp_target_free(target);
>        kfree(vport);
> @@ -967,21 +967,15 @@ static int __init ibmvstgt_init(void)
>        if (!ibmvstgt_transport_template)
>                return err;
>
> -       vtgtd = create_workqueue("ibmvtgtd");
> -       if (!vtgtd)
> -               goto release_transport;
> -
>        err = get_system_info();
>        if (err)
> -               goto destroy_wq;
> +               goto release_transport;
>
>        err = vio_register_driver(&ibmvstgt_driver);
>        if (err)
> -               goto destroy_wq;
> +               goto release_transport;
>
>        return 0;
> -destroy_wq:
> -       destroy_workqueue(vtgtd);
>  release_transport:
>        srp_release_transport(ibmvstgt_transport_template);
>        return err;
> @@ -991,7 +985,6 @@ static void __exit ibmvstgt_exit(void)
>  {
>        printk("Unregister IBM virtual SCSI driver\n");
>
> -       destroy_workqueue(vtgtd);
>        vio_unregister_driver(&ibmvstgt_driver);
>        srp_release_transport(ibmvstgt_transport_template);
>  }

(added Brian King and Robert Jennings in CC)

Hello Tejun,

Insertion of  flush_work_sync() fixes a race - that's a good catch.
flush_work_sync() should be invoked a little earlier though because
the scheduled work may access the queue destroyed by the
crq_queue_destroy(target) call. And the CRQ interrupt should be
disabled from before flush_work_sync() is invoked until after the CRQ
has been destroyed.

Regarding the queue removal: I might have missed something, but why
would you like to remove the vtgtd work queue ? Since the ibmvstgt
driver is a storage target driver, processing latency matters. I'm
afraid that switching from a dedicated queue to the global work queue
will increase processing latency.

Bart.
