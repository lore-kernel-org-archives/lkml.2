Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0F1SGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 14:06:10 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53508 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab0F1SGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 14:06:07 -0400
Date: Mon, 28 Jun 2010 11:04:28 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Veaceslav Falico <vfalico@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Steve Grubb <sgrubb@redhat.com>,
       Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100628180428.GQ4175@outflux.net>
References: <20100624190527.GD5917@outflux.net>
 <20100625082722.8031.A69D9226@jp.fujitsu.com>
 <1277747318.4840.9.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277747318.4840.9.camel@wall-e.seibold.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 07:48:38PM +0200, Stefani Seibold wrote:
> Am Freitag, den 25.06.2010, 08:56 +0900 schrieb KOSAKI Motohiro:
> > > Through get_task_comm() and many direct uses of task->comm in the kernel,
> > > it is possible for escape codes and other non-printables to leak into
> > > dmesg, syslog, etc.  In the worst case, these strings could be used to
> > > attack administrators using vulnerable terminal emulators, and at least
> > > cause confusion through the injection of \r characters.
> > > 
> > > This patch sanitizes task->comm to only contain printable characters
> > > when it is set.  Additionally, it redefines get_task_comm so that it is
> > > more obvious when misused by callers (presently nothing was incorrectly
> > > calling get_task_comm's unsafe use of strncpy).
> > > 
> > > Signed-off-by: Kees Cook <kees.cook@canonical.com>
> > 
> > I've reviewed this patch briefly, Here is my personal concern...
> > 
> > On Linux, non-printable leaking is fundamental, only fixing task->comm
> > doesn't solve syslog exploit issue. Probably all /proc/kmsg user should
> > have escaping non-pritables code.
> > 
> > However, task->comm is one of most easy injection data of kernel, because
> > we have prctl(PR_SET_NAME), attacker don't need root privilege. So,
> > conservative assumption seems guard from crappy fault. Plus, this patch
> > is very small and our small TASK_COMM_LEN lead that we don't need
> > big performance concern.
> > 
> > So, I don't find demerit in this proposal. but I'm not security specialist,
> > it's only personal thinking.
> > 
> Agree. I think a escaped printk should be a more generic solution.

I think sanitizing inputs is more effective than sanitizing outputs.
If ->comm is safe internally, then we don't have to filter it going out
on printk, audit, /proc output, etc.  There is a limited number of places
where a process has control over an arbitrary string in kernel structures,
so the places where they are set should be fixed instead of fixing every
possible usage of it on output.

I wouldn't mind sanitizing printk also, but it's tangential to sanitizing
task->comm when it is set.

-Kees

-- 
Kees Cook
Ubuntu Security Team
