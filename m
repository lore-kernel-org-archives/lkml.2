Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1KGVfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:35:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45979 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1KGVfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:35:24 -0500
Message-ID: <4EB84F05.1000704@zytor.com>
Date: Mon, 07 Nov 2011 13:35:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Vasiliy Kulikov <segoon@openwall.com>, Eric Paris <eparis@parisplace.org>,
        kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
References: <20111107174522.GA2317@albatros> <9718.1320689192@turing-police.cc.vt.edu> <20111107190112.GA3732@albatros> <4EB82F08.8060209@zytor.com> <20111107192915.GA4690@albatros> <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com> <4EB83674.3040207@zytor.com> <20111107201120.GA5775@albatros> <4EB843FF.5080201@zytor.com> <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
In-Reply-To: <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 01:23 PM, Linus Torvalds wrote:
> On Mon, Nov 7, 2011 at 12:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> You didn't really get my point.  There are global nodes which are
>> dynamic, and more importantly the *set* changes across the system life.
>>  A global policy option is a lot easier to deal with for the vast
>> majority of users who don't need fine grain control.
> 
> I want *one* global policy that the kernel would actually know about:
> is the user physically at the machine right now.
> 
> Sadly, I don't think the kernel has any good way to figure that out
> automatically.
> 
> Because quite frankly, a lot of the /proc files should be "root or
> desktop user". If you control the hardware, you should damn well be
> able to see the interrupt counts in order to do bug reports etc
> without having to 'sudo' or similar.
> 
> I realize that pam & co could give us this info, or we could just add
> a new capability flag, but I think this is something where the kernel
> really could just do the RightThing(tm) automatically, and screw the
> crazy login managers, odd policies (I really don't believe that adding
> magic selinux rules actually improves security all that much, because
> it's too painful and too hard to know for any normal user).
> 
> The person in front of the hardware really *is* fundamentally special.
> 
> Right now all the distros do magic things with the audio device
> because they know the person in front of the machine is special. But
> all those things are ad-hoc per device, and never cover things like
> random /proc files etc.
> 

I was going to say "let's just have the login manager add a group to the
desktop user's permission set" but then I realized that this would be
really bad because of setgid files.

Which exposes a real problem with chgrp and setgid files overall.

The way setgid works effectively means that any user can become a member
of any group that they have at any time been a member of, simply by
"stashing" a copy of the group as a setgid file:

	cp /bin/sh my-saved-group
	chgrp mygroup my-saved-group
	chmod g+s my-saved-group

This is rather messy, because gids are otherwise a very nice capability
mechanism.

	-hpa
