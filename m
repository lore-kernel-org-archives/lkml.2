Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab1GZF4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:56:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6923 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1GZF4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:56:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:references:date:
	in-reply-to:message-id:user-agent:mime-version:content-type:x-system-of-record;
	b=HLfDufWWmrEylnzsHbF4ulGpWysqSa7qFPjtvro3H7bTJ5bK1DbCpQcqNQ67Ejl2X
	OhyZJjUG8g/RKVQh4pT+Q==
From: Ian Lance Taylor <iant@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, gcc-help@gcc.gnu.org,
        stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] TRACING: Fix a copmile warning
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	<1311618747.3526.32.camel@gandalf.stny.rr.com>
	<CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	<1311625197.3526.35.camel@gandalf.stny.rr.com>
	<CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
	<CACqU3MXO_oR+8Ac2Z7wSji0sUeu-2FwskmxZxtY9NV+XpJXuwA@mail.gmail.com>
	<mcrfwltoov5.fsf@coign.corp.google.com>
	<1311642628.3526.58.camel@gandalf.stny.rr.com>
Date: Mon, 25 Jul 2011 22:55:52 -0700
In-Reply-To: <1311642628.3526.58.camel@gandalf.stny.rr.com> (Steven Rostedt's
	message of "Mon, 25 Jul 2011 21:10:28 -0400")
Message-ID: <mcrtya9mvpz.fsf@coign.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> Compiling with -O2 (which gives no warning) (x86_64) produces:
>
> 0000000000000000 <fn>:
>    0:	48 83 ec 08          	sub    $0x8,%rsp
>    4:	e8 00 00 00 00       	callq  9 <fn+0x9>
> 			5: R_X86_64_PC32	e-0x4
>    9:	48 85 c0             	test   %rax,%rax
>    c:	74 1a                	je     28 <fn+0x28>
>    e:	e8 00 00 00 00       	callq  13 <fn+0x13>
> 			f: R_X86_64_PC32	f-0x4
>   13:	48 85 c0             	test   %rax,%rax
>   16:	74 10                	je     28 <fn+0x28>
>   18:	48 83 c4 08          	add    $0x8,%rsp
>   1c:	e9 00 00 00 00       	jmpq   21 <fn+0x21>
> 			1d: R_X86_64_PC32	g-0x4
>   21:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
>   28:	48 83 c4 08          	add    $0x8,%rsp
>   2c:	c3                   	retq   
>
> and compiling with -Os:
>
> 0000000000000000 <fn>:
>    0:	55                   	push   %rbp
>    1:	53                   	push   %rbx
>    2:	51                   	push   %rcx
>    3:	e8 00 00 00 00       	callq  8 <fn+0x8>
> 			4: R_X86_64_PC32	e-0x4
>    8:	48 85 c0             	test   %rax,%rax
>    b:	48 89 c3             	mov    %rax,%rbx
>    e:	74 08                	je     18 <fn+0x18>
>   10:	e8 00 00 00 00       	callq  15 <fn+0x15>
> 			11: R_X86_64_PC32	f-0x4
>   15:	48 89 c5             	mov    %rax,%rbp
>   18:	48 85 ed             	test   %rbp,%rbp
>   1b:	74 0d                	je     2a <fn+0x2a>
>   1d:	48 85 db             	test   %rbx,%rbx
>   20:	74 08                	je     2a <fn+0x2a>
>   22:	5a                   	pop    %rdx
>   23:	5b                   	pop    %rbx
>   24:	5d                   	pop    %rbp
>   25:	e9 00 00 00 00       	jmpq   2a <fn+0x2a>
> 			26: R_X86_64_PC32	g-0x4
>   2a:	58                   	pop    %rax
>   2b:	5b                   	pop    %rbx
>   2c:	5d                   	pop    %rbp
>   2d:	c3                   	retq   
>
> Which is 1 byte more than -O2. I would think that -Os would be smaller.

Ideally, it should be, yes.  The -Os code would be smaller except that
it needs to save a register across a function call, which forces it to
push and pop %rbx, which in turn means that stack alignment adds yet
another push and two pop instructions.  It's a heuristic failure.

Ian
