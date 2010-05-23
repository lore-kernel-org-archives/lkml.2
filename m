Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0EWJZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:25:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45185 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab0EWJY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:24:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=YJLtKiaNlFbjiCz7LfShiOsf+NP9/yZ/Mugra8/Hdd3vkuokWURz07jOT+x1RjVDfY
         wZ2hg60flL8zJ1GjcgG/7zxZunBNist9SWktT/+qG2ibLFPdC0h/A666CGV9LUZyz2lp
         Xf/ODtpK4sFCL+URcZKGxCMg5HlO5iEyRcQXg=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100523070917.GO23411@kernel.dk>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org> 
	<AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com> 
	<20100522223838.ebca396a.akpm@linux-foundation.org> <AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com> 
	<20100523070917.GO23411@kernel.dk>
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Sun, 23 May 2010 11:24:35 +0200
Message-ID: <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 9:09 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Sun, May 23 2010, Michael Kerrisk wrote:
>> On Sun, May 23, 2010 at 4:38 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Sun, 23 May 2010 07:30:01 +0200 Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>> >
>> >> Hi all,
>> >>
>> >> I see that this patch has hit Linus's git, so some questions
>> >>
>> >> On Wed, May 19, 2010 at 6:49 PM, Linus Torvalds
>> >> <torvalds@linux-foundation.org> wrote:
>> >> >
>> >> >
>> >> > On Wed, 19 May 2010, Miklos Szeredi wrote:
>> >> >>
>> >> >> One issue I see is that it's possible to grow pipes indefinitely.
>> >> >> Should this be restricted to privileged users?
>> >> >
>> >> > Yes. But perhaps only if it grows past the default (or perhaps "default*2"
>> >> > or similar). That way a normal user could shrink the pipe buffers, and
>> >> > then grow them again if he wants to.
>> >> >
>> >> > Oh, and I think you need to also require that there be at least two
>> >> > buffers. Otherwise we can't guarantee POSIX behavior, I think.
>> >>
>> >> Is there any documentation (e.g., a man-pages patch) for these changes?
>> >>
>> >> The argument of the fcntl() operations is expressed in pages. I take
>> >> it that this means that the semantics of the argument will very
>> >> depending on the system page size? So for example, 2 on x86 will mean
>> >> 8192 bytes, but will mean 32768 of ia64? That seems very weird. (And
>> >> what about architectures where the page size is switchable?) Such
>> >> changes in semantics should not be silent for the use, IMO.
>> >
>> > Well, there is getpagesize().  But I agree - this interface is just
>> > asking (x86) people to write non-portable code.
>> >
>> > otoh, if the arg was in bytes, they'd just hard-code "8192".  They're
>> > clever like that.
>> >
>> > But we have gone to some lengths to avoid exposing things like
>> > PAGE_SIZE and HZ in procfs, so it makes sense to take the same approach
>> > to syscalls.
>>
>> Quite. All of the other memory-related APIs that I can think of
>> require the user to express the info in bytes. (mlock(),
>> remap_file_pages(), mmap(), mremap(), mprotect(), shmget(), and so
>> on). Not doing the same for this interface is needlessly inconsistent.
>> And while there will be the silly users you mention above, smart users
>> will know how to do the right thing with a consistently designed
>> interface.
>
> We can easily make F_GETPIPE_SZ return bytes, but I don't think passing
> in bytes to F_SETPIPE_SZ makes a lot of sense. The pipe array must be a
> power of 2 in pages. So the question is if that makes the API cleaner,
> passing in number of pages but returning bytes? Or pass in bytes all
> around, but have F_SETPIPE_SZ round to the nearest multiple of pow2 in
> pages if need be. Then it would return a size at least what was passed
> in, or error.

I'd recommend this: Pass it in and out in bytes. Don't round to a
power of 2. Require the user to know what they are doing. Give an
error if the user doesn't supply a power-of-2 * page-size for
F_SETPIPE_SZ. (Again, consider the case of architectures  with
switchable page sizes.)

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
