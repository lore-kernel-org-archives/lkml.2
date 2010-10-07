Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab0JGDIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:08:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab0JGDIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 23:08:35 -0400
Date: Wed, 6 Oct 2010 23:08:07 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com, andi@firstfloor.org
Cc: robert.richter@amd.com, gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: [RFC] arch generic way to trigger unknown NMIs
Message-ID: <20101007030807.GA4076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was trying to put some automation test scripts together and was looking
for an arch neutral way to generate an unknown NMI.  I know some arches
do not support NMI.  Any way I wanted to add the code to the lkdtm module,
so I could more easily generate unknown NMIs  without hacking up the code.

For x86, I have been using:


diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index ef34de7..c685242 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -43,6 +43,7 @@
 #include <linux/slab.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/debugfs.h>
+#include <asm/apic.h>
 
 #ifdef CONFIG_IDE
 #include <linux/ide.h>
@@ -78,6 +79,7 @@ enum ctype {
 	SOFTLOCKUP,
 	HARDLOCKUP,
 	HUNG_TASK,
+	NMI,
 };
 
 static char* cp_name[] = {
@@ -105,6 +107,7 @@ static char* cp_type[] = {
 	"SOFTLOCKUP",
 	"HARDLOCKUP",
 	"HUNG_TASK",
+	"NMI",
 };
 
 static struct jprobe lkdtm;
@@ -340,6 +343,9 @@ static void lkdtm_do_action(enum ctype which)
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
 		break;
+	case NMI:
+		apic->send_IPI_allbutself(NMI_VECTOR);
+		break;
 	case NONE:
 	default:
 		break;

Anyone have any thoughts?  Maybe there is an easier way?

Thanks,
Don
