Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab1EZTtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:49:51 -0400
Received: from mail.lang.hm ([64.81.33.126]:57121 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1EZTtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:49:50 -0400
Date: Thu, 26 May 2011 12:49:15 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Drewry <wad@chromium.org>, Colin Walters <walters@verbum.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
In-Reply-To: <20110526194621.GB6363@elte.hu>
Message-ID: <alpine.DEB.2.02.1105261247470.4413@asgard.lang.hm>
References: <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com> <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com> <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com> <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com> <BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com>
 <BANLkTi=UFB6PLfsSTVpFEQbveMs-W4MjUg@mail.gmail.com> <BANLkTim44ziUsEbYVOjfLPvOLfhUgH9itw@mail.gmail.com> <BANLkTineHBZ-oHRsfc9R6bpcp_oyczL5pA@mail.gmail.com> <20110526184723.GA3177@elte.hu> <alpine.DEB.2.02.1105261204020.4413@asgard.lang.hm>
 <20110526194621.GB6363@elte.hu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Ingo Molnar wrote:

> * david@lang.hm <david@lang.hm> wrote:
>
>> On Thu, 26 May 2011, Ingo Molnar wrote:
>>
>>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>
>>>> It also gets rid of all configuration - one of the things that
>>>> makes most security frameworks (look at selinux, but also just
>>>> ACL's etc) such a crazy rats nest is the whole "set up for other
>>>> processes". If it's designed very much to be about just the "self"
>>>> process (after initialization etc), then I think that avoids pretty
>>>> much all the serious issues.
>>>
>>> That's how the event filters work currently: even when inherited they
>>> get removed when exec-ing a setuid task, so they cannot leak into
>>> privileged context and cannot modify execution there.
>>>
>>> Inheritance works when requested, covering only same-credential child
>>> tasks, not privileged successors.
>>
>> this is a very reasonable default, but there should be some way of
>> saying that you want the restrictions to carry over to the suid
>> task (I really know what I'm doing switch)
>
> Unless you mean that root should be able to do it it's a security
> hole both for events and for filters:
>
> - for example we dont want really finegrained events to be used to
>   BTS hw-trace sshd and thus enable it to discover cryptographic
>   properties of the private key sshd is using.
>
> - we do not want to *modify* the execution flow of a setuid program,
>   that can lead to exploits: by pushing the privileged codepath into
>   a condition that can never occur on a normal system - and thus can
>   push it into doing something it was not intended to do.
>
>   data damage could be done as well: for example if the privileged
>   code is logging into a system file then modifying execution can
>   damage the log file.
>
> So it's not a good idea in general to allow unprivileged code to
> modify the execution of privileged code. In fact it's not a good idea
> to allow it to simply *observe* privileged code. It must remain a
> black box with very few information leaking outwards.

I was thinking of the use case of the real sysadmin (i.e. root) wanting to 
be able to constrain things. I can see why you would not want to allow 
normal users to do this.

David Lang
