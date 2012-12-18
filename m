Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2LRKHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:07:12 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49608 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab2LRKHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:07:10 -0500
X-Greylist: delayed 1133 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 05:07:09 EST
Message-ID: <50D039FF.5090006@openvz.org>
Date: Tue, 18 Dec 2012 13:40:15 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121123 Firefox/10.0.11 Iceape/2.7.11
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] mm/swap: abort swapoff after disk error
References: <20121214110110.8181.70783.stgit@zurg> <alpine.LNX.2.00.1212171953070.5927@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1212171953070.5927@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Fri, 14 Dec 2012, Konstantin Khlebnikov wrote:
>
>> Content of non-uptodate pages completely random, we cannot expose them into
>> userspace. This leads to information leak and will crash userspace for sure.
>
> Good find, yes, it's very wrong as is.  But, sorry, I don't like your fix
> - better than ignoring the issue as at present, but not the right answer.
>
>> Probably we can reuse hwpoison entries here, but tmpfs already too complex.
>
> HWpoison entries?  They're for when that page of RAM is bad, but this is
> quite a different case: the page is fine and can perfectly well be freed
> and reused - what's bad is the data currently in it.
>
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> Original-patch-by: Alexey Kuznetsov<kuznet@ms2.inr.ac.ru>
>> Cc: Andrew Morton<akpm@linux-foundation.org>
>> Cc: Hugh Dickins<hughd@google.com>
>> Cc: Andi Kleen<andi@firstfloor.org>
>> ---
>>   mm/swapfile.c |   16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index e97a0e5..98fc2fd 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -1127,6 +1127,22 @@ int try_to_unuse(unsigned int type, bool frontswap,
>>   		wait_on_page_writeback(page);
>>
>>   		/*
>> +		 * If read failed we cannot map not-uptodate page to
>> +		 * user space. Actually, we are in serious troubles,
>> +		 * we do not even know what process to kill. So, the only
>
> try_to_unuse() is all about locating exactly where this page belongs;
> and if the user is lucky, the page in question won't even be needed again
> before the process exits, so nothing should be killed at this point.
>
>
>> +		 * variant remains: to stop swapoff() and allow someone
>> +		 * to kill processes to zap invalid pages.
>
> No, we should not abort swapoff: there's every reason to continue,
> to make sure that this unreliable area can be taken out of service.
>
>> +		 *
>> +		 * TODO replace page with hwpoison entry in pte and shmem.
>
> Instead of blindly going ahead and inserting ptes pointing to the
> !PageUptodate page, unuse_pte() and shmem_unuse_inode() should insert
> a substitute bad swapentry, to generate SIGBUS if it's accessed.
>
> swp_entry(1, 0) might serve, but there's probably a few mods needed
> here and there; and getting the details right (e.g. memcg charges)
> will need care.
>
> Not as straightforward as your block below, I admit.  I wonder if you
> posted that just to stir me to do better: or can you take it further?

I found this patch in our kernel tree. For some reason it wasn't sent
to mainline. So I decided to send it as is to not lose it for a few more
years. Using here hwpoison was just a guess. Your bad-swap-entry is much
more accurate solution. Seems like here is no rush, this bug was here from
the beginning, so I'll handle it. Thanks for your advice.

>
> Thanks,
> Hugh
>
>> +		 */
>> +		if (unlikely(!PageUptodate(page))) {
>> +			unlock_page(page);
>> +			page_cache_release(page);
>> +			retval = -EIO;
>> +			break;
>> +		}
>> +
>> +		/*
>>   		 * Remove all references to entry.
>>   		 */
>>   		swcount = *swap_map;
