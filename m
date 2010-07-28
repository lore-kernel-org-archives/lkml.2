Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0G1Prg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:47:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab0G1Pr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:47:27 -0400
Message-ID: <4C505025.1040709@ds.jp.nec.com>
Date: Wed, 28 Jul 2010 11:43:33 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/7][memcg] memcg use ID in page_cgroup
References: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com> <20100727165629.6f98145c.kamezawa.hiroyu@jp.fujitsu.com> <20100728023904.GE12642@redhat.com> <20100728114402.571b8ec6.kamezawa.hiroyu@jp.fujitsu.com> <20100728031358.GG12642@redhat.com>
In-Reply-To: <20100728031358.GG12642@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote, on 07/27/2010 11:13 PM:
> On Wed, Jul 28, 2010 at 11:44:02AM +0900, KAMEZAWA Hiroyuki wrote:
>> On Tue, 27 Jul 2010 22:39:04 -0400
>> Vivek Goyal<vgoyal@redhat.com>  wrote:
>>
>>> On Tue, Jul 27, 2010 at 04:56:29PM +0900, KAMEZAWA Hiroyuki wrote:
>>>> From: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>>>>
>>>> Now, addresses of memory cgroup can be calculated by their ID without complex.
>>>> This patch relplaces pc->mem_cgroup from a pointer to a unsigned short.
>>>> On 64bit architecture, this offers us more 6bytes room per page_cgroup.
>>>> Use 2bytes for blkio-cgroup's page tracking. More 4bytes will be used for
>>>> some light-weight concurrent access.
>>>>
>>>> We may able to move this id onto flags field but ...go step by step.
>>>>
>>>> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>>>> ---
>>>>   include/linux/page_cgroup.h |    3 ++-
>>>>   mm/memcontrol.c             |   40 +++++++++++++++++++++++++---------------
>>>>   mm/page_cgroup.c            |    2 +-
>>>>   3 files changed, 28 insertions(+), 17 deletions(-)
>>>>
>>>> Index: mmotm-0719/include/linux/page_cgroup.h
>>>> ===================================================================
>>>> --- mmotm-0719.orig/include/linux/page_cgroup.h
>>>> +++ mmotm-0719/include/linux/page_cgroup.h
>>>> @@ -12,7 +12,8 @@
>>>>    */
>>>>   struct page_cgroup {
>>>>   	unsigned long flags;
>>>> -	struct mem_cgroup *mem_cgroup;
>>>> +	unsigned short mem_cgroup;	/* ID of assigned memory cgroup */
>>>> +	unsigned short blk_cgroup;	/* Not Used..but will be. */
>>>
>>> So later I shall have to use virtually indexed arrays in blkio controller?
>>> Or you are just using virtually indexed arrays for lookup speed and
>>> I can continue to use css_lookup() and not worry about using virtually
>>> indexed arrays.
>>>
>> yes. you can use css_lookup() even if it's slow.
>>
>
> Ok.
>
>>> So the idea is that when a page is allocated, also store the blk_group
>>> id and once that page is submitted for writeback, we should be able
>>> to associate it to right blkio group?
>>>
>> blk_cgroup id can be attached whenever you wants. please overwrite
>> page_cgroup->blk_cgroup when it's necessary.
>
>> Did you read Ikeda's patch ? I myself doesn't have patches at this point.
>> This is just for make a room for recording blkio-ID, which was requested
>> for a year.
>
> I have not read his patches yet. IIRC, previously there were issues
> regarding which group should be charged for the page. The person who
> allocated it or the thread which did last write to it etc... I guess
> we can sort that out later.

Absolutely.
iotrack, a part of blkio cgroup for async write patch I posted, charges
the thread (in exact, blkio-cgroup to which the thread belongs) which
dirtied the page first.  Though it should be controversial and we need
to discuss who should be charged, adding pc->blk_cgroup has no problem
because blkio-cgroup can overwrite it any time, as Kame said above.

Beyond that, adding pc->blk_cgroup is a big step for us.  Now I encode
and store ID in pc->flags.  pc->blk_cgroup is more straight and that
is what we have been looking forward.  Thanks Kame!



-- 
IKEDA, Munehiro
   NEC Corporation of America
     m-ikeda@ds.jp.nec.com

