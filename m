Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1LGKX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:23:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab1LGKX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:23:26 -0500
Date: Wed, 7 Dec 2011 12:25:08 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20111207102507.GB8326@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz>,
"Rafael J. Wysocki" <rjw@sisk.pl>,
Len Brown <len.brown@intel.com>,
linux-pm@vger.kernel.org
Bcc: 
Subject: Re: [PATCH v4 12/12] virtio: balloon: Add freeze, restore handlers
 to support S4
Reply-To: 
In-Reply-To: <5deccc36afa59032f0e3b10a653773bad511f303.1323199985.git.amit.shah@redhat.com>

On Wed, Dec 07, 2011 at 01:18:50AM +0530, Amit Shah wrote:
> Now to not race with a host issuing ballooning requests while we are in
> the process of freezing, we just exit from the vballoon kthread when the
> processes are asked to freeze.  Upon thaw and restore, we re-start the
> thread.

...

> ---
>  drivers/virtio/virtio_balloon.c |   79 ++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 78 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 8bf99be..10ec638 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -258,7 +258,13 @@ static int balloon(void *_vballoon)
>  	while (!kthread_should_stop()) {
>  		s64 diff;
>  
> -		try_to_freeze();
> +		/*
> +		 * On suspend, we want to exit this thread.  We will
> +		 * start a new thread on resume.
> +		 */
> +		if (freezing(current))
> +			break;
> +
>  		wait_event_interruptible(vb->config_change,
>  					 (diff = towards_target(vb)) != 0
>  					 || vb->need_stats_update

...

Note: this relies on kthreads being frozen before devices.
Looking at kernel/power/hibernate.c this is the case,
but I think we should add a comment to note this.

Also Cc linux-pm crowd in case I got it wrong.

-- 
MST
