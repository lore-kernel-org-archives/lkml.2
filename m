Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1CYQq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:46:28 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44197 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1CYQq1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:11:1>);
	Fri, 25 Mar 2011 12:46:27 -0400
Message-Id: <4D8CD52702000078000386BD@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 25 Mar 2011 16:47:19 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Borislav Petkov" <bp@amd64.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <npiggin@kernel.dk>,
        "x86@kernel.org" <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Ingo Molnar" <mingo@redhat.com>, "Jack Steiner" <steiner@sgi.com>,
        <tee@sgi.com>, "Nikanth Karthikesan" <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
	 test_and_set_bit_lock if possible
References: <201103241026.01624.knikanth@suse.de>
 <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab>
 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
 <20110324171924.GC2414@elte.hu>
 <4D8C772202000078000384E1@vpn.id2.novell.com>
 <AANLkTimXLAV-xssvuKMs8ZqUKsRgHDedjTiGM6fxQ-ku@mail.gmail.com>
In-Reply-To: <AANLkTimXLAV-xssvuKMs8ZqUKsRgHDedjTiGM6fxQ-ku@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.03.11 at 17:29, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Fri, Mar 25, 2011 at 3:06 AM, Jan Beulich <JBeulich@novell.com> wrote:
>>
>> The problem was observed with __lock_page() (in a variant not
>> upstream for reasons not known to me), and prefixing e.g.
>> trylock_page() with an extra PageLocked() check yielded the
>> below quoted improvements.
> 
> Ok. __lock_page() _definitely_ should do the test_bit() thing first,
> because it's normally called from lock_page() that has already tested
> the bit.
> 
> But it already seems to do that, so I'm wondering what your variant is.

lock_page() does, but here it's really about __lock_page().

We've got a patch from Nick Piggin in the tree that aims at
speeding up unlock_page, which turns __lock_page() (on
2.6.32) into

void __lock_page(struct page *page)
{
	wait_queue_head_t *wq = page_waitqueue(page);
	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);

	do {
		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
		SetPageWaiters(page);
		if (likely(PageLocked(page)))
			sync_page(page);
	} while (!trylock_page(page));
	finish_wait(wq, &wait.wait);
}

(No, I do not know why the patch isn't upstream, but Nick is on Cc,
so maybe he can tell.)

> I'm also a bit surprised that lock_page() is that hot (unless your
> _lock_page() variant is simply too broken and ends up spinning?).
> Maybe we have some path that takes the page lock unnecessarily? What's
> the load?

So yes, there is spinning involved. A first improvement from Jack
was to make the SetPageWaiters() (introduced by that patch)
conditional upon the bit not already being set.

But that wasn't yielding the desired improvement, hence they
added a PageLocked() || ... in front of the trylock_page(), which
in turn raised the question why trylock_page() wouldn't do this
generally.

Jan

