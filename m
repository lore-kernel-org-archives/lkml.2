Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1CFSBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 13:01:41 -0500
Received: from smtp-out.google.com ([216.239.44.51]:50546 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab1CFSBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 13:01:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w/6m4GkZ2JgBcp45wVvjOTDTESGHWZlo9XebXt4nM0XYlmQNdFMFSMZoWFTI5Yw/JI
         ojBFPzfZfGU6IzDjwEQA==
MIME-Version: 1.0
In-Reply-To: <AANLkTinjs42oy9h7rdj0+PRQ8+HAJsd-66KdBsc6Kpor@mail.gmail.com>
References: <AANLkTinjs42oy9h7rdj0+PRQ8+HAJsd-66KdBsc6Kpor@mail.gmail.com>
Date: Sun, 6 Mar 2011 10:01:35 -0800
Message-ID: <AANLkTinTvZZydNgg7CiD-wMjHXhjnK_-m_wdY5O9paW4@mail.gmail.com>
Subject: Re: [PATCH mmotm] fix broken bootup on 32-bit
From: Hugh Dickins <hughd@google.com>
To: =?UTF-8?Q?Micha=C5=82_Nazarewicz?= <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Douglas W. Jones" <jones@cs.uiowa.edu>, linux-kernel@vger.kernel.org,
        Denis Vlasenko <vda.linux@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 2:09 PM, Michał Nazarewicz <mina86@mina86.com> wrote:
> On Mar 5, 2011 8:49 PM, "Hugh Dickins" <hughd@google.com> wrote:
>> I realize that zeroes are handled, but I was imagining that one branch
>> taken (for numbers up to 9999) is cheaper than four out-of-line function
>> calls, six divisions-or-modulos by constant 10000, three multiplications
>> by constants; oh, and a lot more once I look inside put_dec_full4().
>>
>> Is that not the case?  Isn't performance the justification for this magic?
>
> It turns out that difference in speed is minimal and inconclusive, as the
> version without cascading ifs seems to perform better on ARM. So because my
> benchmarks didn't show a clear winner, we can go with a shorter version.

At first I was surprised by that, but now I'm suspecting that it's a
severe flaw in your benchmarking.

Am I right to think that you are measuring the performance of the
algorithms on random unsigned long longs?  Which are very unlikely to
have all the upper 16 bits unset?  Let alone the upper 32 bits or the
upper 48 bits all unset?

Whereas, what would be the distribution of numbers that the kernel is
typically called upon to vsprintf?  I put it to you that numbers with
the upper 48 bits all unset would predominate, followed by those with
just the upper 32 bits unset.

I'm sure there are u64s and s64s and unsigned long longs and long
longs to be found and printed, but the mm statistics I just looked up
appear to be merely unsigned longs, just 32 bits on 32-bit; and even
in the 64-bit case, I'd still expect that lower numbers would
generally predominate.

I suspect that, without more branching than you have at present, your
new algorithms actually slow down the kernel.

Hugh
