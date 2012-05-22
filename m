Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab2EVBwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:52:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53127 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759620Ab2EVBwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:52:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120522011152.GA18115@redhat.com>
References: <20120522011152.GA18115@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 18:51:51 -0700
X-Google-Sender-Auth: 0cYX4pwoA9bIWPZMuLxWYnSu3c0
Message-ID: <CA+55aFwimihFb=JTFMraAhYFSwR6bBt_Pmwfx0wLybUDq1JQ0w@mail.gmail.com>
Subject: Re: 3.4+ dcache BUG.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 6:11 PM, Dave Jones <davej@redhat.com> wrote:
> Just hit this. Probably related to todays dcache changes ?

Almost certainly. Except:

> I'm not sure why, but the dcache.c line numbers don't match up..
> This kernel was v3.3-rc7-14528-g29db10d which looked like..

You seem to not have fetched any tags lately (so it says "3.3-rc7 +
14528 commits" instead of something more relevant), and I can't make
sense of that SHA1 either (29db10d) either.

You probably have other changes in your tree as well, explaining the
SHA1 that I don't recognize?

But that line number does match the BUG_ON() in d_free() of the
pre-careful name lookup dcache.c, so it's all sane apart from the odd
versions you have.

What was the load you used, btw? Considering that this hits the
d_free() BUG_ON(), I have a good guess about what is going on, and I
suspect that we *used* to be protected by the pointless d_unhashed()
check in fs/dcache.c.

I say "pointless", because it *should* be pointless. But your
backtrace is intriguing, since it says:

  sys_close -> filp_close -> fput -> dput -> d_kill -> d_free

and the only way you get from d_put to d_kill is through an unhashed dentry.

But the people who unhash the dentries *should* have either

 (a) happened after umount, when nobody can possibly actually match on
that dentry

OR

 (b) done the proper dentry sequence number dance to make sure we never use it.

that's why the d_unhashed() check got removed as "unnecessary". But
clearly I screwed it up.

What was the load that triggered this? Just a regular kernel compile?
I see the "comm: cc1" there, and I'm a bit surprised, since I ran
those patches here locally a *lot*. Is this perhaps some low-memory
scenario?

Anyway, thinking more about it, I'm starting to see why my thinking
about sequence counts was buggy. I think that happens is:

 - RCU lookup races with __d_drop

 - __d_drop unhashes the dentry, and does a "write_seqcount_barrier()"

 - the RCU lookup saw the old dentry pointer (that we unhashed), but
by the time it loaded the sequence number off it, it's the new
sequence number after the barrier.

 - so now all the sequence numbers check out ok, but we have a unhashed dentry

and I was just wrong about the d_unhashed() check being unnecessary
due to the sequence numbers.

I'll revert commit 8c01a529b861.

                      Linus
