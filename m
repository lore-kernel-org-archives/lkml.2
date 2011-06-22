Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab1FVU7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:59:44 -0400
Received: from claw.goop.org ([74.207.240.146]:50188 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758550Ab1FVU7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:59:43 -0400
Message-ID: <4E0257BC.9050509@goop.org>
Date: Wed, 22 Jun 2011 13:59:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate
 code
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <1308664868.26237.173.camel@twins> <4E0240AC.9060603@goop.org> <4E024E5B.7090103@zytor.com>
In-Reply-To: <4E024E5B.7090103@zytor.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 01:19 PM, H. Peter Anvin wrote:
> On 06/22/2011 12:21 PM, Jeremy Fitzhardinge wrote:
>> A friend just pointed out that gcc has a "__sync_fetch_and_add()"
>> intrinsic, which compiles to xadd when used in this context.  What's the
>> general feeling about using these kinds of gcc features?
>>
> In general they are good, IF:
>
> a) they cover all versions of gcc we care about (or we have a fallback),

What is the supported range for these days?

> and
> b) they have the right semantics.

My main concern was making sure that its a strong enough barrier, but
the documentation is pretty explicit about that.

> Using gcc intrinsics can generate better code than we can in inline
> assembly.

It does seem to do a pretty good job; it generates a plain locked add if
you never look at the returned value, for example.

> However, (b) is a killer since gcc doesn't have a way to generate our
> lock prefix annotations, and so it isn't really useful here.

Yeah, I thought about that.  Its a bit unfortunate we're getting into
spinlock code at all on a UP system, but we don't have a mechanism to
stomp locking at a higher level.  (Ignoring all the insane stuff that
happens when the system becomes UP transiently just because all the
other CPUs have been unplugged for suspend, etc; we just shouldn't
bother in that case.)

    J
