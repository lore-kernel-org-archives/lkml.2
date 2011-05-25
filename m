Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab1EYPmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:42:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62328 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab1EYPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IhzOStPYfyyLm+kn4TvXRlHQsMzdE5I+jQi77EMriY/9K5cL4vTVOtIZfs9FNZsDwx
         o58BJg1W1LHNxN266RMav7aEPHvBvi8m/WiL3mddtfXAIpbn1blRxsnSWpbh8PXIzQTn
         u1HLdu8ZPqiUlwFjKg7VzoQGUfk1iKzLwjn40=
Subject: Re: SLUB regression in current Linus
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: James Morris <jmorris@namei.org>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1105250945240.23309@router.home>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
	 <alpine.LRH.2.00.1105242204100.12283@tundra.namei.org>
	 <alpine.DEB.2.00.1105240908100.25760@router.home>
	 <alpine.LRH.2.00.1105250813290.16922@tundra.namei.org>
	 <alpine.DEB.2.00.1105250945240.23309@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 17:42:29 +0200
Message-ID: <1306338149.2820.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 25 mai 2011 à 09:47 -0500, Christoph Lameter a écrit :
> On Wed, 25 May 2011, James Morris wrote:
> 
> > It turned out the system was still unstable with the attached config
> > (e.g. spontaneous reboot).
> 
> Ahh. Thank you.
> 
> Here is the fix:
> 
> Subject: slub: Fix double bit unlock in debug mode
> 
> Commit 442b06bcea23a01934d3da7ec5898fa154a6cafb added a deactivate_slab()
> in the debug case in __slab_alloc(). deactivate_slab() unlocks the current
> slab used for allocation. Going to the label unlock_out: does it again.
> 
> So simply return the object. In the debug case we do not need all the other
> processing that unlock_out: does.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  mm/slub.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-05-25 09:41:27.000000000 -0500
> +++ linux-2.6/mm/slub.c	2011-05-25 09:41:39.000000000 -0500
> @@ -1884,7 +1884,8 @@ debug:
>  	deactivate_slab(s, c);
>  	c->page = NULL;

is this c->page = NULL; really necessary ?

Thanks !

>  	c->node = NUMA_NO_NODE;
> -	goto unlock_out;
> +	local_irq_restore(flags);
> +	return object;
>  }
> 
>  /*


