Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab2BHBal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 20:30:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63551 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261Ab2BHBaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 20:30:39 -0500
Message-ID: <4F31D03B.9040707@openvz.org>
Date: Wed, 08 Feb 2012 05:30:35 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111108 Iceape/2.0.14
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] radix-tree: iterating general cleanup
References: <20120207074905.29797.60353.stgit@zurg>  <CA+55aFy3NZ2sWX0CNVd9FnPSx0mUKSe0XzDWpDsNfU21p6ebHQ@mail.gmail.com>
In-Reply-To: <CA+55aFy3NZ2sWX0CNVd9FnPSx0mUKSe0XzDWpDsNfU21p6ebHQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, Feb 6, 2012 at 11:54 PM, Konstantin Khlebnikov
> <khlebnikov@openvz.org>  wrote:
>> This patchset implements common radix-tree iteration routine and
>> reworks page-cache lookup functions with using it.
>
> So what's the advantage? Both the line counts and the bloat-o-meter
> seems to imply this is all just bad.

If do not count comments here actually is negative line count change.
And if drop (almost) unused radix_tree_gang_lookup_tag_slot() and
radix_tree_gang_lookup_slot() total bloat-o-meter score becomes negative too.
There also some shrinkable stuff in shmem code.
So, if this is really a problem it is fixable. I just didn't want to bloat patchset.

>
> I assume there is some upside to it, but you really don't make that
> obvious, so why should anybody ever waste even a second of time
> looking at this?

Hmm, from my point of view, this unified iterator code looks cleaner than
current duplicated radix-tree code. That's why I was titled it "cleanup".

There also some simple bit-hacks: find-next-bit instead of dumb loops in tagged-lookup.

Here some benchmark results: there is radix-tree with 1024 slots, I fill and tag every <step> slot,
and run lookup for all slots with radix_tree_gang_lookup() and radix_tree_gang_lookup_tag() in the loop.
old/new rows -- nsec per iteration over whole tree.

tagged-lookup
step	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16
old	7035	5248	4742	4308	4217	4133	4030	3920	4038	3933	3914	3796	3851	3755	3819	3582
new	3578	2617	1899	1426	1220	1058	936	822	845	749	695	679	648	575	591	509

so, new tagged-lookup always faster, especially for sparse trees.

normal-lookup
step	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16
old	4156	2641	2068	1837	1630	1531	1467	1415	1373	1398	1333	1323	1308	1280	1236	1249
new	3048	2520	2429	2280	2266	2296	2215	2219	2188	2170	2218	2332	2166	2096	2100	2058

New normal lookup works faster for dense trees, on sparse trees it slower.
Looks like it caused by struct radix_tree_iter aliasing,
gcc cannot effectively use its field as loop counter in nested-loop.
But how important is this? Anyway, I'll think how to fix this misfortune.


>
>                    Linus

