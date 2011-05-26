Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab1EZTkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:40:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab1EZTkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:40:41 -0400
Date: Thu, 26 May 2011 21:39:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, acme@redhat.com, eranian@google.com,
        tzanussi@gmail.com, penberg@cs.helsinki.fi,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        davej@redhat.com, davem@davemloft.net, fweisbec@gmail.com,
        kees.cook@canonical.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf symbols: Handle
 /proc/sys/kernel/kptr_restrict
Message-ID: <20110526193946.GA6363@elte.hu>
References: <tip-mt512joaxxbhhp1odop04yit@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-mt512joaxxbhhp1odop04yit@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Commit-ID:  ec80fde746e3ccf93895d25ae1a7071c9af52585
> Gitweb:     http://git.kernel.org/tip/ec80fde746e3ccf93895d25ae1a7071c9af52585
> Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> AuthorDate: Thu, 26 May 2011 09:53:51 -0300
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Thu, 26 May 2011 11:15:25 -0300
> 
> perf symbols: Handle /proc/sys/kernel/kptr_restrict

Ok, things are much better now with kptr_restrict turned on - but i 
still see a few rough edges in practice.

For example 'perf top' says:

  aldebaran:~/linux> perf top
  [kernel.kallsyms] with build id 122214021a666675f6e5ff97d70a85ce7139c0e7 not found, continuing without symbols
  The (null) file can't be used

Now we've confused the user, havent we? :-)

Also, if i run 'perf top' with the proper vmlinux in the cwd, i do 
not get any warning messages - despite both module symbols not being 
available and potetial relocations not being considered.

Secondly, even though i have the proper 'vmlinux' in cwd, i get half 
a page long warnings on perf record warning me about the vmlinux:

  WARNING: Kernel address maps (/proc/{kallsyms,modules}) are restricted, check /proc/sys/kernel/kptr_restrict.

  Samples in kernel functions may not be resolved if a suitable 
  vmlinux file is not found in the buildid cache or in the vmlinux 
  path.

  ...

But a vmlinux file *is* in the cwd.

One detail i noticed in the patch:

>  	symbol__init();
>  
> +	if (symbol_conf.kptr_restrict)
> +		pr_warning("WARNING: Kernel address maps "
> +			   "(/proc/{kallsyms,modules}) are restricted, "
> +			   "check /proc/sys/kernel/kptr_restrict.\n\n"
> +			   "Samples in kernel functions may not be resolved "
> +			   "if a suitable vmlinux file is not found in the "
> +			   "buildid cache or in the vmlinux path.\n\n"
> +			   "Samples in kernel modules won't be resolved "
> +			   "at all.\n\n"
> +			   "If some relocation was applied (e.g. kexec) "
> +			   "symbols may be misresolved even with a suitable "
> +			   "vmlinux or kallsyms file.\n\n");


messages broken mid-line just to make it look better is really bad 
and can break git grep searches for the string as seen on the screen, 
such as:

   git grep="are restricted, check"

The solution i use in such cases is to deviate in a common-sense way 
from the standard coding style:

	if (symbol_conf.kptr_restrict) {
		pr_warning(
"WARNING: Kernel address maps (/proc/{kallsyms,modules}) are restricted, check /proc/sys/kernel/kptr_restrict.\n\n"
"Samples in kernel functions may not be resolved if a suitable vmlinux file is not found in the buildid cache or in the vmlinux path.\n\n"
"Samples in kernel modules won't be resolved at all.\n\n"
"If some relocation was applied (e.g. kexec) symbols may be misresolved even with a suitable vmlinux or kallsyms file.\n\n");
	}

This has the big advantage that you can check how the *user* will see 
this message.

Had you done this you'd have immediately noticed that the individual 
lines are *way* too large to fit on even large terminals. Please 
break such messages in a much shorter fashion - we want the error 
messages we output to be readable even on relatively small (80col) 
terminals.

Thanks,

	Ingo
