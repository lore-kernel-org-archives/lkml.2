Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850Ab2DKSMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:12:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59523 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2DKSMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:12:03 -0400
Message-ID: <4F85C96B.2070803@zytor.com>
Date: Wed, 11 Apr 2012 11:11:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com> <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com> <4F7F1864.8090606@zytor.com> <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com> <4F85C640.3060608@zytor.com> <CA+55aFzT1OomhJkDx+crnqRmH-kowAM4w8SRqsmPVMyh8gEwZQ@mail.gmail.com>
In-Reply-To: <CA+55aFzT1OomhJkDx+crnqRmH-kowAM4w8SRqsmPVMyh8gEwZQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 11:04 AM, Linus Torvalds wrote:
> On Wed, Apr 11, 2012 at 10:58 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> But it still has the same braindamage: one system call per loop
>> invocation, and we can do better.  I would much rather see fdwalk() in SUS.
> 
> Why would we bother to do better?
> 
> System calls are cheap, and usually you actually do want to do
> something about the fd, so you actually want to iterate over them.
> 
> I'd much rather have simple cheap interfaces than anything else. If
> SuS has a F_NEXT fcntl, let's just do that thing. Much simpler than
> doing something more complex and then just having to emulate the
> simple thing in user space anyway.
> 
> If a standard interface exists, we should just use it.
> 

I went back and looked at the post, and also the discussion on the SUS
mailing list.

The proposal for FD_NEXT was rejected with some serious vitriol.

fdwalk() was considered just more palatable since there is an existing
implementation (in Solaris) and since it might be possible to provide a
way to hide specific fds from fdwalk(), but a much bigger issue raised
is that *ALL* of these interfaces are inherently broken.  Closing random
file descriptors is:

a) inherently racy in a multithreaded environment;
b) unsafe because there might be file descriptors used by libc itself.

Instead, from the resolution text:

> Therefore, the rest of this proposal seeks to document the problem
> with closing arbitrary file descriptors, and a new bugid will be
> opened to propose standardizing some recent interfaces and interface
> extensions first appearing in Linux (new interfaces such as pipe2( ),
> accept4( ), mkostemps( ), ..., and extensions like fopen(,"we")) to
> guarantee the atomic creation of file descriptors with the cloexec
> bit already set, as was already done in the standard with O_CLOEXEC
> in open( ) and F_DUPFD_CLOEXEC in fcntl( ). See also 0000368 for
> a related proposal to require CLOEXEC on hidden descriptors.

I say we ask the new glibc people to provide fdwalk() since it already
has an implementation history (and because it can be implemented without
new system calls, thereby working on old kernels), but the *big*
takeaway from this is that if there is way to create a file descriptor
so that it doesn't have O_CLOEXEC set from the very beginning, *that* is
what we need to fix.

	-hpa
