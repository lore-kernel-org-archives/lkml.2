Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0FUK4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 06:56:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757620Ab0FUK4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 06:56:51 -0400
Message-ID: <4C1F455E.6050502@redhat.com>
Date: Mon, 21 Jun 2010 18:56:30 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Dan Carpenter <error27@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch] x86, pat: freeing invalid memtype messages
References: <20100617134559.GA29824@bicker> <20100617161728.GA2741@joi.lan> <4C1B1691.6020809@redhat.com> <20100618175726.GA2785@joi.lan>
In-Reply-To: <20100618175726.GA2785@joi.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2010 01:57 AM, Marcin Slusarz wrote:
> On Fri, Jun 18, 2010 at 02:47:45PM +0800, Xiaotian Feng wrote:
>> On 06/18/2010 12:17 AM, Marcin Slusarz wrote:
>>> On Thu, Jun 17, 2010 at 03:45:59PM +0200, Dan Carpenter wrote:
>>>> Commit 20413f27163 "x86, pat: Fix memory leak in free_memtype" added an
>>>> error message in free_memtype() if rbt_memtype_erase() returns NULL.
>>>> The problem is that if CONFIG_X86_PAT is enabled, we use a different
>>>> implimentation of rbt_memtype_erase() that always returns NULL.
>>>>
>>>> I've modified rbt_memtype_erase() to return an ERR_PTR() on errors and
>>>> made free_memtype() check for that instead.
>>>>
>>>> Addresses:  https://bugzilla.kernel.org/show_bug.cgi?id=16205
>>>>
>>>> Signed-off-by: Dan Carpenter<error27@gmail.com>
>>>
>>> This patch is probably ok, but it does not address my bug.
>>> I have CONFIG_X86_PAT=y, so rbt_memtype_erase does not always return NULL.
>>
>> Could you please try boot with kernel parameter "debugpat", and
>> show me the output of reserve_memtype/free_memtype ?
>>
>>
>
>
> http://kadu.net/~joi/kernel/2010.06.09/2.6.35-rc3-debugpat.txt

That's quite weird, from the above log:

[    1.787891] reserve_memtype added 0xbf799000-0xbf79a000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.791029] free_memtype request 0xbf799000-0xbf79a000
[    1.791822] reserve_memtype added 0xbf799000-0xbf79a000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.794998] swapper:1 freeing invalid memtype bf799000-bf79a000
[    1.795795] reserve_memtype added 0xbf799000-0xbf79a000, track uncached-minus, req uncached-minus, ret uncached-minus
[    1.798979] free_memtype request 0xbf799000-0xbf79a000
[    1.799775] Overlap at 0xbf799000-0xbf79a000

[   22.271353] reserve_memtype added 0xd0a40000-0xd0a50000, track write-combining, req write-combining, ret write-combining
[   22.275707] free_memtype request 0xd0a40000-0xd0a50000
[   23.209570] reserve_memtype added 0xd0a40000-0xd0a50000, track write-combining, req write-combining, ret write-combining
[   23.213888] X:2538 freeing invalid memtype d0a40000-d0a50000
[   23.214065] reserve_memtype added 0xd0a40000-0xd0a50000, track write-combining, req write-combining, ret write-combining
[   23.218415] free_memtype request 0xd0a40000-0xd0a50000
[   26.028404] Overlap at 0xd0a40000-0xd0a50000

So it looks like after we free_memtype, reserve the same area again, then free_memtype again showed us the invalid memtype (was not found in rbtree).
But the third time reserve_memtype found overlap (it's in rbtree)...

I guess there might be something wrong between the augmented rbtree insert/remove ..

(Cc'ed Peter)

>
> Marcin
>

