Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0HRPHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:07:40 -0400
Received: from kroah.org ([198.145.64.141]:47480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab0HRPHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:07:38 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 18 08:05:57 2010
Message-Id: <20100818150557.438495679@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 18 Aug 2010 08:01:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hugh@veritas.com>
Subject: [4/6] mm: pass correct mm when growing stack
In-Reply-To: <20100818150615.GA4752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh@veritas.com>

commit 05fa199d45c54a9bda7aa3ae6537253d6f097aa9 upstream.

Tetsuo Handa reports seeing the WARN_ON(current->mm == NULL) in
security_vm_enough_memory(), when do_execve() is touching the
target mm's stack, to set up its args and environment.

Yes, a UMH_NO_WAIT or UMH_WAIT_PROC call_usermodehelper() spawns
an mm-less kernel thread to do the exec.  And in any case, that
vm_enough_memory check when growing stack ought to be done on the
target mm, not on the execer's mm (though apart from the warning,
it only makes a slight tweak to OVERCOMMIT_NEVER behaviour).

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1573,7 +1573,7 @@ static int acct_stack_growth(struct vm_a
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory(grow))
+	if (security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	/* Ok, everything looks good - let it rip */


