Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab2JVOdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:33:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53248 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755080Ab2JVOdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:33:14 -0400
Date: Mon, 22 Oct 2012 10:33:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [RFC PATCH v2 2/6] PM / Runtime: introduce pm_runtime_set_memalloc_noio()
In-Reply-To: <1350894794-1494-3-git-send-email-ming.lei@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1210221023300.1724-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Ming Lei wrote:

> +void pm_runtime_set_memalloc_noio(struct device *dev, bool enable)
> +{
> +	dev->power.memalloc_noio_resume = enable;
> +
> +	if (!dev->parent)
> +		return;
> +
> +	if (enable) {
> +		pm_runtime_set_memalloc_noio(dev->parent, 1);
> +	} else {
> +		/* only clear the flag for one device if all
> +		 * children of the device don't set the flag.
> +		 */
> +		if (device_for_each_child(dev->parent, NULL,
> +					  dev_memalloc_noio))
> +			return;
> +
> +		pm_runtime_set_memalloc_noio(dev->parent, 0);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(pm_runtime_set_memalloc_noio);

Tail recursion should be implemented as a loop, not as an explicit
recursion.  That is, the function should be:

void pm_runtime_set_memalloc_noio(struct device *dev, bool enable)
{
	do {
		dev->power.memalloc_noio_resume = enable;

		if (!enable) {
			/*
			 * Don't clear the parent's flag if any of the
			 * parent's children have their flag set.
			 */
			if (device_for_each_child(dev->parent, NULL,
					  dev_memalloc_noio))
				return;
		}
		dev = dev->parent;
	} while (dev);
}

except that you need to add locking, for two reasons:

	There's a race.  What happens if another child sets the flag
	between the time device_for_each_child() runs and the next loop
	iteration?

	Even without a race, access to bitfields is not SMP-safe 
	without locking.

Alan Stern

