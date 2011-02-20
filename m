Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1BTSIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 13:08:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54365 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab1BTSIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 13:08:51 -0500
Date: Sun, 20 Feb 2011 19:08:45 +0100
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
Message-ID: <20110220180845.GA6713@liondog.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110220175011.GA13726@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 10:50:11AM -0700, Matthew Wilcox wrote:
> On Sun, Feb 20, 2011 at 03:14:52PM +0100, Borislav Petkov wrote:
> > int f() {
> >         return 0xa5a5a5a5;
> > }
> > 
> > int main()
> > {
> > 
> >         char ret = f();
> > 
> >         printf("ret = 0x%016x\n", ret);
> > 
> >         return 0;
> > } 
> > --
> > 
> > doesn't cause a warning and prints a sign extended 0x00000000ffffffa5
> > which is cast to the return type of the function. If ret is an unsigned
> > char, then we return a 0x00000000000000a5.
> > 
> > I found something about it in the C99 standard??, section "6.5.16.1 Simple
> > assignment":
> > 
> > 4.  EXAMPLE 1       In the program fragment
> > 
> >            int f(void);
> >            char c;
> >            /* ... */
> >            if ((c = f()) == -1)
> >                     /* ... */
> > 
> > the int value returned by the function may be truncated when stored in
> > the char, and then converted back to int width prior to the comparison.
> > In an implementation in which ??????plain?????? char has the same range
> > of values as unsigned char (and char is narrower than int), the result
> > of the conversion cannot be negative, so the operands of the comparison
> > can never compare equal. Therefore, for full portability, the variable c
> > should be declared as int."
> > 
> > so the whole "... may be truncated.. " could mean a lot of things. From
> > my example above, gcc does truncate the int return type to a byte-sized
> > char only when they differ in signedness.
> 
> No, that's not what's going on.  GCC _is_ truncating to a byte, 0xa5,
> whether it's signed or not.  Then at the time of the call to printf,
> the 0xa5 is cast to int.  If the char is signed, 0xa5 is sign-extended;
> if unsigned, it's zero-extended.

Yes, you're right, I missed the fact that printf does convert its
arguments based on the format string. I should've done

	printf("ret = 0x%hhx\n", ret);

for chars.

Thanks.

-- 
Regards/Gruss,
    Boris.
