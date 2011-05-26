Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab1EZSVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758298Ab1EZSVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:21:49 -0400
Message-ID: <4DDE99F6.4030804@redhat.com>
Date: Thu, 26 May 2011 21:20:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
References: <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org> <20110526082451.GB26775@elte.hu> <4DDE1419.3000708@redhat.com> <20110526093040.GB19536@elte.hu> <4DDE31D6.4070209@redhat.com> <20110526113842.GA27618@elte.hu> <4DDE96B7.8030006@redhat.com> <20110526181554.GB3572@elte.hu>
In-Reply-To: <20110526181554.GB3572@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 09:15 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
> >  On 05/26/2011 02:38 PM, Ingo Molnar wrote:
> >  >* Avi Kivity<avi@redhat.com>   wrote:
> >  >
> >  >>   >   The biggest amount of RAM is the guest RAM image - but if that is
> >  >>   >   mmap(SHARED) and mapped using hugepages then the pte overhead
> >  >>   >   from a process model is largely mitigated.
> >  >>
> >  >>   That doesn't work with memory hotplug.
> >  >
> >  >  Why not, if we do the sensible thing and restrict the size
> >  >  granularity and alignment of plugged/unplugged memory regions to
> >  >  2MB?
> >
> >  Once forked, you cannot have new shared anonymous memory, can you?
>
> We can have named shared memory.

But then the benefit of transparent huge pages goes away.

Of course, if some is working on extending transparent hugepages, the 
problem is solved.  I know there is interest in this.

> Incidentally i suggested this to Pekka just yesterday: i think we
> should consider guest RAM images to be named files on the local
> filesystem (prefixed with the disk image's name or so, for easy
> identification), this will help with debugging and with swapping as
> well. (This way guest RAM wont eat up regular anonymous swap space -
> it will be swapped to the filesystem.)

Qemu supports this via -mem-path.  The motivation was supporting 
hugetlbfs, before THP.  I can't say it was useful for debugging (but 
then qemu has a built in memory inspector and debugger, and supports 
attaching gdb to the guest).

> As a sidenote, live migration might also become possible this way: in
> theory we could freeze a guest to its RAM image - which can then be
> copied (together with the disk image) to another box as files and
> restarted there, with some some hw configuration state dumped to a
> header portion of that RAM image as well. (outside of the RAM area)

Live migration involves the guest running in parallel with its memory 
being copied over.  Even a 1GB guest will take 10s over 1GbE; any 
reasonably sized guest will take forever.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

