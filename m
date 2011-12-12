Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab1LLHOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:14:43 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59040 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955Ab1LLHOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:14:40 -0500
Date: Mon, 12 Dec 2011 09:14:20 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Christoph Lameter <cl@linux.com>
cc: David Rientjes <rientjes@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: slub: Fix per cpu partial statistics
In-Reply-To: <alpine.DEB.2.00.1111230924500.16544@router.home>
Message-ID: <alpine.LFD.2.02.1112120913000.2555@tux.localdomain>
References: <alpine.DEB.2.00.1111230924500.16544@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Christoph Lameter wrote:
> Subject: slub: Fix per cpu partial statistics
>
> Support for SO_OBJECTS was not properly added to show_slab_objects().
>
> If SO_OBJECTS is not set then the number of slab pages needs to be
> returned and not the number of objects in the partial slabs as now.
>
> We do not have that number so just return 1 until we find a better
> way to determine that.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
> ---
> mm/slub.c |   10 +++++++---
> 1 file changed, 7 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-11-22 13:42:23.000000000 -0600
> +++ linux-2.6/mm/slub.c	2011-11-22 13:47:52.000000000 -0600
> @@ -4451,8 +4451,8 @@ static ssize_t show_slab_objects(struct
> 				continue;
>
> 			if (c->page) {
> -					if (flags & SO_TOTAL)
> -						x = c->page->objects;
> +				if (flags & SO_TOTAL)
> +					x = c->page->objects;
> 				else if (flags & SO_OBJECTS)
> 					x = c->page->inuse;
> 				else
> @@ -4464,7 +4464,11 @@ static ssize_t show_slab_objects(struct
> 			page = c->partial;
>
> 			if (page) {
> -				x = page->pobjects;
> +				if (flags & SO_OBJECTS)
> +					x = page->pobjects;
> +				else
> +					/* Assume one */
> +					x = 1;
>                                 total += x;
>                                 nodes[c->node] += x;
> 			}
>

Looks OK to me. David, Eric?

 			Pekka
