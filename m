Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab1GFBzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 21:55:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38727 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1GFBzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 21:55:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 6 Jul 2011 10:48:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-06-30-15-59 uploaded
Message-Id: <20110706104817.411f45d9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201106302259.p5UMxh5i019162@imap1.linux-foundation.org>
References: <201106302259.p5UMxh5i019162@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 15:59:43 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-06-30-15-59 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
>    git://zen-kernel.org/kernel/mmotm.git
> or
>    git://git.cmpxchg.org/linux-mmotm.git
> 
> It contains the following patches against 3.0-rc5:
> 

==
Because of x86-implement-strict-user-copy-checks-for-x86_64.patch

At compling mm/mempolicy.c, following warning is shown.

In file included from /home/kamezawa/Kernel/mmotm-0701/arch/x86/include/asm/uaccess.h:572,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:10,
                 from include/linux/mempolicy.h:70,
                 from mm/mempolicy.c:68:
In function ?copy_from_user?,
    inlined from ?compat_sys_get_mempolicy? at mm/mempolicy.c:1415:
.../mmotm-0701/arch/x86/include/asm/uaccess_64.h:64: warning: call to ?copy_from_user_overflow? declared with attribute warning: copy_from_user() buffer size is not provably correct
  LD      mm/built-in.o

Fix this by passing correct buffer size value.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: mmotm-0701/mm/mempolicy.c
===================================================================
--- mmotm-0701.orig/mm/mempolicy.c
+++ mmotm-0701/mm/mempolicy.c
@@ -1412,7 +1412,9 @@ asmlinkage long compat_sys_get_mempolicy
 	err = sys_get_mempolicy(policy, nm, nr_bits+1, addr, flags);
 
 	if (!err && nmask) {
-		err = copy_from_user(bm, nm, alloc_size);
+		unsigned long copy_size;
+		copy_size = min_t(unsigned long, sizeof(bm), alloc_size);
+		err = copy_from_user(bm, nm, copy_size);
 		/* ensure entire bitmap is zeroed */
 		err |= clear_user(nmask, ALIGN(maxnode-1, 8) / 8);
 		err |= compat_put_bitmap(nmask, bm, nr_bits);

