Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0EMFl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 01:41:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35443 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab0EMFlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 01:41:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=nwOrwudkFmuYEMbUj6EktJdFWO4OhicYXo6zXjnzfyBAVqG1up6c9+v7MpWIG5Vx9
	pDAZPSQ0Xwm0oarbwTuKQ==
MIME-Version: 1.0
In-Reply-To: <h2h8d20b11a1005121939tb35d9708p92eebd1f7b66b93a@mail.gmail.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
	 <1273634462-2672-7-git-send-email-walken@google.com>
	 <22741.1273666943@redhat.com>
	 <h2h8d20b11a1005121939tb35d9708p92eebd1f7b66b93a@mail.gmail.com>
Date: Wed, 12 May 2010 22:41:20 -0700
Message-ID: <u2p8d20b11a1005122241o12d5df8dl43c669a058665f40@mail.gmail.com>
Subject: Re: [PATCH 06/12] rwsem: wake queued readers when other readers are 
	active
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

On Wed, May 12, 2010 at 7:39 PM, Michel Lespinasse <walken@google.com> wrote:
> On Wed, May 12, 2010 at 5:22 AM, David Howells <dhowells@redhat.com> wrote:
>> Michel Lespinasse <walken@google.com> wrote:
>>
>>> In this situation, it would be perfectly fine to let threads B and C work
>>> in parallel as they each only want a read acquire on the rwsem. We can
>>> recognize this situation and let A wake B as long as there are no active
>>> writers on the rwsem.
>>
>> There can't be any active writers on the rwsem.  An active writer must have
>> just been upped and is in the process of waking the first sleeper up.
>
> Yes. My point is that by the point thread A (the writer that just got
> upped) gets around to waking B (a blocked reader), another reader C
> might have gotten active already. We don't want the nonzero active
> count (due to C) to prevent B from getting woken.

My bad - this is actually fine. C will notice there are still waiting
threads, so it will run rwsem_down_read_failed and queue itself. At
this point the active count will go back down to 0 and B and C will
both get woken.

I'll merge this back into change 7 since change 7 does require this in
order to work.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
