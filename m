Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab1L3RIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 12:08:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:50743 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1L3RIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 12:08:40 -0500
Message-ID: <1325264878.30917.11.camel@twins>
Subject: Re: [GIT PULL] futex fixlet
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
        Hugh Dickins <hughd@google.com>
Date: Fri, 30 Dec 2011 18:07:58 +0100
In-Reply-To: <CA+55aFydsXqRg-QwfVBuUOSfpGQ24MjgWaK-z+3Qvgn-BHn6Tw@mail.gmail.com>
References: <20111229210707.GA22300@elte.hu>
	 <CA+55aFydsXqRg-QwfVBuUOSfpGQ24MjgWaK-z+3Qvgn-BHn6Tw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-29 at 17:26 -0800, Linus Torvalds wrote:
> Why do we even bother to check "page->mapping" at all? What's the
> *use* of that loop? My gut feeling is that *that* is the fundamental
> problem, and we should just get rid of it, rather than add all these
> totally random work-arounds for the problem.
> 
> Peter Z? That "if (!page->mapping) goto again" actually goes back to
> 38d47c1b7075, in 2008. Why does it exist in the first place? There's
> no comment nor explanation in the changelog.
> 
> Why don't we just unconditionally return -EFAULT? What is the retry
> actually supposed to *do*? If somebody races with a mmap/munmap, why
> the hell would we care? What is it doing? 

Vague memory seems to suggest it was to do with an unmap race, now the
only such race we care about is swapping, if someone has a futex and
does munmap+mmap under us we really don't care and you get to keep
whatever result that yields.

That said, the ->mapping test is wrong because ->mapping is not actually
cleared when the page is unmapped.

Also, I suspect the is_page_cache_freeable() test in pageout() avoids
the worst of it. It keeps the page around if we have a reference to it,
so a minor fault will then quickly re-instate the same page without loss
of data.

So I _think_ you're completely right and we can simply kill the whole
thing, but I've been trying very hard to forget everything kernel
related for a week, and I really shouldn't kick-start my brain until
somewhere next week.


