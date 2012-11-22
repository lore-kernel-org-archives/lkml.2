Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab2KVTc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:32:28 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47833 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab2KVTcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:32:00 -0500
Message-ID: <50AE3463.1040107@gmail.com>
Date: Thu, 22 Nov 2012 09:19:15 -0500
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121112 Thunderbird/16.0.1
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v12 4/7] mm: introduce compaction and migration for ballooned
 pages
References: <cover.1352656285.git.aquini@redhat.com> <6602296b38c073a5c6faa13ddbc74ceb1eceb2dd.1352656285.git.aquini@redhat.com> <50A7D0FA.2080709@gmail.com> <20121117215434.GA23879@x61.redhat.com> <CA+1xoqfbxL-mL3XRDXxnuv0R6b9w6qxU7t+8U3FwS2eK5Sf0OA@mail.gmail.com> <20121120141438.GA21672@x61.redhat.com> <50AC2BCC.6050507@gmail.com> <20121122000114.GB1815@t510.redhat.com>
In-Reply-To: <20121122000114.GB1815@t510.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 07:01 PM, Rafael Aquini wrote:
> On Tue, Nov 20, 2012 at 08:18:04PM -0500, Sasha Levin wrote:
>> On 11/20/2012 09:14 AM, Rafael Aquini wrote:
>>> On Sun, Nov 18, 2012 at 09:59:47AM -0500, Sasha Levin wrote:
>>>> On Sat, Nov 17, 2012 at 4:54 PM, Rafael Aquini <aquini@redhat.com> wrote:
>>>>> On Sat, Nov 17, 2012 at 01:01:30PM -0500, Sasha Levin wrote:
>>>>>>
>>>>>> I'm getting the following while fuzzing using trinity inside a KVM tools guest,
>>>>>> on latest -next:
>>>>>>
>>>>>> [ 1642.783728] BUG: unable to handle kernel NULL pointer dereference at 0000000000000194
>>>>>> [ 1642.785083] IP: [<ffffffff8122b354>] isolate_migratepages_range+0x344/0x7b0
>>>>>>
>>>>>> My guess is that we see those because of a race during the check in
>>>>>> isolate_migratepages_range().
>>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Sasha
>>>>>
>>>>> Sasha, could you share your .config and steps you did used with trinity? So I
>>>>> can attempt to reproduce this issue you reported.
>>>>
>>>> Basically try running trinity (with ./trinity -m --quiet --dangerous
>>>> -l off) inside a disposable guest as root.
>>>>
>>>> I manage to hit that every couple of hours.
>>>>
>>>> Config attached.
>>>>
>>>
>>> Howdy Sasha,
>>>
>>> After several hours since last Sunday running trinity tests on a traditional
>>> KVM-QEMU guest as well as running it on a lkvm guest (both running
>>> next-20121115) I couldn't hit a single time the crash you've reported,
>>> (un)fortunately.
>>
>> Odd... I can see it happening here every couple of hours.
>>
>>> Also, the .config you gave me, applied on top of next-20121115, haven't produced
>>> the same bin you've running and hitting the mentioned bug, apparently.
>>>
>>> Here's the RIP for your crash:
>>> [ 1642.783728] BUG: unable to handle kernel NULL pointer dereference at
>>> 0000000000000194
>>> [ 1642.785083] IP: [<ffffffff8122b354>] isolate_migratepages_range+0x344/0x7b0
>>>
>>>
>>> And here's the symbol address for the next-20121115 with your .config I've been
>>> running tests on:
>>> [raquini@x61 linux]$ nm -n vmlinux | grep isolate_migratepages_range 
>>> ffffffff8122d890 T isolate_migratepages_range
>>>
>>> Also, it seems quite clear I'm missing something from your tree, as applying the
>>> RIP displacement (0x344) to my local isolate_migratepages_range sym addr leads
>>> me to the _middle_ of a instruction opcode that does not dereference any
>>> pointers at all.
>>
>> Yup, I carry another small fix to mpol (which is unrelated to this one).
>>
>>> So, if you're consistently reproducing the same crash, consider to share with us
>>> a disassembled dump from the isolate_migratepages_range() you're running along
>>> with the crash stack-dump, please.
>>
>> Sure!
>>
>> The call chain is:
>>
>> 	isolate_migratepages_range
>> 		balloon_page_movable
>> 			__is_movable_balloon_page
>> 				mapping_balloon
>>
>> mapping_balloon() fails because it checks for mapping to be non-null (and it is -
>> it's usually a small value like 0x50), and then it dereferences that.
>>
>> The relevant assembly is:
>>
>> static inline int mapping_balloon(struct address_space *mapping)
>> {
>>         return mapping && test_bit(AS_BALLOON_MAP, &mapping->flags);
>>     17ab:       48 85 c0                test   %rax,%rax
>>     17ae:       0f 84 4c 02 00 00       je     1a00 <isolate_migratepages_range+0x590>
>>     17b4:       48 8b 80 40 01 00 00    mov    0x140(%rax),%rax
>>     17bb:       a9 00 00 00 20          test   $0x20000000,%eax
>>     17c0:       0f 84 3a 02 00 00       je     1a00 <isolate_migratepages_range+0x590>
>>
>> It dies on 17b4.
>>
>> Let me know if you need anything else from me, I can also add debug code into the
>> kernel if it would help you...
>>
> 
> I still failing miserably on getting a reproducer, but I'm quite curious about
> what kind of page is being left behind with this barbed wire at ->mapping.
> 
> This might be an overkill on messages, but could you run a test with the
> following patch? This migth bring some light to this corner as well as it might
> help me on figuring out a clever/cleaner way to perform that test.
> 
> Thanks a lot for your attention here.

I've modified it a bit to decrease the noise:

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index e339dd9..7dfbce1 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -98,6 +98,8 @@ static inline bool __is_movable_balloon_page(struct page *page)
         */
        struct address_space *mapping = ACCESS_ONCE(page->mapping);
        smp_read_barrier_depends();
+       if (mapping && mapping < 0x1000)
+               dump_page(page);
        return mapping_balloon(mapping);
 }

And managed to reproduce it only once through last night, here is the dump I got
before the oops:

[ 2760.356820] page:ffffea0000d00e00 count:1 mapcount:-2147287036 mapping:00000000000004f4 index:0xd00e00000003
[ 2760.362354] page flags: 0x350000000001800(private|private_2)


Thanks,
Sasha

