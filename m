Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2ARIBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 03:01:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54123 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2ARIBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 03:01:09 -0500
Date: Wed, 18 Jan 2012 12:01:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
Message-ID: <20120118080103.GA2889@moon>
References: <20120117142759.GE16213@moon>
 <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com>
 <20120117144452.GG16213@moon>
 <4F15C249.3000602@zytor.com>
 <m1obu29fnf.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1obu29fnf.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 01:35:00PM -0800, Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
> > On 01/17/2012 06:44 AM, Cyrill Gorcunov wrote:
> >> On Tue, Jan 17, 2012 at 04:38:14PM +0200, Alexey Dobriyan wrote:
> >>> On 1/17/12, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> >>>> +#define KCMP_EQ		0
> >>>> +#define KCMP_LT		1
> >>>> +#define KCMP_GT		2
> >>>
> >>> LT and GT are meaningless.
> >>>
> >> 
> >> I found symbolic names better than open-coded values. But sure,
> >> if this is problem it could be dropped.
> >> 
> >> Or you mean that in general anything but 'equal' is useless?
> >> 
> >
> > Why on Earth would user space need to know which order in memory certain
> > kernel objects are?
> 
> For checkpoint restart and for some other kinds of introspection what is
> needed is a comparison function to see if two processes share the same
> object.  The most interesting of these objects from a checkpoint restart case
> are file descriptors, and there can be a lot of file descriptors.
> 
> The order in memory does not matter.  What does matter is that the
> comparison function return some ordering between objects.  The algorithm
> for figuring out of N items which of them are duplicates is O(N^2) if
> the comparison function can only return equal or not equal.  The
> algorithm for finding duplications is only O(NlogN) if the comparison
> function will return an ordering among the objects.
> 

Yes, thanks Eric, I missed this text in patch description, my bad. And
yes, performance will degrade with plain eq/ne approach. But as Pavel
stated in another email

 | We can compare the e.g. files' target inodes (ino + dev) and positions and
 | comparing each-to-each only for those having these pairs equal. Looking at
 | the existing large containers with tens thousands of fd-s we have this
 | gives us maximum 6 files to compare, and performing 15 syscalls for this suits
 | us for now.

> > Keep in mind that this is *exactly* the kind of information which makes
> > rootkits easier.
> 
> I would be very surprised if basic in memory ordering information was
> not already available from simple creation ordering.
> 

I think Peter means the scenario where we say have some bug in slab/slub
code which happens on say some Nth allocation and attacker somehow reveal
at least one memory address of struct file, then using such syscall an
attacker might inspect a series of fd (and associated struct file) and guess
which addresses the rest of "struct file" are. In most cases this wont help
(if a system is under more/less high load and open/close files fast enough
 'cause "struct file" comes from kmem caches) but on some non-heavy loaded
machine this might do a trick and narrow addresses (if say there only 10
fds which allocated from cache in a row and you somehow know address of
one associated struct file).

In short -- I don't know if it's indeed really serious issue or not
(since from my POV it'll require at least a couple of bugs in a row
 to happen before the attacker might use this information). OTOH, shit
happens exactly in 'impossible' scenarios ;)

> If using the in memory ordering is a problem in practice there are a lot
> of other possible ways to order the kernel objects.  Allocating sequence
> numbers for the kernel objects, passing the pointers through a
> cryptographically secure hash before comparing them, etc.
> 

We've been trying this already ;)

> It does look like Cyrill's patch description lacked the important bit of
> information about the algorithm complexity requiring an ordering among
> kernel objects.  Cyrill you probably want to describe more prominently
> what is happening now and why in your patch description rather than give
> the history of different approaches.
> 

Yeah, i'll write detailed change log, gimme some time. Thanks Eric!

Btw, extending this syscall to lt/ge variant will be easy, so this is
not a problem I think. At moment we guarantee to return 0/1 on succes,
and < 0 on error, so if we start returing 2/3 in a sake of ordering
the applications which were using only 0/1 values wont crash (if they
are not crappy written ones).

	Cyrill
