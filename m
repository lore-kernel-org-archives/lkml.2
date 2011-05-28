Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab1E1Aom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 20:44:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41896 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1E1Aol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 20:44:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=A/9iKgwXapBVM4x4d114sgzhYrr6Jkgd1xyB/c9IvABiOsGtSo2SuwimtONqbY4WKf
         8oFbsOYu3iyJ9qN85k1Q==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105271618470.9445@chino.kir.corp.google.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
 <1306519125-19301-1-git-send-email-vnagarnaik@google.com> <alpine.DEB.2.00.1105271618470.9445@chino.kir.corp.google.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 27 May 2011 17:44:06 -0700
Message-ID: <BANLkTimfdkpY=9pgEmBZwE3ezCmooEtQTA@mail.gmail.com>
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
To: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 4:22 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 27 May 2011, Vaibhav Nagarnaik wrote:
>
>> The tracing ring buffer is allocated from kernel memory. While
>> allocating the memory, if OOM happens, the allocating process might not
>> be the one that gets killed, since the ring-buffer memory is not
>> allocated as process memory. Thus random processes might get killed
>> during the allocation.
>>
>> This patch makes sure that the allocating process is considered the most
>> likely oom-kill-able process while the allocating is going on. Thus if
>> oom-killer is invoked because of ring-buffer allocation, it is easier
>> for the ring buffer memory to be freed and save important system
>> processes from being killed.
>>
>> This patch also adds __GFP_NORETRY flag to the ring buffer allocation
>> calls to make it fail more gracefully if the system will not be able to
>> complete the allocation request.
>>
>> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>
> Still not sure this is what we want, I'm afraid.
>
> I like the addition of __GFP_NORETRY, but I don't understand the use of
> test_set_oom_score_adj() here.  Why can't we use oom_killer_disable(),
> allocate with __GFP_NORETRY, and then do oom_killer_enable()?
>
> This prevents other tasks from getting oom killed themselves if they have
> oom_score_adj of OOM_SCORE_ADJ_MAX and allows the write to fail with
> -ENOMEM rather then being oom killed out from under us.
>
> So why is test_set_oom_score_adj() better?
>

When I tested this change, I saw that oom-killer can be invoked by any
process trying to allocate. If the oom_score_adj is not set to MAXIMUM,
oom-killer will not pick the "echo" process allocating ring buffer
memory since the memory is not counted against its RSS. This was the
main reason to use the test_set_oom_score_adj() API.

I saw this API being used in the swapoff() to allocate RAM for the pages
swapped out and as implemented, it seemed like a similar use case.

This change is not for the case where memory is already constrained. It
is for the case where the user has specified an invalid amount of memory
to be allocated while running in a constrained container. We don't want
to kill random processes while allocation of ring buffer is going on.

By using oom_killer_{enable|disable}, I think you mean setting the
global variable oom_killer_disabled. Using it will upset the system's
expectation of memory behavior. When GFP_NORETRY is set for our ring
buffer allocating process, the oom_killer_disabled is never checked. But
it would cause NULL's to be returned to other allocating processes which
might destabilize them and the system. The oom-killer has much better
success of reclaiming memory by killing the ring buffer allocating
process at that point.

For the other tasks with OOM_SCORE_ADJ_MAX set, one can argue that they
had expectation to be killed even if they themselves were not the direct
cause of the OOM situation.

> The alternative would be to setup an oom notifier for the ring buffer and
> stop allocating prior to killing a task and return a size that was smaller
> than what the user requested.
>

I think this gets really complex for the ring buffer allocation
scenario. I see that using __GFP_NORETRY is great for a graceful
failure. In the rare case where the allocation is going on and some
other process invokes oom-killer, stopping the ring buffer allocation
should be a priority to make sure that the system doesn't get
de-stabilized. As far as I can see, setting the oom_score_adj to maximum
is the best way to solve it.

That said, I am open to changing it if Steven and you think using
oom_killer_disabled is a better solution.



Vaibhav Nagarnaik
