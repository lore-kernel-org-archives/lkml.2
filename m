Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab2EUTjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:39:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39064 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab2EUTjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:39:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120521154709.GA8697@redhat.com>
References: <20120517213120.GA12329@redhat.com> <20120518185851.GA5728@redhat.com>
 <20120521154709.GA8697@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 12:39:19 -0700
X-Google-Sender-Auth: t0Mv79zveajdfGl9_dwMmkj3q4Y
Message-ID: <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com>
Subject: Re: 3.4-rc7 numa_policy slab poison.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
        Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added some more people explicitly to the cc, in case they don't peruse
the mailing lists as carefully as their personal emails.

It certainly looks like some kind of mpol_get/put imbalance.

However, looking at mm/mempolicy.c, I really want to just dig out my
own eyes with a spoon. All the games with MPOL_F_SHARED in particular
look *really* unsafe. In particular, why i it safe to suddenly set
MPOL_F_SHARED in sp_alloc(), when it previously was unshared and might
have random stale refcounts if so?

The locking is also *really* hard to read. It's full of conditional
locks/unlock things, see for example do_mbind(), which really is
inexcusably ugly in just about all respects.

But there's not a lot of recent stuff. The thing that jumps out is Mel
Gorman's recent commit cc9a6c8776615 ("cpuset: mm: reduce large
amounts of memory barrier related damage v3"), which has a whole new
loop with that scary mpol_cond_put() usage. And there's we had
problems with vma merging..

Dave, how recent is this problem? Have you already tried older kernels?

Kosaki, Mel, Christoph, please give Dave's system call fuzzer a test,
maybe you can see what the problem is quickly..

                              Linus

On Mon, May 21, 2012 at 8:47 AM, Dave Jones <davej@redhat.com> wrote:
> On Fri, May 18, 2012 at 02:58:51PM -0400, Dave Jones wrote:
>  > On Thu, May 17, 2012 at 05:31:20PM -0400, Dave Jones wrote:
>  >
>  >  > =============================================================================
>  >  > BUG numa_policy (Not tainted): Poison overwritten
>  >  > -----------------------------------------------------------------------------
>  >  >
>  >  > INFO: 0xffff880146498250-0xffff880146498250. First byte 0x6a instead of 0x6b
>  >  > INFO: Allocated in mpol_new+0xa3/0x140 age=46310 cpu=6 pid=32154
>  >  >   __slab_alloc+0x3d3/0x445
>  >  >   kmem_cache_alloc+0x29d/0x2b0
>  >  >   mpol_new+0xa3/0x140
>  >  >   sys_mbind+0x142/0x620
>  >  >   system_call_fastpath+0x16/0x1b
>  >  > INFO: Freed in __mpol_put+0x27/0x30 age=46268 cpu=6 pid=32154
>  >  >   __slab_free+0x2e/0x1de
>  >  >   kmem_cache_free+0x25a/0x260
>  >  >   __mpol_put+0x27/0x30
>  >  >   remove_vma+0x68/0x90
>  >  >   exit_mmap+0x118/0x140
>  >  >   mmput+0x73/0x110
>  >  >   exit_mm+0x108/0x130
>  >  >   do_exit+0x162/0xb90
>  >  >   do_group_exit+0x4f/0xc0
>  >  >   sys_exit_group+0x17/0x20
>  >  >   system_call_fastpath+0x16/0x1b
>  >  > INFO: Slab 0xffffea0005192600 objects=27 used=27 fp=0x          (null) flags=0x20000000004080
>  >  > INFO: Object 0xffff880146498250 @offset=592 fp=0xffff88014649b9d0
>  >
>  > As I can reproduce this fairly easily, I enabled the dynamic debug prints for mempolicy.c,
>  > and noticed something odd (but different to the above trace..)
>  >
>  > INFO: 0xffff88014649abf0-0xffff88014649abf0. First byte 0x6a instead of 0x6b
>  > INFO: Allocated in mpol_new+0xa3/0x140 age=196087 cpu=7 pid=11496
>  >  __slab_alloc+0x3d3/0x445
>  >  kmem_cache_alloc+0x29d/0x2b0
>  >  mpol_new+0xa3/0x140
>  >  sys_mbind+0x142/0x620
>  >  system_call_fastpath+0x16/0x1b
>  > INFO: Freed in __mpol_put+0x27/0x30 age=40838 cpu=7 pid=20824
>  >  __slab_free+0x2e/0x1de
>  >  kmem_cache_free+0x25a/0x260
>  >  __mpol_put+0x27/0x30
>  >  mpol_set_shared_policy+0xe6/0x280
>  >  shmem_set_policy+0x2a/0x30
>  >  shm_set_policy+0x28/0x30
>  >  sys_mbind+0x4e7/0x620
>  >  system_call_fastpath+0x16/0x1b
>  > INFO: Slab 0xffffea0005192600 objects=27 used=27 fp=0x          (null) flags=0x20000000004080
>  > INFO: Object 0xffff88014649abf0 @offset=11248 fp=0xffff880146498de0
>  >
>  > In this case, it seems the policy was allocated by pid 11496, and freed by a different pid!
>  > How is that possible ?  (Does kind of explain why it looks like a double-free though I guess).
>  >
>  > debug printout for the relevant pids below, in case it yields further clues..
>
> Anyone ?  This can be reproduced very quickly by doing..
>
> $ git clone git://git.codemonkey.org.uk/trinity.git
> $ make
> $ ./trinity -q -c mbind
>
> On my 8-core box, it happens within 30 seconds.
>
> If I run this long enough, the box wedges completely, needing a power cycle to reboot.
>
>        Dave
>
