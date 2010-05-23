Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0EWVRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 17:17:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57292 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab0EWVRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 17:17:20 -0400
Date: Sun, 23 May 2010 23:17:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Markus <M4rkusXXL@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request
Message-ID: <20100523211717.GD1408@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Markus <M4rkusXXL@web.de>,
	linux-kernel@vger.kernel.org
References: <201005231829.32106.M4rkusXXL@web.de>
 <20100523183851.GA20229@liondog.tnic>
 <201005232244.41977.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201005232244.41977.M4rkusXXL@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus <M4rkusXXL@web.de>
Date: Sun, May 23, 2010 at 10:44:41PM +0200

> It is 0000000001912178.
> http://img256.imageshack.us/img256/4370/shotn.gif

True story, the fact that this value is not what it is expected to be
judging from the code it happens might actually be a clue:

[64112.502507] Code: 8b bf b0 00 00 00 31 ed 48 8d 50 f0 48 85 c0 48 0f 45 ea 48 85 ff 74 10 48 89 ee e8 8d d3 ff ff 85 c0 0f 8e c5 00 00 00 48 89 eb <49> 8b bd b8 00 00 00 48 85 ff 74 10 48 89 ee e8 6e d3 ff ff 85
All code
========
   0:   8b bf b0 00 00 00       mov    0xb0(%rdi),%edi
   6:   31 ed                   xor    %ebp,%ebp
   8:   48 8d 50 f0             lea    -0x10(%rax),%rdx
   c:   48 85 c0                test   %rax,%rax
   f:   48 0f 45 ea             cmovne %rdx,%rbp
  13:   48 85 ff                test   %rdi,%rdi
  16:   74 10                   je     0x28
  18:   48 89 ee                mov    %rbp,%rsi
  1b:   e8 8d d3 ff ff          callq  0xffffffffffffd3ad
  20:   85 c0                   test   %eax,%eax
  22:   0f 8e c5 00 00 00       jle    0xed
  28:   48 89 eb                mov    %rbp,%rbx
  2b:*  49 8b bd b8 00 00 00    mov    0xb8(%r13),%rdi     <-- trapping instruction
  32:   48 85 ff                test   %rdi,%rdi
  35:   74 10                   je     0x47
  37:   48 89 ee                mov    %rbp,%rsi
  3a:   e8 6e d3 ff ff          callq  0xffffffffffffd3ad
  3f:   85                      .byte 0x85

Code starting with the faulting instruction
===========================================
   0:   49 8b bd b8 00 00 00    mov    0xb8(%r13),%rdi
   7:   48 85 ff                test   %rdi,%rdi
   a:   74 10                   je     0x1c
   c:   48 89 ee                mov    %rbp,%rsi
   f:   e8 6e d3 ff ff          callq  0xffffffffffffd382
  14:   85                      .byte 0x85


and %r13 contains 00000000019129c0 in the register snapshot. Hmm...

> Serial console is no option, but this "netconsole"-thing looks
> promising. I'll set that up and try to catch the next one with this.

That'll help. Also let me make sure: Is this a vanilla kernel or are
there any distribution patches on top of it? I see it says 2.6.34-gentoo
but just in case. If it is not a vanilla kernel please try a vanilla one
from kernel.org.

Also, please send the whole dmesg of the system, there might be
something suspicious there and also the output of 'cat /proc/cpuinfo'
and 'dmidecode', the last one run as root.

Thanks.

-- 
Regards/Gruss,
    Boris.
