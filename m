Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1GDOm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:42:29 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63373 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1GDOmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:42:25 -0400
X-Nat-Received: from [202.181.97.72]:54846 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1309790531.25346
To: richard@nod.at
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1309779003-8668-1-git-send-email-richard@nod.at>
	<201107041357.43481.richard@nod.at>
	<201107042110.EDI30723.OLFHOtQSMOFFJV@I-love.SAKURA.ne.jp>
	<201107041420.31049.richard@nod.at>
In-Reply-To: <201107041420.31049.richard@nod.at>
Message-Id: <201107042342.HDH34381.OFtHSLOMVFJFOQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 4 Jul 2011 23:42:09 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04072011 #5726947, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> > That's strange... Would you show us printk() output like
> > 
> > 	printk(KERN_INFO "Calling request_module()\n");
> > 	request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
> > 	printk(KERN_INFO "Returned from request_module()\n");
> > 
> > for demonstrating that __request_module() cannot stop at
> > MAX_KMOD_CONCURRENT levels of nesting?
> 
> There you go!
> http://userweb.kernel.org/~rw/boot.log
> 
> I did not count all messages, but they are more than 50. :-)

Thank you.

$ grep -F 'Calling request_module()' boot.log | wc -l
25819
$ grep -F 'Returned from request_module()' boot.log | wc -l
25770

So, __request_module() is stopping at MAX_KMOD_CONCURRENT levels
of nesting. Eventually the process that triggered the first
request_module() will return from search_binary_handler().
I don't think this is an infinite loop inside search_binary_handler().

But it would look like an infinite loop bug if the caller of execve()
repeats forever. Printing additional information like

  printk(KERN_INFO "Calling request_module() %s %d %s %d %d\n", current->comm,
         current->pid, bprm->filename, bprm->argc, bprm->envc);

would help.
