Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab1EZUXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:23:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49187 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab1EZUXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=rjqNmYC/8E807G9snbgeIjrlwHGfBaAggchLC4hw+0LMBGxqIcfHuoPdeGPHYMd8J/
         cPsewgJmedcSYocSrqYA==
MIME-Version: 1.0
In-Reply-To: <1306440288.3857.9.camel@gandalf.stny.rr.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com> <1306440288.3857.9.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 26 May 2011 13:23:09 -0700
Message-ID: <BANLkTi=dEHG4zEZ2xRF7VEDdM6fsd9Hr=g@mail.gmail.com>
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 1:04 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-05-26 at 12:52 -0700, Vaibhav Nagarnaik wrote:
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
>
> Hmm, have you tried this in practice? Yes we may kill the "echo" command
> but it doesn't stop the ring buffer from being allocated, and thus
> killing the echo command may not be enough, and those critical processes
> that you are trying to protect will be killed next.
>

Yes I did try this and found that it works as we intend it to. When
oom-killer is invoked, it picks the process which has lowest
oom_score_adj and kills it or one of its children. When the process is
getting killed, any memory allocation from it would be returned -ENOMEM,
which gets handled in our allocation process and we free up previously
allocated memory.

This API is now being used in other parts of kernel too, where it knows
that the allocation could cause OOM.

> Perhaps we should change the allocation of the ring buffer or detect OOM
> triggering. Maybe make all the allocations ATOMIC, thus it will be
> either available or not, and fail instead of trying to swap out other
> memory for the allocation.
>
> -- Steve
>

Vaibhav Nagarnaik
