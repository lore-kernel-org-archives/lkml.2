Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1HHXen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:34:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab1HHXem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:34:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=IJEB5JZOLoIihSpGKHhxRuiK9rF+PU4JGCyEAvaSF6vo+Coht+u2VAGzEARXPd6Rx
	hm/DW8OzKu06dHYu688zA==
MIME-Version: 1.0
In-Reply-To: <20110808213721.GA1972@redhat.com>
References: <1312495991-28377-1-git-send-email-zakmagnus@chromium.org>
	<1312495991-28377-2-git-send-email-zakmagnus@chromium.org>
	<20110805134042.GJ1972@redhat.com>
	<CAAuSN919rQj93P8HE69_N5vC04ywMFfeJjRdMhn8ga1V-jFb7A@mail.gmail.com>
	<20110805184323.GK20762@redhat.com>
	<CAAuSN91Pi8SbWbU87v7QdDWS_N1GiXsM8dGUYSYKTUCUp+2Mww@mail.gmail.com>
	<20110808201951.GY1972@redhat.com>
	<1312836771.22367.35.camel@twins>
	<20110808213721.GA1972@redhat.com>
Date: Mon, 8 Aug 2011 16:34:33 -0700
X-Google-Sender-Auth: 1PP9gc8ekkRw8_K4fcZ0nkK1Ukw
Message-ID: <CAAuSN91zeipoQVU5jEtvVR1bXeu2c1KGY2sqowYuDzozpa818w@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] Output stall traces in /proc
From: Alex Neronskiy <zakmagnus@chromium.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 2:37 PM, Don Zickus <dzickus@redhat.com> wrote:
> Maybe irq_work isn't what we needed.  I just wasn't smart enough to figure
> out how to make sure we can write data in an NMI context and read it in a
> normal context.  I supposed the whole swapping buffers could work and is
> simpler.
So each of the buffers has its own lock, right? If a lock protects a
pair of buffers, then: A reader takes the lock, and a writing NMI
comes in and writes to the non-readable buffer and swaps the two. The
reader still has the lock. Another NMI comes in, sees that the lock is
unavailable, and writes to the "backup" buffer, which is actually the
one the reader is still reading from. Bad corrupted read results.

Either way, I don't see how to make the idea work safely for one pair
of buffers shared by multiple CPU's. It works one-pair-per-CPU, but
that's not how the current design is. I guess it would need to
add/remove files every time a processor is added/removed, and there
have to be some other changes too, obviously. What do you think, Don?
Should this be a per-CPU thing, instead of global worst?

Other alternatives:
1. Try lock. The interrupts will simply not save their data if they
are locked out by readers.
2. Work queue + dynamic allocation. No, I don't mean irq_work. This
works, doesn't it? But it's a bit wasteful of cycles and memory.
