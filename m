Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab2EJQrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:47:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60922 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2EJQrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:47:45 -0400
MIME-Version: 1.0
In-Reply-To: <1336667984.947.24.camel@mop>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
 <20120509070710.GA29981@gmail.com> <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
 <1336611278.728.9.camel@mop> <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
 <1336667984.947.24.camel@mop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 May 2012 09:47:23 -0700
X-Google-Sender-Auth: Iu-MfQb3wxL2gTyZPiRyPeKJG6Q
Message-ID: <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Kay Sievers <kay@vrfy.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 9:39 AM, Kay Sievers <kay@vrfy.org> wrote:
>
> All the special rules are gone. KERN_CONT is the same as KERN_DEFAULT
> now.

That's wrong.

Key, KERN_CONT and KERN_DEFAULT really are different and have
fundamentally different semantics. The fact that you think they aren't
shows that you don't understand it.

Your "current" check doesn't change anything.

There are two main and important differences:

 - people can avoid using '\n' if they know the next printk will have
a KERN_xxx marker (xxx != CONT).

   This is often useful for having loops that print out individual
entries all on the same line - print all of them without the '\n'.

   The printk afterwards will automatically start a new line if it has
KERN_DEFAULT.

   If you make KERN_CONT and KERN_DEFAULT the same, it is a BUG. Don't do it.

 - You don't seem to realize that interrupts are threaded events too,
but they will happen with the same task-struct.

   An interrupt that prints out with KERN_DEFAULT had better not act
the same way as KERN_CONT.

So dammit, just stop trying to get rid of KERN_CONT or KERN_DEFAULT.
They are both real, and they are both *different*. If you think they
are the same, you are WRONG.

Don't try to change the rules because you think you are "clever".
You're only making things worse.

                       Linus
