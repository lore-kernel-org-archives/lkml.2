Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab0INUAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:00:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41705 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0INUA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:00:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=h635APGBxaAM8pSKotgnl1ZLm7bGrKZA+9iMKY9PjCOAfGJyOE8ZKDUIaVDv0hfId
	YMtOWDOT/vM5zby4DC++Q==
Date: Tue, 14 Sep 2010 13:00:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
In-Reply-To: <1284490101-2362-2-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org> <1284490101-2362-2-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Pekka Enberg wrote:

> SLUB uses the name of the first slab cache for all merged slab caches. To make
> the output of /proc/slabinfo more obvious, append the name of each merged slab
> cache to s->name.
> 
> An example output of /proc/slabinfo with this patch looks like this:
> 
>   kmalloc-8192         544    544   8192    4    8 : tunables    0
>   kmalloc-4096+names_cache+biovec-256+sgpool-128+ecryptfs_headers
>   kmalloc-2048+biovec-128+sgpool-64    400    416   2048   16    8
>   kmalloc-1024+biovec-64+sgpool-32    436    496   1024   16    4 :
>   kmalloc-512+task_xstate+skbuff_fclone_cache+sgpool-16   1060   10
>   kmalloc-256+mnt_cache+skbuff_head_cache+biovec-16+sgpool-8+arp_   [ snip ]
>   kmalloc-128+pid+bip-1+eventpoll_epi+request_sock_TCP+ip_mrt_cac
>   kmalloc-64+fs_cache+biovec-4+blkdev_ioc+inet_peer_cache+tcp_bin
>   kmalloc-32+ip_fib_alias+dnotify_struct+inotify_event_private_da
>   kmalloc-16+biovec-1+ecryptfs_file_cache+dm_rq_clone_bio_info+dm
>   kmalloc-8           5119   5120      8  512    1 : tunables    0
>   kmalloc-192+cred_jar+key_jar+filp+bip-4+bio-0+request_sock_TCPv
>   kmalloc-96           924   1008     96   42    1 : tunables    0
>   kmem_cache_node      128    128     64   64    1 : tunables    0
> 

I really don't like this.

I can understand how it's confusing that only the first slab cache name is 
being emitted, and I think that can be changed, but this shows way too 
much information that is already available when CONFIG_SLUB_DEBUG is used 
via the sysfs interface.

CONFIG_SLUB_DEBUG is the default configuration for all users and is 
required for CONFIG_SLABINFO when using slub.  It softlinks merged caches 
together so that it's very simple to determine their relationship.

There's also nothing preventing a name from already including a '+' 
itself.

I think it would be better to use the unique id of each slab cache when 
emitting this information, perhaps suffixed with a count of the number of 
caches merged such as ":t-0000008(3)".
