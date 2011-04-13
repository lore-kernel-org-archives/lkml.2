Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab1DMVLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:11:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56475 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab1DMVLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=sJCq4lQw4vc9J92b+gus8hztmSj5XohPzx/+cyos8SauRqub7uWwHsqA8ndG/VOtxo
         KTdm3JCLgoHPy3E3KjaZBhGonNSGhzwGlCYB/6tZjnCENEggS/nLox6Fmja9YBZX1Wg9
         kUAGzs9PPvndi025sMxth7d/9UWgkjderbMA8=
MIME-Version: 1.0
In-Reply-To: <20110413210546.GC16830@elf.ucw.cz>
References: <BANLkTi=F-C-vwX4PGGfbkdTBw3OWL-twfg@mail.gmail.com>
 <201104132258.17705.rjw@sisk.pl> <BANLkTiknfeTj6GD0t-ekMoaS1QYQBVyBjQ@mail.gmail.com>
 <20110413210546.GC16830@elf.ucw.cz>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 13 Apr 2011 17:11:10 -0400
X-Google-Sender-Auth: aY-bqq-vXIUafsFbOHXdRG9HpqA
Message-ID: <BANLkTinj3y+-VhzFAPz8Gzb5vAbtUFU6Aw@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] freezer: should barriers be smp ?
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 17:05, Pavel Machek wrote:
> On Wed 2011-04-13 17:02:45, Mike Frysinger wrote:
>> On Wed, Apr 13, 2011 at 16:58, Rafael J. Wysocki wrote:
>> > On Wednesday, April 13, 2011, Mike Frysinger wrote:
>> >> when we suspend/resume Blackfin SMP systems, we notice that the
>> >> freezer code runs on multiple cores.  this is of course what you want
>> >> -- freeze processes in parallel.  however, the code only uses non-smp
>> >> based barriers which causes us problems ... our cores need software
>> >> support to keep caches in sync, so our smp barriers do just that.  but
>> >> the non-smp barriers do not, and so the frozen/thawed processes
>> >> randomly get stuck in the wrong task state.
>> >>
>> >> thinking about it, shouldnt the freezer code be using smp barriers ?
>> >
>> > Yes, it should, but rmb() and wmb() are supposed to be SMP barriers.
>> >
>> > Or do you mean something different?
>>
>> then what's the diff between smp_rmb() and rmb() ?
>>
>> this is what i'm proposing:
>> --- a/kernel/freezer.c
>> +++ b/kernel/freezer.c
>> @@ -17,7 +17,7 @@ static inline void frozen_process(void)
>>  {
>>     if (!unlikely(current->flags & PF_NOFREEZE)) {
>>         current->flags |= PF_FROZEN;
>> -       wmb();
>> +       smp_wmb();
>>     }
>>     clear_freeze_flag(current);
>>  }
>> @@ -93,7 +93,7 @@ bool freeze_task(struct task_struct *p, bool sig_only)
>>      * the task as frozen and next clears its TIF_FREEZE.
>>      */
>>     if (!freezing(p)) {
>> -       rmb();
>> +       smp_rmb();
>>         if (frozen(p))
>>             return false;
>
> smp_rmb() is NOP on uniprocessor.
>
> I believe the code is correct as is.

that isnt what the code / documentation says.  unless i'm reading them
wrong, both seem to indicate that the proposed patch is what we
actually want.

include/linux/compiler-gcc.h:
#define barrier() __asm__ __volatile__("": : :"memory")

include/asm-generic/system.h:
#define mb()    asm volatile ("": : :"memory")
#define rmb()   mb()
#define wmb()   asm volatile ("": : :"memory")

#ifdef CONFIG_SMP
#define smp_mb()    mb()
#define smp_rmb()   rmb()
#define smp_wmb()   wmb()
#else
#define smp_mb()    barrier()
#define smp_rmb()   barrier()
#define smp_wmb()   barrier()
#endif

Documentation/memory-barriers.txt:
SMP memory barriers are reduced to compiler barriers on uniprocessor compiled
systems because it is assumed that a CPU will appear to be self-consistent,
and will order overlapping accesses correctly with respect to itself.

[!] Note that SMP memory barriers _must_ be used to control the ordering of
references to shared memory on SMP systems, though the use of locking instead
is sufficient.
-mike
