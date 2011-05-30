Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1E3Xr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 19:47:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1E3XrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 19:47:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=kBUTnzIof7VwLIWMrdVztvFZEouwwui1tjjdARuiGshW2kJwp8yjzHNP5FbLzdOpUh
         4j7SRCUbsULRJACOyzQQ==
MIME-Version: 1.0
In-Reply-To: <1306547453.3857.44.camel@gandalf.stny.rr.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
 <1306519125-19301-1-git-send-email-vnagarnaik@google.com> <alpine.DEB.2.00.1105271618470.9445@chino.kir.corp.google.com>
 <BANLkTimfdkpY=9pgEmBZwE3ezCmooEtQTA@mail.gmail.com> <1306547453.3857.44.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 30 May 2011 16:46:52 -0700
Message-ID: <BANLkTik5yUMVpdPmELMZfmGE=JZRQCQQ2Q@mail.gmail.com>
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 6:50 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-05-27 at 17:44 -0700, Vaibhav Nagarnaik wrote:
>
>> That said, I am open to changing it if Steven and you think using
>> oom_killer_disabled is a better solution.
>
> My biggest concern is that we are setting policy in the kernel. If you
> are concerned about this, why not just have the process that is going to
> increase the size of the ring buffer adjust its own oom policy
> with /proc/<pid>/oom_score_adj ? Only a privilege process can increase
> the size of the ring buffer so it's not like we are worried about any
> normal user task upping the ring buffer to kill other processes.
>
> -- Steve

You are right. Changing the value of oom_killer_disabled is setting
kernel policy and I don't like the solution either.

It would be great if the user always sets oom_score_adj while
allocating ring buffer memory, but there are different use cases I see
where it might not be feasible. One is the number of different
applications which use ftrace and set the ring buffer memory size
(trace-cmd, perf, powertop, etc). The other case is where a developer
is setting the size for his own tracing. In all these cases,
oom_score_adj *should* be set to maximum to be safe, but it a
developer might forget this step and can de-stabilize the system. This
is why I think that setting oom_score_adj to maximum in the kernel
while allocating buffer as well as using __GFP_NORETRY should suffice
for the end goal of being a good memory citizen.


Vaibhav Nagarnaik
