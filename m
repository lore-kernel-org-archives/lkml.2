Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab2GLS0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 14:26:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34162 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2GLS0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 14:26:02 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyue0ivxx541BSfL1kkL76KZjwPdGc7=6OXcnArKGyxMw@mail.gmail.com>
References: <20120709180328.GA4105@redhat.com> <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
 <1341859731.801.0.camel@mop> <20120712005405.GA1613@redhat.com>
 <CAPXgP13J98an3GW1-aBOEk=5Vyr+is1DaPhz-UFWHBOJ2nHkKA@mail.gmail.com>
 <20120712140552.GA13745@redhat.com> <CA+55aFyue0ivxx541BSfL1kkL76KZjwPdGc7=6OXcnArKGyxMw@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 12 Jul 2012 20:25:41 +0200
Message-ID: <CAPXgP12USC2LETFz2gy8yubMQbrNA6ou_hByH+UqHdo6-hfkGQ@mail.gmail.com>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 7:11 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jul 12, 2012 at 7:05 AM, Dave Jones <davej@redhat.com> wrote:
>>
>> I've seen it a few times, always with the soft lockup trace.
>
> I bet it's because you have tons of modules, and the line ends up
> being *really* long. And overflows LOG_LINE_MAX. I suspect something
> odd happens.

Straight to the point. That's the issue, combined with the later
safety range checks, we produce somehow "ugly" output.

We already flush the line out of the buffer when we can not add stuff
anymore. The line length is then close to LOG_LINE_MAX, and we want to
add a prefix with the timestamp during output and we reach the limit
of LOG_LINE_MAX.

> There are tons of odd special cases for LOG_LINE_MAX, and I bet Kay
> doesn't see it for the simple reason that he's not totally insane, and
> hasn't loaded hundreds of modules.

Yeah, I just added a loop now that prints over-long continuation
lines, and I can see parts of the effect Dave sees.

> Kay, I suspect the "continuation line" logic could easily have a rule like
>
>   "If the old line is already > 80 characters, do a line break here
> and add TAB to the beginning of the new line"
>
> In fact, that could be really nice for things like stack dumps etc -
> we wouldn't have to worry about line breaks and crap, if the printk
> logic just makes "KERN_CONT" do a line break automatically if it
> doesn't fit on the screen.
>
> People who use KERN_CONT don't do it because they *need* things to be
> on one line (it's not guaranteed anyway), they do it because they want
> the output to be dense and readable. Doing auto-line-break would
> actually *help*. And would mean that you never hit the odd
> LOG_LINE_MAX cases just because somebody is printing lots of modules.

That sounds good. I'll look into that.

Kay
