Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0E3Rm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 13:42:59 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:39649 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab0E3Rm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 13:42:58 -0400
Message-ID: <4C02A39D.3050303@cesarb.net>
Date: Sun, 30 May 2010 14:42:53 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Make kunmap_atomic() harder to misuse
References: <1275043993-26557-1-git-send-email-cesarb@cesarb.net> <20100529204256.b92b1ff6.akpm@linux-foundation.org>
In-Reply-To: <20100529204256.b92b1ff6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-05-2010 00:42, Andrew Morton escreveu:
> On Fri, 28 May 2010 07:53:13 -0300 Cesar Eduardo Barros<cesarb@cesarb.net>  wrote:
>> Make it much harder to misuse, by moving it to level 9 on Rusty's
>> list[4] ("The compiler/linker won't let you get it wrong"). This is done
>> by refusing to build if the pointer passed to it is convertible to a
>> struct page * but it is not a void * (verified by trying to convert it
>> to a pointer to a dummy struct).
>>
>> The real kunmap_atomic() is renamed to kunmap_atomic_notypecheck()
>> (which is what you would call in case for some strange reason calling it
>> with a pointer to a struct page is not incorrect in your code).
>>
>
> Fair enough, that's a 99% fix.  A long time ago I made kmap_atomic()
> return a char * (iirc) and kunmap_atomic() is passed a char*.  It
> worked, but I ended up throwing it away.  I don't precisely remember
> why - I think it was intrusiveness and general hassle rather than
> anything fundamental.

I vaguely recall reading something about that on LWN a long time ago.[1]

The advantage of my __builtin_types_compatible_p approach is that it 
does not have to change the callers at all (except in the extremly 
unlikely case that someone actually meant to call it with a struct page 
*, which is something I did not find when looking at the whole kernel 
with spatch[2]).

The disadvantage of my approach is that gcc's error message is 
absolutely atrocious:

mm/swapfile.c: In function ‘foo’:
mm/swapfile.c:2501: error: negative width in bit-field ‘<anonymous>’

But that is a problem with BUILD_BUG_ON, not this code.

>> +/* Prevent people trying to call kunmap_atomic() as if it were kunmap() */
>> +struct __kunmap_atomic_dummy {};
>> +#define kunmap_atomic(addr, idx) do { \
>> +		BUILD_BUG_ON( \
>> +			__builtin_types_compatible_p(typeof(addr), struct page *)&&  \
>> +			!__builtin_types_compatible_p(typeof(addr), struct __kunmap_atomic_dummy *)); \
>> +		kunmap_atomic_notypecheck((addr), (idx)); \
>> +	} while (0)
>
> We have a little __same_type() helper for this.  __must_be_array()
> should be using it, too.

It would be great (shortening the long lines a lot), except that in this 
case it is a complete misnomer, which would probably confuse people 
reading the code. If __same_type(typeof(addr), void *) worked, I would 
not need a dummy struct; but __same_type is actually looking for 
compatible types, not same type (perhaps for non-pointers it actually 
means "same type"). In the first part of the condition, I am actually 
looking for "same type", but even there __same_type(void *, struct page 
*) would return true (which is why I need the second part).

And now I am having second thoughts about the line breaks here; I should 
have also broken between the parameters of __builtin_types_compatible_p, 
to avoid long lines. If you want, I can resend the patch with it reindented.


[1] Yep, there it is: https://lwn.net/Articles/111226/
[2]
@@
struct page *page;
expression E;
@@
* kunmap_atomic(page, E)

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
