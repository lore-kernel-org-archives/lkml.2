Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2AaQAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:00:07 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:39735 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab2AaQAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:00:03 -0500
Date: Tue, 31 Jan 2012 10:59:55 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matt Mackall <mpm@selenic.com>, Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char random: fix boot id uniqueness race
Message-ID: <20120131155955.GA24356@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Matt Mackall <mpm@selenic.com>, Greg Kroah-Hartman <greg@kroah.com>,
	linux-kernel@vger.kernel.org
References: <20120130044012.GA31966@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130044012.GA31966@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 11:40:12PM -0500, Mathieu Desnoyers wrote:
> Index: linux-2.6-lttng/drivers/char/random.c
> ===================================================================
> --- linux-2.6-lttng.orig/drivers/char/random.c
> +++ linux-2.6-lttng/drivers/char/random.c
> @@ -1231,6 +1231,8 @@ static int min_read_thresh = 8, min_writ
>  static int max_read_thresh = INPUT_POOL_WORDS * 32;
>  static int max_write_thresh = INPUT_POOL_WORDS * 32;
>  static char sysctl_bootid[16];
> +static int boot_id_generated;
> +static DEFINE_MUTEX(boot_id_mutex);

My preference would be to put these statics in proc_do_uuid(), but
that's arguably a nit.

> +	} else {
> +		if (unlikely(!ACCESS_ONCE(boot_id_generated))) {
> +			mutex_lock(&boot_id_mutex);
> +			if (!boot_id_generated) {
> +				generate_random_uuid(uuid);
> +				/* Store uuid before boot_id_generated. */
> +				smp_wmb();
> +				boot_id_generated = 1;
> +			}
> +			mutex_unlock(&boot_id_mutex);
> +		} else {
> +			/* Load boot_id_generated before uuid */
> +			smp_rmb();
> +		}
> +	}

I don't believe the smp_wmb() and smp_rmb() are necessary here; the
mutex_lock() and mutex_unlock() should put the necessary memory
barriers in place.

Regards,

						- Ted
