Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab0CTN1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 09:27:00 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34691 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab0CTN0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 09:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=UIKk/kSPqztJ00AjRfZgg9AcMTkAuqiY7iAofuKuKrQb3/oW2xJeQJQ+3qkt5FWLaL
         kBpWZ5B2agSDj6+cBzY/6KnOkImGu/QPIKDFWU6BGg7Q5xhjKZfe2s2c6MJA8qi2JVRh
         q/ItQnQGxioarad6x7VDRYMFbJw/7FsMtZoR8=
Date: Sat, 20 Mar 2010 16:19:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] trace: find the correct ftrace event
Message-ID: <20100320131923.GA20922@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code doesn't work because "call" is never NULL there.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
My code should work, but it seems like there should but it seems like
there should be a more elegant way to do this?

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 4615f62..6070c70 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1388,16 +1388,19 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	struct event_filter *filter;
 	struct filter_parse_state *ps;
 	struct ftrace_event_call *call = NULL;
+	int found = 0;
 
 	mutex_lock(&event_mutex);
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (call->id == event_id)
+		if (call->id == event_id) {
+			found = 1;
 			break;
+		}
 	}
 
 	err = -EINVAL;
-	if (!call)
+	if (!found)
 		goto out_unlock;
 
 	err = -EEXIST;
