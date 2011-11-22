Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab1KVR73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:59:29 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:37239 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752755Ab1KVR71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:59:27 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: TMvCaJcVM1n_gICt3ufK7oeIQusX1llmY6wYT7T_FoedG9U
 HQ_WwKNb2J2oePkxkhLPg2VtBn1_bDYY.I1SOtXmiGrodpp.cuSFaTMpYNJC
 UXFCXTg15E6wQLyBKlDqEIQ9Xrt0EJdibr3ez5bYvFKn6vwomPbhyeAmPg5O
 3_NzIgw6F.YW7Hkup.OULizCraYkp8xUsL4N8jxBr9rWhj37h6UAN9sYx7Cb
 P16EfS4QL_bpPtBGbF_ndw5FaaSQqc_dwzDZ35a_4_FsRRYbfFJ18uW89I35
 j7Hc4ZlwziXu6J1JjQjoAakgB0L2kfG.SiyolpmQyJ8UAhlhvDjKz9W3Qjkw
 XKUGCNb7Iwy8eRszU9K8L_qpqedPjnvx8_gtXP54oXL2nILipp7khO2uAIWT
 XPpccN9Jb43.mNOH8UTkm4A--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 11:59:22 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: slub: Lockout validation scans during freeing of object
In-Reply-To: <1321982484.18002.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1111221144580.28197@router.home>
References: <alpine.DEB.2.00.1111221033350.28197@router.home>  <alpine.DEB.2.00.1111221040300.28197@router.home>  <alpine.DEB.2.00.1111221052130.28197@router.home> <1321982484.18002.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Eric Dumazet wrote:

> This seems better, but I still have some warnings :
>
> [  162.117574] SLUB: selinux_inode_security 136 slabs counted but counter=137
> [  179.879907] SLUB: task_xstate 1 slabs counted but counter=2

This is the total # of slabs that mismatches. Some slabs are not on the
partial list and are neither on the full list since they are currently
on the per cpu partial lists. Thats an accounting issue introduced in 3.2
with the per cpu pages. Need to find some way to count the per cpu partial
pages correctly. Could just force the per cpu pages to be empty?


Subject: Switch per cpu partial page support off for debugging

Otherwise we have accounting issues.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-11-22 11:57:21.000000000 -0600
+++ linux-2.6/mm/slub.c	2011-11-22 11:57:55.000000000 -0600
@@ -3027,7 +3027,9 @@ static int kmem_cache_open(struct kmem_c
 	 *    per node list when we run out of per cpu objects. We only fetch 50%
 	 *    to keep some capacity around for frees.
 	 */
-	if (s->size >= PAGE_SIZE)
+	if (kmem_cache_debug(s))
+		s->cpu_partial = 0;
+	else if (s->size >= PAGE_SIZE)
 		s->cpu_partial = 2;
 	else if (s->size >= 1024)
 		s->cpu_partial = 6;
