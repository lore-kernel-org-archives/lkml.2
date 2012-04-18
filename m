Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2DRRCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:02:32 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53530 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2DRRCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:02:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120418031935.GB29828@redhat.com>
References: <20120417172142.GA30237@redhat.com> <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
 <20120417203223.GA31699@redhat.com> <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
 <20120418031935.GB29828@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Apr 2012 10:02:06 -0700
X-Google-Sender-Auth: m9ETUsSpx1Hgz6Xe5hFY0O7HFn0
Message-ID: <CA+55aFwrARr4=ZztWseFbND1h6W=QV52r98qioL+bK6jKrehSA@mail.gmail.com>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 8:19 PM, Dave Jones <davej@redhat.com> wrote:
>
> So now that I'm instrumenting it, it's taking a lot longer to trigger
> (how typical). Almost 6 hours in though, it's down to 72 bytes, and spewed
> the traces below, which look pretty.. deep.

Yeah. Sadly, they are less useful than I was hoping for. It's not some
single deep call-chain, it's almost all debug stuff and the "did we
release the RCU lock" or preemption checks, which I guess makes sense.
You have tons of options enabled in your kernel that makes for deeper
stack traces, and then all the interesting stuff gets overwritten by
what happened later.

For example, it looks like you have the USB serial console enabled,
and some of those deep stack traces are about that - and largely got
overwritten by the "dump_trace()" logic itself. So dump_trace()
printing stuff out also ended up overwriting the stack trace that we
were interested in.

I assume you have USB serial console on for a reason (ie: great for
catching oopses before the machine dies), but in this case it hurts.

Could you try just adding a

   console_lock();
   ...
   console_unlock();

around the show_trace() call. That will force the code to not actually
call down to the console layer until after the console_unlock(), so
the printing of the stack trace won't affect the stack *too* much.

That said, if you get the function tracer thing working, that will
give much nicer backtraces.

                   Linus
