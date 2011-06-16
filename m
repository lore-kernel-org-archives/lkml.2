Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1FPEwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:52:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829Ab1FPEwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:52:20 -0400
Date: Wed, 15 Jun 2011 21:52:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Richard Weinberger <richard@nod.at>
Subject: Re: fs/exec.c: use BUILD_BUG_ON for VM_STACK_FLAGS &
 VM_STACK_INCOMPLETE_SETUP
Message-Id: <20110615215207.ba7a0386.akpm@linux-foundation.org>
In-Reply-To: <BANLkTimPwZsWNi=t57xz+h11gLn4CkOfug@mail.gmail.com>
References: <201106160359.p5G3x3j4020081@hera.kernel.org>
	<20110615213549.9b399976.randy.dunlap@oracle.com>
	<BANLkTimPwZsWNi=t57xz+h11gLn4CkOfug@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 21:45:00 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Jun 15, 2011 at 9:35 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > fwiw, I just reported that this causes a build error in UML on x86_64
> > in mmotm-2011-06-15:
> 
> Gaah. That sounds really familiar. Have we done this same mistake once
> before already, or is it just deja-vu for some other reason.
> 
> On x86-64 UML, we have
> 
>   #define VM_STACK_DEFAULT_FLAGS vm_stack_flags
> 
> so VM_STACK_FLAGS ends up not being a constant, even though it really
> looks like one.
> 
> UML is _really_ confused in this area, btw. It seems to re-define that
> thing if TIF_IA32 is defined. That's some crazy stuff. Doesn't the
> compiler warn about it?
> 
> I guess I should just revert that commit, though. Even if it does seem
> to be the case that UML is just being crazy. Andrew?
> 

Sure, it was just a tiny optimization.

We can bring it back if Richard feels like decrazyifying UML ;)



From: Michal Hocko <mhocko@suse.cz>

a8bef8ff ("mm: migration: avoid race between shift_arg_pages() and
rmap_walk() during migration by not migrating temporary stacks")
introduced a BUG_ON() to ensure that VM_STACK_FLAGS and
VM_STACK_INCOMPLETE_SETUP do not overlap.  The check is a compile time
one, so BUILD_BUG_ON is more appropriate.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exec.c~fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup fs/exec.c
--- a/fs/exec.c~fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup
+++ a/fs/exec.c
@@ -277,7 +277,7 @@ static int __bprm_mm_init(struct linux_b
 	 * use STACK_TOP because that can depend on attributes which aren't
 	 * configured yet.
 	 */
-	BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
+	BUILD_BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
 	vma->vm_end = STACK_TOP_MAX;
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
 	vma->vm_flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
_

