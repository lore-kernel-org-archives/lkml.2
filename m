Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0GFD6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 23:58:32 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:17540 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0GFD6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 23:58:30 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAONGMkyrR7Ht/2dsb2JhbACfenGkaZovhSUEg3g
X-IronPort-AV: E=Sophos;i="4.53,544,1272844800"; 
   d="scan'208";a="554820648"
From: Roland Dreier <rdreier@cisco.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kmem_cache_destroy() badness with SLUB
References: <1277688701.4200.159.camel@pasglop>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 05 Jul 2010 20:58:27 -0700
In-Reply-To: <1277688701.4200.159.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Mon, 28 Jun 2010 11:31:41 +1000")
Message-ID: <aday6dpmfbw.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks !
Internally, I'm hitting a little "nit"...

sysfs_slab_add() has this check:

	if (slab_state < SYSFS)
		/* Defer until later */
		return 0;

But sysfs_slab_remove() doesn't.

So if the slab is created -and- destroyed at, for example, arch_initcall
time, then we hit a WARN in the kobject code, trying to dispose of a
non-existing kobject.

Now, at first sight, just adding the same test to sysfs_slab_remove()
would do the job... but it all seems very racy to me.

I don't understand in fact how this slab_state deals with races at all. 

What prevents us from hitting slab_sysfs_init() at the same time as
another CPU deos sysfs_slab_add() ? How do that deal with collisions
trying to register the same kobject twice ? Similar race with remove...

Shouldn't we have a mutex around those guys ?

Cheers,
Ben.


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
