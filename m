Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2EUPrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:47:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab2EUPrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:47:16 -0400
Date: Mon, 21 May 2012 11:47:09 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
Message-ID: <20120521154709.GA8697@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20120517213120.GA12329@redhat.com>
 <20120518185851.GA5728@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518185851.GA5728@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 02:58:51PM -0400, Dave Jones wrote:
 > On Thu, May 17, 2012 at 05:31:20PM -0400, Dave Jones wrote:
 > 
 >  > =============================================================================
 >  > BUG numa_policy (Not tainted): Poison overwritten
 >  > -----------------------------------------------------------------------------
 >  > 
 >  > INFO: 0xffff880146498250-0xffff880146498250. First byte 0x6a instead of 0x6b
 >  > INFO: Allocated in mpol_new+0xa3/0x140 age=46310 cpu=6 pid=32154
 >  > 	__slab_alloc+0x3d3/0x445
 >  > 	kmem_cache_alloc+0x29d/0x2b0
 >  > 	mpol_new+0xa3/0x140
 >  > 	sys_mbind+0x142/0x620
 >  > 	system_call_fastpath+0x16/0x1b
 >  > INFO: Freed in __mpol_put+0x27/0x30 age=46268 cpu=6 pid=32154
 >  > 	__slab_free+0x2e/0x1de
 >  > 	kmem_cache_free+0x25a/0x260
 >  > 	__mpol_put+0x27/0x30
 >  > 	remove_vma+0x68/0x90
 >  > 	exit_mmap+0x118/0x140
 >  > 	mmput+0x73/0x110
 >  > 	exit_mm+0x108/0x130
 >  > 	do_exit+0x162/0xb90
 >  > 	do_group_exit+0x4f/0xc0
 >  > 	sys_exit_group+0x17/0x20
 >  > 	system_call_fastpath+0x16/0x1b
 >  > INFO: Slab 0xffffea0005192600 objects=27 used=27 fp=0x          (null) flags=0x20000000004080
 >  > INFO: Object 0xffff880146498250 @offset=592 fp=0xffff88014649b9d0
 > 
 > As I can reproduce this fairly easily, I enabled the dynamic debug prints for mempolicy.c,
 > and noticed something odd (but different to the above trace..)
 > 
 > INFO: 0xffff88014649abf0-0xffff88014649abf0. First byte 0x6a instead of 0x6b
 > INFO: Allocated in mpol_new+0xa3/0x140 age=196087 cpu=7 pid=11496
 >  __slab_alloc+0x3d3/0x445
 >  kmem_cache_alloc+0x29d/0x2b0
 >  mpol_new+0xa3/0x140
 >  sys_mbind+0x142/0x620
 >  system_call_fastpath+0x16/0x1b
 > INFO: Freed in __mpol_put+0x27/0x30 age=40838 cpu=7 pid=20824
 >  __slab_free+0x2e/0x1de
 >  kmem_cache_free+0x25a/0x260
 >  __mpol_put+0x27/0x30
 >  mpol_set_shared_policy+0xe6/0x280
 >  shmem_set_policy+0x2a/0x30
 >  shm_set_policy+0x28/0x30
 >  sys_mbind+0x4e7/0x620
 >  system_call_fastpath+0x16/0x1b
 > INFO: Slab 0xffffea0005192600 objects=27 used=27 fp=0x          (null) flags=0x20000000004080
 > INFO: Object 0xffff88014649abf0 @offset=11248 fp=0xffff880146498de0
 > 
 > In this case, it seems the policy was allocated by pid 11496, and freed by a different pid!
 > How is that possible ?  (Does kind of explain why it looks like a double-free though I guess).
 > 
 > debug printout for the relevant pids below, in case it yields further clues..

Anyone ?  This can be reproduced very quickly by doing..

$ git clone git://git.codemonkey.org.uk/trinity.git
$ make
$ ./trinity -q -c mbind

On my 8-core box, it happens within 30 seconds.

If I run this long enough, the box wedges completely, needing a power cycle to reboot.

	Dave

