Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1AHWmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 17:42:08 -0500
Received: from ist.d-labs.de ([213.239.218.44]:51701 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab1AHWmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 17:42:07 -0500
Date: Sat, 8 Jan 2011 23:42:00 +0100
From: Florian Mickler <florian@mickler.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Dan Carpenter <error27@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, balbir@linux.vnet.ibm.com,
        guichaz@gmail.com
Subject: Re: [PATCH] taskstats: Use better ifdef for alignment
Message-ID: <20110108234200.209c67e4@schatten.dmk.lab>
In-Reply-To: <20110102131747.3e79107a@schatten.dmk.lab>
References: <4D1BCE58.4000902@suse.com>
	<20101229161418.d34bf0d4.akpm@linux-foundation.org>
	<4D1C180A.20000@suse.com>
	<20101229213243.891b0db5.akpm@linux-foundation.org>
	<4D1CAAA1.8030106@suse.com>
	<20110101171946.6179c3b6@schatten.dmk.lab>
	<20110101165135.GJ1886@bicker>
	<20110102131747.3e79107a@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Jan 2011 13:17:47 +0100
Florian Mickler <florian@mickler.org> wrote:

> On Sat, 1 Jan 2011 19:51:35 +0300
> Dan Carpenter <error27@gmail.com> wrote:
> 
> > On Sat, Jan 01, 2011 at 05:19:46PM +0100, Florian Mickler wrote:
> > > Is there already a patch available or integrated into iotop which
> > > fixes this? I'd think that if the kernel could wait on fixed iotop's to
> > > be distributed it would be easier to sell the breakage on bugzilla &
> > > co...

Ok, I sent a fix for the iotop parsing to Guillaume, but didn't receive
any reaction... maybe someone here find's it useful... 

commit 392f7e7455c94cdc64aeb0353a79d22b4780687c
Author: Florian Mickler <florian@mickler.org>
Date:   Tue Jan 4 12:03:25 2011 +0100

    fix parsing of netlink messages
    
    The linux kernel may enhance the message with fields to pad the taskstats struct
    (commit 4be2c95d1f ["taskstats: pad taskstats netlink
    response for aligment issues on ia64"] in Linus tree).
    So now we honour the flexible format and extract the field we are
    interested in.

diff --git a/iotop/data.py b/iotop/data.py
index 1164344..c75c190 100644
--- a/iotop/data.py
+++ b/iotop/data.py
@@ -136,6 +136,7 @@ TASKSTATS_CMD_GET = 1
 TASKSTATS_CMD_ATTR_PID = 1
 TASKSTATS_TYPE_AGGR_PID = 4
 TASKSTATS_TYPE_PID = 1
+TASKSTATS_TYPE_STATS = 3
 
 class TaskStatsNetlink(object):
     # Keep in sync with format_stats() and pinfo.did_some_io()
@@ -163,19 +164,23 @@ class TaskStatsNetlink(object):
         if len(reply.payload) < 292:
             # Short reply
             return
-        reply_length, reply_type = struct.unpack('HH', reply.payload[4:8])
-        assert reply_length >= 288
-        assert reply_type == TASKSTATS_TYPE_AGGR_PID
-
-        pid_length, pid_type = struct.unpack('HH', reply.payload[8:12])
-        assert pid_type == TASKSTATS_TYPE_PID
-
-        taskstats_start = 4 + 4 + pid_length + 4
-        taskstats_data = reply.payload[taskstats_start:]
+	reply.payload = reply.payload[4:]
+	data = get_data(TASKSTATS_TYPE_AGGR_PID, reply.payload)
+	assert( len(data) > 0)
+	taskstats_data = get_data(TASKSTATS_TYPE_STATS, data)
         taskstats_version = struct.unpack('H', taskstats_data[:2])[0]
         assert taskstats_version >= 4
         return Stats(taskstats_data)
 
+def get_data(field_type, payload):
+	while len(payload) > 3:
+		reply_length, reply_type = struct.unpack('HH', payload[:4])
+		if (reply_type == field_type):
+			break
+		payload = payload[reply_length:]
+
+	return payload[4:reply_length]
+
 #
 # PIDs manipulations
 #


