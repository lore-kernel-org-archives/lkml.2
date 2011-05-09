Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1EIXRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:17:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932437Ab1EIXRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:17:52 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikLJPCc5ffobAb5uhdryRqjGhpVAQ@mail.gmail.com>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz>
 <alpine.LSU.2.00.1105081303540.16151@sister.anvils> <alpine.DEB.2.00.1105091307570.32299@artax.karlin.mff.cuni.cz>
 <BANLkTinCUQSjjif3op3H_9HDm5Eu-o+Luw@mail.gmail.com> <BANLkTim3kKJkisZK1mOgKhsEEs7FzZmyXA@mail.gmail.com>
 <1304979549.4865.56.camel@mulgrave.site> <BANLkTim7ATRyJ2NvoCj4Sv=7CLizKMd_WA@mail.gmail.com>
 <BANLkTi=DCKmN_BafFckKHOMfjWpVLQPDFA@mail.gmail.com> <BANLkTikkA5H2D23u23FV0cTcL2bAT8BKWQ@mail.gmail.com>
 <BANLkTikLJPCc5ffobAb5uhdryRqjGhpVAQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 May 2011 16:17:29 -0700
Message-ID: <BANLkTiksgtgviJGmq925OtLNU4QynVLVtg@mail.gmail.com>
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
To: Tony Luck <tony.luck@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Fenghua Yu <fenghua.yu@intel.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 4:08 PM, Tony Luck <tony.luck@gmail.com> wrote:
>
> Definitely not for normal processes - I'm not sure how both stacks are
> set up for threads.

We don't actually allow user space to set the growsup/growsdown bits
any more (we have PROT_GROWSUP and PROT_GROWSDOWN, but that is to
allow mprotect to not give an exact range, but say "apply this to the
end of a growsup/growsdown segment").

So the only thing that has those bits are things that the kernel sets
explicitly at exec time. So if ia64 doesn't set it, we're all good.

>> One thing I did want to verify: did the mlockall() actually change the
>> stack size without that patch? Just to double-check that the patch
>> actually did change semantics visibly.
>
> On an unpatched system I see this (lots more than one page of growth -
> pages are 64K on this config):
> 6007fffffff50000-6007fffffff70000 rw-p 00000000 00:00 0
> 6007fffffff50000-6008000000750000 rw-p 00000000 00:00 0
>
> On a patched system I see (this one has 16K pages - no growth)
> 600007ffff9d0000-600007ffff9d4000 rw-p 00000000 00:00 0
> 600007ffff9d0000-600007ffff9d4000 rw-p 00000000 00:00 0

Ok, I'll consider it tested. I'll commit it with Mikulas as author,
but note that I edited it so he won't get the blame if there's some
problem.

                             Linus
