Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2FEQz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:55:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:49299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2FEQz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:55:56 -0400
Message-ID: <1338915342.2749.11.camel@twins>
Subject: Re: [PATCH 4/4] x86: Check user address explicitly in
 copy_from_user_nmi()
From: Peter Zijlstra <peterz@infradead.org>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Tue, 05 Jun 2012 18:55:42 +0200
In-Reply-To: <1334961696-19580-5-git-send-email-asharma@fb.com>
References: <1334961696-19580-1-git-send-email-asharma@fb.com>
	 <1334961696-19580-5-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 15:41 -0700, Arun Sharma wrote:
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/lib/usercopy.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
> index d6ae30b..2da7914 100644
> --- a/arch/x86/lib/usercopy.c
> +++ b/arch/x86/lib/usercopy.c
> @@ -21,6 +21,9 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
>  	void *map;
>  	int ret;
>  
> +	if (__range_not_ok(from, n, TASK_SIZE) == 0)
> +		return len;
> +
>  	do {
>  		ret = __get_user_pages_fast(addr, 1, 0, &page);
>  		if (!ret)

Needed the below to make it compile.. folded that.

---
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 
 #include <asm/word-at-a-time.h>
+#include <linux/sched.h>
 
 /*
  * best effort, GUP based copy_from_user() that is NMI-safe

