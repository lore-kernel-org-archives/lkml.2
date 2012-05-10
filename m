Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761379Ab2EJAAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:00:40 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50328 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760488Ab2EJAAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:00:38 -0400
MIME-Version: 1.0
In-Reply-To: <4FAAEB37.1080001@siemens.com>
References: <4FAAEB37.1080001@siemens.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 May 2012 17:00:16 -0700
X-Google-Sender-Auth: AheXYFhQ78X0ZUTMjnaMssQNmEc
Message-ID: <CA+55aFz-z6F=ynvTZp2xrSyq+Ar7huT92_S9e8Wuxepyppq5ZQ@mail.gmail.com>
Subject: Re: [PATCH] compat: Fix RT signal mask corruption via sigprocmask
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Anthony Liguori <aliguori@us.ibm.com>, Kevin Wolf <kwolf@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 3:09 PM, Jan Kiszka <jan.kiszka@siemens.com> wrote:
> compat_sys_sigprocmask reads a smaller signal mask from userspace than
> sigprogmask accepts for setting. So the high word of blocked.sig[0] will
> be cleared, releasing any potentially blocked RT signal.

I see what you're trying to do, but I think your patch is wrong.

It may work for SIG_BLOCK and SIG_SETMASK to use the current blocked
bits in the high bits, but I'm pretty sure it doesn't work at all for
SIG_UNBLOCK.

I suspect that compat_sys_sigprocmask() should simply be rewritten to
*not* use sys_sigprocmask() at all, but simply open-code the three
cases directly. IOW, copy the code from sys_sigprocmask(), and modify
it for an incoming/outgoing compat_old_sigset_t.

Hmm?

                    Linus
