Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0LMIZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 03:25:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55204 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0LMIZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 03:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EY+kJu+TkKtFteX+gB04V8YnJ8gEEzNxW4/Cc7dkonXw6UiQ8xcMcaoGV0QvXNLPtS
         tSyZxB34BVTA0XYYnnUOwJ9IZcOdYy4ScVdHe18z9Hjjq57qkQT/HOKwduw6AmtEjDeg
         NuXFBqTo4JcdHQduTqwNKDjKHmnXzry5F1xyo=
MIME-Version: 1.0
In-Reply-To: <9580.1292225351@jrobl>
References: <20101209070938.GA3949@amd>
	<19324.1291990997@jrobl>
	<20101213014553.GA6522@amd>
	<9580.1292225351@jrobl>
Date: Mon, 13 Dec 2010 19:25:05 +1100
Message-ID: <AANLkTimeWSEUU6EYa4yWY11OyAVQqNu5eoBZc5ddqHQL@mail.gmail.com>
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

On Mon, Dec 13, 2010 at 6:29 PM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Nick Piggin:
>> It's not scaling but just single threaded performance. gcc turns memcmp
>> into rep cmp, which has quite a long latency, so it's not appripriate
>> for short strings.
>
> Honestly speaking I doubt how this 'long *' approach is effective
> (Of course it never means that your result (by 'char *') is doubtful).

Well, let's see what turns up. We certainly can try the long *
approach. I suspect on architectures where byte loads are
very slow, gcc will block the loop into larger loads, so it should
be no worse than a normal memcmp call, but if we do explicit
padding we can avoid all the problems associated with tail
handling.

Doing name padding and long * comparison will be practically
free (because slab allocator will align out to sizeof(long long)
anyway), so if any architecture prefers to do the long loads, I'd
be interested to hear and we could whip up a patch.

> But is the "rep cmp has quite a long latency" issue generic for all x86
> architecture, or Westmere system specific?

I don't believe it is Westmere specific. Intel and AMD have
been improving these instructions in the past few years, so
Westmere is probably as good or better than any.

That said, rep cmp may not be as heavily optimized as the
set and copy string instructions.

In short, I think the change should be suitable for all x86 CPUs,
but I would like to hear more opinions or see numbers for other
cores.

Thanks,
Nick
