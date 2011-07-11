Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841Ab1GKUrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:47:31 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50818 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab1GKUra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:47:30 -0400
Message-ID: <4E1B615B.3040509@gmail.com>
Date: Mon, 11 Jul 2011 22:47:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        cl@linux.com, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: page->_count build failure [was: mmotm 2011-07-08-12-50 uploaded]
References: <201107082028.p68KSWWf013053@imap1.linux-foundation.org> <4E1B5CAA.7070001@gmail.com> <20110711134121.54557e28.akpm@linux-foundation.org> <CAOJsxLG3jjjebBPbZjWTzue7nZJFMWVGZ3iGK41cjGpdKi477Q@mail.gmail.com>
In-Reply-To: <CAOJsxLG3jjjebBPbZjWTzue7nZJFMWVGZ3iGK41cjGpdKi477Q@mail.gmail.com>
X-Enigmail-Version: 1.2pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2011 10:45 PM, Pekka Enberg wrote:
> On Mon, Jul 11, 2011 at 11:41 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Mon, 11 Jul 2011 22:27:22 +0200
>> Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>>> On 07/08/2011 09:50 PM, akpm@linux-foundation.org wrote:
>>>> The mm-of-the-moment snapshot 2011-07-08-12-50 has been uploaded to
>>>
>>> Hi, am I the only one encountering a build failure due to double
>>> definition of _count in page struct introduced by:
>>> commit fc9bb8c768abe7ae10861c3510e01a95f98d5933
>>> Author: Christoph Lameter <cl@linux.com>
>>> Date:   Wed Jun 1 12:25:48 2011 -0500
>>>
>>>     mm: Rearrange struct page
>>>
>>> in the -next tree?
>>>
>>> $ make
>>> ...
>>>   CC      arch/x86/kernel/asm-offsets.s
>>> In file included from include/linux/sched.h:64:0,
>>>                  from arch/x86/kernel/asm-offsets.c:9:
>>> include/linux/mm_types.h:74:15: error: duplicate member ____count___
>>> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
>>> make: *** [prepare0] Error 2
>>> $ gcc --version
>>> gcc (SUSE Linux) 4.6.0 20110607 [gcc-4_6-branch revision 174741]
>>>
>>
>> Oh dear.  Yes, I would call that an error.  Afacit the two `_count's
>> end up at the same offset in the page struct.  Perhaps that makes it
>> legal and your compiler got it wrong.  Or perhaps it is illegal and all
>> other compilers got it wrong.
>>
>> Still, we should fix it.  It's daft to have two distinct page->_count's.
>>
>> To fix it, we could rename one of them.  Which means that we're going
>> to need to work out which references to page->_count are referring to
>> which field.  Which demonstrates the problem!
>>
>>
>> hmm, let's jiggle the offset:
>>
>> --- a/include/linux/mm_types.h~a
>> +++ a/include/linux/mm_types.h
>> @@ -71,6 +71,7 @@ struct page {
>>                                         * Kernel may make use of this field even when slub
>>                                         * uses the rest of the double word!
>>                                         */
>> +                                       int foo;
>>                                        atomic_t _count;
>>                                };
>>                        };
>> _
>>
>> nope, it still compiles OK.  It has to be gcc bustification I think.
>> Fixed in gcc-4.6.0.
> 
> Didn't commit ea6bd8ee1a2ccdffc38b2b1fcfe941addfafaade fix the issue?

Which repo is that from? Git doesn't know it here.

thanks,
-- 
js
