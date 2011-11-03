Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab1KCTJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:09:38 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:45433 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934385Ab1KCTJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:09:36 -0400
Message-ID: <4EB2E6E6.60107@linux.vnet.ibm.com>
Date: Fri, 04 Nov 2011 00:39:26 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arnd@arndb.de, oleg@redhat.com,
        matthltc@us.ibm.com
Subject: Re: [PATCH 12/17] freezer: clean up freeze_processes() failure path
References: <1320087928-32307-1-git-send-email-tj@kernel.org> <1320087928-32307-13-git-send-email-tj@kernel.org>
In-Reply-To: <1320087928-32307-13-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11110319-8878-0000-0000-0000001989C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/01/2011 12:35 AM, Tejun Heo wrote:
> freeze_processes() failure path is rather messy.  Freezing is canceled
> for workqueues and tasks which aren't frozen yet but frozen tasks are
> left alone and should be thawed by the caller and of course some
> callers (xen and kexec) didn't do it.
> 
> This patch updates __thaw_task() to handle cancelation correctly and
> makes thaw_processes() call thaw_processes() on failure instead so
        ^^^^^^^^^^^^^^
You meant freeze_processes() and freeze_kernel_threads() here, right?

> that the system is fully thawed on failure.  

I really like this approach of handling freezing failures.

> Unnecessary
> thaw_processes() calls are removed from kernel/power/hibernate.c and
> user.c.
> 
Did you miss kernel/power/suspend.c?
Shouldn't we be also doing something like this:

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index fdd4263..57aaca5 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -110,7 +110,6 @@ static int suspend_prepare(void)
        } else
                return 0;
 
-       suspend_thaw_processes();
        usermodehelper_enable();
  Finish:
        pm_notifier_call_chain(PM_POST_SUSPEND);



--- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab

