Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231Ab1EYAoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 20:44:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37687 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab1EYAoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 20:44:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDC50C1.4000201@jp.fujitsu.com>
Date: Wed, 25 May 2011 09:43:45 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: luto@mit.edu
CC: minchan.kim@gmail.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking
 vmlinux)
References: <BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com> <BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com> <BANLkTins7qxWVh0bEwtk1Vx+m98N=oYVtw@mail.gmail.com> <20110520140856.fdf4d1c8.kamezawa.hiroyu@jp.fujitsu.com> <20110520101120.GC11729@random.random> <BANLkTikAFMvpgHR2dopd+Nvjfyw_XT5=LA@mail.gmail.com> <20110520153346.GA1843@barrios-desktop> <BANLkTi=X+=Wh1MLs7Fc-v-OMtxAHbcPmxA@mail.gmail.com> <20110520161934.GA2386@barrios-desktop> <BANLkTi=4C5YAxwAFWC6dsAPMR3xv6LP1hw@mail.gmail.com> <BANLkTimThVw7-PN6ypBBarqXJa1xxYA_Ow@mail.gmail.com> <BANLkTint+Qs+cO+wKUJGytnVY3X1bp+8rQ@mail.gmail.com> <BANLkTinx+oPJFQye7T+RMMGzg9E7m28A=Q@mail.gmail.com> <BANLkTik29nkn-DN9ui6XV4sy5Wo2jmeS9w@mail.gmail.com> <BANLkTikQd34QZnQVSn_9f_Mxc8wtJMHY0w@mail.gmail.com> <BANLkTi=wVOPSv1BA_mZq9=r14Vu3kUh3_w@mail.gmail.com> <BANLkTimw23VP4yyuDed-KrLEcnfLMMA-fQ@mail.gmail.com> <BANLkTi=PffB2AmQ4m1XymxhnDUWsEXTwQA@mail.gmail.com> <BANLkTinGsBOCDpKcBzrgfJbrVokPaZpFzg@mail.gmail.com>
In-Reply-To: <BANLkTinGsBOCDpKcBzrgfJbrVokPaZpFzg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/24 20:55), Andrew Lutomirski wrote:
> On Tue, May 24, 2011 at 7:24 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Mon, May 23, 2011 at 9:34 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>>> On Tue, May 24, 2011 at 10:19 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>>>> On Sun, May 22, 2011 at 7:12 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>>>>> Could you test below patch based on vanilla 2.6.38.6?
>>>>> The expect result is that system hang never should happen.
>>>>> I hope this is last test about hang.
>>>>>
>>>>> Thanks.
>>>>>
>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>> index 292582c..1663d24 100644
>>>>> --- a/mm/vmscan.c
>>>>> +++ b/mm/vmscan.c
>>>>> @@ -231,8 +231,11 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>>>>>       if (scanned == 0)
>>>>>               scanned = SWAP_CLUSTER_MAX;
>>>>>
>>>>> -       if (!down_read_trylock(&shrinker_rwsem))
>>>>> -               return 1;       /* Assume we'll be able to shrink next time */
>>>>> +       if (!down_read_trylock(&shrinker_rwsem)) {
>>>>> +               /* Assume we'll be able to shrink next time */
>>>>> +               ret = 1;
>>>>> +               goto out;
>>>>> +       }
>>>>>
>>>>>       list_for_each_entry(shrinker, &shrinker_list, list) {
>>>>>               unsigned long long delta;
>>>>> @@ -286,6 +289,8 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>>>>>               shrinker->nr += total_scan;
>>>>>       }
>>>>>       up_read(&shrinker_rwsem);
>>>>> +out:
>>>>> +       cond_resched();
>>>>>       return ret;
>>>>>  }
>>>>>
>>>>> @@ -2331,7 +2336,7 @@ static bool sleeping_prematurely(pg_data_t
>>>>> *pgdat, int order, long remaining,
>>>>>        * must be balanced
>>>>>        */
>>>>>       if (order)
>>>>> -               return pgdat_balanced(pgdat, balanced, classzone_idx);
>>>>> +               return !pgdat_balanced(pgdat, balanced, classzone_idx);
>>>>>       else
>>>>>               return !all_zones_ok;
>>>>>  }
>>>>
>>>> So far with this patch I can't reproduce the hang or the bogus OOM.
>>>>
>>>> To be completely clear, I have COMPACTION, MIGRATION, and THP off, I'm
>>>> running 2.6.38.6, and I have exactly two patches applied.  One is the
>>>> attached patch and the other is a the fpu.ko/aesni_intel.ko merger
>>>> which I need to get dracut to boot my box.
>>>>
>>>> For fun, I also upgraded to 8GB of RAM and it still works.
>>>>
>>>
>>> Hmm. Could you test it with enable thp and 2G RAM?
>>> Isn't it a original test environment?
>>> Please don't change test environment. :)
>>
>> The test that passed last night was an environment (hardware and
>> config) that I had confirmed earlier as failing without the patch.
>>
>> I just re-tested my original config (from a backup -- migration,
>> compaction, and thp "always" are enabled).  I get bogus OOMs but not a
>> hang.  (I'm running with mem=2G right now -- I'll swap the DIMMs back
>> out later on if you want.)
>>
>> I attached the bogus OOM (actually several that happened in sequence).
>>  They look readahead-related.  There was plenty of free swap space.
> 
> Now with log actually attached.

Unfortnately, this log don't tell us why DM don't issue any swap io. ;-)
I doubt it's DM issue. Can you please try to make swap on out of DM?

