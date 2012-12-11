Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2LKVgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:36:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2LKVgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:36:46 -0500
Date: Tue, 11 Dec 2012 13:36:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dingel@linux.vnet.ibm.com
Cc: David Rientjes <rientjes@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove unused code from do_wp_page
Message-Id: <20121211133645.64a712d7.akpm@linux-foundation.org>
In-Reply-To: <1355237090-52434-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1355237090-52434-1-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2012 15:44:50 +0100
dingel@linux.vnet.ibm.com wrote:

> From: Dominik Dingel <dingel@linux.vnet.ibm.com>
> 
> page_mkwrite is initalized with zero and only set once, from that point exists no way to get to the oom or oom_free_new labels.
> 
> Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
> ---
>  mm/memory.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 221fc9f..c322708 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2795,10 +2795,6 @@ oom_free_new:
>  	page_cache_release(new_page);
>  oom:
>  	if (old_page) {
> -		if (page_mkwrite) {
> -			unlock_page(old_page);
> -			page_cache_release(old_page);
> -		}
>  		page_cache_release(old_page);
>  	}
>  	return VM_FAULT_OOM;

I hope you've checked all this carefully, including the "goto reuse"
and "goto gotten" paths.  I *think* it's OK, but geeze. And the oom path
surely gets very little testing.

do_wp_page() has become truly awful.  I'm wondering if we should
actually leave that code in there in case something changes in the
future and it becomes necessary.

With my compiler version this patch actually increases the size of
memory.o's text by 7 bytes.  Odd.

Ho hum.  You should also have done this:

--- a/mm/memory.c~mm-memoryc-remove-unused-code-from-do_wp_page-fix
+++ a/mm/memory.c
@@ -2780,9 +2780,8 @@ unlock:
 oom_free_new:
 	page_cache_release(new_page);
 oom:
-	if (old_page) {
+	if (old_page)
 		page_cache_release(old_page);
-	}
 	return VM_FAULT_OOM;
 
 unwritable_page:
_

