Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1HIVog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:44:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24812 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1HIVof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:44:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=qf6/r0Wfog9avXXLWu1e0Vqc1lqKx3WYHKBeUjGO6vwa4CAOj0PBuu9Dja1iSXM3p
	z/rkHHSpKOT4GZx+3RmGA==
MIME-Version: 1.0
In-Reply-To: <20110809210829.GH1972@redhat.com>
References: <1312495991-28377-1-git-send-email-zakmagnus@chromium.org>
	<1312495991-28377-2-git-send-email-zakmagnus@chromium.org>
	<20110805134042.GJ1972@redhat.com>
	<CAAuSN919rQj93P8HE69_N5vC04ywMFfeJjRdMhn8ga1V-jFb7A@mail.gmail.com>
	<20110805184323.GK20762@redhat.com>
	<CAAuSN91Pi8SbWbU87v7QdDWS_N1GiXsM8dGUYSYKTUCUp+2Mww@mail.gmail.com>
	<20110808201951.GY1972@redhat.com>
	<1312836771.22367.35.camel@twins>
	<20110808213721.GA1972@redhat.com>
	<CAAuSN91zeipoQVU5jEtvVR1bXeu2c1KGY2sqowYuDzozpa818w@mail.gmail.com>
	<20110809210829.GH1972@redhat.com>
Date: Tue, 9 Aug 2011 14:44:31 -0700
X-Google-Sender-Auth: VCcNhmrWgxTgBzs-WgNiO9_r7LI
Message-ID: <CAAuSN905uf1p1Uz1Kuh6=XsM6H0QpYwHQO4mazE39WTj2oUTLA@mail.gmail.com>
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

On Tue, Aug 9, 2011 at 2:08 PM, Don Zickus <dzickus@redhat.com> wrote:
> Well, looking at the code again, I think the spin_locks in the NMI handler
> will block the other cpus from writing to the page at the same time.  So
> it gets serialized that way, I think.  The next trick is to do something
> with procfs like swapping buffers successfully.
>
> I am trying to think how that would work, but I guess if you use the
> cmpxchg macros then
>
> procfs could cmpxchg a READ_BIT on the buffer and if successful (no
> WRITE_BIT), then proceed to read the buffer.  Otherwise use the other
> buffer.  A lock would have to be used to serialize access on the procfs.
>
> The NMI code could do the same with a WRITE_BIT and if succesful (no
> READ_BIT), then proceed to write the buffer.  Otherwise use the other
> buffer.  Because the NMI is serialized only one write could go on at any
> one time.
>
> I was reading the kernel/irq_work.c code to generate the above idea.
>
> Not sure if it works.  Thoughts?
>
> Cheers,
> Don
>
I don't think that the reader should use the other buffer if it finds
contention. Who knows what that other buffer contains? Maybe something
really stale, maybe nothing. However, I think it's okay for the reader
to wait to be able to obtain the lock from the writer; just not the
other way around. I have a similar idea sketched out and I'll try and
get a patch out soon. Basically, the reader will be really simple and
just obtain the lock on whatever buffer it's told and then read that
buffer and unlock. The worst that will happen is that it will read a
slightly stale value, and that's only because it read "before" the
buffers switched. The writer, meanwhile, merely tries to lock a
buffer, and if it fails, sets the other one as the writable one (this
state is not shared with the reader). Then it locks that one
(guaranteed no contention), writes out the data, tells the reader to
read from the new buffer from now on, and unlocks. Both readers and
writers are serialized.

It's probably pretty hard to follow that description. Hopefully the
patch will be clearer.
