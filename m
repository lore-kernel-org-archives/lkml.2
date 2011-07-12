Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1GLGNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 02:13:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58850 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab1GLGNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 02:13:18 -0400
Message-ID: <4E1BE5F9.10401@kernel.org>
Date: Tue, 12 Jul 2011 09:13:13 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slub: partly fix freeze in __slab_free
References: <alpine.LSU.2.00.1107111156310.13035@sister.anvils> <1310413167.2860.3.camel@edumazet-laptop>
In-Reply-To: <1310413167.2860.3.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/11 10:39 PM, Eric Dumazet wrote:
> Le lundi 11 juillet 2011 à 11:58 -0700, Hugh Dickins a écrit :
>> My load tests on PowerPC freeze within minutes in __slab_free().
>> I happened to try PPC first, didn't try without this fix on x86.
>>
>> It looks as if the author was interrupted while devising the new
>> cmpxchg_double_slab() version of __slab_free(): its decision to
>> spin_lock_irqsave() depends on several uninitialized fields,
>> and fixing that (by copying page to new) mostly fixes it.
>>
>> But I didn't think about it very much, and this may well not be what
>> the author intends; and I have seen a couple of much rarer freezes
>> in __slab_free() on PPC (not yet on x86) even after applying this.
>>
>> Signed-off-by: Hugh Dickins<hughd@google.com>
>> ---
>>   mm/slub.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> --- mmotm/mm/slub.c	2011-07-08 18:59:44.135443127 -0700
>> +++ linux/mm/slub.c	2011-07-10 05:07:08.000000000 -0700
>> @@ -2217,6 +2217,7 @@ static void __slab_free(struct kmem_cach
>>   		return;
>>
>>   	do {
>> +		new = *page;
>>   		prior = page->freelist;
>>   		counters = page->counters;
>>   		set_freepointer(s, object, prior);
>> --
> I suspect you hit the bug on 32bit arch ?
>
> What about following patch instead ?
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 3d76a43..1351d28 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -62,7 +62,7 @@ struct page {
>   		struct {			/* SLUB cmpxchg_double area */
>   			void *freelist;
>   			union {
> -				unsigned long counters;
> +				u64	counters;
>   				struct {
>   					unsigned inuse:16;
>   					unsigned objects:15;
>

Christoph?
