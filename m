Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab2F0NBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:01:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56453 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab2F0NBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:01:41 -0400
Date: Wed, 27 Jun 2012 08:01:25 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Doug Ledford <dledford@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC, PATCH] CLONE_NEWIPC and exit_group()
Message-ID: <20120627130125.GA23431@sergelap>
References: <20120626120425.GA10275@otc-wbsnb-06>
 <20120627123455.GA32171@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627123455.GA32171@altlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dmitry V. Levin (ldv@altlinux.org):
> Hi,
> 
> On Tue, Jun 26, 2012 at 03:04:26PM +0300, Kirill A. Shutemov wrote:
> > Patch to move kern_unmount() out of exit_group() code path is below.
> > Dmitry, could you check if it's beneficial for your use-case?
> 
> I've benchmarked a slightly modified test which is closer to our use-case
> (child processes are forked sequentially):

Did you run this in parallel, perhaps with numcpus/2 jobs plus a
hackbench running on the side?

> #define _GNU_SOURCE
> #include <unistd.h>
> #include <sched.h>
> #include <stdlib.h>
> #include <sys/wait.h>
> 
> int
> main(void)
> {
> 	int i;
> 	for (i = 0; i < 1024; i++) {
> 		if (fork()) {
> 			wait(NULL);
> 			continue;
> 		}
> 		unshare(CLONE_NEWIPC);
> 		exit(0);
> 	}
> 	return 0;
> }
> 
> On 3.4.4 with rcu_barrier patch:
> 0.09user 0.00system 0:32.77elapsed 0%CPU (0avgtext+0avgdata 1472maxresident)k
> 0inputs+0outputs (0major+38017minor)pagefaults 0swaps
> 
> On 3.4.4 with rcu_barrier patch and your new patch:
> 0.00user 0.06system 0:32.77elapsed 0%CPU (0avgtext+0avgdata 1472maxresident)k
> 0inputs+0outputs (0major+38017minor)pagefaults 0swaps
> 
> So there is a clear difference in accounting (user vs system)

Yup, I'd argue that's a bad thing :)

> but no
> noticeable difference in the real time.

Thanks for testing!

-serge
