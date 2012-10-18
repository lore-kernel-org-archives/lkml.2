Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2JRXAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:00:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31163 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2JRXAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:00:10 -0400
MIME-Version: 1.0
Message-ID: <444a6439-b1a4-4740-9e7e-bc37267cfe73@default>
Date: Thu, 18 Oct 2012 16:00:03 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>
Subject: cancel_delayed_work() semantics broken?
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun --

Forgive me if I am missing something, but it appears
that your commit:  57b30ae77bf00d2318df711ef9a4d2a9be0a3a2a
(workqueue: reimplement cancel_delayed_work() using try_to_grab_pending())
has subtly broken the semantics of the function. If
work was idle, according to the comment, it should
return false, correct?

It appears that very few callsites check the return value,
but ramster does, as does ocfs2 from whence the code at the
ramster callsite was derived.  They both decrement
a kref count based on the return value.

I am still looking at try_to_grab_pending as I am not sure
if its semantics have also changed.

Thanks,
Dan

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d951daa..042d221 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2982,7 +2982,7 @@ bool cancel_delayed_work(struct delayed_work *dwork)
 
 	set_work_cpu_and_clear_pending(&dwork->work, work_cpu(&dwork->work));
 	local_irq_restore(flags);
-	return true;
+	return ret;
 }
 EXPORT_SYMBOL(cancel_delayed_work);
