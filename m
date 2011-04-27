Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1D0T00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:26:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab1D0T0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:26:24 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=olKWhAQIiWJiAothbJ0A:9 a=xcnoRvYnU_7DFB1sL1kA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <1303931761.18763.101.camel@gandalf.stny.rr.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
	 <1303926576.18763.75.camel@gandalf.stny.rr.com>
	 <4DB86163.2070201@zytor.com>
	 <BANLkTikQiA9iwSs1qX7-76GKUN23GV=8Uw@mail.gmail.com>
	 <1303931761.18763.101.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Apr 2011 15:26:22 -0400
Message-ID: <1303932382.18763.104.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 15:16 -0400, Steven Rostedt wrote:
> On Wed, 2011-04-27 at 21:51 +0300, Pekka Enberg wrote:

> 00000000000001df <streq>:
>  1df:   55                      push   %rbp
>  1e0:   48 89 e5                mov    %rsp,%rbp
>  1e3:   8a 07                   mov    (%rdi),%al
>  1e5:   8a 16                   mov    (%rsi),%dl
>  1e7:   48 ff c7                inc    %rdi
>  1ea:   48 ff c6                inc    %rsi
>  1ed:   38 d0                   cmp    %dl,%al
>  1ef:   75 0b                   jne    1fc <streq+0x1d>
>  1f1:   84 c0                   test   %al,%al
>  1f3:   75 ee                   jne    1e3 <streq+0x4>
>  1f5:   b8 01 00 00 00          mov    $0x1,%eax
>  1fa:   eb 02                   jmp    1fe <streq+0x1f>
>  1fc:   31 c0                   xor    %eax,%eax
>  1fe:   c9                      leaveq 
>  1ff:   c3                      retq   

I just noticed that 5 byte move instruction. So changing the function to
bool, makes it a little nicer:

bool streq(const char *cs, const char *ct)
{
        unsigned char c1, c2;

        while (1) {
                c1 = *cs++;
                c2 = *ct++;
                if (c1 != c2)
                        return false;
                if (!c1)
                        break;
        }
        return true;
}

00000000000001df <streq>:
 1df:   55                      push   %rbp
 1e0:   48 89 e5                mov    %rsp,%rbp
 1e3:   8a 07                   mov    (%rdi),%al
 1e5:   8a 16                   mov    (%rsi),%dl
 1e7:   48 ff c7                inc    %rdi
 1ea:   48 ff c6                inc    %rsi
 1ed:   38 d0                   cmp    %dl,%al
 1ef:   75 08                   jne    1f9 <streq+0x1a>
 1f1:   84 c0                   test   %al,%al
 1f3:   75 ee                   jne    1e3 <streq+0x4>
 1f5:   b0 01                   mov    $0x1,%al
 1f7:   eb 02                   jmp    1fb <streq+0x1c>
 1f9:   31 c0                   xor    %eax,%eax
 1fb:   c9                      leaveq 
 1fc:   c3                      retq   

-- Steve


