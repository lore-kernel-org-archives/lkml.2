Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0C3GOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:14:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:50190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab0C3GOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:14:32 -0400
Message-ID: <4BB19656.9040803@kernel.org>
Date: Mon, 29 Mar 2010 23:12:38 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 07/31] lmb: Add reserve_lmb/free_lmb
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>	 <1269830604-26214-8-git-send-email-yinghai@kernel.org>	 <1269865322.24620.42.camel@concordia>  <4BB0D92C.3010103@kernel.org>	 <1269901252.2286.11.camel@concordia> <1269905491.7101.40.camel@pasglop>	 <4BB13FDB.9060006@kernel.org> <1269926794.7101.46.camel@pasglop>
In-Reply-To: <1269926794.7101.46.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 10:26 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2010-03-29 at 17:03 -0700, Yinghai Lu wrote:
>>
>> in short: It could make us to avoid use the range that we are going to
>> reserve,
>>       when we try to get new position new lmb.reserved.region. 
> 
> I'm not too sure I follow you. For the resizing, I would just basically
> call a low level variant of alloc (__lmb_alloc ?) that explicitely
> doesn't honor the total-2 "reserved" entries in the array.

1. you want to reserve rangeA
2. before that will check if region array is big enough,
3. if region is not big enough, will call lmb_alloc to get new range.
   lmb_alloc could return rangB that is overlapped with rangeA
4. current lmb_alloc only honor limit, and doesn't honor low limit.

another usage is: for temporary buffer, like range array for subtraction.
we don't need to do free later.

> 
> Ie. It should all be one single find/allocation function.
> 
> In fact, you want to split lmb_find from lmb_reserve, then just make
> lmb_alloc use the above, I don't want 2 implementations of the same
> thing (maybe call it __lmb_find to expose the fact that it's a low level
> function to avoid for normal use).

that is some difference between them, and lmb_alloc doesn't honor low limit.

we can provide
lmb_find_area
lmb_reserve_area
lmb_free_area

and use lmb_find_area + lmb_reserve_area to get one lmb_alloc()

x86 sometime is using find_lmb_area to find big area, and use those area and later reserve actually used area.

you could use lmb_alloc, and later lmb_free not used. that is equal to lmb_find + lmb_reserve + lmb_free ...

Thanks

Yinghai Lu
