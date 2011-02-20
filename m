Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1BTTdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 14:33:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42954 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab1BTTdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 14:33:12 -0500
Date: Sun, 20 Feb 2011 20:33:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Dan Carpenter <error27@gmail.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:AMD MICROCODE UPD..." <amd64-microcode@amd64.org>,
        open list <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch -next] x86, microcode, AMD: signedness bug in
 generic_load_microcode()
Message-ID: <20110220193306.GB6713@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Matthew Wilcox <matthew@wil.cx>, Borislav Petkov <bp@amd64.org>,
	Ingo Molnar <mingo@elte.hu>, Dan Carpenter <error27@gmail.com>,
	"Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	"maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
	"open list:AMD MICROCODE UPD..." <amd64-microcode@amd64.org>,
	open list <linux-kernel@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
References: <20110218091716.GA4384@bicker>
 <20110220130214.GD25700@elte.hu>
 <20110220141452.GA12127@aftab>
 <20110220175011.GA13726@parisc-linux.org>
 <20110220180845.GA6713@liondog.tnic>
 <20110220184217.GB13726@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110220184217.GB13726@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 11:42:17AM -0700, Matthew Wilcox wrote:
> On Sun, Feb 20, 2011 at 07:08:45PM +0100, Borislav Petkov wrote:
> > On Sun, Feb 20, 2011 at 10:50:11AM -0700, Matthew Wilcox wrote:
> > > No, that's not what's going on.  GCC _is_ truncating to a byte, 0xa5,
> > > whether it's signed or not.  Then at the time of the call to printf,
> > > the 0xa5 is cast to int.  If the char is signed, 0xa5 is sign-extended;
> > > if unsigned, it's zero-extended.
> > 
> > Yes, you're right, I missed the fact that printf does convert its
> > arguments based on the format string. I should've done
> > 
> > 	printf("ret = 0x%hhx\n", ret);
> 
> GCC's special treatment of the printf format string is only in the
> gneration of warnings.  It doesn't promote differently based on the
> format string.
> 
> You need to look at 6.5.2.2, parts 6 and 7.  Part 7 says:
> 
> 	The ellipsis notation in a function prototype declarator causes
> 	argument type conversion to stop after the last declared
> 	parameter. The default argument promotions are performed on
> 	trailing arguments.
> 
> And part 6 describes the default argument promotions:
> 
> 	If the expression that denotes the called function has a type that
> 	does not include a prototype, the integer promotions are performed
> 	on each argument, and arguments that have type float are promoted
> 	to double. These are called the default argument promotions.
> 
> So passing a char to printf will cause it to be promoted to int, no
> matter what the format string says.  All the format string will do is
> change how it's printed.  Probably by casting it back to a char :-)

Ha, I see, maybe I should've seen this earlier if I would've looked at
the asm, as grandma always taught me:

	char ret = f();
	...
	printf("ret = 0x%hhx\n", ret);

translates to:

00000000004004e4 <f>:
  4004e4:       55                      push   %rbp
  4004e5:       48 89 e5                mov    %rsp,%rbp
  4004e8:       b8 a5 a5 a5 a5          mov    $0xa5a5a5a5,%eax
  4004ed:       c9                      leaveq 
  4004ee:       c3                      retq   

00000000004004ef <main>:
  4004ef:       55                      push   %rbp
  4004f0:       48 89 e5                mov    %rsp,%rbp
  4004f3:       48 83 ec 10             sub    $0x10,%rsp
  4004f7:       b8 00 00 00 00          mov    $0x0,%eax
  4004fc:       e8 e3 ff ff ff          callq  4004e4 <f>
  400501:       88 45 ff                mov    %al,-0x1(%rbp)
  400504:       0f be 55 ff             movsbl -0x1(%rbp),%edx		<--- mov 8-bit reg/mem with sign extension to a 32-bit reg
  400508:       b8 1c 06 40 00          mov    $0x40061c,%eax
  40050d:       89 d6                   mov    %edx,%esi
  40050f:       48 89 c7                mov    %rax,%rdi
  400512:       b8 00 00 00 00          mov    $0x0,%eax
  400517:       e8 c4 fe ff ff          callq  4003e0 <printf@plt>


vs the unsigned char case

	unsigned char ret = f();
	...
	printf("ret = 0x%hhx\n", ret);

=>
  ...

  400501:       88 45 ff                mov    %al,-0x1(%rbp)
  400504:       0f b6 55 ff             movzbl -0x1(%rbp),%edx		<--- mov 8-bit reg/mem with zero-extension to a 32-bit reg
  400508:       b8 1c 06 40 00          mov    $0x40061c,%eax
  40050d:       89 d6                   mov    %edx,%esi
  40050f:       48 89 c7                mov    %rax,%rdi
  400512:       b8 00 00 00 00          mov    $0x0,%eax
  400517:       e8 c4 fe ff ff          callq  4003e0 <printf@plt>


Thanks for enlightening me! :)

-- 
Regards/Gruss,
    Boris.
