Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1HHMk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:40:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41113 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab1HHMkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:40:55 -0400
MIME-Version: 1.0
In-Reply-To: <4E3FD403.6000400@parallels.com>
References: <20110808110658.31053.55013.stgit@localhost6>
	<CAOJsxLF909NRC2r6RL+hm1ARve+3mA6UM_CY9epJaauyqJTG8w@mail.gmail.com>
	<4E3FD403.6000400@parallels.com>
Date: Mon, 8 Aug 2011 15:40:55 +0300
X-Google-Sender-Auth: zxWxHb78hVWdRFfEWsW6WqHZ9XY
Message-ID: <CAOJsxLHOM3NR8Rqzj4pp=9PP2UU=coPd6ftHFihjLQRiHMobfw@mail.gmail.com>
Subject: Re: [PATCH 1/2] vmscan: promote shared file mapped pages
From: Pekka Enberg <penberg@kernel.org>
To: Konstantin Khlebnikov <khlebnikov@parallels.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 3:18 PM, Konstantin Khlebnikov
<khlebnikov@parallels.com> wrote:
> Pekka Enberg wrote:
>>
>> Hi Konstantin,
>>
>> On Mon, Aug 8, 2011 at 2:06 PM, Konstantin Khlebnikov
>> <khlebnikov@openvz.org>  wrote:
>>>
>>> Commit v2.6.33-5448-g6457474 (vmscan: detect mapped file pages used only
>>> once)
>>> greatly decreases lifetime of single-used mapped file pages.
>>> Unfortunately it also decreases life time of all shared mapped file
>>> pages.
>>> Because after commit v2.6.28-6130-gbf3f3bc (mm: don't mark_page_accessed
>>> in fault path)
>>> page-fault handler does not mark page active or even referenced.
>>>
>>> Thus page_check_references() activates file page only if it was used
>>> twice while
>>> it stays in inactive list, meanwhile it activates anon pages after first
>>> access.
>>> Inactive list can be small enough, this way reclaimer can accidentally
>>> throw away any widely used page if it wasn't used twice in short period.
>>>
>>> After this patch page_check_references() also activate file mapped page
>>> at first
>>> inactive list scan if this page is already used multiple times via
>>> several ptes.
>>>
>>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>>
>> Both patches seem reasonable but the changelogs don't really explain
>> why you're doing the changes. How did you find out about the problem?
>> Is there some workload that's affected? How did you test your changes?
>>
>
> I found this while trying to fix degragation in rhel6 (~2.6.32) from rhel5
> (~2.6.18).
> There a complete mess with >100 web/mail/spam/ftp containers,
> they share all their files but there a lot of anonymous pages:
> ~500mb shared file mapped memory and 15-20Gb non-shared anonymous memory.
> In this situation major-pagefaults are very costly, because all containers
> share the same page.
> In my load kernel created a disproportionate pressure on the file memory,
> compared with the anonymous,
> they equaled only if I raise swappiness up to 150 =)
>
> These patches actually wasn't helped a lot in my problem,
> but I saw noticable (10-20 times) reduce in count and average time of
> major-pagefault in file-mapped areas.
>
> Actually both patches are fixes for commit v2.6.33-5448-g6457474,
> because it was aimed at one scenario (singly used pages),
> but it breaks the logic in other scenarios (shared and/or executable pages)

It'd be nice to have such details in the changelogs. FWIW,

Acked-by: Pekka Enberg <penberg@kernel.org>
