Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2IOM0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 08:26:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47565 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab2IOM0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 08:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <1347287780.2124.10.camel@twins>
References: <CA+55aFzJWwBPgqp_QquhncpRqLXHRh0m9hHPh94Ujzd1d7kMDQ@mail.gmail.com>
 <20120904154412.GA14321@redhat.com> <504A3527.9070104@gmail.com>
 <CA+55aFwh5kUDC_5-_4_TkqnQU73sotAkOs166ag4R3Fx8VKffw@mail.gmail.com> <1347287780.2124.10.camel@twins>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sat, 15 Sep 2012 14:25:51 +0200
Message-ID: <CA+1xoqcY5=Ru-pgSGux0rGEp8d2nOWFpqk3EW9j=Qt2N6=XECw@mail.gmail.com>
Subject: Re: Linux 3.6-rc4
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 4:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-09-07 at 11:39 -0700, Linus Torvalds wrote:
>> Al? Please look into this. I'm not entirely sure what's going on, but
>> lockdep complains about this:
>>
>>  Possible interrupt unsafe locking scenario:
>>
>>        CPU0                    CPU1
>>        ----                    ----
>>   lock(&(&p->alloc_lock)->rlock);
>>                                local_irq_disable();
>>                                lock(&(&new_timer->it_lock)->rlock);
>>                                lock(tasklist_lock);
>>   <Interrupt>
>>     lock(&(&new_timer->it_lock)->rlock);
>>
>>  *** DEADLOCK ***
>>
>> and it looks real. IOW, if I read that right, we have the task_lock ->
>> it_lock dependency through exit_itimers(), and then we have the
>> tasklist_lock -> task_lock dependency everywhere else. So now it_lock
>> -> tasklist_lock becomes a deadlock.
>
> Agreed, I've got the following series from Oleg queued to solve this:
>
>  http://marc.info/?l=linux-kernel&m=134600821828491&w=2

I'm still seeing lockdep warnings even with the code above applied.
