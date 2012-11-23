Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab2KWXNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 18:13:15 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64336 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab2KWXNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 18:13:13 -0500
X-Nat-Received: from [202.181.97.72]:62515 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1353712357.11655
To: ppandit@redhat.com
Cc: keescook@chromium.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        josh@joshtriplett.org, serge.hallyn@canonical.com,
        linux-fsdevel@vger.kernel.org, me@halfdog.net
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LFD.2.02.1211182211350.5012@wniryva.cad.erqung.pbz>
	<CAGXu5jJ4ZuviFMQcFocLWfcMreZSt4kCHFNm-PNW+yuy+v+FiQ@mail.gmail.com>
	<alpine.LFD.2.02.1211191158550.5042@wniryva.cad.erqung.pbz>
	<CAGXu5jKY90dsnUjLcjC43Djoe53HEAffugtaEfsBphtp7j_A7g@mail.gmail.com>
	<alpine.LFD.2.02.1211240004060.15883@wniryva.cad.erqung.pbz>
In-Reply-To: <alpine.LFD.2.02.1211240004060.15883@wniryva.cad.erqung.pbz>
Message-Id: <201211240812.HAE95846.FSQOFFtOJHLOMV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 24 Nov 2012 08:12:36 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 23112012 #8503182, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

P J P wrote:
> 
>    Hello Kees, all,
> 
> Please have a look at a *NEW* patch at the end of this mail. It seems to fix 
> both the issues, stack disclosure + undue recursions.
> 
> It uses modprobe "--first-time" option which returns an error code when trying 
> to load a module which is already present or unload one which is not present.

It might fix both "stack disclosure" + "undue recursions" issues, but it
introduces a regression "only one of concurrent requesters succeeds" which
ruins the value of automatic module loading feature.

> @@ -1423,7 +1423,14 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
>  				break; /* -ENOEXEC */
>  			if (try)
>  				break; /* -ENOEXEC */
> -			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));

What happens if more than one processes are requesting execve() of a program
which needs to call request_module("binfmt-%04x") to succeed, and more than two
of them concurrently reached at this line? Only one process will succeed. This
means that execve() of a program which needs to call request_module() will fail
if concurrently reached here.

> +            if (request_module("binfmt-%04x",
> +                                *(unsigned short *)(&bprm->buf[2])))
> +            {
> +                printk(KERN_WARNING
> +                        "request_module: failed to load: binfmt-%04x",
> +                         *(unsigned short *)(&bprm->buf[2]));
> +                break;
> +            }
>  		}
>  #else
>  		break;
