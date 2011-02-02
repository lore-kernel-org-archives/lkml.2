Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1BBAnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404Ab1BBAn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:27 -0500
Date: Tue, 1 Feb 2011 16:42:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: avi@redhat.com, mtosatti@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/2] Allow GUP to fail instead of waiting on a page.
Message-Id: <20110201164240.9a5c06e9.akpm@linux-foundation.org>
In-Reply-To: <1296559307-14637-2-git-send-email-gleb@redhat.com>
References: <1296559307-14637-1-git-send-email-gleb@redhat.com>
	<1296559307-14637-2-git-send-email-gleb@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Feb 2011 13:21:46 +0200
Gleb Natapov <gleb@redhat.com> wrote:

> GUP user may want to try to acquire a reference to a page if it is already
> in memory, but not if IO, to bring it in, is needed. For example KVM may
> tell vcpu to schedule another guest process if current one is trying to
> access swapped out page. Meanwhile, the page will be swapped in and the
> guest process, that depends on it, will be able to run again.
> 
> This patch adds FAULT_FLAG_RETRY_NOWAIT (suggested by Linus) and
> FOLL_NOWAIT follow_page flags. FAULT_FLAG_RETRY_NOWAIT, when used in
> conjunction with VM_FAULT_ALLOW_RETRY, indicates to handle_mm_fault that
> it shouldn't drop mmap_sem and wait on a page, but return VM_FAULT_RETRY
> instead.
>
> ...
>
> +#define FOLL_NOWAIT	0x20	/* return if disk transfer is needed */

The comment is a little misleading.  Or incomplete.

For both swap-backed and file-backed pages, the code will initiate the
disk transfer and will then return without waiting for it to complete. 
This (important!) information isn't really presented in either the
changelog or the code itself.

This?

--- a/include/linux/mm.h~mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix
+++ a/include/linux/mm.h
@@ -1537,7 +1537,8 @@ struct page *follow_page(struct vm_area_
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
-#define FOLL_NOWAIT	0x20	/* return if disk transfer is needed */
+#define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
+				 * and return without waiting upon it */
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 
_

