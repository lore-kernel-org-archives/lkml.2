Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1ECWJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:09:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43722 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1ECWJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=feLT6evcvfGxQAOAGg6EhMvTTl8gLq3HvS0bOGc5ZVzoMRoihy2XM45SKquAQ+tkE8
         hLrGvMBz2+eMmcTuYALcSgc3ZhG61hDy4UEL/BDHBpgcTJFU411FT0ykr7q7+wp76LFN
         RrwB7Yjs1pwN2eck1htZAkq+A6Oem9iNB2R00=
Date: Wed, 4 May 2011 00:09:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] tracing: Don't call wakeup() when committing the
 event
Message-ID: <20110503220948.GE2678@nowhere>
References: <1304456616-30281-1-git-send-email-vnagarnaik@google.com>
 <20110503214142.GC2678@nowhere>
 <BANLkTinA8M8Ok2jghtCoeBiTfw6n3NSziA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinA8M8Ok2jghtCoeBiTfw6n3NSziA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 02:56:11PM -0700, Vaibhav Nagarnaik wrote:
> On Tue, May 3, 2011 at 2:41 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Tue, May 03, 2011 at 02:03:36PM -0700, Vaibhav Nagarnaik wrote:
> >> In using syscall tracing by concurrent processes, the wakeup() that is
> >> called in the event commit function causes contention on the spin lock
> >> of the waitqueue. I enabled sys_enter_getuid and sys_exit_getuid
> >> tracepoints, and by running getuid_microbench from autotest in parallel
> >> I found that the contention causes exponential latency increase in the
> >> tracing path.
> >>
> >> The autotest binary getuid_microbench calls getuid() in a tight loop for
> >> the given number of iterations and measures the average time required to
> >> complete a single invocation of syscall.
> >>
> >> The patch here points to the problem and provides a naive solution to
> >> start the discussion. It is not intended to be a definitive solution.
> >
> > Right, so another solution could be to have per cpu waitqueues for
> > the per_cpu trace_pipe/trace_pipe_raw files, and one big for the main
> > trace_pipe file.
> 
> That could be another way. But if there is still *one* common waitqueue for
> the main trace file, we are still going to get contention on waking up that
> common waitqueue.
> 
> Unless I am missing something, can you explain why there won't be contention
> in your suggested solution?

Ah right, I missed that.

I wonder if we should have a lite version of wake_up() that checks
if the list of waiters is empty before locking the queue.
After all we don't care much about tight races for tracing.

Hm?
