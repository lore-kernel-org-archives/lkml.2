Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab0GGNcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:32:05 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:47387 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab0GGNcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:32:03 -0400
Date: Wed, 7 Jul 2010 15:34:03 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6/6] padata: update documentation
Message-ID: <20100707133403.GB10072@secunet.com>
References: <20100707132915.GV10072@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707132915.GV10072@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jul 2010 13:32:00.0671 (UTC) FILETIME=[C775AAF0:01CB1DD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the padata documentation to the changed
API of padata_start/padata_stop and padata_do parallel.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 Documentation/padata.txt |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/Documentation/padata.txt b/Documentation/padata.txt
index 269d7d0..3d77d09 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.txt
@@ -22,12 +22,15 @@ actually be done; it should be a multithreaded queue, naturally.
 
 There are functions for enabling and disabling the instance:
 
-    void padata_start(struct padata_instance *pinst);
+    int padata_start(struct padata_instance *pinst);
     void padata_stop(struct padata_instance *pinst);
 
-These functions literally do nothing beyond setting or clearing the
-"padata_start() was called" flag; if that flag is not set, other functions
-will refuse to work.
+These functions are setting or clearing the "PADATA_INIT" flag;
+if that flag is not set, other functions will refuse to work.
+padata_start returns zero on success (flag set) or -EINVAL if the
+padata cpumask contains no active cpu (flag not set).
+padata_stop clears the flag and blocks until the padata instance
+is unused. 
 
 The list of CPUs to be used can be adjusted with these functions:
 
@@ -63,12 +66,10 @@ The submission of work is done with:
 The pinst and padata structures must be set up as described above; cb_cpu
 specifies which CPU will be used for the final callback when the work is
 done; it must be in the current instance's CPU mask.  The return value from
-padata_do_parallel() is a little strange; zero is an error return
-indicating that the caller forgot the padata_start() formalities.  -EBUSY
-means that somebody, somewhere else is messing with the instance's CPU
-mask, while -EINVAL is a complaint about cb_cpu not being in that CPU mask.
-If all goes well, this function will return -EINPROGRESS, indicating that
-the work is in progress.
+padata_do_parallel() is zero on success, indicating that the work is in
+progress. -EBUSY means that somebody, somewhere else is messing with the
+instance's CPU mask, while -EINVAL is a complaint about cb_cpu not being
+in that CPU mask or about a not running instance.
 
 Each task submitted to padata_do_parallel() will, in turn, be passed to
 exactly one call to the above-mentioned parallel() function, on one CPU, so
-- 
1.5.6.5

