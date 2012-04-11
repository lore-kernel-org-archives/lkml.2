Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044Ab2DKTqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:46:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33418 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab2DKTqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:46:21 -0400
MIME-Version: 1.0
In-Reply-To: <4F85C96B.2070803@zytor.com>
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com>
 <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
 <4F7F1864.8090606@zytor.com> <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com>
 <4F85C640.3060608@zytor.com> <CA+55aFzT1OomhJkDx+crnqRmH-kowAM4w8SRqsmPVMyh8gEwZQ@mail.gmail.com>
 <4F85C96B.2070803@zytor.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Apr 2012 15:46:00 -0400
Message-ID: <CAHGf_=qBY1uVqWiDoOQY5UrxqK8G47+J_o=HQAbutGZNdhX5Ug@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> But it still has the same braindamage: one system call per loop
>>> invocation, and we can do better.  I would much rather see fdwalk() in SUS.
>>
>> Why would we bother to do better?
>>
>> System calls are cheap, and usually you actually do want to do
>> something about the fd, so you actually want to iterate over them.
>>
>> I'd much rather have simple cheap interfaces than anything else. If
>> SuS has a F_NEXT fcntl, let's just do that thing. Much simpler than
>> doing something more complex and then just having to emulate the
>> simple thing in user space anyway.
>>
>> If a standard interface exists, we should just use it.
>>
>
> I went back and looked at the post, and also the discussion on the SUS
> mailing list.
>
> The proposal for FD_NEXT was rejected with some serious vitriol.
>
> fdwalk() was considered just more palatable since there is an existing
> implementation (in Solaris) and since it might be possible to provide a
> way to hide specific fds from fdwalk(), but a much bigger issue raised
> is that *ALL* of these interfaces are inherently broken.  Closing random
> file descriptors is:
>
> a) inherently racy in a multithreaded environment;

I would say two things. 1) I know and I agree we _can_ misuse the interface.
but many already existed interface also can be misused. 2) As I
already explained
this can be used correctly.

So, I have a question. Why do you bother a possibility of misuse? Of
if you didn't point
out misuse, can you please point out a real world use case of multi
threads + fd interation?


> b) unsafe because there might be file descriptors used by libc itself.

I agree this. Even though almost developer don't use libc message catalogue and
we can avoid such issue by using nextfd() + fcntl(O_CLOEXEC).


> Instead, from the resolution text:
>
>> Therefore, the rest of this proposal seeks to document the problem
>> with closing arbitrary file descriptors, and a new bugid will be
>> opened to propose standardizing some recent interfaces and interface
>> extensions first appearing in Linux (new interfaces such as pipe2( ),
>> accept4( ), mkostemps( ), ..., and extensions like fopen(,"we")) to
>> guarantee the atomic creation of file descriptors with the cloexec
>> bit already set, as was already done in the standard with O_CLOEXEC
>> in open( ) and F_DUPFD_CLOEXEC in fcntl( ). See also 0000368 for
>> a related proposal to require CLOEXEC on hidden descriptors.
>
> I say we ask the new glibc people to provide fdwalk() since it already
> has an implementation history (and because it can be implemented without
> new system calls, thereby working on old kernels), but the *big*
> takeaway from this is that if there is way to create a file descriptor
> so that it doesn't have O_CLOEXEC set from the very beginning, *that* is
> what we need to fix.

Yeah, I don't think fdwalk() is problematic. It's an option if I
understand Alexey's mail
correctly. but I disagree almost all developers should fix a design
and rewrite their
applications. In theory, they can avoid glibc or they can rewrite all
of their code or
avoid linux. but there is one problem. unrealistic.
