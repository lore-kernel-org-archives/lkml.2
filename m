Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab2D2DtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 23:49:25 -0400
Received: from [12.216.194.151] ([12.216.194.151]:45611 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab2D2DtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 23:49:23 -0400
Message-ID: <4F9CBA41.6000900@tilera.com>
Date: Sat, 28 Apr 2012 23:49:21 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: avoid calling do_signal() after fork from
 a kernel thread
References: <20120427172444.GA30267@redhat.com> <20120427184528.GL6871@ZenIV.linux.org.uk> <20120427202002.8ED632C0BF@topped-with-meat.com> <20120427211244.GO6871@ZenIV.linux.org.uk> <20120427212729.652542C0AF@topped-with-meat.com> <20120427231526.GP6871@ZenIV.linux.org.uk> <20120427235023.GR6871@ZenIV.linux.org.uk> <201204281858.q3SIwC7H014319@farm-0027.internal.tilera.com> <20120428205517.GW6871@ZenIV.linux.org.uk> <4F9C6525.3050405@tilera.com> <20120429005505.GX6871@ZenIV.linux.org.uk>
In-Reply-To: <20120429005505.GX6871@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/2012 8:55 PM, Al Viro wrote:
> On Sat, Apr 28, 2012 at 05:46:13PM -0400, Chris Metcalf wrote:
>>> For another,
>>> there's kernel_execve() and if it fails (binary doesn't exist/has wrong
>>> format/etc.) you'll get to .Lresume_userspace with EX1_PL(regs->ex1)
>>> unchanged, i.e. the kernel one...
>> This is a good point.  The current syscall return path goes directly to
>> .Lresume_userspace, which will screw up kernel syscalls.  I think the right
>> answer is still to jump to interrupt_return from those cases, though.  In
>> particular, this gets rid of the existing cruftiness where we have to
>> document that a local label (.Lresume_userspace) can be the target of jumps
>> from outside the containing function.
> Point, but...  Are you sure you want to add extra work to a very hot path?
> Leaving the "we don't have any pending work to do" unburdened by that check
> would reduce the overhead a lot.

I suppose that's plausible; it's only 5 cycles of work (including the one
cache-hot load), but might also be an extra icache line load, which could
be quite a bit slower.

I think the way to do this may be to both take your suggestion about
checking user_mode() in do_work_pending(), and also handle the looping over
the flag bits there as well.  Then we can load the caller-saves once, prior
to calling do_work_pending(), and when we return we're guaranteed to have
interrupts disabled and TIF_ALLWORK clear.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

