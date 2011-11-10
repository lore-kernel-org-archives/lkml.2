Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1KJSRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:17:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab1KJSQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:16:56 -0500
Date: Thu, 10 Nov 2011 19:12:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 2/3] pids: Split alloc_pidmap into parts
Message-ID: <20111110181217.GA32156@redhat.com>
References: <4EBC0696.9030103@parallels.com> <4EBC06C5.4080805@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBC06C5.4080805@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10, Pavel Emelyanov wrote:
>
> The map's page allocation code is moved to separate function
> to make clone-with-pids patching simpler.

Sorry for the really cosmetic nit, but I simply can't resist...

> +static int alloc_pidmap_page(struct pidmap *map)
> +{
> +	void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +
> +	/*
> +	 * Free the page if someone raced with us
> +	 * installing it:
> +	 */
> +	spin_lock_irq(&pidmap_lock);
> +	if (!map->page) {
> +		map->page = page;
> +		page = NULL;
> +	}
> +	spin_unlock_irq(&pidmap_lock);
> +	kfree(page);
> +
> +	return map->page ? 0 : -1;

Again, I won't insist, but "return !map->page" looks more readable.
Even better (imho) would be to return map->page, and change the
single caller to check "if (!alloc_pidnap_page())".

Oleg.

