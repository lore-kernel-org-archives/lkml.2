Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab2JSHUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:20:43 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:56585 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab2JSHUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:20:41 -0400
Date: Fri, 19 Oct 2012 10:20:32 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Joonsoo Kim <js1304@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] slub: remove one code path and reduce lock contention
 in __slab_free()
In-Reply-To: <1345042960-6287-2-git-send-email-js1304@gmail.com>
Message-ID: <alpine.LFD.2.02.1210191020010.4221@tux.localdomain>
References: <1345042960-6287-1-git-send-email-js1304@gmail.com> <1345042960-6287-2-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, Joonsoo Kim wrote:
> When we try to free object, there is some of case that we need
> to take a node lock. This is the necessary step for preventing a race.
> After taking a lock, then we try to cmpxchg_double_slab().
> But, there is a possible scenario that cmpxchg_double_slab() is failed
> with taking a lock. Following example explains it.
> 
> CPU A               CPU B
> need lock
> ...                 need lock
> ...                 lock!!
> lock..but spin      free success
> spin...             unlock
> lock!!
> free fail
> 
> In this case, retry with taking a lock is occured in CPU A.
> I think that in this case for CPU A,
> "release a lock first, and re-take a lock if necessary" is preferable way.
> 
> There are two reasons for this.
> 
> First, this makes __slab_free()'s logic somehow simple.
> With this patch, 'was_frozen = 1' is "always" handled without taking a lock.
> So we can remove one code path.
> 
> Second, it may reduce lock contention.
> When we do retrying, status of slab is already changed,
> so we don't need a lock anymore in almost every case.
> "release a lock first, and re-take a lock if necessary" policy is
> helpful to this.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>
> Acked-by: Christoph Lameter <cl@linux.com>

Applied, thanks!
