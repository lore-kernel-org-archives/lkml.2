Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0LNHC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 02:02:56 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:46210 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab0LNHCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 02:02:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=E/qRFyL5JCZ9tN7/49v0PLtephLDUUZTzvxkCOvOEpm/Rb3A8bPozHBvZGds8QcWqp
         SINZu1dLKyZM5GWphhuet+tZo2YFqEu1XpI8ezkd/AR8Uuiohh5rS+4RyT4IA6ISfEBJ
         YN1ZgQtXClEkBQEBz3ltBIpflaxM9BIYr9hYw=
Date: Tue, 14 Dec 2010 10:02:43 +0300
From: Dan Carpenter <error27@gmail.com>
To: Brian Rogers <brian@xyzw.org>, Jeff Mahoney <jeffm@suse.com>,
        balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Guillaume Chazarain <guichaz@gmail.com>, akpm@linux-foundation.org
Subject: [patch] delayacct: fix iotop on x86_64
Message-ID: <20101214070243.GJ1620@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Brian Rogers <brian@xyzw.org>, Jeff Mahoney <jeffm@suse.com>,
	balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	Guillaume Chazarain <guichaz@gmail.com>, akpm@linux-foundation.org
References: <20101213113745.GE1620@bicker>
 <20101213125709.GB14178@balbir.in.ibm.com>
 <4D0639B2.4060903@suse.com>
 <4D068869.7040305@xyzw.org>
 <20101213212253.GI1620@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213212253.GI1620@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We changed how the taskstats was exported to user space in:
85893120699 "delayacct: align to 8 byte boundary on 64-bit systems"
This was important because it fixes a run time warning on IA64.  In
theory it shouldn't have broken anything, if you just assume that user
space programmers don't smoke crack all day long.

But actually it breaks iotop on x86_64.

Reported-by: Brian Rogers <brian@xyzw.org>
Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index c8231fb..a0758de 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -358,7 +358,19 @@ static struct taskstats *mk_reply(struct sk_buff *skb, int type, u32 pid)
 	 * This causes lots of runtime warnings on systems requiring 8 byte
 	 * alignment */
 	u32 pids[2] = { pid, 0 };
-	int pid_size = ALIGN(sizeof(pid), sizeof(long));
+	int pid_size;
+
+	/*
+	 * IA64 can't be aligned on a 4 byte boundary.  But iotop on x86_64
+	 * depends on the current struct layout.  The next version of iotop
+	 * will fix this so maybe we can move everything to the new code in
+	 * a couple years.
+	 */
+#if defined(CONFIG_IA64)
+	pid_size = ALIGN(sizeof(pid), sizeof(long));
+#else
+	pid_size = sizeof(u32);
+#endif
 
 	aggr = (type == TASKSTATS_TYPE_PID)
 			? TASKSTATS_TYPE_AGGR_PID
