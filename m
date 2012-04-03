Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab2DCPup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:50:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38927 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab2DCPuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <1333463572.26079.31.camel@joe2Laptop>
References: <1333415903.860.0.camel@mop> <1333420612.26079.6.camel@joe2Laptop>
 <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
 <1333424865.26079.9.camel@joe2Laptop> <CAPXgP13fDRZtAvV651NPqQ2TgUEtb+MX1EhKhwirAgoiNOg5tQ@mail.gmail.com>
 <1333463572.26079.31.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 3 Apr 2012 17:50:23 +0200
Message-ID: <CAPXgP133MQX2u3H6imOR4FFR4TsHYc=f_yrAJfdd2sG-8bFrmA@mail.gmail.com>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 16:32, Joe Perches <joe@perches.com> wrote:
> On Tue, 2012-04-03 at 12:30 +0200, Kay Sievers wrote:
>> On Tue, Apr 3, 2012 at 05:47, Joe Perches <joe@perches.com> wrote:
>> > I think you should do it "right" rather than add
>> > trivial markers.
>>
>> The trivial markers _are_ correct. And they really fix things as soon
>> as we start storing machine-readable records with printk(), instead of
>> blindly glueing bytes together with each printk() call, for humans to
>> puzzle with them if things go wrong.
>
> These KERN_CONT changes don't _fix_ things,
> they just make it less likely to cause problems.

They sure changes things, as you can see in the first message in this
thread. This is a real paste of output, not made up stuff.

It will matter as soon as we do not allow the next printk() to get
appended to 'left-over garbage' of the last printk() without a
trailing '\n'. We should not allow that, and the 'risk' of
interleaving and garbled messages should be limited to threads which
_both_ do continuation at the same time. The likeliness of that will
get pretty low.

We should make absolutely sure, it will never affect the thread which
does a proper single and complete line.

> Imagine two threads with printks extended with
> KERN_CONT
>
> Thread 1:                                 Thread 2:
> printk(KERN_INFO "info message: ");
>                                          printk(KERN_ERR "err message: ");
> printk(KERN_CONT "online\n");
>                                          printk(KERN_CONT "offline\n");
>
> Instead of a guarantee of "info message: online" and
> "err message: offline", buffering could still join
> the messages to "err message: online".

Yes, both threads play racy games with continuation, and that makes
them both vulnerable to interleaving. But we must make sure, that
single and complete lines are never affected by that.

I did not claim to address the problem of concurrent continuation line
writers, and this patch has absolutely nothing to do with that
problem. It _does_ fix encountered problems, and it is correct as it
is. Please do not mix other issues you bring up here into it, they
should go into a separate thread, unrelated to this patch.

> I believe the only _guaranteed_ way to correctly
> assemble these messages is to use a initiator with
> a cookie and pass that cookie to assembling printks.
>
> Something like:
>
>        cookie = multi_printk_start()
>        multi_printk(cookie, level fmt, ...);
>        ...
>        multi_printk_end(cookie);
>
> Though get_current() might be a reasonable cookie
> so perhaps the multi_ variants aren't needed.

Apart from *possibly* switching to per-cpu buffers for printk() core,
I think the callers should probably just do that on their own, maybe
just on the stack, if the message is small enough.

> git.kernel.org isn't responding right now.  I
> can't read the link you sent me privately to
> check if you are using get_current() or some
> other current_thread_info() constuct.

No, it does not change any current behaviour or gets any knowledge
about threads, it just makes sure that full and single line always
ends up in its own record instead of accepting unterminated left-overs
from earlier printk()s.

Thanks,
Kay
