Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1H2QjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab1H2QjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:39:08 -0400
Date: Mon, 29 Aug 2011 18:35:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 3/4] freezer: check freezing() before
	leaving FROZEN state
Message-ID: <20110829163533.GB9973@redhat.com>
References: <20110829140418.GB18871@mtj.dyndns.org> <20110829140509.GC18871@mtj.dyndns.org> <20110829140549.GD18871@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829140549.GD18871@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29, Tejun Heo wrote:
>
> --- work.orig/kernel/freezer.c
> +++ work/kernel/freezer.c
> @@ -60,6 +60,7 @@ bool __refrigerator(bool check_kthr_stop
>  	 */
>  	spin_lock_irq(&freezer_lock);
>  	current->flags |= PF_FROZEN;
> +refreeze:
>  	spin_unlock_irq(&freezer_lock);
>
>  	save = current->state;
> @@ -78,8 +79,10 @@ bool __refrigerator(bool check_kthr_stop
>  		schedule();
>  	}
>
> -	/* leave FROZEN */
> +	/* leave FROZEN after checking freezing() holding freezer_lock */
>  	spin_lock_irq(&freezer_lock);
> +	if (freezing(current))
> +		goto refreeze;

Looks like, you should move "save = current->state" up then.

Oleg.

