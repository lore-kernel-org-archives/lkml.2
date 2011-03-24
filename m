Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab1CXO6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:58:17 -0400
Received: from mail4.comsite.net ([205.238.176.238]:18555 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1CXO6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:58:16 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Message-id: <hvc-kick-notask@mdm.bga.com>
Subject: Re: hvc_console: Don't access hvc_task if not initialised
To: Amit Shah <amit.shah@redhat.com>
References: <df8ea6d65c1ceeb25b0a3fdfc66995b8a8273ea5.1300951793.git.amit.shah@redhat.com>
In-Reply-To: <df8ea6d65c1ceeb25b0a3fdfc66995b8a8273ea5.1300951793.git.amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, greg@kroah.com,
        Amit Shah <amit.shah@redhat.com>, linuxppc-dev@ozlabs.org
Date: Thu, 24 Mar 2011 08:58:04 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[removed stable list from discussion]

On Thu, 24 Mar 2011 07:29:58 -0000, Amit Shah wrote:
> hvc_open() can be called without having any backing device.  This
> results in a call to hvc_kick() which calls wake_up_process on a NULL
> pointer.  

How is hvc_open called without a hvc_driver registered to the tty layer?

> Ensure hvc is initialised by checking for a non-NULL hvc_task
> before waking up the hvc thread.

No if the task is missing the subsystem is really stuck.  Put a check
in open and refuse to open.

> 
> This was found by an autotest run for virtio_console without having a
> console backend.
> 

stack trace please

> CC: stable@kernel.org
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> 
> ---
> drivers/tty/hvc/hvc_console.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
> index e9cba13..b2cb5cc 100644
> --- a/drivers/tty/hvc/hvc_console.c
> +++ b/drivers/tty/hvc/hvc_console.c
> @@ -286,6 +286,9 @@ EXPORT_SYMBOL_GPL(hvc_instantiate);
>  /* Wake the sleeping khvcd */
>  void hvc_kick(void)
>  {
> +	if (!hvc_task)
> +		return;
> +
>  	hvc_kicked = 1;
>  	wake_up_process(hvc_task);
>  }
