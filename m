Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab1FUEI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 00:08:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab1FUEIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 00:08:55 -0400
Message-ID: <4E00192E.70901@redhat.com>
Date: Tue, 21 Jun 2011 12:08:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: completely disable THP by transparent_hugepage=never
References: <1308587683-2555-1-git-send-email-amwang@redhat.com> <20110620165844.GA9396@suse.de> <4DFF7E3B.1040404@redhat.com> <4DFF7F0A.8090604@redhat.com> <4DFF8106.8090702@redhat.com> <4DFF8327.1090203@redhat.com> <4DFF84BB.3050209@redhat.com> <4DFF8848.2060802@redhat.com> <20110620182558.GF4749@redhat.com> <20110620192117.GG20843@redhat.com>
In-Reply-To: <20110620192117.GG20843@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月21日 03:21, Andrea Arcangeli 写道:
> On Mon, Jun 20, 2011 at 02:25:58PM -0400, Vivek Goyal wrote:
>> So I see some opprotunity there to save memory. But this 10kB
>> definitely sounds trivial amount to me.
>
> Agree with you and Rik. Also I already avoided the big memory waste
> (that for example isn't avoided in the ksmd and could be optimized
> away without decreasing flexibility of KSM, and ksmd surely runs on
> the kdump kernel too...) that is to make khugepaged exit and release
> kernel stack when enabled=never (either done by sysfs or at boot with
> transparent_hugepage=never) and all other structs associated with a
> (temporarily) useless kernel thread.

I agree to disable ksm in kdump kernel, thanks for pointing this out!
I will look into later, and probably send a patch for this too.

>
> The khugepaged_slab_init and mm_slot_hash_init() maybe could be
> deferred to when khugepaged starts, and be released when it shutdown
> but it makes it more tricky/racey. If you really want to optimize
> that, without preventing to ever enable THP again despite all .text
> was compiled in and ready to run. You will likely save more if you
> make ksmd exit when run=0 (which btw is a much more common config than
> enabled=never with THP). And slots hashes are allocated by ksm too so
> you could optimize those too if you want and allocate them only by the
> time ksmd starts.

The thing is that we can save ~10K by adding 3 lines of code as this
patch showed, where else in kernel can you save 10K by 3 lines of code?
(except some kfree() cases, of course) So, again, why not have it? ;)

>
> As long as it'd still possible to enable the feature again as it is
> possible now without noticing an altered behavior from userland, I'm
> not entirely against optimizing for saving ~8k of ram even if it
> increases complexity a bit (more kernel code will increase .text a bit
> though, hopefully not 8k more of .text ;).

Why do we _force_ the feature to be tunable even when user completely
don't want to disable it? Why not provide a way to let the user to decide
which is better for him?

When programming kernel, providing a mechanism rather than a policy is
what I always keep in mind, I don't know why you violate this rule here,
to be honest. :-/

Thanks.
