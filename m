Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966266Ab0CPOIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:08:54 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:64415 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966027Ab0CPOIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:08:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ZhToIf4I/5M3eoETvDvdacRrygGkuuxzmqESMBgknUnbIrVJZLqe8/iQoj0J55gEB1
         dNbrjnQ+092m3wySdGx0CTI2GFuawQsIQm01YFUGDqL5M+422RHHNdvSFtgkinu3SsxR
         O7MIeM1oKislw9n1D3m97YDzeZA85dzdb0wkA=
MIME-Version: 1.0
Date: Tue, 16 Mar 2010 15:08:51 +0100
Message-ID: <79c603601003160708s7fb45682rdec739776d0f5e81@mail.gmail.com>
Subject: [PATCH] oom_kill: set default process to kill
From: Bob Sleigh <bobslgh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 mm/Kconfig    |    9 +++++++++
 mm/oom_kill.c |   10 ++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 9c61158..3911730 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -287,3 +287,12 @@ config NOMMU_INITIAL_TRIM_EXCESS
          of 1 says that all excess pages should be trimmed.

          See Documentation/nommu-mmap.txt for more information.
+
+config MM_USUAL_SUSPECT
+       string "Default executable name to be killed by the OOM killer"
+       default ""
+       help
+         This option sets the default executable name to be killed when we run
+         out of memory.
+
+         If unsure, set to "firefox-bin".
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 35755a4..333fa46 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -300,6 +300,16 @@ static struct task_struct
*select_bad_process(unsigned long *ppoints,
                if (p->signal->oom_adj == OOM_DISABLE)
                        continue;

+#ifdef CONFIG_MM_USUAL_SUSPECT
+               /*
+                * Select the task if matching the usual suspect.
+                */
+               if (strcmp(p->comm, CONFIG_MM_USUAL_SUSPECT)) {
+                       chosen = p;
+                       continue;
+               }
+#endif
+
                points = badness(p, uptime.tv_sec);
                if (points > *ppoints || !chosen) {
                        chosen = p;
