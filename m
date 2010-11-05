Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0KEUJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 16:09:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60927 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0KEUJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 16:09:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jBcQjxlGpkFEEiWls7bL6vdTm53sP4r3tIYRwoHm0GuiyjeO4WJQHk2X048Sw0UKTK
         IfYu1pWoT+OLZX4t53Gg==
MIME-Version: 1.0
In-Reply-To: <20101105035114.GA6698@nowhere>
References: <AANLkTikCYjENib2zfz-rmAM2fZbZEzK-9jgL4D-b40xs@mail.gmail.com>
	<AANLkTikukr3d+GmWDdPB9jfwAAuMUgNwb06WXPZgRFwc@mail.gmail.com>
	<20101105035114.GA6698@nowhere>
Date: Fri, 5 Nov 2010 13:09:03 -0700
Message-ID: <AANLkTinvWzZfFtUB8bxh1EAXX43_bNDyss=xZfuGSwvW@mail.gmail.com>
Subject: Re: [RFD] Perf generic context based exclusion/inclusion (was Re:
 [PATCH 0/4] Finer granularity and task/cgroup irq time accounting)
From: Venkatesh Pallipadi <venki@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 4, 2010 at 8:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Nov 04, 2010 at 12:46:42PM -0700, Venkatesh Pallipadi wrote:
>> On Thu, Nov 4, 2010 at 8:40 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
<snip>
>
>
>> - This may be a bit odd and probably there is some other way of doing
>> this better. But, one other context we may want to track is the sleep
>> or wait at certain points. What I am thinking is something like how
>> long are we waiting on this kmalloc when we are holding this mutex
>> kind of info. May be it is best to do this as having sleep in kmalloc
>> as a context.
>
>
>
> If I understand you well, you want to define a context made of a
> sleeping time?
>
> The problem is that it means defining an empty context:
> nothing happens in task X while it is sleeping (by definition), so
> capturing any events, or counting whatever counter in this slice
> would never report anything.
>
> OTOH you can capture trace events and get the time between a
> sleep and a wake up event, then you can compute the difference
> from a post processing script in perf tools.
>

Agree. Sleeping context won't work in general. I was just thinking
aloud on whether there is a way to tie up sleep trace event with a pid
and mutex being held, so that something like "how long did this thread
wait in this kmalloc while being in some critical section" can be
captured. So, post processing trace events is a better option here.

Thanks,
Venki

>> - Few other examples of this being useful is to count events only when
>> these two or more locks are held together or how long we were waiting
>> on one spinlock while we are holding one spinlock.
>
>
> Agreed. For that you can combine two levels of contexts, let's say you want
> to count instructions when we hold lock Y when we also hold lock X
> (the lock dependency order beeing X -> Y), but you don't want to count
> when you hold Y without X:
>
> - create two perf events: lock_acquire and lock_release, apply filter on lock name X
> - create two perf events: lock_acquire and lock_release, apply filter on lock name Y
> - apply the first pair of lock events as an inclusive context for the second pair
>  (which means the second pair must only count/sample on the context delimited by the
>  first pair)
> - create a perf event that count instructions, apply the second above pair as an
>  inclusive context.
>
>
>
