Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2EINvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:51:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34760 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751398Ab2EINvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:51:04 -0400
Message-ID: <1336571457.30189.29.camel@joe2Laptop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 09 May 2012 06:50:57 -0700
In-Reply-To: <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
References: <1336004953.4240.9.camel@mop>
	 <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
	 <1336475689.1179.12.camel@mop>
	 <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
	 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 11:38 +0200, Kay Sievers wrote:
> On Wed, May 9, 2012 at 5:52 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Tue, May 8, 2012 at 4:14 AM, Kay Sievers <kay@vrfy.org> wrote:
> >>
> >> Yeah, we need to make sure, we never merge the (always racy)
> >> continuation printk() users with (non-racy) non-continuation users.
> >> Therefore KERN_CONT is required to suppress the newline and to merge the
> >> content with the earlier non-newline-terminated printk() line.
> >
> > Why?
> 
> The idea was: Prefixes are not used that often, but not using a prefix
> should not expose the user to wrongly get appended to an earlier
> non-terminated line of another thread.
> 
> The point was to limit the "risk" of wrong merges to users of
> continuation, and not to users which send ordinary "atomic" lines.

I think your premise is wrong for a couple of reasons.

1: printk content is not guaranteed to be stable.

   printk content should not be guaranteed to be stable.
   It'd make it difficult to simply add a new message
   or extend or correct an existing one.

2: There are _thousands_ of printks without prefix levels.

   KERN_CONT was always kind of a half-stupid idea.
   It's only real purpose is to designate message
   continuations but it never gave enough information to
   correctly coalesce the messages.

I think you need to give up on the idea that printk
output can be made to be machine readable.

If you really want to have users get complete and
not-interleaved messages you need to buffer partial
messages,  Whether or not printk message coalescing
needs to have a cookie or can be done well enough by
using call tree information as suggested by Andrew
Morton is tbd.

Changing printk semantics and trying to stabilize
printk message content are bad ideas though.

I think printk_emit is an OK idea.  Having a
per-subsystem notification mechanism, something
like an expanded ethtool is certainly useful.

Making the new additional content of printk_emit
discoverable would be useful.

Converting log_buf from circular to record oriented
and adding another binary header/descriptor to it
is a good idea too.

cheers, Joe

