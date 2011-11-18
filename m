Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab1KRK1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:27:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab1KRK1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:27:44 -0500
Message-ID: <4EC63304.1060709@redhat.com>
Date: Fri, 18 Nov 2011 18:27:16 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Pekka Enberg <penberg@kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org, kay.sievers@vrfy.org
Subject: Re: [Patch] tmpfs: add fallocate support
References: <1321346525-10187-1-git-send-email-amwang@redhat.com> <CAOJsxLEXbWbEhqX2YfzcQhyLJrY0H2ifCJCvGkoFHZsYAZEMPA@mail.gmail.com> <4EC361C0.7040309@redhat.com> <alpine.LFD.2.02.1111160911320.2446@tux.localdomain> <4EC3633D.6090900@redhat.com> <alpine.LSU.2.00.1111161634360.1957@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1111161634360.1957@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月17日 09:31, Hugh Dickins 写道:
> On Wed, 16 Nov 2011, Cong Wang wrote:
>> 于 2011年11月16日 15:12, Pekka Enberg 写道:
>>> On Wed, 16 Nov 2011, Cong Wang wrote:
>>>>> What's the use case for this?
>>>>
>>>> Systemd needs it, see http://lkml.org/lkml/2011/10/20/275.
>>>> I am adding Kay into Cc.
>>>
>>> The post doesn't mention why it needs it, though.
>>>
>>
>> Right, I should mention this in the changelog. :-/
>
> Yes, but I think Pekka's point is that the page which you link to does not
> explain why Plumbers would want tmpfs to support fallocate() properly.
>
> What good is it going to do for them?  Why not just do it in userspace,
> either by dd if=/dev/zero of=tmpfsfile, or by mmap() and touch if very
> anxious to avoid the triple memset/memcpy (once reading from /dev/zero,
> once allocating tmpfs pages, once copying to tmpfs pages)?  Or splice().


It is not hard at all to implement this in kernel space, so this
will make systemd a little happier.

>
> I don't want to stand in the way of progress, but there's a lot of
> things tmpfs does not support (a persistent filesystem would be top
> of the list; but readahead, direct I/O, AIO, ....), and it may be
> better to continue not to support them unless there's good reason.
> tmpfs does not have a disk layout that we need to optimize.


True, and no one requests for these features so far? As systemd
developers need this light feature, fallocate, and it is not hard
to implement it, so why not? ;)

>
> I did not study your implementation in detail, but agree with Dave
> and Kame that (if it needs to be in kernel at all) you should reuse
> the existing code rather than repeating extracts: shmem_getpage_gfp()
> is the one place which looks after all of shmem page allocation, so
> I'd prefer you just make a loop of calls to that (with a new sgp_type
> if there's particular reason to do something differently in there).


Yes, while reworking on this patch, I did exactly what you said.

>
> I've not yet looked up the specification of fallocate(), but it
> looked surprising to be allocating pages up to the point where a
> page already exists (when shmem_add_to_page_cache will fail) and
> then giving up with -EEXIST.

You are right, I need to fix this.

>
> Seeing your Subject, I imagined at first that you would be implementing
> FALLOC_FL_PUNCH_HOLE support. That is on my list to do: tmpfs has its
> own peculiar madvise(MADV_REMOVE) support (and yes, you may question
> whether we were right to add that in) - we should be converting
> MADV_REMOVE to use FALLOC_FL_PUNCH_HOLE, and tmpfs to support that.
>

I will add this in my V2 patch.

Thanks!
