Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab0EAIMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 04:12:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:41964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0EAIMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 04:12:00 -0400
Message-ID: <4BDBE237.1040809@kernel.org>
Date: Sat, 01 May 2010 10:11:35 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@au1.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH tip/perf] perf: fix resource leak in failure path of perf_event_open()
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 01 May 2010 08:11:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_event_open() kfrees event after init failure which doesn't
release all resources allocated by perf_event_alloc().  Use
free_event() instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/kernel/perf_event.c
===================================================================
--- work.orig/kernel/perf_event.c
+++ work/kernel/perf_event.c
@@ -4897,7 +4897,7 @@ err_fput_free_put_context:

 err_free_put_context:
 	if (err < 0)
-		kfree(event);
+		free_event(event);

 err_put_context:
 	if (err < 0)
