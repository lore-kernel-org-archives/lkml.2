Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2AKIXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:23:20 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52101 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab2AKIXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:23:15 -0500
Message-ID: <4F0D46EF.4060705@openvz.org>
Date: Wed, 11 Jan 2012 12:23:11 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111108 Iceape/2.0.14
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: adjust rss counters for migration entiries
References: <20120106173827.11700.74305.stgit@zurg>	<20120106173856.11700.98858.stgit@zurg> <20120111144125.0c61f35f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120111144125.0c61f35f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 06 Jan 2012 21:38:56 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> Memory migration fill pte with migration entry and it didn't update rss counters.
>> Then it replace migration entry with new page (or old one if migration was failed).
>> But between this two passes this pte can be unmaped, or task can fork child and
>> it will get copy of this migration entry. Nobody account this into rss counters.
>>
>> This patch properly adjust rss counters for migration entries in zap_pte_range()
>> and copy_one_pte(). Thus we avoid extra atomic operations on migration fast-path.
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>
> It's better to show wheter this is a bug-fix or not in changelog.
>
> IIUC, the bug-fix is the 1st harf of this patch + patch [2/3].
> Your new bug-check code is in patch[1/3] and 2nd half of this patch.
>

No, there only one new bug-check in 1st patch, this is non-fatal warning.
I didn't hide this check under CONFIG_VM_DEBUG because it rather small and
rss counters covers whole page-table management, this is very good invariant.
Currently I can trigger this warning only on this rare race -- extremely loaded
memory compaction catches this every several seconds.

1/3 bug-check
2/3 fix preparation
3/3 bugfix in two places:
     do rss++ in copy_one_pte()
     do rss-- in zap_pte_range()

> I think it's better to do bug-fix 1st and add bug-check later.
>
> So, could you reorder patches to bug-fix and new-bug-check ?

Patches didn't share any context, so they can be applied in any order.

>
> To the logic itself,
> Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Please CC when you repost.
>
>
>


