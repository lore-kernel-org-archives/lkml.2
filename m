Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0FZIfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 04:35:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0FZIfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 04:35:14 -0400
Date: Sat, 26 Jun 2010 18:35:11 +1000
From: Nick Piggin <npiggin@suse.de>
To: Bob Peterson <rpeterso@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cache last free vmap_area to avoid restarting beginning
Message-ID: <20100626083511.GF29809@laptop>
References: <118879818.966271277501902144.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <1731662946.966291277502022446.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1731662946.966291277502022446.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 05:40:22PM -0400, Bob Peterson wrote:
> On 2010-05-25 8:43:23, Nick Piggin wrote:
> Hey Nick,
> 
> I spotted what seems to be a regression in this patch.
> The spin_lock was moved before the try loop:
> 
> 	spin_lock(&vmap_area_lock);
> retry:
> 
> But later, after the overflow label, it can unlock the spin_lock and
> loop back to retry without the spin_lock locked.  See:
> 
> overflow:
> 		spin_unlock(&vmap_area_lock);
> 		if (!purged) {
> 			purge_vmap_area_lazy();
> 			purged = 1;
> 			goto retry;
> 
> If I'm not mistaken we should either put the spin_lock back below the
> retry label or move the spin_unlock after the if (!purged) to prevent
> accesses without the spin_lock held.
> 
> Regards,
> 
> Bob Peterson
> Red Hat File Systems

Hi Bob,

Thanks for having a look. You are right, I think Minchan spotted
this too and the version in Andrew Morton's tree should have that
fixed.

http://userweb.kernel.org/~akpm/mmotm/broken-out/mm-vmap-area-cache.patch

Thanks,
Nick

