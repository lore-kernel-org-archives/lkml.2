Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1CJQk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:40:58 -0500
Received: from mout.perfora.net ([74.208.4.194]:53227 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab1CJQkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:40:55 -0500
Date: Thu, 10 Mar 2011 11:40:22 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Andi Kleen <ak@linux.intel.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Paul Mundt <lethal@linux-sh.org>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] make *_gate_vma accept mm_struct instead of
	task_struct
Message-ID: <20110310164022.GA6242@fibrous.localdomain>
References: <1299630721-4337-1-git-send-email-wilsons@start.ca> <20110310160032.GA20504@alboin.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310160032.GA20504@alboin.amr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:OSiwpQEHrKvA86oqjo3hVv2dKkKr/L+Yizou7Etycax
 T519X07M3OFcF+zqhoX9xsKwvkrSzYYOGPXLGhvkrpSfc5bhqO
 XCp13w6XyZzhi+kcIorPR0vU73OJHQ+pjv1QFMenY9tpCCmuTq
 XK/oY6tOOiOxOSjk8XNay80B9Oerk3YTRz3o5B7qhjfVheyahu
 J5Skg9edMWRWB9pGXak3/Kvdv7ZwhL7k7DBu1qbgI4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Mar 10, 2011 at 08:00:32AM -0800, Andi Kleen wrote:
> On Tue, Mar 08, 2011 at 07:31:56PM -0500, Stephen Wilson wrote:
> > 
> > Morally, the question of whether an address lies in a gate vma should be asked
> > with respect to an mm, not a particular task.
> > 
> > Practically, dropping the dependency on task_struct will help make current and
> > future operations on mm's more flexible and convenient.  In particular, it
> > allows some code paths to avoid the need to hold task_lock.
> > 
> > The only architecture this change impacts in any significant way is x86_64.
> > The principle change on that architecture is to mirror TIF_IA32 via
> > a new flag in mm_context_t. 
> 
> The problem is -- you're adding a likely cache miss on mm_struct for
> every 32bit compat syscall now, even if they don't need mm_struct
> currently (and a lot of them do not) Unless there's a very good
> justification to make up for this performance issue elsewhere
> (including numbers) this seems like a bad idea.

I do not think this will result in cache misses on the scale you
suggest.  I am simply mirroring the *state* of the TIF_IA32 flag in
mm_struct, not testing/accessing it in the same way.

The only place where this flag is accessed (outside the exec() syscall
path) is in x86/mm/init_64.c, get_gate_vma(),  which in turn is needed
by a few, relatively heavy weight, page locking/pinning routines on the
mm side (get_user_pages, for example).  Patches 3 and 4 in the series
show the extent of the change.

Or am I missing something?


> > /proc/pid/mem.  I will be posting the second series to lkml shortly.  These
> 
> Making every syscall slower for /proc/pid/mem doesn't seem like a good
> tradeoff to me. Please solve this in some other way.
> 
> -Andi

-- 
steve

