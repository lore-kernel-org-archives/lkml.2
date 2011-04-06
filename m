Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab1DFUtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:49:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41748 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab1DFUtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=wuhnU6GMi3IR0x9+4K6npVBENgMI8Mj2xtucrrDnJ6YdSUUBJ1SCpQarn9WSpE1tsy
         CmTzBkZ0GhbqDa9ALhpqebJxGdw/a4M5uxw+HocAFNz3aVynaJLI9jobs2mCw9OKbetq
         appfrJAtUh62kBfnA7WOjHL791oxfyKCx29HM=
MIME-Version: 1.0
In-Reply-To: <20110406201442.GV21838@one.firstfloor.org>
References: <cover.1301324270.git.luto@mit.edu> <m2mxk35ji7.fsf@firstfloor.org>
 <BANLkTi=g96=Q_OOBeejcsZ1eWGZ9cZYLYA@mail.gmail.com> <20110406201442.GV21838@one.firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 6 Apr 2011 16:49:00 -0400
X-Google-Sender-Auth: AAMuJzQ8um5atbRL2M6tJH17YiI
Message-ID: <BANLkTimfS1R0NYwuhDVsMvDJBWmnSU27aA@mail.gmail.com>
Subject: Re: [PATCH 0/6] x86-64: Micro-optimize vclock_gettime
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 4:14 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Apr 06, 2011 at 04:10:22PM -0400, Andrew Lutomirski wrote:
>> I ran Ingo's time-warp-test w/ 6, 7, and 8 threads on Sandy Bridge and
>> on a Xeon 5600 series chip.  My C2D laptop thinks that its TSC halts
>> in idle and my only AMD system has unsynchronized TSCs.
>
> I think you should have coverage on more systems. The original
> problems that motivated the barriers were on older K8 AMD systems.
>
> You can ask people on l-k to run such tests for you if you don't
> have the hardware.

Will do, once v2 is ready.

>
>> > I did a similar attempt recently for the in kernel timers.
>> > You won't see any difference in a micro benchmark loop, but you may
>> > in a workload that dirties lots of cache between timer calls.
>>
>> For CLOCK_REALTIME they're already in one cache line.  I tried the
>> prefetch and couldn't measure a speedup even after playing with
>
> Did you run a cache pig between the calls? With a tight loop it's obviously
> useless.

No, but I clflushed the cache line with vsyscall_gtod_data in it.  I
think the result was just too noisy.

>
>> Agreed.  In fact, I could do both in one fell swoop: have a flag for
>> the mode and have one option be "just issue the syscall."  Static
>> branch stuff scares me because this stuff runs in userspace and, in
>> theory, userspace might have COWed the page with this code in it.
>
> The vdso is never cowed.

This program successfully gets SIGTRAP.  I assume COW is involved.

#include <dlfcn.h>
#include <stdio.h>
#include <sys/mman.h>
#include <time.h>

int main()
{
  volatile char *vclock_gettime;
  struct timespec t;

  void *vdso = dlopen("linux-vdso.so.1", RTLD_NOW | RTLD_NOLOAD);
  if (!vdso) {
    fprintf(stderr, "dlopen: %s\n", dlerror());
    return 1;
  }
  vclock_gettime = dlsym(vdso, "clock_gettime");
  if (!vclock_gettime) {
    fprintf(stderr, "dlsym: %s\n", dlerror());
    return 1;
  }

  if (mprotect((void*)((unsigned long)vclock_gettime & ~0xFFFUL),
	       4096, PROT_READ | PROT_WRITE | PROT_EXEC) != 0) {
    perror("mprotect");
    return 1;
  }

  *vclock_gettime = 0xcc;  /* breakpoint */
  clock_gettime(CLOCK_MONOTONIC, &t);

  return 0;
}

--Andy
