Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760433Ab0LOEGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 23:06:06 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65147 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab0LOEGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 23:06:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=g7PUFMi0xL15uvfR9yesVQD16L3oTX6VwaUZkYEzMrdj3taeqZk6exiydx0+TyOtGM
         mAFniwOSklppB8Z93Cm1EQ6c15MnIW7m30fkzQAXX5GLih5RaJ8+jpjW8y53m1GvClbu
         DbwCCtgWeymhv8CQPsoPgM0bt6QcLkkIvX5oA=
MIME-Version: 1.0
In-Reply-To: <12853.1292353313@jrobl>
References: <20101209070938.GA3949@amd>
	<19324.1291990997@jrobl>
	<20101213014553.GA6522@amd>
	<9580.1292225351@jrobl>
	<AANLkTimeWSEUU6EYa4yWY11OyAVQqNu5eoBZc5ddqHQL@mail.gmail.com>
	<12853.1292353313@jrobl>
Date: Wed, 15 Dec 2010 15:06:00 +1100
Message-ID: <AANLkTinjkcciZhJM5FmUkh_YCJ6bc9aTq8zV=SACDb1O@mail.gmail.com>
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
From: Nick Piggin <npiggin@gmail.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 6:01 AM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Nick Piggin:
>> Well, let's see what turns up. We certainly can try the long *
>> approach. I suspect on architectures where byte loads are
>> very slow, gcc will block the loop into larger loads, so it should
>> be no worse than a normal memcmp call, but if we do explicit
>> padding we can avoid all the problems associated with tail
>> handling.
>
> Thank you for your reply.
> But unfortunately I am afraid that I cannot understand what you wrote
> clearly due to my poor English. What I understood is,
> - I suggested 'long *' approach
> - You wrote "not bad and possible, but may not be worth"
> - I agreed "the approach may not be effective"
> And you gave deeper consideration, but the result is unchaged which
> means "'long *' approach may not be worth". Am I right?

What I meant is that a "normal" memcmp that does long * memory
operations is not a good idea, because it requires code and branches
to handle the tail of the string. When average string lengths are less
than 16 bytes, it hardly seems wothwhile. It will just get more
mispredicts and bigger icache footprint.

However instead of a normal memcmp, we could actually pad dentry
names out to sizeof(long) with zeros, and take advantage of that with
a memcmp that does not have to handle tails -- it would operate
entirely with longs.

That would avoid icache and branch regressions, and might speed up
the operation on some architectures. I just doubted whether it would
show an improvement to be worth doing at all. If it does, I'm all for it.


>> In short, I think the change should be suitable for all x86 CPUs,
>> but I would like to hear more opinions or see numbers for other
>> cores.
>
> I'd like to hear from other x86 experts too.
> Also I noticed that memcmp for x86_32 is defined as __builtin_memcmp
> (for x86_64 is "rep cmp"). Why does x86_64 doesn't use __builtin_memcmp?
> Is it really worse?
>
>
> J. R. Okajima
>
