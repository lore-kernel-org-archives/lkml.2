Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab1DTPNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:13:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57926 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1DTPNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=nAhQwefA+njD7Wgi0fVRC4U9lrsC+huWg8R+u5XJlnQmMLnX5c1PK0iNEWT6D9xMoY
         Ia4KPBfcIak8kBDk37LgVINYz8RKhc3id52X+JmcyqoEjWLkn1q675HcU84BCwkogyud
         iOp4hwraLpjGCAHsZAr0UyiWK2DqQJBbGO4ZM=
Message-ID: <4DAEF821.4050103@openvz.org>
Date: Wed, 20 Apr 2011 19:13:37 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH -tip] perf, x86: P4 PMU - Don't forget to clear cpuc->active_mask
 on overflow
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not enough to simply disable event on overflow the cpuc->active_mask
should be cleared as well otherwise counter may stall in "active" even
in real being already disabled (which potentially may lead to the situation
that user may not use this counter further).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Ming, iirc you were testing this one, but without unknown nmi fix. So
patch from Don should fix unknown nmi issue, please give this patch a
shot again if you have some time (Don's patch is here
https://lkml.org/lkml/2011/4/18/404 but I think you have it already in mailbox).

 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -946,7 +946,7 @@ static int p4_pmu_handle_irq(struct pt_r
 		if (!x86_perf_event_set_period(event))
 			continue;
 		if (perf_event_overflow(event, 1, &data, regs))
-			p4_pmu_disable_event(event);
+			x86_pmu_stop(event, 0);
 	}

 	if (handled) {

-- 
    Cyrill
