Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0GBL76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 07:59:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64584 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab0GBL75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 07:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=knm/2oajZW3pxhjgUlxitKTxxfwMnBnyk+lvtci0wX0KrwSxH+fJ2g8OBeCbqPkiI4
         ouk2+tBy7ItlXBJHDQ0l/hpbhH0CegatinJu21qg3H/5/oo6IeWHJUYv6Jvb+JBPcj1O
         VZT6T6oG4h8kLwEbxdsi3NsX4wxsXo5KkLsKU=
MIME-Version: 1.0
Date: Fri, 2 Jul 2010 15:59:54 +0400
X-Google-Sender-Auth: de8n7XFSs2FjWvCrObnmTRWKbJw
Message-ID: <AANLkTimVTMsVkSBHWLve8t76-YkoSYposgv9wHir_wPa@mail.gmail.com>
Subject: [PATCH] Fixed division by zero bug in kernel/padata.c
From: Dan Kruchinin <dkruchinin@acm.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 When boot CPU(typically CPU #0) is excluded from padata cpumask and
 user enters halt command from console, kernel faults on division by zero;
 This occurs because during the halt kernel shuts down each non-boot CPU one
 by one and after it shuts down the last CPU that is set in the padata cpumask,
 the only working CPU in the system is a boot CPU(#0) and it's the only CPU that
 is set in the cpu_active_mask. Hence when padata_cpu_callback calls
 __padata_remove_cpu(which calls padata_alloc_pd) it appears that
padata cpumask and
 cpu_active_mask aren't intersect. Hence the following code in
padata_alloc_pd causes
 a DZ error exception:
  cpumask_and(pd->cpumask, cpumask, cpu_active_mask); // pd->cpumask
will be empty
  ...
  num_cpus = cpumask_weight(pd->cpumask); // num_cpus = 0
  pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1; // DZ!


Signed-off-by: Dan Kruchinin <dkruchinin@acm.org>
---
 kernel/padata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index fdd8ae6..dbe6d26 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -434,7 +434,7 @@ static struct parallel_data
*padata_alloc_pd(struct padata_instance *pinst,
 		atomic_set(&queue->num_obj, 0);
 	}

-	num_cpus = cpumask_weight(pd->cpumask);
+	num_cpus = cpumask_weight(pd->cpumask) + 1;
 	pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;

 	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
-- 
1.7.1


-- 
W.B.R.
Dan Kruchinin
