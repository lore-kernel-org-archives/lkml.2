Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab0FIGxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 02:53:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45380 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0FIGxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 02:53:37 -0400
To: Salman <sqazi@google.com>
Cc: peterz@infradead.org, mingo@elte.hu, akpm@inux-foundation.org,
       linux-kernel@vger.kernel.org, tytso@google.com
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be reused immediately.
From: Andi Kleen <andi@firstfloor.org>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
Date: Wed, 09 Jun 2010 08:53:31 +0200
In-Reply-To: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com> (Salman's message of "Tue\, 08 Jun 2010 23\:24\:38 -0700")
Message-ID: <87d3w066j8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salman <sqazi@google.com> writes:
> +++ b/kernel/pid.c
> @@ -153,8 +153,17 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>  		if (likely(atomic_read(&map->nr_free))) {
>  			do {
>  				if (!test_and_set_bit(offset, map->page)) {
> +					int prev;
>  					atomic_dec(&map->nr_free);
> -					pid_ns->last_pid = pid;
> +
> +					do {
> +						prev = last;
> +						last = cmpxchg(&pid_ns->last_pid,
> +							       prev,
> +						pid);

At some point not all architectures in Linux supported cmpxchg,
so it was not allowed to use it unconditionally in portable code.

This might have changed now (at least the UP only architectures fall
back to a generic cmpxchg now I think), but I'm not sure you have full
coverage on SMP.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
