Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab1EZTqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:46:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757775Ab1EZTqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:46:38 -0400
Date: Thu, 26 May 2011 21:46:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Drewry <wad@chromium.org>, Colin Walters <walters@verbum.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110526194621.GB6363@elte.hu>
References: <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
 <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com>
 <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
 <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
 <BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com>
 <BANLkTi=UFB6PLfsSTVpFEQbveMs-W4MjUg@mail.gmail.com>
 <BANLkTim44ziUsEbYVOjfLPvOLfhUgH9itw@mail.gmail.com>
 <BANLkTineHBZ-oHRsfc9R6bpcp_oyczL5pA@mail.gmail.com>
 <20110526184723.GA3177@elte.hu>
 <alpine.DEB.2.02.1105261204020.4413@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1105261204020.4413@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* david@lang.hm <david@lang.hm> wrote:

> On Thu, 26 May 2011, Ingo Molnar wrote:
> 
> >* Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >>It also gets rid of all configuration - one of the things that
> >>makes most security frameworks (look at selinux, but also just
> >>ACL's etc) such a crazy rats nest is the whole "set up for other
> >>processes". If it's designed very much to be about just the "self"
> >>process (after initialization etc), then I think that avoids pretty
> >>much all the serious issues.
> >
> >That's how the event filters work currently: even when inherited they
> >get removed when exec-ing a setuid task, so they cannot leak into
> >privileged context and cannot modify execution there.
> >
> >Inheritance works when requested, covering only same-credential child
> >tasks, not privileged successors.
> 
> this is a very reasonable default, but there should be some way of 
> saying that you want the restrictions to carry over to the suid 
> task (I really know what I'm doing switch)

Unless you mean that root should be able to do it it's a security 
hole both for events and for filters:

 - for example we dont want really finegrained events to be used to 
   BTS hw-trace sshd and thus enable it to discover cryptographic 
   properties of the private key sshd is using.

 - we do not want to *modify* the execution flow of a setuid program,
   that can lead to exploits: by pushing the privileged codepath into 
   a condition that can never occur on a normal system - and thus can 
   push it into doing something it was not intended to do.

   data damage could be done as well: for example if the privileged 
   code is logging into a system file then modifying execution can 
   damage the log file.

So it's not a good idea in general to allow unprivileged code to 
modify the execution of privileged code. In fact it's not a good idea 
to allow it to simply *observe* privileged code. It must remain a 
black box with very few information leaking outwards.

Thanks,

	Ingo
