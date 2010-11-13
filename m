Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0KMUcB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 15:32:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756192Ab0KMUcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 15:32:00 -0500
MIME-Version: 1.0
In-Reply-To: <1289677904.16461.82.camel@Joe-Laptop>
References: <1289669176.16461.12.camel@Joe-Laptop> <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
 <1289677904.16461.82.camel@Joe-Laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 13 Nov 2010 12:31:03 -0800
Message-ID: <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
To: Joe Perches <joe@perches.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 11:51 AM, Joe Perches <joe@perches.com> wrote:
>
> Maybe something like this?
>
> Make CONFIG_SECURITY_DMESG_RESTRICT depend on CONFIG_SECURITY
> Remove dependency on CONFIG_PRINTK

No, this is wrong:

> +#ifdef CONFIG_SECURITY_DMESG_RESTRICT
> +extern int dmesg_restrict;
> +#endif

CONFIG_SECURITY_DMESG_RESTRICT is supposed to be about the initial
_value_ of dmesg_restrict, not about whether it exists or not. If you
don't have CONFIG_SECURITY, you still end up defaulting to the common
capability model, and it would still want that dmesg_restrict thing.

But what can make sense is to move "dmesg_restrict" into
security/commoncap.c, and just make it about capabilities. Of course,
that then means that if you use some other security model that just
doesn't care about capabilities at all, they'll never care about
dmesg_restrict either. So that, to me, smells of really bad interface
design.

We had this exact problem with the whole "mmap_min_addr" thing. People
_thought_ of it as generic, but because it was actually tested by the
security logic, if you ended up enabling SELinux the test actually
went away entirely (or maybe it was the other way around). So with
certain security models, the whole thing was bypassed, and the
security module actually became an _IN_security module.

That's why I don't think we should do things like this inside the
security models themselves. People just get really confused about what
the real semantics are.

If something should be generic (and by all accounts, that's the
intention of 'dmesg_restrict', the same way it was for
'mmap_min_addr'). Which is why I'd change the whole idiotic
security_syslog() model itself as per the patch I just sent out.

                               Linus
