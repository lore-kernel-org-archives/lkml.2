Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0F2Ox2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:53:28 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42012 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab0F2Ox1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 10:53:27 -0400
Date: Tue, 29 Jun 2010 07:51:37 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
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
Message-ID: <20100629145137.GD4175@outflux.net>
References: <20100624190527.GD5917@outflux.net>
 <20100629103650.3b80e09f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629103650.3b80e09f@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 10:36:50AM +0100, Alan Cox wrote:
> > Through get_task_comm() and many direct uses of task->comm in the kernel,
> > it is possible for escape codes and other non-printables to leak into
> > dmesg, syslog, etc.  In the worst case, these strings could be used to
> > attack administrators using vulnerable terminal emulators, and at least
> > cause confusion through the injection of \r characters.
> 
> If an administrator has a vulnerable terminal emulator they have other
> problems.

Totally agreed.

> Please do any filtering you must in the yama security module where it
> only affects that. One way to approach it without losing data within the
> module might be to use HTML style encoding within Yama so your own tools
> can undo the 'sanitizing' rather than losing information ?

I'm not interested in sanitizing this in Yama.  The use of task->comm via
printk was seen as a flaw.  I didn't agree (see above about terminal),
and suggested that if it was a flaw, it was a flaw with printk or
task->comm itself.  Since "fixing" both of those have been vetoed,
I have no more interest in the filtering.

What I do have interest in is fixing get_task_comm's use of buffers, which
is theoretically problematic in some future where someone accidentally
calls it with a buffer smaller than sizeof(task->comm).

I'll send a patch that only fixes that and leaves out the filtering.

-Kees

-- 
Kees Cook
Ubuntu Security Team
