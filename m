Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2AZTjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:39:25 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40850 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2AZTjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:39:24 -0500
Message-ID: <4F21ABE2.1060302@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 01:09:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiri Slaby <jirislaby@gmail.com>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Baohua.Song@csr.com, Tejun Heo <tj@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG at	kernel/workqueue.c:3659
References: <4F1EC8D5.5040102@suse.cz> <201201250002.37916.rjw@sisk.pl> <4F1F4717.2090704@gmail.com> <201201250110.44360.rjw@sisk.pl> <4F20204F.6040606@linux.vnet.ibm.com>
In-Reply-To: <4F20204F.6040606@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12012609-0260-0000-0000-00000072E7B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rafael,

On 01/25/2012 09:01 PM, Srivatsa S. Bhat wrote:

> 
> Ok, I will need to quote a part of the userspace utility to explain the
> problem.
> 
> In suspend.c inside the suspend-utils userspace package, I see a loop such
> as:
> 
>         error = freeze(snapshot_fd);
> 	...
>         attempts = 2;
>         do {
>                 if (set_image_size(snapshot_fd, image_size)) {
>                         error = errno;
>                         break;
>                 }
>                 if (atomic_snapshot(snapshot_fd, &in_suspend)) {
>                         error = errno;
>                         break;
>                 }
>                 if (!in_suspend) {
>                         /* first unblank the console, see console_codes(4) */
>                         printf("\e[13]");
>                         printf("%s: returned to userspace\n", my_name);
>                         free_snapshot(snapshot_fd);
>                         break;
>                 }
> 
>                 error = write_image(snapshot_fd, resume_fd, -1);
>                 if (error) {
>                         free_swap_pages(snapshot_fd);
>                         free_snapshot(snapshot_fd);
>                         image_size = 0;
>                         error = -error;
>                         if (error != ENOSPC)
>                                 break;
>                 } else {
>                         splash.progress(100);
> #ifdef CONFIG_BOTH
>                         if (s2ram_kms || s2ram) {
>                                 /* If we die (and allow system to continue)
>                                  * between now and reset_signature(), very bad
>                                  * things will happen. */
>                                 error = suspend_to_ram(snapshot_fd);
>                                 if (error)
>                                         goto Shutdown;
>                                 reset_signature(resume_fd);
>                                 free_swap_pages(snapshot_fd);
>                                 free_snapshot(snapshot_fd);
>                                 if (!s2ram_kms)
>                                         s2ram_resume();


Your patch alters how SNAPSHOT_FREE (IOW, free_snapshot() in this utility) is
handled. So, I was trying to see if there are any points of concern...

In the above code, s2ram_resume() gets invoked after free_snapshot(). Will that
pose any problems because kernel threads would have been thawed at that point,
after applying your patch?

And other than that, do you foresee any problems arising from the change caused
to SNAPSHOT_FREE by your patch? I mean, s2ram/s2disk/suspend-utils package are
not the only userspace utilities after all... so I just wanted to ensure that
we don't over-fit our solution to this particular utility and end up breaking
others...

Regards,
Srivatsa S. Bhat

>                                 goto Unfreeze;
>                         }
> Shutdown:
> #endif
>                         close(resume_fd);
>                         suspend_shutdown(snapshot_fd);
>                 }
>         } while (--attempts);
> 
> ...
> Unfreeze:
>         unfreeze(snapshot_fd);
> 


