Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab1JEHDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:03:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:46476 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab1JEHDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:03:08 -0400
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using
 "performance" settings
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jon Mason <mason@myri.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>
In-Reply-To: <CA+55aFyOcb2y1QVaTNssWFU+nCee8RSs9-wZ-ARnFWcF5MdGSA@mail.gmail.com>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
	 <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com>
	 <1317742838.29415.217.camel@pasglop>
	 <CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com>
	 <1317744493.29415.238.camel@pasglop>
	 <CA+55aFyV9uqTt6UHA2wsAdRHHCSAtCSmoO2d3dm62HAo+s75Sg@mail.gmail.com>
	 <1317749439.29415.251.camel@pasglop>
	 <CA+55aFyOcb2y1QVaTNssWFU+nCee8RSs9-wZ-ARnFWcF5MdGSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 09:01:53 +0200
Message-ID: <1317798113.29415.270.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 10:36 -0700, Linus Torvalds wrote:
> On Tue, Oct 4, 2011 at 10:30 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > Patches 1 and 2 fix it to do what it's supposed to.
> 
> Maybe.
> 
> Or maybe not.

:-)

> We just don't the hell know, do we?

Well, we do with some confidence :-) Or rather what we do know is what
you have today in your tree is broken.

Let's break the story back into simple steps, I think there's a lot of
confusion about what's there, what not, etc... :

 - I came up with a crackpot configuration scheme for MPS based on what
pHyp does on our machines. Whether that's scheme is suitable for the
general case or not or even useful is the root of the debate between Ben
and I (I originally intended to have this inside arch/powerpc).

 - Jon was trying to fix MPS related issues (BIOS doing the wrong thing
on some machines) at the same time in generic code.

 - I described my scheme to Jon, who implemented it as the "performance"
option, he also implemented a "safe" option which does the classic
algorithm of clamping everbody down the the lowest common MPS.

 - Jon original patch (which went upstream) had a few problems. Among
others it made "performance" the default, and he didn't completely
understand what I wanted, ie, his implementation of "performance" was in
fact totally broken (it would try to configure devices with MPS larger
than what they can support for example). So that was a trainwreck.

 - I was travelling and didn't get to review things properly before it
went upstream.

 - Jon eventually got to fix things in most cases by switching the
default to "safe" rather than "performance" (as it should have been to
start with). This exposed different problems related to even "safe" not
working well on some chipsets due to HW errata. This is what you have
upstream today.

 - Jon patches 3 switches things to "don't touch" by default. We agree
that's what we want for 3.1. However, whatever way you look at it,
"performance" is still totally broken (he didn't implement my algorithm,
but something "else" that cannot work and never worked).

 - Patches 1 and 2 only affect the "performance" case and "fix" it to do
what I want.

So patches 1 and 2 are about taking the existing busted & known to not
work "performance" option in your tree and turning it into what I
originally wanted it to be, which will work at least for some cases
(tested !).

Now you may prefer to just remove the code for "performance" completely,
I wouldn't object.

But don't leave it there in a known totally busted state.... at least
that's my preference.

Cheers,
Ben.


