Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1BTSmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 13:42:20 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48880 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1BTSmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 13:42:19 -0500
Date: Sun, 20 Feb 2011 11:42:17 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>, Dan Carpenter <error27@gmail.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:AMD MICROCODE UPD..." <amd64-microcode@amd64.org>,
        open list <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch -next] x86, microcode, AMD: signedness bug in
	generic_load_microcode()
Message-ID: <20110220184217.GB13726@parisc-linux.org>
References: <20110218091716.GA4384@bicker> <20110220130214.GD25700@elte.hu> <20110220141452.GA12127@aftab> <20110220175011.GA13726@parisc-linux.org> <20110220180845.GA6713@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220180845.GA6713@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 07:08:45PM +0100, Borislav Petkov wrote:
> On Sun, Feb 20, 2011 at 10:50:11AM -0700, Matthew Wilcox wrote:
> > No, that's not what's going on.  GCC _is_ truncating to a byte, 0xa5,
> > whether it's signed or not.  Then at the time of the call to printf,
> > the 0xa5 is cast to int.  If the char is signed, 0xa5 is sign-extended;
> > if unsigned, it's zero-extended.
> 
> Yes, you're right, I missed the fact that printf does convert its
> arguments based on the format string. I should've done
> 
> 	printf("ret = 0x%hhx\n", ret);

GCC's special treatment of the printf format string is only in the
gneration of warnings.  It doesn't promote differently based on the
format string.

You need to look at 6.5.2.2, parts 6 and 7.  Part 7 says:

	The ellipsis notation in a function prototype declarator causes
	argument type conversion to stop after the last declared
	parameter. The default argument promotions are performed on
	trailing arguments.

And part 6 describes the default argument promotions:

	If the expression that denotes the called function has a type that
	does not include a prototype, the integer promotions are performed
	on each argument, and arguments that have type float are promoted
	to double. These are called the default argument promotions.

So passing a char to printf will cause it to be promoted to int, no
matter what the format string says.  All the format string will do is
change how it's printed.  Probably by casting it back to a char :-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
