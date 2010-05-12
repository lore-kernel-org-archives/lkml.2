Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab0ELU3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:29:21 -0400
Received: from tex.lwn.net ([70.33.254.29]:40962 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183Ab0ELU3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:29:20 -0400
Date: Wed, 12 May 2010 14:29:17 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Add a document for the padata interface
Message-ID: <20100512142917.4287bf6e@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last month I promised to format this information up as a documentation
addition; here it is.  In the absence of unhappiness, I'll send it
Linusward through my docs tree when the merge window opens.

Comments welcome,

jon
---
Add a document describing the padata interface

This originally appeared as http://lwn.net/Articles/382257/.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/00-INDEX   |    2 +
 Documentation/padata.txt |  107 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/padata.txt

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 06b982a..dd10b51 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -250,6 +250,8 @@ numastat.txt
 	- info on how to read Numa policy hit/miss statistics in sysfs.
 oops-tracing.txt
 	- how to decode those nasty internal kernel error dump messages.
+padata.txt
+	- An introduction to the "padata" parallel execution API
 parisc/
 	- directory with info on using Linux on PA-RISC architecture.
 parport.txt
diff --git a/Documentation/padata.txt b/Documentation/padata.txt
new file mode 100644
index 0000000..32bd1e4
--- /dev/null
+++ b/Documentation/padata.txt
@@ -0,0 +1,107 @@
+The padata parallel execution mechanism
+Last updated for 2.6.34
+
+Padata is a mechanism by which the kernel can farm work out to be done in
+parallel on multiple CPUs while retaining the ordering of tasks.  It was
+developed for use with the IPsec code, which needs to be able to perform
+encryption and decryption on large numbers of packets without reordering
+those packets.  The crypto developers made a point of writing padata in a
+sufficiently general fashion that it could be put to other uses as well.
+
+The first step in using padata is to set up a padata_instance structure for
+overall control of how tasks are to be run:
+
+    #include <linux/padata.h>
+
+    struct padata_instance *padata_alloc(const struct cpumask *cpumask,
+				         struct workqueue_struct *wq);
+
+The cpumask describes which processors will be used to execute work
+submitted to this instance.  The workqueue wq is where the work will
+actually be done; it should be a multithreaded queue, naturally.
+
+There are functions for enabling and disabling the instance:
+
+    void padata_start(struct padata_instance *pinst);
+    void padata_stop(struct padata_instance *pinst);
+
+These functions literally do nothing beyond setting or clearing the
+"padata_start() was called" flag; if that flag is not set, other functions
+will refuse to work.
+
+The list of CPUs to be used can be adjusted with these functions:
+
+    int padata_set_cpumask(struct padata_instance *pinst,
+			   cpumask_var_t cpumask);
+    int padata_add_cpu(struct padata_instance *pinst, int cpu);
+    int padata_remove_cpu(struct padata_instance *pinst, int cpu);
+
+Changing the CPU mask has the look of an expensive operation, though, so it
+probably should not be done with great frequency.
+
+Actually submitting work to the padata instance requires the creation of a
+padata_priv structure:
+
+    struct padata_priv {
+        /* Other stuff here... */
+	void                    (*parallel)(struct padata_priv *padata);
+	void                    (*serial)(struct padata_priv *padata);
+    };
+
+This structure will almost certainly be embedded within some larger
+structure specific to the work to be done.  Most its fields are private to
+padata, but the structure should be zeroed at initialization time, and the
+parallel() and serial() functions should be provided.  Those functions will
+be called in the process of getting the work done as we will see
+momentarily.
+
+The submission of work is done with:
+
+    int padata_do_parallel(struct padata_instance *pinst,
+		           struct padata_priv *padata, int cb_cpu);
+
+The pinst and padata structures must be set up as described above; cb_cpu
+specifies which CPU will be used for the final callback when the work is
+done; it must be in the current instance's CPU mask.  The return value from
+padata_do_parallel() is a little strange; zero is an error return
+indicating that the caller forgot the padata_start() formalities.  -EBUSY
+means that somebody, somewhere else is messing with the instance's CPU
+mask, while -EINVAL is a complaint about cb_cpu not being in that CPU mask.
+If all goes well, this function will return -EINPROGRESS, indicating that
+the work is in progress.
+
+Each task submitted to padata_do_parallel() will, in turn, be passed to
+exactly one call to the above-mentioned parallel() function, on one CPU, so
+true parallelism is achieved by submitting multiple tasks.  The workqueue
+is used to actually make these calls, so parallel() runs in process context
+and is allowed to sleep.  The parallel() function gets the padata_priv
+structure pointer as its lone parameter; information about the actual work
+to be done is probably obtained by using container_of() to find the
+enclosing structure.
+
+Note that parallel() has no return value; the padata subsystem assumes that
+parallel() will take responsibility for the task from this point.  The work
+need not be completed during this call, but, if parallel() leaves work
+outstanding, it should be prepared to be called again with a new job before
+the previous one completes.  When a task does complete, parallel() (or
+whatever function actually finishes the job) should inform padata of the
+fact with a call to:
+
+    void padata_do_serial(struct padata_priv *padata);
+
+At some point in the future, padata_do_serial() will trigger a call to the
+serial() function in the padata_priv structure.  That call will happen on
+the CPU requested in the initial call to padata_do_parallel(); it, too, is
+done through the workqueue, but with local software interrupts disabled.
+Note that this call may be deferred for a while since the padata code takes
+pains to ensure that tasks are completed in the order in which they were
+submitted.
+
+The one remaining function in the padata API should be called to clean up
+when a padata instance is no longer needed:
+
+    void padata_free(struct padata_instance *pinst);
+
+This function will busy-wait while any remaining tasks are completed, so it
+might be best not to call it while there is work outstanding.  Shutting
+down the workqueue, if necessary, should be done separately.

