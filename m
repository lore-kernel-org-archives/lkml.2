Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab2AHDzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 22:55:33 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:57574 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2AHDzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 22:55:32 -0500
Message-ID: <1325994892.5482.10.camel@ThinkPad-T61>
Subject: Re: [PATCH v2 powerpc] fix unpaired __trace_hcall_entry and
 __trace_hcall_exit
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        Anton Blanchard <anton@samba.org>
Date: Sun, 08 Jan 2012 11:54:52 +0800
In-Reply-To: <1325552057.23910.5.camel@pasglop>
References: <1324260407.3006.17.camel@ThinkPad-T61>
	 <1325552057.23910.5.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12010717-0260-0000-0000-000000585538
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 11:54 +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2011-12-19 at 10:06 +0800, Li Zhong wrote:
> > Unpaired calling of __trace_hcall_entry and __trace_hcall_exit could
> > cause incorrect preempt count. And it might happen as the global
> > variable hcall_tracepoint_refcount is checked separately before calling
> > them. 
> > 
> > I don't know much about the powerpc arch. But the idea here is to store
> > the hcall_tracepoint_refcount locally, so __trace_hcall_entry and
> > __trace_hcall_exit will be called or not called in pair by checking the
> > same value. 
> 
> Can you re-use an existing spot in the stack frame rather than adding
> this entry ? There's plenty of unused spots :-) For example the link
> editor doubleword is never going to be used in that function, we could
> hijack it safely. It would make the patch (and the code) simpler.
> 
> Cheers,
> Ben.

Hi Ben, 

Thank you for the suggestion. Below is the updated version, much less
code changes :) Would you please help review again to see whether my
understanding is correct? 

Thanks,
Zhong

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/hvCall.S |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hvCall.S
b/arch/powerpc/platforms/pseries/hvCall.S
index fd05fde..3ce73d0 100644
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -36,6 +36,7 @@ BEGIN_FTR_SECTION;						\
 	b	1f;						\
 END_FTR_SECTION(0, 1);						\
 	ld      r12,hcall_tracepoint_refcount@toc(r2);		\
+	std	r12,32(r1);					\
 	cmpdi	r12,0;						\
 	beq+	1f;						\
 	mflr	r0;						\
@@ -74,7 +75,7 @@ END_FTR_SECTION(0, 1);						\
 BEGIN_FTR_SECTION;						\
 	b	1f;						\
 END_FTR_SECTION(0, 1);						\
-	ld      r12,hcall_tracepoint_refcount@toc(r2);		\
+	ld      r12,32(r1);					\
 	cmpdi	r12,0;						\
 	beq+	1f;						\
 	mflr	r0;						\
-- 
1.7.5.4

