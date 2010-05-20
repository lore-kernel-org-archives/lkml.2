Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab0ETWda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:33:30 -0400
Received: from smtp-out.google.com ([74.125.121.35]:42429 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab0ETWd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:33:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=U3eNmT81t39XtPjZyh4zPqUHAdF0cBpO2hnBfT2wSdLTbnCPoN4MNLrXyC409hbcF
	sh2EaHBksUL0xTDzVdDFQ==
MIME-Version: 1.0
In-Reply-To: <5592.1274271931@redhat.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
	 <1274135154-24082-4-git-send-email-walken@google.com>
	 <5592.1274271931@redhat.com>
Date: Thu, 20 May 2010 15:33:24 -0700
Message-ID: <AANLkTimmqYpeIrb9N60gk6LgAfeGjv_65Ikb1yfdxeE8@mail.gmail.com>
Subject: Re: [PATCH 03/10] rwsem: lighter active count checks when waking up 
	readers
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 5:25 AM, David Howells <dhowells@redhat.com> wrote:
> Michel Lespinasse <walken@google.com> wrote:
>
>> ... When there are waiter threads on a rwsem and the spinlock is held, other
>> threads can only increment the active count by trying to grab the rwsem in
>> up_xxxx().
>
> That's not true.  A thread attempting to get an rwsem by issuing a down_read()
> or down_write() will also unconditionally increment the active count before it
> considers calling out to the slow path.
>
> Maybe what you mean is that other threads wanting to do a wake up can only
> increase the active count for the processes being woken up whilst holding the
> rwsem's spinlock.

Damn, this was a pretty bad commit comment - I wrote up_xxxx instead
of down_xxxx here.

down_xxxx can increase the active count but it will then take the
down_failed path and wait to acquire the spinlock - so we don't need
to worry about it. Other code paths can't even increase the active
count, since they don't hold the spinlock.

(I got mixed up due to a legitimate mention of the up_xxxx path higher
up. Semaphore operation names confuse me with the active count going
up in down() and down in up() - I suppose it made more sense in the
era of mechanical train semaphores :)

>> +     /* If we come here from up_xxxx(), another thread might have reached
>> +      * rwsem_down_failed_common() before we acquired the spinlock and
>> +      * woken up an active locker.
>
> Do you mean a waiter rather than an active locker?  If a process is still
> registering activity on the rwsem, then it can't be woken yet.

Yes, I meant a waiter (but since it got woken it's now an active locker).

> Apart from that, the patch looks fine.  That's all comment/description fixes.

Thanks. Updated the comments. And I thought I could speak english... :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
