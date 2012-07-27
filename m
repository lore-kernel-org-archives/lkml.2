Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab2G0BbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 21:31:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38898 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2G0BbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 21:31:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120726174617.GA9161@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-9-git-send-email-ming.lei@canonical.com>
	<20120725160425.GK11152@aftab.osrc.amd.com>
	<CACVXFVO5HHFraBXsV2S_a_KUrBg3ffyO0qqaGCjzq8Rksr9KaA@mail.gmail.com>
	<20120726122016.GD30717@aftab.osrc.amd.com>
	<CACVXFVMxUKezcR5BBv6jM0wZr8UivF7dJGe1gLNiFx=1h4U59g@mail.gmail.com>
	<20120726174617.GA9161@aftab.osrc.amd.com>
Date: Fri, 27 Jul 2012 09:30:57 +0800
Message-ID: <CACVXFVOrQg56VKv22i3ydm5Vw6o=UTzDJP6-_NUiyXbD46wNhQ@mail.gmail.com>
Subject: Re: [RFC PATCH 08/13] driver core: firmware loader: fix device lifetime
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 1:46 AM, Borislav Petkov <bp@amd64.org> wrote:
> On Thu, Jul 26, 2012 at 11:44:48PM +0800, Ming Lei wrote:
>> On Thu, Jul 26, 2012 at 8:20 PM, Borislav Petkov <bp@amd64.org> wrote:
>> >
>> > Ok, here's what I got from looking at the patch:
>> >
>> > Your commit message says: "Also request_firmware_nowait should be called
>> > in atomic context now, so fix the obsolete comments."
>> >
>> > Atomic context in my book means you're not allowed to sleep at all.
>>
>> In fact, I mean the function can be called in atomic context now, and
>> I know some time ago the function will create kthread to execute
>> the request_firmware, and atomic context is not allowed.
>
> Right, but when called with GFP_KERNEL mask, it can sleep, right?

>
>> > But the comment says that it is possible to sleep a little. This is very
>> > wrongly formulated AFAICT.
>>
>> The function can be run in both contexts, and I don't see any words which
>> says the function will sleep.
>
> "
> ...
>  *      Asynchronous variant of request_firmware() for user contexts where
>  *      it is not possible to sleep for long time.
>  **/
> "
>
> Not possible to sleep for a long time means the function still *can*
> sleep... even for short time. For a certain definion of "short."

In fact, many drivers like to use it in its probe() because too long sleep
in probe will slow down kernel boot if driver is built in kernel. During
kernel boot, rootfs is not mounted and user space is not ready, request_firmware
will timeout to cause problem.

Also after introducing work in this function, it is allowed to be called in
atomic context if 'gfp' is passed as GFP_ATOMIC, so I removed the obsolete
comments.

>
>> > But, since request_firmware_nowait receives a GFP mask as one of its
>> > arguments and some of its callers don't supply GFP_ATOMIC then this
>> > has nothing to do with atomic contexts at all. Then, you should simply
>> > explain in the comment why exactly callers aren't allowed to be sleeping
>> > for a long time. And using adjectives like "long" or "short" is very
>> > misleading in such explanations so please be more specific as to why the
>>
>> It is the original one, and I don't think it is wrong. Also it
>> shouldn't be covered
>> by this patch.
>>
>> Maybe I shouldn't have fixed the comment in this patch.
>
> Why, simply fix the comment to adhere to what the function does. And
> since it can sleep, maybe the easiest fix is to say simply that:
> "function can sleep", right?

No, the comment above is misleading and not useless, and I think the below
is good:

 *      Asynchronous variant of request_firmware() for user contexts where
 *      it is not possible to sleep for long time or can't sleep at all, depends
 *      on the @gfp flag passed.

Anyway, the original part of 'It can't be called in atomic contexts.' is wrong
and should be removed.


Thanks,
--
Ming Lei
