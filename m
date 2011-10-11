Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1JKUr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 16:47:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48260 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1JKUr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 16:47:57 -0400
Date: Tue, 11 Oct 2011 13:47:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-Id: <20111011134753.2751aeb1.akpm@linux-foundation.org>
In-Reply-To: <20110922184614.25419.84606.stgit@ponder>
References: <20110922184614.25419.84606.stgit@ponder>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011 12:51:23 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> Allow drivers to report at probe time that they cannot get all the resources
> required by the device, and should be retried at a later time.
> 
> This should completely solve the problem of getting devices
> initialized in the right order.  Right now this is mostly handled by
> mucking about with initcall ordering which is a complete hack, and
> doesn't even remotely handle the case where device drivers are in
> modules.  This approach completely sidesteps the issues by allowing
> driver registration to occur in any order, and any driver can request
> to be retried after a few more other drivers get probed.

What happens is there is a circular dependency, or if a driver's
preconditions are never met?  AFAICT the code keeps running the probe
function for ever.

If so: bad.  The kernel should detect such situations, should
exhaustively report them and if possible, fix them up and struggle
onwards.

>
> ...
>
> +	 * This bit is tricky.  We want to process every device in the
> +	 * deferred list, but devices can be removed from the list at any
> +	 * time while inside this for-each loop.  There are two things that
> +	 * need to be protected against:
> +	 * - if the device is removed from the deferred_probe_list, then we
> +	 *   loose our place in the loop.  Since any device can be removed

s/loose/lose/

> +	 *   asynchronously, list_for_each_entry_safe() wouldn't make things
> +	 *   much better.  Simplest solution is to restart walking the list
> +	 *   whenever the current device gets removed.  Not the most efficient,
> +	 *   but is simple to implement and easy to audit for correctness.
> +	 * - if the device is unregistered, and freed, then there is a risk
> +	 *   of a null pointer dereference.  This code uses get/put_device()
> +	 *   to ensure the device cannot disappear from under our feet.
> +	 */
>
> ...
>
> +		/* Drop the mutex while probing each device; the probe path
> +		 * may manipulate the deferred list */

Please don't invent new coding styles.  Like this:

		/*
		 * Drop the mutex while probing each device; the probe path
		 * may manipulate the deferred list
		 */

(entire patch)

>
> ...
>
