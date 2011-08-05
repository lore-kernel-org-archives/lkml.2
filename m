Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1HEV0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:26:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46848 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1HEV0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:26:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=wyKZ1S66iNqzdRX22qaNI58ueGrj4ImaV844XILKD1N4H5d8rxrXoLBKeod5OwQ5b
	gq/IRUP6r1PWytZDbvCTQ==
MIME-Version: 1.0
In-Reply-To: <20110805184323.GK20762@redhat.com>
References: <1312495991-28377-1-git-send-email-zakmagnus@chromium.org>
	<1312495991-28377-2-git-send-email-zakmagnus@chromium.org>
	<20110805134042.GJ1972@redhat.com>
	<CAAuSN919rQj93P8HE69_N5vC04ywMFfeJjRdMhn8ga1V-jFb7A@mail.gmail.com>
	<20110805184323.GK20762@redhat.com>
Date: Fri, 5 Aug 2011 14:26:12 -0700
Message-ID: <CAAuSN91Pi8SbWbU87v7QdDWS_N1GiXsM8dGUYSYKTUCUp+2Mww@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] Output stall traces in /proc
From: ZAK Magnus <zakmagnus@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 11:43 AM, Don Zickus <dzickus@redhat.com> wrote:
> I missed that you defined that as a pointer to a spinlock and assigned it
> later.  I see what you are doing now, but I am not a fan of it because you
> are now using the same spinlock in both the NMI context and the userspace
> context.  This can cause deadlocks if something got screwed up in the
> seq_printf functions or produced a very large amount of data.  Normally
> you don't want to do that.
>
> What others have done like perf and the APEI error handling is use
> something called irq_work_queue(??).  Basically you would capture the
> tracae in the NMI context, put it on an irq_work_queue and in the
> interrupt context save it to your global trace variable.  Then you could
> put spin_lock_irqsave inside the proc sys function and the work queue
> function and not have any potential deadlocks.
Work queue? Okay. The worker thread still needs a lock in order to
share the intermediate buffer with the NMI context, though. Any chance
of something screwing up in the middle of copying that structure,
causing a stall and deadlocking with the NMI?

Or maybe the intermediate buffer should be dynamically allocated. That
would work without a lock, although it seems slightly inefficient.

Regarding the lock between the work queue thread and the system call,
maybe that should become a mutex instead, since it's all outside of
interrupt context at that point?

> The softstall case should be ok though.
Why's that? The soft stall traces are not written in a NMI context but
just in a regular interrupt context, right? Doesn't that pose similar
problems?


These are weird rare corner cases anyway, right? Maybe the simplest
thing could be to let the interrupts only try_lock(), so they might
sometimes fail to record a stall, but it would be a pretty big
coincidence.
