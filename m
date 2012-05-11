Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2EKAjC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 20:39:02 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61028 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab2EKAi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 20:38:59 -0400
Message-ID: <1336696707.947.56.camel@mop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Kay Sievers <kay@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Date: Fri, 11 May 2012 02:38:27 +0200
In-Reply-To: <CA+55aFwJgtVr9ZndEU-yhJW3wi-5Omga51pjun+J213awQwJZA@mail.gmail.com>
References: <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
	 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
	 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
	 <20120509070710.GA29981@gmail.com>
	 <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
	 <1336611278.728.9.camel@mop>
	 <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
	 <1336667984.947.24.camel@mop>
	 <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
	 <1336676986.947.47.camel@mop> <20120510201409.GA6467@thunk.org>
	 <1336682226.29763.2.camel@joe2Laptop>
	 <CAPXgP11T7vjBBFaE5jne0hntZ2J-MoVxwJ2C9TNsRzme9DmLuQ@mail.gmail.com>
	 <1336682772.29763.6.camel@joe2Laptop>
	 <CA+55aFwJgtVr9ZndEU-yhJW3wi-5Omga51pjun+J213awQwJZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:52 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The change to verify that 'current' matches the previous printout is
> so far the *only* sane semantic change I've seen in this thread.
> Everything else has been pure garbage.

Ok, let's continue with sane things then. :)

Here is a stupid kernel module which creates 3 racy printk() loops, 2 of
them do continuation, one does an atomic print. The continuation one
prints one char per printk.
  http://people.freedesktop.org/~kay/printk-race/printk-race.c

The lines all try to look like:
  (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
  (CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC)
  (XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)

Every loop has it's own uppercase character. The line enclosed in '()'.
'A' is the atomic one, the cont ones are 'C' and 'X'.

Our current kernel look like:
[   99.056806] XC(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[   99.059772] XC(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[   99.062168] XCCX(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[   99.066479] CXXC(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[   99.070063] XC(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[   99.073081] XCCXCXCXCXCXCXCXCXCXCXCXCXCXCXCCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXC)
[   99.148325] (CCXCXCX)
[   99.155468] (XXCXCXCXCCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXCXXCXCXCXCXCXCXCXCXC)
[   99.277357] (CCXCXCXCX)
  http://people.freedesktop.org/~kay/printk-race/printk-out-before.txt


The kernel with the record buffer, and the 'current' who owns the cont buffer
looks like:
[   78.080866] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[   78.082790] (CC
[   78.084152] (XX
[   78.084497] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[   78.085494] C
[   78.086125] X
[   78.087188] C
[   78.088669] X
[   78.089803] C
[   78.091510] X
[   78.091924] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[   78.094112] CC
[   78.096171] X
  http://people.freedesktop.org/~kay/printk-race/printk-out-after.txt

Thanks,
Kay

