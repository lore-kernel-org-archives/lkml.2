Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab2JSPxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:53:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856Ab2JSPxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:53:48 -0400
Message-ID: <5081777A.8050104@redhat.com>
Date: Fri, 19 Oct 2012 11:53:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>,
        Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: question on NUMA page migration
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea, Peter,

I have a question on page refcounting in your NUMA
page migration code.

In Peter's case, I wonder why you introduce a new
MIGRATE_FAULT migration mode. If the normal page
migration / compaction logic can do without taking
an extra reference count, why does your code need it?

In Andrea's case, we have a comment suggesting an
extra refcount is needed, immediately followed by
a put_page:

         /*
          * Pin the head subpage at least until the first
          * __isolate_lru_page succeeds (__isolate_lru_page pins it
          * again when it succeeds). If we unpin before
          * __isolate_lru_page successd, the page could be freed and
          * reallocated out from under us. Thus our previous checks on
          * the page, and the split_huge_page, would be worthless.
          *
          * We really only need to do this if "ret > 0" but it doesn't
          * hurt to do it unconditionally as nobody can reference
          * "page" anymore after this and so we can avoid an "if (ret >
          * 0)" branch here.
          */
         put_page(page);

This also confuses me.

If we do not need the extra refcount (and I do not
understand why NUMA migrate-on-fault needs one more
refcount than normal page migration), we can get
rid of the MIGRATE_FAULT mode.

If we do need the extra refcount, why is normal
page migration safe? :)

-- 
All rights reversed
