Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1GZBKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:10:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54899 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1GZBKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:10:32 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=wp_X8QvuP7UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=J5sihgMohE3R-roQMvAA:9 a=Fj1mOega-j5m5XEp6jkA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Lance Taylor <iant@google.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>, gcc-help@gcc.gnu.org,
        stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <mcrfwltoov5.fsf@coign.corp.google.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	 <1311618747.3526.32.camel@gandalf.stny.rr.com>
	 <CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	 <1311625197.3526.35.camel@gandalf.stny.rr.com>
	 <CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
	 <CACqU3MXO_oR+8Ac2Z7wSji0sUeu-2FwskmxZxtY9NV+XpJXuwA@mail.gmail.com>
	 <mcrfwltoov5.fsf@coign.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 21:10:28 -0400
Message-ID: <1311642628.3526.58.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 17:41 -0700, Ian Lance Taylor wrote:
> Arnaud Lacombe <lacombar@gmail.com> writes:

> > It seems gcc transforms the conditional from:
> >
> > if (a != NULL && b != NULL) ...
> >
> > to
> >
> > if (b != NULL && a != NULL) ...
> >
> > In which case the warning is fully valid. I'm not sure what's the C
> > standard guarantee in term of conditional test order. gcc 4.7.0 has
> > the same behavior.
> 
> Not quite.  C guarantees that && is executed in order.  In this case gcc
> is generating
> 
>   a = e();
>   if (a != NULL)
>     b = f();
>   if (a != NULL & b != NULL)
>     g();
> 
> Note the change from && to & in the last conditional.  This
> transformation is safe, in that it does not change the meaning of the
> program.  However, it does cause a read of an uninitialized memory
> location, and this is causing a later gcc pass to generate a false
> positive warning.
> 

Looking at the assembly again, and not knowing what gcc is doing
internally, it does seem to be:

	if (a != NULL)
		b = f();
	if (b != NULL && a != NULL)
		g();

But if the first conditional fails, then the second will never pass
regardless of what b is. In which case, it is the same as:

	if (a != NULL)
		b = f();
	if (a != NULL && b != NULL)
		g();

And it doesn't change the meaning of the code.

> Please consider filing a bug report about this false positive.  Thanks.

I agree that this is just a warning bug.


On a tangent:

Compiling with -O2 (which gives no warning) (x86_64) produces:

0000000000000000 <fn>:
   0:	48 83 ec 08          	sub    $0x8,%rsp
   4:	e8 00 00 00 00       	callq  9 <fn+0x9>
			5: R_X86_64_PC32	e-0x4
   9:	48 85 c0             	test   %rax,%rax
   c:	74 1a                	je     28 <fn+0x28>
   e:	e8 00 00 00 00       	callq  13 <fn+0x13>
			f: R_X86_64_PC32	f-0x4
  13:	48 85 c0             	test   %rax,%rax
  16:	74 10                	je     28 <fn+0x28>
  18:	48 83 c4 08          	add    $0x8,%rsp
  1c:	e9 00 00 00 00       	jmpq   21 <fn+0x21>
			1d: R_X86_64_PC32	g-0x4
  21:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  28:	48 83 c4 08          	add    $0x8,%rsp
  2c:	c3                   	retq   

and compiling with -Os:

0000000000000000 <fn>:
   0:	55                   	push   %rbp
   1:	53                   	push   %rbx
   2:	51                   	push   %rcx
   3:	e8 00 00 00 00       	callq  8 <fn+0x8>
			4: R_X86_64_PC32	e-0x4
   8:	48 85 c0             	test   %rax,%rax
   b:	48 89 c3             	mov    %rax,%rbx
   e:	74 08                	je     18 <fn+0x18>
  10:	e8 00 00 00 00       	callq  15 <fn+0x15>
			11: R_X86_64_PC32	f-0x4
  15:	48 89 c5             	mov    %rax,%rbp
  18:	48 85 ed             	test   %rbp,%rbp
  1b:	74 0d                	je     2a <fn+0x2a>
  1d:	48 85 db             	test   %rbx,%rbx
  20:	74 08                	je     2a <fn+0x2a>
  22:	5a                   	pop    %rdx
  23:	5b                   	pop    %rbx
  24:	5d                   	pop    %rbp
  25:	e9 00 00 00 00       	jmpq   2a <fn+0x2a>
			26: R_X86_64_PC32	g-0x4
  2a:	58                   	pop    %rax
  2b:	5b                   	pop    %rbx
  2c:	5d                   	pop    %rbp
  2d:	c3                   	retq   

Which is 1 byte more than -O2. I would think that -Os would be smaller.

-- Steve


