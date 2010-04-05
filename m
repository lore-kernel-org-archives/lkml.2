Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab0DEVYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:24:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756379Ab0DEVYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:24:43 -0400
Date: Mon, 5 Apr 2010 14:24:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-kernel@vger.kernel.org, pv-drivers@vmware.com,
       Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] VMware Balloon driver
Message-Id: <20100405142419.2c9bea3d.akpm@linux-foundation.org>
In-Reply-To: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Apr 2010 14:52:02 -0700
Dmitry Torokhov <dtor@vmware.com> wrote:

> This is standalone version of VMware Balloon driver. Unlike previous
> version, that tried to integrate VMware ballooning transport into virtio
> subsystem, and use stock virtio_ballon driver, this one implements both
> controlling thread/algorithm and hypervisor transport.
> 
> We are submitting standalone driver because KVM maintainer (Avi Kivity)
> expressed opinion (rightly) that our transport does not fit well into
> virtqueue paradigm and thus it does not make much sense to integrate
> with virtio.
> 

I think I've forgotten what balloon drivers do.  Are they as nasty a
hack as I remember believing them to be?

A summary of what this code sets out to do, and how it does it would be
useful.

Also please explain the applicability of this driver.  Will xen use it?
kvm?  Out-of-tree code?

The code implements a user-visible API (in /proc, at least).  Please
fully describe the proposed interface(s) in the changelog so we can
review and understand that proposal.

>
> ...
>
> +static bool vmballoon_send_start(struct vmballoon *b)
> +{
> +	unsigned long status, dummy;
> +
> +	STATS_INC(b->stats.start);
> +
> +	status = VMWARE_BALLOON_CMD(START, VMW_BALLOON_PROTOCOL_VERSION, dummy);
> +	if (status == VMW_BALLOON_SUCCESS)
> +		return true;
> +
> +	pr_debug("%s - failed, hv returns %ld\n", __func__, status);

The code refers to something called "hv".  I suspect that's stale?

> +	STATS_INC(b->stats.start_fail);
> +	return false;
> +}
> +
> +static bool vmballoon_check_status(struct vmballoon *b, unsigned long status)
> +{
> +	switch (status) {
> +	case VMW_BALLOON_SUCCESS:
> +		return true;
> +
> +	case VMW_BALLOON_ERROR_RESET:
> +		b->reset_required = true;
> +		/* fall through */
> +
> +	default:
> +		return false;
> +	}
> +}
> +
> +static bool vmballoon_send_guest_id(struct vmballoon *b)
> +{
> +	unsigned long status, dummy;
> +
> +	status = VMWARE_BALLOON_CMD(GUEST_ID, VMW_BALLOON_GUEST_ID, dummy);
> +
> +	STATS_INC(b->stats.guest_type);
> +
> +	if (vmballoon_check_status(b, status))
> +		return true;
> +
> +	pr_debug("%s - failed, hv returns %ld\n", __func__, status);
> +	STATS_INC(b->stats.guest_type_fail);
> +	return false;
> +}

The lack of comments makes it all a bit hard to take in.

>
> ...
>
> +static int __init vmballoon_init(void)
> +{
> +	int error;
> +
> +	/*
> +	 * Check if we are running on VMware's hypervisor and bail out
> +	 * if we are not.
> +	 */
> +	if (!vmware_platform())
> +		return -ENODEV;
> +
> +	vmballoon_wq = create_freezeable_workqueue("vmmemctl");
> +	if (!vmballoon_wq) {
> +		pr_err("failed to create workqueue\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* initialize global state */
> +	memset(&balloon, 0, sizeof(balloon));

The memset seems to be unneeded.

> +	INIT_LIST_HEAD(&balloon.pages);
> +	INIT_LIST_HEAD(&balloon.refused_pages);
> +
> +	/* initialize rates */
> +	balloon.rate_alloc = VMW_BALLOON_RATE_ALLOC_MAX;
> +	balloon.rate_free = VMW_BALLOON_RATE_FREE_MAX;
> +
> +	INIT_DELAYED_WORK(&balloon.dwork, vmballoon_work);
> +
> +	/*
> +	 * Start balloon.
> +	 */
> +	if (!vmballoon_send_start(&balloon)) {
> +		pr_err("failed to send start command to the host\n");
> +		error = -EIO;
> +		goto fail;
> +	}
> +
> +	if (!vmballoon_send_guest_id(&balloon)) {
> +		pr_err("failed to send guest ID to the host\n");
> +		error = -EIO;
> +		goto fail;
> +	}
> +
> +	error = vmballoon_procfs_init(&balloon);
> +	if (error)
> +		goto fail;
> +
> +	queue_delayed_work(vmballoon_wq, &balloon.dwork, 0);
> +
> +	return 0;
> +
> +fail:
> +	destroy_workqueue(vmballoon_wq);
> +	return error;
> +}
>
> ...
>

Oh well, ho hum.  Help is needed on working out what to do about this,
please.

Congrats on the new job, btw ;)

