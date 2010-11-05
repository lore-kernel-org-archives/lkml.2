Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab0KEWW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 18:22:26 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:59839 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab0KEWWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 18:22:24 -0400
Message-ID: <4CD4842A.5050009@cs.columbia.edu>
Date: Fri, 05 Nov 2010 18:24:42 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Gene Cooperman <gene@ccs.neu.edu>,
        hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org>
In-Reply-To: <4CD26948.7050009@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/04/2010 04:05 AM, Tejun Heo wrote:
> Hello,
>
> On 11/04/2010 04:40 AM, Kapil Arya wrote:
>> (Sorry for resending the message; the last message contained some html
>> tags and was rejected by server)
>
> And please also don't top-post.  Being the antisocial egomaniacs we
> are, people on lkml prefer to dissect the messages we're replying to,
> insert insulting comments right where they would be most effective and
> remove the passages which can't yield effective insults.  :-)
>
>> In our personal view, a key difference between in-kernel and userland
>> approaches is the issue of security.  The Linux C/R developers state
>> the issue very well in their FAQ (question number 7):
>>> https://ckpt.wiki.kernel.org/index.php/Faq :
>>> 7. Can non-root users checkpoint/restart an application ?
>>>
>>> For now, only users with CAP_SYSADMIN privileges can C/R an
>>> application. This is to ensure that the checkpoint image has not been
>>> tampered with and will be treated like a loadable kernel-module.
>
> That's an interesting point but I don't think it's a dealbreaker.
> Kernel CR is gonna require userland agent anyway and access control
> can be done there.

Indeed, this is a restriction on the new eclone() syscall, and can
be addressed with proper userspace tools (including crypo-sign the
checkpoint image). There core of the c/r code allows a user to
restore anything within the user's privilege level.

> Being able to snapshot w/o root privieldge
> definitely is a plust but it's not like CR is gonna be deployed on
> majority of desktops and servers (if so, let's talk about it then).

Why not ?  it has zero overhead when not in use, and a reasonable
code footprint (which can be reduced by modularizing some of it,
but that's outside the point).

>> Strategies like these are easily handled in userspace.  We suspect
>> that while one may begin with a pure kernel approach, eventually,
>> one will still want to add a userland component to achieve this kind
>> of flexibility, just as BLCR has already done.
>
> Yeap, agreed.  There gotta be user agents which can monitor and
> manipulate userland states.  It's a fundamentally nasty job, that of

Are we talking about distributed checkpoint or "standalone" ?

DMTCP relies on user agents to allow distributed/remote execution
in a manner mostly transparent to the application. Many distributed
systems don't require (and do not use) user agents. Consider a
multi-tier system with web server, sql server and some applications
server. These are not suitable to DMTCP's mode or work.

(This is not to say DMTCP isn't useful - it's a clever piece of
software with specific goals and more geared towards HPC needs).

Now regarding "standalone" c/r, if you want to save/restore single
or a subset of processes of a system without the rest of it, then
you will always need user agents, regardless of userspace/kernel
method. Likewise, their work on those tools will be as useful
independently of which c/r 'engine' it uses.

When you include all the relevant processes (e.g. an entire VNC
session, a web server, HPC and batch jobs), you generally don't
need the user agents. The checkpoint is self-contained, and linux-cr
can provide you that guarantee at checkpoint time.

> collecting and applying application-specific workarounds.  I've only
> glanced the dmtcp paper so my understanding is pretty superficial.
> With that in mind, can you please answer some of my curiosities?
>
> * As Oren pointed out in another message, there are somethings which
>   could seem a bit too visible to the target application.  Like the
>   manager thread (is it visible to the application or is it hidden by
>   the libc wrapper?) and reserved signal.  Also, while it's true that
>   all programs should be ready to handle -EINTR failure from system
>   calls, it's something which is very difficult to verify and test and
>   could lead to once-in-a-blue-moon head scratchy kind of failures.

If there is a will, there is (almost always) a way ;)

What MTCP does, IIUC, is wrap around the applications with a complete
pid-namespace (and more) in userspace. There are/were also commercial
products that do that. It's a tremendous effort and I'm impressed by
their (MTCP) work so far.

It is important to understand that it has a price tag: performance
and complexity. It's usually useful for HPC needs, but unsuitable
for the generic server/VPS space.

>
>   I think most of those issues can be tackled with minor narrow-scoped
>   changes to the kernel.  Do you guys have things on mind which the
>   kernel can do to make these things more transparent or safer?

Hmmm... the kernel already does much of it - for instance, we have
neat pid-namespace infrastructure; does it make sense to go into
the trouble of adding interfaces to provide for pid-virtalization
in userspace ?  we should be past that ...

Moreover, your objection was based on the apparent complexity of
a badly presented aggregate diff (and I disagree: most of that
are simple refactoring and cleanups). However, that very set of
"narrow-scoped changes" to the kernel that you suggest, will take
life in the form of kernel patches that will do more than these
and will achieve less.

> * The feats dmtcp achieves with its set of workarounds are impressive
>   but at the same time look quite hairy.  Christoph said that having a
>   standard userland C-R implementation would be quite useful and IMHO
>   it would be helpful in that direction if the implementation is
>   modularized enough so that the core functionality and the set of
>   workarounds can be easily separated.  Is it already so?

 From what I understand, the 'wrapper' functionality to support
distributed operation is said to be well modularized from the
actual c/r engine - which will allow it to use better c/r engines;
and coincidentally, I have one in mind... ;)

Oren.
