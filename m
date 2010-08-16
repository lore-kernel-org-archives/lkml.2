Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab0HPLZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:25:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0HPLZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:25:22 -0400
Subject: Re: [PATCH] Fixed a mismatch between the users of radix_tree and
 the implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Salman Qazi <sqazi@google.com>
Cc: paulmck@us.ibm.com, nickpiggin@yahoo.com.au, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, adurbin@google.com
In-Reply-To: <20100813071735.18763.14706.stgit@bumblebee1.mtv.corp.google.com>
References: <20100813071735.18763.14706.stgit@bumblebee1.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 13:25:14 +0200
Message-ID: <1281957914.1926.1249.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 00:20 -0700, Salman Qazi wrote:
> This matters for the lockless page cache, in particular find_get_pages implementation.
> 
> In the following case, we get can get a deadlock:
> 
>     0.  The radix tree contains two items, one has the index 0.
>     1.  The reader (in this case find_get_pages) takes the rcu_read_lock.
>     2.  The reader acquires slot(s) for item(s) including the index 0 item.
>     3.  The non-zero index item is deleted, and as a consequence the other item
>         is moved to the root of the tree.  The place where it used to be is
>         queued for deletion after the readers finish.
>     4.  The reader looks at the index 0 slot, and finds that the page has 0 ref count
>     5.  The reader looks at it again, hoping that the item will either be freed
>         or the ref count will increase.  This never happens, as the slot it
>         is looking at will never be updated.  Also, this slot can never be reclaimed
>         because the reader is holding rcu_read_lock and is in an infinite loop.
> 
> This can be reproduced with reliably by running dbench followed by compilebench under
> autotest.  I have not been able to construct a small targeted repro case.
> 
> There is also a similar potential issue with insertion.  Storing the first
> element in the root and then moving it to a new slot on insertion of a
> second element would potentially lead to a similar problem.
> 
> Both of these issues have been fixed in this change.

Your changelog fails to mention how you fixed it.. 

It also reminds me how much I hate that height hack, I really should get
path-compression working some day...

http://programming.kicks-ass.net/kernel-patches/concurrent-pagecache/23-rc1-rt/radix-tree-path-compression.patch


