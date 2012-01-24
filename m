Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2AXHIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 02:08:20 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49965 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2AXHIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 02:08:18 -0500
Message-ID: <4F1E58DD.6030607@openvz.org>
Date: Tue, 24 Jan 2012 11:08:13 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111108 Iceape/2.0.14
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: adjust rss counters for migration entiries
References: <20120106173827.11700.74305.stgit@zurg> <20120106173856.11700.98858.stgit@zurg> <20120111144125.0c61f35f.kamezawa.hiroyu@jp.fujitsu.com> <4F0D46EF.4060705@openvz.org> <20120111174126.f35e708a.kamezawa.hiroyu@jp.fujitsu.com> <20120118152131.45a47966.akpm@linux-foundation.org> <alpine.LSU.2.00.1201231719580.14979@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1201231719580.14979@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 18 Jan 2012, Andrew Morton wrote:
>> On Wed, 11 Jan 2012 17:41:26 +0900
>> KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>  wrote:
>>> On Wed, 11 Jan 2012 12:23:11 +0400
>>> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
> I only just got around to looking at these, sorry.
>
>>
>> Putting "fix" in the patch title text is a good way of handling this.
>>
>> I renamed [3/3] to "mm: fix rss count leakage during migration" and
>> shall queue it for 3.3.  If people think we should also backport it
>> into -stable then please let me know.
>
> I don't think it needs backporting to stable: unless I'm forgetting
> something, the only thing that actually uses these rss counters is the
> OOM killer, and I don't think that will be greatly affected by the bug.
>

Yes, there are only counters. But, I can imagine local DoS attack via this race.

>>
>> I reordered the patches and worked the chagnelogs quite a bit.  I now
>> have:
>>
>> : From: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> : Subject: mm: fix rss count leakage during migration
>> :
>> : Memory migration fills a pte with a migration entry and it doesn't update
>> : the rss counters.  Then it replaces the migration entry with the new page
>> : (or the old one if migration failed).  But between these two passes this
>> : pte can be unmaped, or a task can fork a child and it will get a copy of
>> : this migration entry.  Nobody accounts for this in the rss counters.
>> :
>> : This patch properly adjust rss counters for migration entries in
>> : zap_pte_range() and copy_one_pte().  Thus we avoid extra atomic operations
>> : on the migration fast-path.
>> :
>> : Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> : Cc: Hugh Dickins<hughd@google.com>
>> : Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>
> That was a good find, Konstantin: thank you.
>
>>
>> and
>>
>> : From: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> : Subject: mm: add rss counters consistency check
>> :
>> : Warn about non-zero rss counters at final mmdrop.
>> :
>> : This check will prevent reoccurences of bugs such as that fixed in "mm:
>> : fix rss count leakage during migration".
>> :
>> : I didn't hide this check under CONFIG_VM_DEBUG because it rather small and
>> : rss counters cover whole page-table management, so this is a good
>> : invariant.
>> :
>> : Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> : Cc: Hugh Dickins<hughd@google.com>
>> : Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>
> I'd be happier with this one if you do hide the check under
> CONFIG_VM_DEBUG - or even under CONFIG_DEBUG_VM if you want it to
> be compiled in sometimes ;)  I suppose NR_MM_COUNTERS is only 3,
> so it isn't a huge overhead; but I think you're overestimating the
> importance of these counters, and it would look better under DEBUG_VM.

Theoretically, some drivers can touch page tables,
for example if they do that outside of vma we can get some kind of strange memory leaks.

>
>>
>> and
>>
>> : From: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> : Subject: mm: postpone migrated page mapping reset
>> :
>> : Postpone resetting page->mapping until the final remove_migration_ptes().
>> : Otherwise the expression PageAnon(migration_entry_to_page(entry)) does not
>> : work.
>> :
>> : Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> : Cc: Hugh Dickins<hughd@google.com>
>> : Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>
> Isn't this one actually an essential part of the fix?  It should have
> been part of the same patch, but you split them apart, now Andrew has
> reordered them and pushed one part to 3.3, but this needs to go in too?
>

Oops. I missed that. Yes. race-fix does not work for anon-memory without that patch.
But this is non-fatal, there are no new bugs.

> Hugh

