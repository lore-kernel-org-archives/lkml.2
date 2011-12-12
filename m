Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1LLSzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:55:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63819 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1LLSzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:55:20 -0500
MIME-Version: 1.0
In-Reply-To: <tip-890890cb8e415e1e7a61bfe3c8e246f710196824@git.kernel.org>
References: <20111211181319.GA17097@p183.telecom.by> <tip-890890cb8e415e1e7a61bfe3c8e246f710196824@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Dec 2011 10:54:58 -0800
X-Google-Sender-Auth: PQ__iFQomq97mi5zSdOay5CD2i8
Message-ID: <CA+55aFwKaOwLm2U6iA1_ytdYUynt2x90yUxFaXkapkrWt2P-Gg@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86/i386: Use less assembly in strlen(), speed
 things up a bit
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        adobriyan@gmail.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:37 AM, tip-bot for Alexey Dobriyan
<adobriyan@gmail.com> wrote:
>
> x86/i386: Use less assembly in strlen(), speed things up a bit

We could probably remove the thing entirely, and just use the generic
strlen. Some of the rep instruction usage is just purely historic,
there's little point.

Using "repne; scasb" is possibly worth it when inlined. And especially
with the change in this patch-set, where inlining also combines with
things like expression simplification, and then things like
"strlen(s)+1" (common for sizing allocations) the compiler can
actually remove the "-1" part entirely. Then the advantage of 'repne
scas' is that it's short.

But for out-of-line, we might actually be better off with just a
traditional loop. Not because we can do multiple bytes in a go (most
kernel strings are likely short enough that it's not a big deal), but
simply because 'repne scas' is not generally all that fast.

I dunno. strlen() usually isn't very hot, so it probably doesn't
matter. The really hot paths tend to do something like computing a
hash at the same time as checking the length of the string or need
something more complex anyway (ie the "hash and find '\0' or '/' in a
pathname" that path walking does). Pure strlen() is reasonably rare.

So it probably doesn't matter. The patch looks like a nice cleanup.

                      Linus
