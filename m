Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2IGSkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:40:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52181 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab2IGSkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:40:05 -0400
MIME-Version: 1.0
In-Reply-To: <504A3527.9070104@gmail.com>
References: <CA+55aFzJWwBPgqp_QquhncpRqLXHRh0m9hHPh94Ujzd1d7kMDQ@mail.gmail.com>
 <20120904154412.GA14321@redhat.com> <504A3527.9070104@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 7 Sep 2012 11:39:43 -0700
X-Google-Sender-Auth: 4Xa6Bfi8Rwc1WznfFe9EoEFzRCc
Message-ID: <CA+55aFwh5kUDC_5-_4_TkqnQU73sotAkOs166ag4R3Fx8VKffw@mail.gmail.com>
Subject: Re: Linux 3.6-rc4
To: Sasha Levin <levinsasha928@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al? Please look into this. I'm not entirely sure what's going on, but
lockdep complains about this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&p->alloc_lock)->rlock);
                               local_irq_disable();
                               lock(&(&new_timer->it_lock)->rlock);
                               lock(tasklist_lock);
  <Interrupt>
    lock(&(&new_timer->it_lock)->rlock);

 *** DEADLOCK ***

and it looks real. IOW, if I read that right, we have the task_lock ->
it_lock dependency through exit_itimers(), and then we have the
tasklist_lock -> task_lock dependency everywhere else. So now it_lock
-> tasklist_lock becomes a deadlock.

                  Linus

On Fri, Sep 7, 2012 at 10:55 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On 09/04/2012 05:44 PM, Dave Jones wrote:
>> On Sat, Sep 01, 2012 at 03:10:58PM -0700, Linus Torvalds wrote:
>>  > The kernel summit is over, and most people have either returned or are
>>  > returning from San Diego.
>>
>> Still seeing this, that I started seeing just before leaving for San Diego..
>>
>>       Dave
>
> I've bisected this one down to
>
>
> d35abdb28824cf74f0a106a0f9c6f3ff700a35bf is the first bad commit
> commit d35abdb28824cf74f0a106a0f9c6f3ff700a35bf
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sat Jun 30 11:55:24 2012 +0400
>
>     hold task_lock around checks in keyctl
>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>
>
> Just didn't get a response from anyone when I've mailed about it...
