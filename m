Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab1CXRKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:10:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933890Ab1CXRKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:10:08 -0400
MIME-Version: 1.0
In-Reply-To: <201103241026.01624.knikanth@suse.de>
References: <201103241026.01624.knikanth@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Mar 2011 10:01:24 -0700
Message-ID: <AANLkTinpzu5JqHBKkH7DMpWqoNu1rBMTNXqEVph+6XX0@mail.gmail.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@novell.com>, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 9:56 PM, Nikanth Karthikesan <knikanth@suse.de> wrote:
> On x86_64 SMP with lots of CPU atomic instructions which assert the LOCK #
> signal can stall other CPUs. And as the number of cores increase this penalty
> scales proportionately. So it is best to try and avoid atomic instructions
> wherever possible. test_and_set_bit_lock() can avoid using LOCK_PREFIX if it
> finds the bit set already.

This is potentially _very_ wrong. It means that test_and_set_bit() is
no longer a serializing instruction in the failure case, and I wonder
what effect that will have on the thousands of users.

It also means that test_and_set_bit() on an uncached entry now starts
out with a read-for-ownership cache operation, which can be quite a
bit slower than the exclusive ownership thing for the hopefully common
case where it succeeds.

So no, I really think this is seriously wrong. It basically makes it
impossible for the user of the bitop function to do a good job if it
wants to.

WHICH test_and_set_bit() are you having performance issues with?
Because I think the right approach is to do this optimization on a
case-by-case basis in the code that actually does the operation, not
in the low-level routine.

                       Linus
