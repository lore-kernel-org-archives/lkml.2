Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab0EMAyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 20:54:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20432 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab0EMAyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 20:54:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=SH3UZ2uAatZ7x2jF2tJIDMKwQxq0nin0hhOBoKVB5PqIv3bh7p55XExDc6w2lMBth
	LysuxiEUP3UkgON6kudXg==
MIME-Version: 1.0
In-Reply-To: <28032.1273662070@redhat.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
	 <1273634462-2672-3-git-send-email-walken@google.com>
	 <28032.1273662070@redhat.com>
Date: Wed, 12 May 2010 17:54:42 -0700
Message-ID: <m2g8d20b11a1005121754r2c3e5803x3ff28aa72232d70a@mail.gmail.com>
Subject: Re: [PATCH 02/12] rwsem: use single atomic update for sem count when 
	waking up readers.
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

On Wed, May 12, 2010 at 4:01 AM, David Howells <dhowells@redhat.com> wrote:
> Michel Lespinasse <walken@google.com> wrote:
>
>> - *   - there must be someone on the queue
>> + * - there must be someone on the queue
>
> Why did you change this comment?  This is still a guarantee up_xxxx() must
> make about the state of the rwsem.

What I meant is that we do rely on there being someone on the queue
even if not coming from up_xxxx().

>> + retry_readers:
>> +     oldcount = rwsem_atomic_update(woken, sem) - woken;
>> +     if (!downgrading && (oldcount & RWSEM_ACTIVE_MASK))
>
> The problem with doing this here is that you may just have wasted all the work
> you did working out what woken is going to be.  That may have been quite slow
> as the CPU may have had to get hold of a bunch of cachelines that weren't in
> its cache.  Furthermore, you are doing this under a spinlock, so you may have
> lost your right to wake anyone up, and you'll be blocking the CPU that will be
> allowed to perform the wakeup.
>
> Incrementing the count first nets you a guarantee that you have the right to
> wake things up.
>
> You may point out that if there's no contention, then what your revised code
> does doesn't slow anything down.  That's true, but on modern CPU's, neither
> does the old code as the exclusively held cache line will lurk in the CPU's
> cache until there's contention on it.

My reasoning was more that in all cases except downgrade_write()
(which gets an exemption anyway because we know nobody can grab the
write lock from it) we've already checked the active count and found
it to be zero, so there is not much point checking again at the start
of __rwsem_do_wake(). However you are correct that incrementing the
active count at that point could be important, just to guarantee that
nobody can grab a write lock while we count how many readers we want
to wake.

I'll make sure to address this.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
