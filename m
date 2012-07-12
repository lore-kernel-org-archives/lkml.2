Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161391Ab2GLRLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:11:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35693 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab2GLRLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:11:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120712140552.GA13745@redhat.com>
References: <20120709180328.GA4105@redhat.com> <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
 <1341859731.801.0.camel@mop> <20120712005405.GA1613@redhat.com>
 <CAPXgP13J98an3GW1-aBOEk=5Vyr+is1DaPhz-UFWHBOJ2nHkKA@mail.gmail.com> <20120712140552.GA13745@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Jul 2012 10:11:22 -0700
X-Google-Sender-Auth: AI4gSlhHE3XGQO3V74lgOY1e4Gk
Message-ID: <CA+55aFyue0ivxx541BSfL1kkL76KZjwPdGc7=6OXcnArKGyxMw@mail.gmail.com>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
To: Dave Jones <davej@redhat.com>, Kay Sievers <kay@vrfy.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 7:05 AM, Dave Jones <davej@redhat.com> wrote:
>
> I've seen it a few times, always with the soft lockup trace.

I bet it's because you have tons of modules, and the line ends up
being *really* long. And overflows LOG_LINE_MAX. I suspect something
odd happens.

There are tons of odd special cases for LOG_LINE_MAX, and I bet Kay
doesn't see it for the simple reason that he's not totally insane, and
hasn't loaded hundreds of modules.

Kay, I suspect the "continuation line" logic could easily have a rule like

  "If the old line is already > 80 characters, do a line break here
and add TAB to the beginning of the new line"

In fact, that could be really nice for things like stack dumps etc -
we wouldn't have to worry about line breaks and crap, if the printk
logic just makes "KERN_CONT" do a line break automatically if it
doesn't fit on the screen.

People who use KERN_CONT don't do it because they *need* things to be
on one line (it's not guaranteed anyway), they do it because they want
the output to be dense and readable. Doing auto-line-break would
actually *help*. And would mean that you never hit the odd
LOG_LINE_MAX cases just because somebody is printing lots of modules.

             Linus
