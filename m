Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab0KOBTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 20:19:46 -0500
Received: from tundra.namei.org ([65.99.196.166]:50636 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257Ab0KOBTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 20:19:44 -0500
Date: Mon, 15 Nov 2010 12:16:33 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Joe Perches <joe@perches.com>, Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
In-Reply-To: <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1011151155240.20099@tundra.namei.org>
References: <1289669176.16461.12.camel@Joe-Laptop> <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com> <1289677904.16461.82.camel@Joe-Laptop> <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Nov 2010, Linus Torvalds wrote:

[Adding the LSM list]

> CONFIG_SECURITY_DMESG_RESTRICT is supposed to be about the initial
> _value_ of dmesg_restrict, not about whether it exists or not. If you
> don't have CONFIG_SECURITY, you still end up defaulting to the common
> capability model, and it would still want that dmesg_restrict thing.
> 
> But what can make sense is to move "dmesg_restrict" into
> security/commoncap.c, and just make it about capabilities. Of course,
> that then means that if you use some other security model that just
> doesn't care about capabilities at all, they'll never care about
> dmesg_restrict either. So that, to me, smells of really bad interface
> design.

Yes, it should not be possible for an LSM to reduce the default security 
-- an interface which allows this breaks the security model.

> We had this exact problem with the whole "mmap_min_addr" thing. People
> _thought_ of it as generic, but because it was actually tested by the
> security logic, if you ended up enabling SELinux the test actually
> went away entirely (or maybe it was the other way around). So with
> certain security models, the whole thing was bypassed, and the
> security module actually became an _IN_security module.
>
> That's why I don't think we should do things like this inside the
> security models themselves. People just get really confused about what
> the real semantics are.
> 
> If something should be generic (and by all accounts, that's the
> intention of 'dmesg_restrict', the same way it was for
> 'mmap_min_addr'). Which is why I'd change the whole idiotic
> security_syslog() model itself as per the patch I just sent out.

Looks like the right approach to me.

Kees, does this patch work for you?

I want to ensure that LSMs which implement security_syslog can't end up 
with a less secure system than the default, regardless of whether they 
call cap_syslog or not.


- James
-- 
James Morris
<jmorris@namei.org>
