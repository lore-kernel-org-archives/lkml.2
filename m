Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab1D0TQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:16:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759753Ab1D0TQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:16:03 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=0wago2nr_u6hNLsGzCwA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thiago Farina <tfransosi@gmail.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>
In-Reply-To: <BANLkTikQiA9iwSs1qX7-76GKUN23GV=8Uw@mail.gmail.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
	 <1303926576.18763.75.camel@gandalf.stny.rr.com>
	 <4DB86163.2070201@zytor.com>
	 <BANLkTikQiA9iwSs1qX7-76GKUN23GV=8Uw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Apr 2011 15:16:01 -0400
Message-ID: <1303931761.18763.101.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 21:51 +0300, Pekka Enberg wrote:

> It's the same kind of API extension kstrdup(), for example, is.
> Whether or not we should it do it is a separate matter and I think the
> only reasonable argument for and against is whether it (a) reduces the
> number of bugs,

I did a quick search through the git logs, and found no bug fixes due to
the semantics. At least by the time it got to mainline, they are fixed
(which is a good thing).


>  (b) improves code readability significantly,

This is a matter of preference. I think I would prefer it, but obviously
others do not.


>  or (c)
> generates better code.

If we implement streq() separately from strcmp() it gets slightly
better:

00000000000001be <strcmp>:
 1be:   55                      push   %rbp
 1bf:   48 89 e5                mov    %rsp,%rbp
 1c2:   8a 07                   mov    (%rdi),%al
 1c4:   8a 16                   mov    (%rsi),%dl
 1c6:   48 ff c7                inc    %rdi
 1c9:   48 ff c6                inc    %rsi
 1cc:   38 d0                   cmp    %dl,%al
 1ce:   74 07                   je     1d7 <strcmp+0x19>
 1d0:   19 c0                   sbb    %eax,%eax
 1d2:   83 c8 01                or     $0x1,%eax
 1d5:   eb 06                   jmp    1dd <strcmp+0x1f>
 1d7:   84 c0                   test   %al,%al
 1d9:   75 e7                   jne    1c2 <strcmp+0x4>
 1db:   31 c0                   xor    %eax,%eax
 1dd:   c9                      leaveq 
 1de:   c3                      retq   

00000000000001df <streq>:
 1df:   55                      push   %rbp
 1e0:   48 89 e5                mov    %rsp,%rbp
 1e3:   8a 07                   mov    (%rdi),%al
 1e5:   8a 16                   mov    (%rsi),%dl
 1e7:   48 ff c7                inc    %rdi
 1ea:   48 ff c6                inc    %rsi
 1ed:   38 d0                   cmp    %dl,%al
 1ef:   75 0b                   jne    1fc <streq+0x1d>
 1f1:   84 c0                   test   %al,%al
 1f3:   75 ee                   jne    1e3 <streq+0x4>
 1f5:   b8 01 00 00 00          mov    $0x1,%eax
 1fa:   eb 02                   jmp    1fe <streq+0x1f>
 1fc:   31 c0                   xor    %eax,%eax
 1fe:   c9                      leaveq 
 1ff:   c3                      retq   


-- Steve


