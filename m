Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab0LBW0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:26:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35286 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab0LBW0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:26:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HL1PsvkS5YFTQ5IWIFwmh+00dW9VSDlsXqQ89GTqg3MiCBlkliNPAcgKWGTOvMzCUW
         vcURrUW3+VHko5aL7drwVP6MsAvbClfHqluWTlSQb26Gyo3UEd9cdVxdSEjPw2PIIfUJ
         pJXa2xvrdbML0jS5C1hmwswtRjxRQU9zOuMtE=
Date: Fri, 3 Dec 2010 01:26:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC] perf: Prevent potential null dereference
Message-ID: <20101202222605.GA6471@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if there is no memory we might hit null
dereference on accessing calloc'ed data.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---

It seems exit right here is more convenient than passing error
handling level up (which would have to exit anyway), thought
if handling it "upper" is preferred -- just say a word.

 tools/perf/builtin-record.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.git/tools/perf/builtin-record.c
=====================================================================
--- linux-2.6.git.orig/tools/perf/builtin-record.c
+++ linux-2.6.git/tools/perf/builtin-record.c
@@ -524,6 +524,10 @@ static void comm__construct(int argc, co
 		return;
 
 	comm = calloc(1, size);
+	if (!comm) {
+		pr_err("Not enough memory to construct internal command line.\n");
+		exit(-1);
+	}
 
 	tmp = comm;
 	for (i = 0; i < argc; i++) {
