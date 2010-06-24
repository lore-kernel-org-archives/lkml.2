Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0FXX4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 19:56:34 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42421 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0FXX4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 19:56:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Kees Cook <kees.cook@canonical.com>
Subject: Re: [PATCH v2] sanitize task->comm to avoid leaking escape codes
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Veaceslav Falico <vfalico@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Stefani Seibold <stefani@seibold.net>,
       Thomas Gleixner <tglx@linutronix.de>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Steve Grubb <sgrubb@redhat.com>,
       Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100624190527.GD5917@outflux.net>
References: <20100624190527.GD5917@outflux.net>
Message-Id: <20100625082722.8031.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Jun 2010 08:56:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Through get_task_comm() and many direct uses of task->comm in the kernel,
> it is possible for escape codes and other non-printables to leak into
> dmesg, syslog, etc.  In the worst case, these strings could be used to
> attack administrators using vulnerable terminal emulators, and at least
> cause confusion through the injection of \r characters.
> 
> This patch sanitizes task->comm to only contain printable characters
> when it is set.  Additionally, it redefines get_task_comm so that it is
> more obvious when misused by callers (presently nothing was incorrectly
> calling get_task_comm's unsafe use of strncpy).
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

I've reviewed this patch briefly, Here is my personal concern...

On Linux, non-printable leaking is fundamental, only fixing task->comm
doesn't solve syslog exploit issue. Probably all /proc/kmsg user should
have escaping non-pritables code.

However, task->comm is one of most easy injection data of kernel, because
we have prctl(PR_SET_NAME), attacker don't need root privilege. So,
conservative assumption seems guard from crappy fault. Plus, this patch
is very small and our small TASK_COMM_LEN lead that we don't need
big performance concern.

So, I don't find demerit in this proposal. but I'm not security specialist,
it's only personal thinking.



