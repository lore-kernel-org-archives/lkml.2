Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2FWP2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 11:28:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51616 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754688Ab2FWP2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 11:28:12 -0400
Message-ID: <1340465290.2274.26.camel@joe2Laptop>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Sat, 23 Jun 2012 08:28:10 -0700
In-Reply-To: <1340452052.1784.40.camel@mop>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
	 <20120622145402.8047a669.akpm@linux-foundation.org>
	 <20120623061313.GA21895@gmail.com> <1340452052.1784.40.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-23 at 13:47 +0200, Kay Sievers wrote:
[]
> We need make some sort of a compromise for the self-tests here, I guess.
> I think the trade of using one of these options for the self-tests to
> cope with the new model is justified:
> - flush explicitly when it is needed, by a global flag or with a
>   message prefix

> - printing a second full line that says: test foo OK, instead
>   of appending the OK to the former line

This is probably the easiest actual fix.

> - printing one full line, and suppress the later OK entirely. The OK
>   might not be needed at all; we will find out that the machine
>   has not crashed at that point and a message in case of an error
>   could be sufficient in most cases.

I think the added timing information useful.

> Reverting the changes now would remove:
> - proper device identifiers attached to a message, which allows
>   tools for the first time to know the contexts of the kernel messages

I think this is not particularly true nor really useful at
present and the [v]printk_emit parts should be removed
until a the benefit of such a capability more proven.

I'm still concerned someone is going to say that the
because you say these things, someone else is going to
declare that the content of the [v]printk_emit bits is
effectively an ABI (inviolate and immutable) like the
seq_ functions.  I think that'd make changing any of the
logging much more difficult and should be avoided.

> - 100% message integrity of structured messages, and single line
>   prints, and if only one continuation line user prints at a time.
>   We never mix continuation users with full line users, like the
>   old buffer did.
> - very reliable continuation line prints, because of the buffering.
>   The only race that can still happen is several cont users racing
>   against each other, which is not too likely

It's hard to say that it's not too likely.  I think it
depends on cpu count.  More cpus, more likely.

Still, it's decidedly better than it was.

> - 100% granularity at line level during userspace buffer access,
>   crash dumping; we never copy around half or overwritten lines,
>   like the old buffer
> - the ring buffer prunes only entire messages not just the half
>   of a line like the old byte buffer
> - sequence numbers allow us to track the state of the read and write
>   position in the buffer, so we never copy in-the-meantime already
>   overwritten messages around
> - sequence numbers which allow userspace to reconnect to the old reading
>   position and process only new messages, and find if messages got
>   overwritten
> - support for multiple concurrent readers with live update of the kernel
>   log stream

Good features list and it was well implemented too.

I think the uses of the direct emit model should simply
be updated to full lines as you suggested.  There are not
too many files that need touching.

