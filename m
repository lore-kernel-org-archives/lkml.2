Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0D1RJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:09:56 -0400
Received: from smtp.nokia.com ([192.100.122.233]:37685 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0D1RJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:09:55 -0400
Date: Wed, 28 Apr 2010 20:09:16 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Robert Richter <robert.richter@amd.com>
Cc: "Siamashka Siarhei (Nokia-D/Helsinki)" <siarhei.siamashka@nokia.com>,
       "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
       "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] updates for oprofile
Message-ID: <20100428170915.GF17639@pcarmody-desktop>
References: <20100427152544.GA9063@pcarmody-desktop> <20100427174026.GR6450@erda.amd.com> <201004272047.52056.siarhei.siamashka@nokia.com> <20100428165906.GA21724@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428165906.GA21724@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 28 Apr 2010 17:09:36.0836 (UTC) FILETIME=[949FD840:01CAE6F5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/04/10 18:59 +0200, ext Robert Richter wrote:
> On 27.04.10 20:47:51, Siarhei Siamashka wrote:
> > Isn't hrtimer callback function supposed to be only called from IRQ context
> > after this cleanup: http://lwn.net/Articles/308545/ ?
> 
> Yes, the patch is upstream since v2.6.29. Thanks Siarhei.
> 
> I will add a null pointer check anyway.

A few here thrashed around a couple of ideas, and the general consensus 
was that the following work for us, and is offered for consideration.

Phil


From: Phil Carmody <ext-phil.2.carmody@nokia.com>
Date: Tue, 27 Apr 2010 19:28:33 +0300
Subject: [PATCH v2 1/1] oprofile: HACK - protect from not being in an IRQ context

http://lkml.org/lkml/2010/4/27/285

Protect against dereferencing regs when it's NULL, and
force a magic number into pc to prevent too deep processing.
This approach permits the dropped samples to be tallied as
invalid Instruction Pointer events.

e.g. output from about 15mins at 10kHz sample rate:
Nr. samples received: 2565380
Nr. samples lost invalid pc: 4

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 drivers/oprofile/cpu_buffer.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index a7aae24..f70f954 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -357,9 +357,15 @@ void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 
 void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 {
-	int is_kernel = !user_mode(regs);
-	unsigned long pc = profile_pc(regs);
-
+	int is_kernel;
+	unsigned long pc;
+	if (likely(regs)) {
+		is_kernel = !user_mode(regs);
+		pc = profile_pc(regs);
+	} else {
+		is_kernel = 0;    /* This value will not be used */
+		pc = ESCAPE_CODE; /* as this causes an early return. */
+	}
 	__oprofile_add_ext_sample(pc, regs, event, is_kernel);
 }
 
-- 
1.6.0.4

