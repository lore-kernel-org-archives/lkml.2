Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab0JUOSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:18:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756881Ab0JUOSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:18:36 -0400
MIME-Version: 1.0
In-Reply-To: <1287669539-22644-1-git-send-email-jslaby@suse.cz>
References: <1287669539-22644-1-git-send-email-jslaby@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Oct 2010 07:17:34 -0700
Message-ID: <AANLkTinZNekvQHn4FYm-aJqGziV_zeUkdwtWWDb09ofm@mail.gmail.com>
Subject: Re: [PATCH 1/1] Char: TTY, restore tty_ldisc_wait_idle
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 6:58 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> It was removed in 65b770468e98 (tty-ldisc: turn ldisc user count into
> a proper refcount), but we need to wait for last user to quit the
> ldisc before we close it in tty_set_ldisc.
>
> Otherwise weird things start to happen. There might be processes
> waiting in tty_read->n_tty_read on tty->read_wait for input to appear
> and at that moment, a change of ldisc is fatal. n_tty_close is called,
> it frees read_buf and the waiting process is still in the middle of
> reading and goes nuts after it is woken.

Hmm. Looks reasonable. And the waiting is outside the lock, so there
aren't any of the problem cases that caused the original changes. And
we don't need the lock, because the TTY_LDISC_CHANGING bit will
protect against anything new coming in, so we don't have races with
the count going up afterwards.

And you're right about the lockless approach being reasonable inside
the testing code too - it's atomic as you say, and we don't touch/care
about anything else.

So I don't have any objections, apart from thinking that the ldisc
code is apparently still too fragile if this is needed.  But the ldisc
change is so special that I don't think this is a unreasonable hack.
Even if it _is_ a bit of a hack still.

So feel free to add an acked-by: from me. Whoever saw the problem
should probably test the patch first, though.

                                Linus
