Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0G0FR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:17:27 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:33249 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab0G0FRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:17:24 -0400
Date: Tue, 27 Jul 2010 07:20:47 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] padata: update API documentation
Message-ID: <20100727052047.GP11081@secunet.com>
References: <20100727051347.GI11081@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727051347.GI11081@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2010 05:17:11.0183 (UTC) FILETIME=[F76851F0:01CB2D4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 Documentation/padata.txt |   76 ++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/Documentation/padata.txt b/Documentation/padata.txt
index 93dd4e6..ad2a0ff 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.txt
@@ -1,5 +1,5 @@
 The padata parallel execution mechanism
-Last updated for 2.6.34
+Last updated for 2.6.36
 
 Padata is a mechanism by which the kernel can farm work out to be done in
 parallel on multiple CPUs while retaining the ordering of tasks.  It was
@@ -13,12 +13,28 @@ overall control of how tasks are to be run:
 
     #include <linux/padata.h>
 
-    struct padata_instance *padata_alloc(const struct cpumask *cpumask,
-				         struct workqueue_struct *wq);
+    struct padata_instance *padata_alloc(struct workqueue_struct *wq,
+					 const struct cpumask *pcpumask,
+					 const struct cpumask *cbcpumask);
 
-The cpumask describes which processors will be used to execute work
-submitted to this instance.  The workqueue wq is where the work will
-actually be done; it should be a multithreaded queue, naturally.
+The pcpumask describes which processors will be used to execute work
+submitted to this instance in parallel. The cbcpumask defines which
+processors are allowed to use as the serialization callback processor.
+The workqueue wq is where the work will actually be done; it should be
+a multithreaded queue, naturally.
+
+To allocate a padata instance with the cpu_possible_mask for both 
+cpumasks this helper function can be used:
+
+    struct padata_instance *padata_alloc_possible(struct workqueue_struct *wq);
+
+Note: Padata maintains two kinds of cpumasks internally. The user supplied
+cpumasks, submitted by padata_alloc/padata_alloc_possible and the 'usable'
+cpumasks. The usable cpumasks are always the subset of active cpus in the
+user supplied cpumasks, these are the cpumasks padata actually use. So
+it is legal to supply a cpumask to padata that contains offline cpus.
+Once a offline cpu in the user supplied cpumask comes online, padata
+is going to use it.
 
 There are functions for enabling and disabling the instance:
 
@@ -34,13 +50,49 @@ is unused.
 
 The list of CPUs to be used can be adjusted with these functions:
 
-    int padata_set_cpumask(struct padata_instance *pinst,
+    int padata_set_cpumasks(struct padata_instance *pinst,
+    			    cpumask_var_t pcpumask,
+			    cpumask_var_t cbcpumask);
+    int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			   cpumask_var_t cpumask);
-    int padata_add_cpu(struct padata_instance *pinst, int cpu);
-    int padata_remove_cpu(struct padata_instance *pinst, int cpu);
+    int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask);
+    int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask);
+
+Changing the CPU masks are expensive operations, though, so it should not be
+done with great frequency.
+
+It's possible to change both cpumasks of a padata instance with
+padata_set_cpumasks by specifying the cpumasks for parallel execution (pcpumask)
+and for the serial callback function (cbcpumask). padata_set_cpumask is to
+change just one of the cpumasks. Here cpumask_type is one of PADATA_CPU_SERIAL,
+PADATA_CPU_PARALLEL and cpumask specifies the new cpumask to use.
+To simply add or remove one cpu from a certain cpumask the functions
+padata_add_cpu/padata_remove_cpu are used. cpu specifies the cpu to add or
+remove and mask is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL.
+
+If a user is interested in padata cpumask changes, he can register to
+the padata cpumask change notifier:
+
+    int padata_register_cpumask_notifier(struct padata_instance *pinst,
+    					 struct notifier_block *nblock);
+
+To unregister from that notifier:
+
+    int padata_unregister_cpumask_notifier(struct padata_instance *pinst,
+    					   struct notifier_block *nblock);
+
+The padata cpumask change notifier notifies about changes of the usable
+cpumasks, i.e. the subset of active cpus in the user supplied cpumask.
+
+Padata calls the notifier chain with:
+
+    blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
+    				 notification_mask,
+				 &pd_new->cpumask);
 
-Changing the CPU mask has the look of an expensive operation, though, so it
-probably should not be done with great frequency.
+Here cpumask_change_notifier is registered notifier, notification_mask
+is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL and cpumask is a pointer
+to a struct padata_cpumask that contains the new cpumask informations.
 
 Actually submitting work to the padata instance requires the creation of a
 padata_priv structure:
@@ -53,7 +105,7 @@ padata_priv structure:
 
 This structure will almost certainly be embedded within some larger
 structure specific to the work to be done.  Most its fields are private to
-padata, but the structure should be zeroed at initialization time, and the
+padata, but the structure should be zeroed at initialisation time, and the
 parallel() and serial() functions should be provided.  Those functions will
 be called in the process of getting the work done as we will see
 momentarily.
-- 
1.5.6.5

