Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978Ab0EXEnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 00:43:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44995 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0EXEnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 00:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=HG+nmaopB1cvB9E90dHF/vl56gKxymKbBAcf+HjXYt2zh4h+MSJiSgdLuPfz5bq4QC
         dx0LU5sUy5QyMmYEcec25bupCzmW44ARV9i0U42O2Ta8LX0cbs9q7IEIP3+LRuzxwEVZ
         OOn5lyu+D5By92FvC+2jva/OjeqrdhUNtWGTY=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87632e846m.fsf@devron.myhome.or.jp>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org> 
	<AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com> 
	<20100522223838.ebca396a.akpm@linux-foundation.org> <AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com> 
	<20100523070917.GO23411@kernel.dk> <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> 
	<20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp>
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Mon, 24 May 2010 06:43:22 +0200
Message-ID: <AANLkTin42kucqLbErGA4GlGPZEIPQV2DFkiHkEVSYiI9@mail.gmail.com>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 3:43 AM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
>
>>> > We can easily make F_GETPIPE_SZ return bytes, but I don't think passing
>>> > in bytes to F_SETPIPE_SZ makes a lot of sense. The pipe array must be a
>>> > power of 2 in pages. So the question is if that makes the API cleaner,
>>> > passing in number of pages but returning bytes? Or pass in bytes all
>>> > around, but have F_SETPIPE_SZ round to the nearest multiple of pow2 in
>>> > pages if need be. Then it would return a size at least what was passed
>>> > in, or error.
>
> I really think "power of 2 in pages" is simply current implementation
> detail, not detail of pipe API.

That's a good point.

>>> I'd recommend this: Pass it in and out in bytes. Don't round to a
>>> power of 2. Require the user to know what they are doing. Give an
>>> error if the user doesn't supply a power-of-2 * page-size for
>>> F_SETPIPE_SZ. (Again, consider the case of architectures  with
>>> switchable page sizes.)
>>
>> But is there much point in erroring on an incorrect size? If the
>> application says "I need at least 120kb of space in there", kernel
>> returns "OK, you got 128kb". Would returning -1/EINVAL for that case
>> really make a better API? Doesn't seem like it to me.
>
> FWIW, my first impression of this was setsockopt(SO_RCV/SNDBUF) of unix
> socket. Well, API itself wouldn't say "at least this size" or "exactly
> this size", so, in here, important thing is consistency of interfaces, I
> think. (And the both is sane API at least for me if those had
> consistency in the system.)
>
> Well, so how about set/get in bytes, and kernel will set "at least
> specified size" actually like setsockopt(SO_RCV/SNDBUF)?

The "at least" idea makes sense. So, I'd change my recommendation to:

Pass the buffer size in and out in bytes (for consistency with other
APIs). Round the input (F_SETPIPE_SZ) value up as required by the
implementation. For the output (F_GETPIPE_SZ) value do one of the
following:
a) Return the value given on input.
b) Return the rounded up value actually used by the kernel.

I suspect (b) might be more useful: if an application cares enough
about pipe size to want to change it, then at least some such
applications might care to know exactly the size that the kernel used.
(And: I can't see any downside to (b).)

One other comment about the interface. We have

                if (!capable(CAP_SYS_ADMIN) && arg > pipe_max_pages)
                        return -EINVAL;

The usual error on a capability denied is EPERM. Please change.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
