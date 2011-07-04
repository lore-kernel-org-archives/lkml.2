Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab1GDT5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 15:57:03 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:58014 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751802Ab1GDT46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 15:56:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RXRnNa3QofWnt59oGd33R7L0KxE+lUJWGr9MUBimS5SC/HE6NeXiQRxQ9fy3hm0uKkFi3ikpr6yioBRXH2n9NV+ESTMStxi5yLaEZkC6uphJxoqc13Se4sxz6X1tDFJL;
Date: Mon, 4 Jul 2011 12:56:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-Id: <20110704125655.57de1f6e.rdunlap@xenotime.net>
In-Reply-To: <20110704170949.11059.92774.stgit@ponder>
References: <20110704170949.11059.92774.stgit@ponder>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jul 2011 11:11:59 -0600 Grant Likely wrote:

> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 6658da7..ccbf3d3 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -28,6 +28,62 @@
>  #include "base.h"
>  #include "power/power.h"
>  
> +/**
> + * deferred_probe_work_func() - Retry probing devices in the deferred list.
> + */
> +static DEFINE_MUTEX(deferred_probe_mutex);
> +static LIST_HEAD(deferred_probe_list);
> +static void deferred_probe_work_func(struct work_struct *work)

The kernel-doc notation needs to be immediately before the function,
without the intervening data...

> +{
> +	struct device *dev;
> +	/*
> +	 * This bit is tricky.  We want to process every device in the
> +	 * deferred list, but devices can be removed from the list at any
> +	 * time while inside this for-each loop.  There are two things that
> +	 * need to be protected against:
> +	 * - if the device is removed from the deferred_probe_list, then we
> +	 *   loose our place in the loop.  Since any device can be removed
> +	 *   asynchronously, list_for_each_entry_safe() wouldn't make things
> +	 *   much better.  Simplest solution is to restart walking the list
> +	 *   whenever the current device gets removed.  Not the most efficient,
> +	 *   but is simple to implement and easy to audit for correctness.
> +	 * - if the device is unregistered, and freed, then there is a risk
> +	 *   of a null pointer dereference.  This code uses get/put_device()
> +	 *   to ensure the device cannot disappear from under our feet.
> +	 */


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
