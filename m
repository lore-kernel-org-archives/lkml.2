Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1KCXR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 19:17:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58912 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1KCXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 19:17:55 -0400
Date: Thu, 3 Nov 2011 23:17:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        David Brown <davidb@codeaurora.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/3] Change ARCH_NR_GPIO into a Kconfig variable
Message-ID: <20111103231707.GU12913@n2100.arm.linux.org.uk>
References: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com> <201111031816.37427.vapier@gentoo.org> <20111103224452.GS12913@n2100.arm.linux.org.uk> <201111031907.46434.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111031907.46434.vapier@gentoo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 07:07:42PM -0400, Mike Frysinger wrote:
> On Thursday 03 November 2011 18:44:52 Russell King - ARM Linux wrote:
> > It most certainly is an improvement.
> > 
> > One of the things that we (the ARM community as a whole) is focused on to
> > is to reduce the amount of code in arch/arm through consolidation, removing
> > as much duplication as practical between the various SoCs.
> > 
> > One of the other factors that we're also focused on is:
> > (a) reducing the number of configurations which have to be built to
> > properly build-test ARM
> > (b) reducing the number of kernels which have to be built to support a
> >     range of ARM platforms
> 
> i'm aware of these efforts, but i don't see how this Kconfig solution gets you 
> there.  it's still a single define depending on arch-specific knobs.  now, if 
> this were treated as a max value that was based on all the arch needs, it's 
> now useful across SoCs.

(a) you need to read other discussions on this subject which have already
been had on linux-arm-kernel.  Essentially I've had it in the neck for
less than 128 bytes of needless bloat.  So when I'm faced with 8K of
bloat, what do you think my reaction will be?  Roll over and capitulate
only to get it in the neck again?  Or come up with an easy solution?

(b) that's effectively what it is - if you understand what's going on with
the 'default' statements.

For any option, there can be multiple 'default' statements:

- default value: "default" <expr> ["if" <expr>]
  A config option can have any number of default values. If multiple
  default values are visible, only the first defined one is active.
...
  Optionally, dependencies only for this default value can be added with
  "if".

Now, because of that well defined order, if we do this:

config FOO
	int
	default 1024 if A
	default 512 if B
	default 256

Then we end up with this truth table:

A B FOO
n n 256
n y 512
y n 1024
y y 1024

Which - provided the order is highest value first - gets us the highest
value for this variable dependent on which platforms have been selected.

And - given that we don't have many which require this treatment, this
is a sane solution to the problem.  Not only that but it's one which can
be trivially deleted from one file if and when we have sparse gpio.
