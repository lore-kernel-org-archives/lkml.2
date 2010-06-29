Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0F2Jdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:33:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54526 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754284Ab0F2Jdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:33:42 -0400
Date: Tue, 29 Jun 2010 10:36:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Veaceslav Falico <vfalico@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Stefani Seibold <stefani@seibold.net>,
       Thomas Gleixner <tglx@linutronix.de>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Steve Grubb <sgrubb@redhat.com>,
       Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100629103650.3b80e09f@lxorguk.ukuu.org.uk>
In-Reply-To: <20100624190527.GD5917@outflux.net>
References: <20100624190527.GD5917@outflux.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Through get_task_comm() and many direct uses of task->comm in the kernel,
> it is possible for escape codes and other non-printables to leak into
> dmesg, syslog, etc.  In the worst case, these strings could be used to
> attack administrators using vulnerable terminal emulators, and at least
> cause confusion through the injection of \r characters.

If an administrator has a vulnerable terminal emulator they have other
problems.

> This patch sanitizes task->comm to only contain printable characters
> when it is set.  Additionally, it redefines get_task_comm so that it is
> more obvious when misused by callers (presently nothing was incorrectly
> calling get_task_comm's unsafe use of strncpy).

This is a regression for tools that correctly handle unmutilated data.

> +	/* sanitize non-printable characters */
> +	for (i = 0; buf[i] && i < (sizeof(tsk->comm) - 1); i++) {
> +		if (!isprint(buf[i]))
> +			tsk->comm[i] = '?';

The kernel "isprint" isn't adequate for this. comm is set by the shell
based on argv[0] usually which means that in normal situations it is a
UTF-8 string.

Please do any filtering you must in the yama security module where it
only affects that. One way to approach it without losing data within the
module might be to use HTML style encoding within Yama so your own tools
can undo the 'sanitizing' rather than losing information ?

Ideally you want to the dev/inode pair of the thing being executed
printed as well - that will give real information for security purposes,
while the ->comm data is much more convenient for general debugging and
investigation than having to keep looking them up.

Alan
