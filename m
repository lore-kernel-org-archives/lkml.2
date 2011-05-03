Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1ECX16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:27:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:63451 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab1ECX15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=YRWF3S7mDEwVKBluO+1bIIUi3IOQj+BpkJ9r3EdrBOejTokVRZjEacRcpl+GrlWsk5
         7N+X6LJq16LFbU7OBpcQ==
MIME-Version: 1.0
In-Reply-To: <20110503230812.GF2678@nowhere>
References: <1304456616-30281-1-git-send-email-vnagarnaik@google.com>
 <20110503214142.GC2678@nowhere> <BANLkTinA8M8Ok2jghtCoeBiTfw6n3NSziA@mail.gmail.com>
 <20110503220948.GE2678@nowhere> <1304462852.25414.2417.camel@gandalf.stny.rr.com>
 <20110503230812.GF2678@nowhere>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 3 May 2011 16:27:22 -0700
Message-ID: <BANLkTikRxY_NiNG+z+t_BDwDAom_rpNmdg@mail.gmail.com>
Subject: Re: [RFC PATCH] tracing: Don't call wakeup() when committing the event
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 4:08 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, May 03, 2011 at 06:47:32PM -0400, Steven Rostedt wrote:
>> On Wed, 2011-05-04 at 00:09 +0200, Frederic Weisbecker wrote:
>>
>> > I wonder if we should have a lite version of wake_up() that checks
>> > if the list of waiters is empty before locking the queue.
>> > After all we don't care much about tight races for tracing.
>>
>> Since tracing is a special case here, we probably could get away to just
>> do it ourselves. That is, have our own flag that determines if we should
>> wakeup or not.
>
> Yep, agreed.
>
How about this? Check if the waitqueue is active and if true, operate on the
trace_wait queue.

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 06f4458..e03ee24 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -353,7 +353,7 @@ void trace_wake_up(void)
 {
 	int cpu;

-	if (trace_flags & TRACE_ITER_BLOCK)
+	if (trace_flags & TRACE_ITER_BLOCK || !waitqueue_active(&trace_wait))
 		return;
 	/*
 	 * The runqueue_is_locked() can fail, but this is the best we

Vaibhav Nagarnaik
