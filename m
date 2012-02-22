Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab2BVPMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:12:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21771 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2BVPMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:12:14 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_aPKG9hbZygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=xQGPVIEKaN_jHu4ctTYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329923533.25686.106.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 10:12:13 -0500
In-Reply-To: <20120222145614.GA2491@elte.hu>
References: <20120222065016.GA16923@elte.hu> <4F44934B.2000808@zytor.com>
	 <20120222072538.GA17291@elte.hu> <4F449ACF.3040807@zytor.com>
	 <20120222074839.GA24890@elte.hu>
	 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
	 <20120222080659.GA25318@elte.hu>
	 <1329916920.25686.79.camel@gandalf.stny.rr.com>
	 <20120222133404.GA14085@elte.hu>
	 <1329918881.25686.92.camel@gandalf.stny.rr.com>
	 <20120222145614.GA2491@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 15:56 +0100, Ingo Molnar wrote:

> > Because it really just looks like a stronger "unlikely()" and 
> > fundamentally it really isn't. [...]
> 
> Well, the fact is that right now it *is* a stronger unlikely() 
> on architectures that have jump-labels and it's mapped to 
> unlikely() on others.
> 

Has gcc been fix to make it truly an unlikely case and remove the "jmp;
jmp" problem of before? I'm still using gcc 4.6.0 which has the
following code for a tracepoint (example is the
trace_sched_migrate_task().

    5b4a:       e9 00 00 00 00          jmpq   5b4f <set_task_cpu+0x5e>

The above is the jump label that turns into a nop at boot up.

    5b4f:       eb 19                   jmp    5b6a <set_task_cpu+0x79>

Here we jump over some of the trace code (this is the fast path)

    5b51:       49 8b 7d 08             mov    0x8(%r13),%rdi
    5b55:       44 89 e2                mov    %r12d,%edx
    5b58:       48 89 de                mov    %rbx,%rsi
    5b5b:       41 ff 55 00             callq  *0x0(%r13)
    5b5f:       49 83 c5 10             add    $0x10,%r13
    5b63:       49 83 7d 00 00          cmpq   $0x0,0x0(%r13)
    5b68:       eb 41                   jmp    5bab <set_task_cpu+0xba>

Below is the continuation of the fast path.

    5b6a:       48 8b 43 08             mov    0x8(%rbx),%rax
    5b6e:       44 39 60 18             cmp    %r12d,0x18(%rax)
    5b72:       74 0c                   je     5b80 <set_task_cpu+0x8f>


Again, I'm using gcc 4.6.0 and maybe it has been fixed.

-- Steve


