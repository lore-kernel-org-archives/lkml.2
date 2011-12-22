Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1LVCT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 21:19:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37626 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1LVCT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 21:19:56 -0500
MIME-Version: 1.0
In-Reply-To: <20111221170535.GB9213@google.com>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com> <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com> <alpine.DEB.2.00.1112210851230.9601@router.home>
 <20111221170535.GB9213@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Dec 2011 18:19:34 -0800
X-Google-Sender-Auth: cL_XvVMp0Q_zj8MJgrAQbLv1NOw
Message-ID: <CA+55aFyr69__vsorCXKZ7UezvXkCkZaot3=5b5xSHaYBEJ2ZKQ@mail.gmail.com>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 9:05 AM, Tejun Heo <tj@kernel.org> wrote:
>
> machines.  (cc'ing arch) Does anyone have better insight here?  How
> much more expensive are local irq save/restore compared to inc/dec'ing
> preempt count on various archs?

I think powerpc does sw irq disable, so it's pretty much the same.

However, on *most* architectures, if the stupid generic "disable
interrupts and then do the op" is too expensive, they could easily
just do an architecture-specific "safe" version. Especially if they
only need to do cmpxchg and add.

Many architectures can do those safely with load-locked,
store-conditional (ie atomic_add), and do so quickly. Sure, there are
broken cases wher ethat is really slow (original alpha is an example
of that), but I think it's fairly rare.

So both arm (in v6+) and powerpc should be able to just use the
"atomic_add" version, with no real downside.

So I really suspect that we could just say: "make the irq-safe version
be the *only* version", and no architecture will really care. Sure, it
can be more expensive, but it usually isn't. Only when done badly and
stupidly is it nasty.

                  Linus
