Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab0KNCpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 21:45:38 -0500
Received: from smtp.outflux.net ([198.145.64.163]:48420 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab0KNCph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 21:45:37 -0500
Date: Sat, 13 Nov 2010 18:44:44 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with
 CONFIG_EMBEDDED=y and CONFIG_PRINTK=n
Message-ID: <20101114024444.GG13854@outflux.net>
References: <1289669176.16461.12.camel@Joe-Laptop>
 <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 09:50:22AM -0800, Linus Torvalds wrote:
> So I would suggest guarding the whole thing, and just returning 0 if
> CONFIG_PRINTK isn't set. Or preferably just move the dmesg_restrict
> test into do_syslog, and stop playing stupid games with
> "security_syslog()", which actually goes away if you disable the you
> disable CONFIG_SECURITY.
> 
> SECURITY_DMESG_RESTRICT is totally independent of CONFIG_SECURITY, so
> doing it in security_syslog() was a bug to begin with.
> 
> Or we should make SECURITY_DMESG_RESTRICT _depend_ on CONFIG_SECURITY,
> and move it entirely into security/commoncap.c, and not pollute
> kernel/printk.c at all with it.

It seems saner to put it in commoncaps to me, but either way, it must happen
after the from_file and OPEN test or it will break /proc/kmesg readers who
open and drop privs (as done with sysklogd, etc).

> +	if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
>...
>  {
>  	if (type != SYSLOG_ACTION_OPEN && from_file)
>  		return 0;
> -	if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
> -		return -EPERM;

i.e.

if (dmesg_restrict && (!from_file || type == SYSLOG_ACTION_OPEN) &&
    !capable(CAP_SYS_ADMIN))

-Kees

-- 
Kees Cook
Ubuntu Security Team
