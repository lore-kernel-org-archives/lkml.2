Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2BOSuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:50:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52757 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2BOSuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:50:51 -0500
Message-ID: <1329331847.2469.2.camel@edumazet-laptop>
Subject: Re: [PATCH] char random: fix boot id uniqueness race (v3)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Date: Wed, 15 Feb 2012 19:50:47 +0100
In-Reply-To: <20120215184044.GB19182@Krystal>
References: <20120215184044.GB19182@Krystal>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 15 février 2012 à 13:40 -0500, Mathieu Desnoyers a écrit :
> The proc file /proc/sys/kernel/random/boot_id can be read concurrently
> by user-space processes. If two (or more) user-space processes
> concurrently read boot_id when sysctl_bootid is not yet assigned, a race
> can occur making boot_id differ between the reads. Because the whole
> point of the boot id is to be unique across a kernel execution, fix this
> by protecting this operation with a spinlock.
> 
> Given that this operation is not frequently used, hitting the spinlock
> on each call should not be an issue.
> 
> * Changelog since v1:
> - boot_id_mutex is now declared within the proc_do_uuid scope.
> - added explanation for memory barriers.
> 
> * Changelog since v2:
> - simplify: use spinlock on all paths, suggested by Eric Dumazet.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: "Theodore Ts'o" <tytso@mit.edu>
> CC: Matt Mackall <mpm@selenic.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Greg Kroah-Hartman <greg@kroah.com>
> ---
>  drivers/char/random.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6-lttng/drivers/char/random.c
> ===================================================================
> --- linux-2.6-lttng.orig/drivers/char/random.c
> +++ linux-2.6-lttng/drivers/char/random.c
> @@ -1250,10 +1250,15 @@ static int proc_do_uuid(ctl_table *table
>  	uuid = table->data;
>  	if (!uuid) {
>  		uuid = tmp_uuid;
> -		uuid[8] = 0;
> -	}
> -	if (uuid[8] == 0)
>  		generate_random_uuid(uuid);
> +	} else {
> +		static DEFINE_SPINLOCK(bootid_spinlock);
> +
> +		spin_lock(&bootid_spinlock);
> +		if (!uuid[8])
> +			generate_random_uuid(uuid);
> +		spin_unlock(&bootid_spinlock);
> +	}
>  
>  	sprintf(buf, "%pU", uuid);
>  
> 

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks Mathieu !


