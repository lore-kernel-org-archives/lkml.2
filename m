Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0LPQwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:52:02 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059Ab0LPQv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:51:59 -0500
MIME-Version: 1.0
In-Reply-To: <4D09E185.2040600@panasas.com>
References: <12853.1292353313@jrobl> <AANLkTinjkcciZhJM5FmUkh_YCJ6bc9aTq8zV=SACDb1O@mail.gmail.com>
 <4D08BF5D.1060509@panasas.com> <20101215.100055.226772943.davem@davemloft.net>
 <4D09E185.2040600@panasas.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Dec 2010 08:51:04 -0800
Message-ID: <AANLkTinZ=Bk53KCr4_8Vjpb6M+RWq6n2XCz=rY2DOLRx@mail.gmail.com>
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: David Miller <davem@davemloft.net>, npiggin@gmail.com,
        hooanon05@yahoo.co.jp, npiggin@kernel.dk, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 1:53 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>
> You miss understood me. I'm saying that we know the beggining of the
> string is aligned and Nick offered to pad the last long, so surly
> a shift by 2 (or 3) + the reduction of the 12 dec-and-test to 3
> should give you an optimization?

Sadly, right now we don't know that the string is necessarily even aligned.

Yes, it's always aligned in a dentry, because it's either the inline
short string, or it's the longer string we explicitly allocated to the
dentry.

But when we do name compares in __d_lookup, only one part of that is a
dentry. The other is a qstr, and the name there is not aligned. In
fact, it's not even NUL-terminated. It's the data directly from the
path itself.

So we can certainly do compares a "long" at a time, but it's not
entirely trivial. And just making the dentries be aligned and
null-padded is not enough. Most likely, you'd have to make the dentry
name compare function do an unaligned load from the qstr part, and
then do the masking.

Which is likely still the best performance on something like x86 where
unaligned loads are cheap, but on other architectures it might be less
so.

                                     Linus
