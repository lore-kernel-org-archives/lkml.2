Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2BRGfn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 01:35:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53698 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2BRGfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 01:35:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.131.90 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F3F46B7.40100@openvz.org>
Date: Sat, 18 Feb 2012 10:35:35 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] mm: memory book keeping and lru_lock splitting
References: <20120215224221.22050.80605.stgit@zurg> <alpine.LSU.2.00.1202151815180.19722@eggly.anvils> <4F3C8B67.6090500@openvz.org> <alpine.LSU.2.00.1202161235430.2269@eggly.anvils> <alpine.LSU.2.00.1202171803380.25191@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1202171803380.25191@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 16 Feb 2012, Hugh Dickins wrote:
>>
>> Yours are not the only patches I was testing in that tree, I tried to
>> gather several other series which I should be reviewing if I ever have
>> time: Kamezawa-san's page cgroup diet 6, Xiao Guangrong's 4 prio_tree
>> cleanups, your 3 radix_tree changes, your 6 shmem changes, your 4 memcg
>> miscellaneous, and then your 15 books.
>>
>> The tree before your final 15 did well under pressure, until I tried to
>> rmdir one of the cgroups afterwards: then it crashed nastily, I'll have
>> to bisect into that, probably either Kamezawa's or your memcg changes.
>
> So far I haven't succeeded in reproducing that at all: it was real,
> but obviously harder to get than I assumed - indeed, no good reason
> to associate it with any of those patches, might even be in 3.3-rc.
>
> It did involve a NULL pointer dereference in mem_cgroup_page_lruvec(),
> somewhere below compact_zone() - but repercussions were causing the
> stacktrace to scroll offscreen, so I didn't get good details.

There some stupid bugs in my v1 patchset, it shouldn't works at all.
I did not expect that someone will try to use it. I sent it just to discuss.

Most destructive bug is this PageCgroupUsed() below:

+struct book *page_book(struct page *page)
+{
+	struct mem_cgroup_per_zone *mz;
+	struct page_cgroup *pc;
+
+	if (mem_cgroup_disabled())
+		return &page_zone(page)->book;
+
+	pc = lookup_page_cgroup(page);
+	if (!PageCgroupUsed(pc))
+		return &page_zone(page)->book;
+	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
+	smp_rmb();
+	mz = mem_cgroup_zoneinfo(pc->mem_cgroup,
+			page_to_nid(page), page_zonenum(page));
+	return &mz->book;
+}

Thus after page uncharge I remove page from wrong book, under wrong lock =)

[ as I wrote, updated patchset there: https://github.com/koct9i/linux ]

>
> Hugh

