Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185Ab2EIJjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:39:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50404 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149Ab2EIJi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:38:59 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 9 May 2012 11:38:38 +0200
Message-ID: <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 5:52 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, May 8, 2012 at 4:14 AM, Kay Sievers <kay@vrfy.org> wrote:
>>
>> Yeah, we need to make sure, we never merge the (always racy)
>> continuation printk() users with (non-racy) non-continuation users.
>> Therefore KERN_CONT is required to suppress the newline and to merge the
>> content with the earlier non-newline-terminated printk() line.
>
> Why?

The idea was: Prefixes are not used that often, but not using a prefix
should not expose the user to wrongly get appended to an earlier
non-terminated line of another thread.

The point was to limit the "risk" of wrong merges to users of
continuation, and not to users which send ordinary "atomic" lines.

> I really think this is just a bug in the new code.
>
> KERN_CONT should not be needed if the previous printk didn't have a final "\n".

It significantly limits wrong merges, especially for users which can
rightfully expect not to get a wrong merge.

> We made it easier to use printk for a reason a few months ago. The new
> rules are:
>
>  - If you have a KERN_<loglevel>, it *always* starts a new line, the
> obvious exception being KERN_CONT
>
>  - the loglevels *only* matter at the start of the printk - so if you
> have '\n' embedded in a single printk, that changes nothing
> what-so-ever. It's not line-based.

It is a different behaviour. "Innocent" users are not exposed to "risky" users.

>  - if you didn't have a '\n', and don't have a loglevel, KERN_CONT is implied.

But a lot of stuff which does not look for continuation, has no
prefix, hasn't it? I rather make the "I want to be appended" explicit,
instead giving the "I don't care about the log level" any meaning.

I think continuation is special, and ideally should not be much used.
We should not "optimize" for it, and not accept breakage introduced to
ordinary users that way.

> Quite frankly, those three rules (a) make sense and (b) make things easy.

It's true, it's much easier, but it's also much less reliable.

> Breaking them now is a bug. Please don't go adding ugly KERN_CONT when
> there really isn't any reason for it. Just fix the printk code you
> broke.

I can do this, I just don't think it's the right thing to do.

I surely would prefer reliability over rather weird heuristics for
special cases. Today, we should be able to trust at least
non-continuation printk users, which we can't, if we do expose them to
the very real problems of continuation.

Still not convinced? :)

Kay
