Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1EQNg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:36:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11972 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab1EQNg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:36:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Huqh69MAeNNUrCdTvgnYd2P59+WM0vbdCF++hYDUbRzq4G2zR4DKBiH2zq/LxGeqKW
         0JgLHPYep2AUrxPM06yA==
Date: Tue, 17 May 2011 15:36:19 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, acme@redhat.com, peterz@infradead.org, fweisbec@gmail.com
Subject: [PATCH] perf: fix multi-event parsing bug
Message-ID: <20110517133619.GA6999@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes an issue with event parsing.
The following commit appears to have broken the
ability to specify a comma separated list of events:

   commit ceb53fbf6dbb1df26d38379a262c6981fe73dd36
   Author: Ingo Molnar <mingo@elte.hu>
   Date:   Wed Apr 27 04:06:33 2011 +0200

       perf stat: Fail more clearly when an invalid modifier is specified

This patch fixes this while preserving the desired effect:

$ perf stat -e instructions:u,instructions:k ls /dev/null
/dev/null

 Performance counter stats for 'ls /dev/null':

            365956 instructions:u           #    0.00  insns per cycle        
            731806 instructions:k           #    0.00  insns per cycle        

        0.001108862  seconds time elapsed

$ perf stat -e task-clock-msecs true
invalid event modifier: '-msecs'
Run 'perf list' for a list of valid events and modifiers

Signed-off-by: Stephane Eranian <eranian@google.com>

---
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index ffa493a..41982c3 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -734,6 +734,9 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 	if (!*str)
 		return 0;
 
+	if (*str == ',')
+		return 0;
+
 	if (*str++ != ':')
 		return -1;
 
