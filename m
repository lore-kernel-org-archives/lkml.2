Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab1CaRHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:07:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab1CaRHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=G3Y7kGAjYPyTGgjezdrq/RKXPlbnX+E71cOwBfIYKbDIlORHxehmHLL4NGaO6Fh1jv
         BA+LxIGoLaap/e42iZgA==
MIME-Version: 1.0
In-Reply-To: <1301578027.4859.256.camel@twins>
References: <1301578027.4859.256.camel@twins>
Date: Thu, 31 Mar 2011 10:06:59 -0700
Message-ID: <BANLkTinmnSqMqtLsfE8ktXmbnGdp1COW0A@mail.gmail.com>
Subject: Re: perf and cgroup event scheduling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Thu, Mar 31, 2011 at 6:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Hi Stephane,
>
> while trying to make sense of various other fun event scheduling issues,
> I noticed that perf_cgroup_switch() isn't always doing the right thing.
>
> So we typically want to schedule: CPU-pinned, TASK-pinned, CPU-flexible
> TASK-flexible, however the current code doesn't respect that.
>
Unfortunately, you are right ;-). I think we should try to centralize
the scheduling
of per-cpu and per-thread event in a single function that goes through
the priority
list. In certain cases, we would sched out and back in per-thread
events, but that
would be the only to maintain the priority scheme. I will look into that.


In the meantime, yesterday, I found and fixed one potential kernel crash problem
related to mixing cgroup + per-thread events. I will be posting the
patch shortly.


> In particular perf_cgroup_sched_in() is placed wrong, it should be
> _before_ we schedule in the task contexts.
>
> There's further complications with things like perf_install_in_context()
> and perf_cgroup_move(), but those are either rare or 'interesting' to
> fix.
>
>
>
