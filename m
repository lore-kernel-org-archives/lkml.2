Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab1CWUci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:32:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62064 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab1CWUcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=auOKJFlPeyo5GT8K+3tAfl359Q9RuGzCd9dp7de5QjIpy98XnfGJWGqHmY2RHml+wq
         gGKyo0x0qimz5LE0MuifbkwHqK8p3gYv0eKDDW4ROyVlUMi8lNPYCO2uxMGm/KIin3Hi
         uoypIm/lHW4zWWaX0lImIgPNUK0UoqG8iVlyU=
Message-ID: <4D8A58E1.5090509@openvz.org>
Date: Wed, 23 Mar 2011 23:32:33 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] kgdb, x86: Pull up NMI notifier handler priority
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kgdb needs IPI to be sent and handled before perf
or anything else NMI, otherwise kgdb hangs with bootup
self-tests (found on P4 HT SMP machine). Raise its priority
so that we're called first in a notifier chain.

Reported-by: Don Zickus <dzickus@redhat.com>
Tested-by: Lin Ming <ming.m.lin@intel.com>
CC: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Don, Jason, take a look please.

 arch/x86/kernel/kgdb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/kgdb.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/kgdb.c
+++ linux-2.6.git/arch/x86/kernel/kgdb.c
@@ -592,9 +592,12 @@ static struct notifier_block kgdb_notifi
 	.notifier_call	= kgdb_notify,

 	/*
-	 * Lowest-prio notifier priority, we want to be notified last:
+	 * We might need to send an IPI and
+	 * do cpu roundup before anything else
+	 * in notifier chain so high priority
+	 * is needed.
 	 */
-	.priority	= NMI_LOCAL_LOW_PRIOR,
+	.priority	= NMI_LOCAL_HIGH_PRIOR,
 };

 /**

-- 
    Cyrill
