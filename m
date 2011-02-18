Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab1BRUFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:05:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44350 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412Ab1BRUFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:05:38 -0500
Date: Fri, 18 Feb 2011 21:05:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86: Combine printk()s in show_regs_common()
Message-ID: <20110218200528.GA4966@elte.hu>
References: <4D5D535A0200007800032730@vpn.id2.novell.com>
 <tip-fd8fa4d3ddc4cc04ec8097e632b995d535c52beb@git.kernel.org>
 <1298058105.15565.4.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298058105.15565.4.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Fri, 2011-02-18 at 10:40 +0000, tip-bot for Jan Beulich wrote:
> > Commit-ID:  fd8fa4d3ddc4cc04ec8097e632b995d535c52beb
> > Gitweb:     http://git.kernel.org/tip/fd8fa4d3ddc4cc04ec8097e632b995d535c52beb
> > Author:     Jan Beulich <JBeulich@novell.com>
> > AuthorDate: Thu, 17 Feb 2011 15:56:58 +0000
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 18 Feb 2011 08:52:30 +0100
> > 
> > x86: Combine printk()s in show_regs_common()
> > 
> > Printing a single character alone when there's an immediately
> > following printk() is pretty pointless (and wasteful).
> 
> Ingo, why did you choose to apply this patch instead of
> the alternative one I posted on the same thread?

Your version:

	/* Board Name is optional */
	board = dmi_get_system_info(DMI_BOARD_NAME);
	if (!board)
		board = "";

	printk(KERN_CONT "\n");

	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s %s%s%s\n",
	       current->pid, current->comm, print_tainted(),
	       init_utsname()->release,
	       (int)strcspn(init_utsname()->version, " "),
	       init_utsname()->version,
	       vendor, product,
	       strlen(board) ? "/" : "",
	       board);

The 'board' fiddling and the strlen(board) check complicates things unnecessarily 
and makes the code hard to read. Jan's version was at least simple.

Something like this:

	/* Board Name is optional */
	board = dmi_get_system_info(DMI_BOARD_NAME);

	printk(KERN_CONT "\n");

	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s %s %s %s\n",
	       current->pid, current->comm, print_tainted(),
	       init_utsname()->release,
	       (int)strcspn(init_utsname()->version, " "),
	       init_utsname()->version,
	       vendor, product, board ? : "");

Would be easier to read and gives similarly useful output.

Thanks,

	Ingo
