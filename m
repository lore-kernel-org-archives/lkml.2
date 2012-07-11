Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab2GKRZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:25:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33499 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab2GKRZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:25:45 -0400
MIME-Version: 1.0
In-Reply-To: <1342025743.13724.102.camel@joe2Laptop>
References: <1342002808.810.12.camel@mop> <1342018897.13724.61.camel@joe2Laptop>
 <CAPXgP11XnrFayb-g5HFu3wPtw8=xLfSY7HNCCbiSoehj8KsGcw@mail.gmail.com>
 <1342020647.13724.71.camel@joe2Laptop> <CAPXgP13ff+eFH_jJ+0FDX0-GkuZj3RSv7VCp3ftcsGzA412FVQ@mail.gmail.com>
 <1342025743.13724.102.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 11 Jul 2012 19:25:24 +0200
Message-ID: <CAPXgP11pjoKLbj8oXbFBJkzeAFUHwP3CyNkT8DfpO27nBhx2eA@mail.gmail.com>
Subject: Re: pr_cat() + CATSTR(name, size)?
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 6:55 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-07-11 at 17:48 +0200, Kay Sievers wrote:
>> On Wed, Jul 11, 2012 at 5:30 PM, Joe Perches <joe@perches.com> wrote:
>> > Well, I think the malloc costs are pretty low
>> > and could devolve pretty easily when OOM.
>>
>> We need to avoid allocating memory in situations where we want to
>> printk(), it's just not possible.
>
> "it's just not possible???"  Kay, them's fightin' words. :)

Nah, I meant it. :) It limits the usefulness of these functions. We
can not safely allocate memory, or do not get any memory in some
situations where we want to use printk(). Hey, it might be used to say
printk("out of memory\n").

>> That's why all the kmsg/printk can
>> not really do any plain malloc. All printk memory needs to be static,
>> on the stack or somehow pre-allocated.
>
> Maybe, I was planning to play with it after
> refactoring printk in the next couple releases.

Sounds good.

>> > Anyway, interesting idea, keep at it, see what
>> > comes out of it.
>>
>> Just depends on us, I guess. :)

> If your solution is just for the dev_<level> messages
> (ie: with vprintk_emit descriptors), then it's not
> too ugly.

Yeah, I thought only about these. But there might be more users where
it makes sense to do that in a more reliable manner, don't know. It
was surely no meant to replace the remaining 99.9% of the other cont
users. :)

> Did you look at the remaining dev_<level> and printk
> continuations grep pattern?  There really aren't too
> many to fix up.

Yeah, it looks fine to fix these few.

> Maybe in 3.6.  None of them appear particularly urgent.

Right.

> One trivial style note:
>
> Maybe CATSTR could use a struct and a DECLARE_ macro?
>
> struct printk_continuation_buffer {
>         size_t length;
>         size_t pos;
>         char buf[];
> }

Yeah, but then we lose the simplicity of passing the normal string
around, and we need accessor macros to get to the string when we pass
it around later. Maybe it's still OK, but it's surely not so intuitive
anymore.

> It's a pity gcc doesn't allow non-static declarations like:
>
> #define DECLARE_PRINTK_BUF(name, size)          \
> struct printk_continuation_buffer name = {      \
>         .length = size;                         \
>         .pos = 0;                               \
>         .buf[size] = {0};                       \
> }

Yeah, when the size changes, we have different type of struct. So we
can not name them all "printk_continuation_buffer", every different
size would conflict with each other.

Also  = {0} on an array forces a memset() of the entire array, nothing
wrong, but it's not really needed.

> So maybe a DECLARE/DESTROY thing could work
> with the appropriate malloc/free.

Hmm, I really don't think we can teach the people, or expect them to
know, that these printk() functions are fragile if used in some
critical code paths. It would at least need the GFP flags and in many
cases GFP_ATOMIC which can easily fail, and we would also need to do
error checking then, and printk() should just never fail, because it
is used to tell that something went wrong. We have the entire kmsg
buffer pre-allocated at bootup for that reason.

I think the only really sane option here is to use the (usually
~50-100 bytes) stack. Or did you have another idea here which I
missed?

Kay
