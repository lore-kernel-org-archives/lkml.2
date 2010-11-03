Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab0KCBaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 21:30:35 -0400
Received: from smtp-out.google.com ([74.125.121.35]:35648 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab0KCBa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 21:30:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=oVAkso6SgyfnfZxRd7j739K2R3kggbzklJInTyIaeJXEKfNf1cO6osYLmDQ9mC82H
	dwXAwFoTtmXKWWlmdnkEw==
Subject: [PATCH v1 08/12] netoops: Add one-shot mode
To: simon.kagstrom@netinsight.net, davem@davemloft.net
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, akpm@linux-foundation.org, chavey@google.com,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Date: Tue, 02 Nov 2010 18:30:13 -0700
Message-ID: <20101103013012.4641.15217.stgit@crlf.mtv.corp.google.com>
In-Reply-To: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it is possible to have a kernel crashing that continuously Oopses.
In this case, we do not want the network dumper get called over and over again,
as we may only be interested in the first Oops that a kernel emits (especially
in cases where we panic_on_oops).

In order to support this dumping policy, this commit introduces a file call
/proc/sys/kernel/net_dump_one_shot that contains a boolean as to whether or not
the netoops driver will operate in one-shot mode.

Note that 'soft' dumps do not disable the netoops driver when one-shot mode is
enabled.

Signed-off-by: Mike Waychison <mikew@google.com>
---
TODO: ABI needs a better home.
---
 drivers/net/netoops.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
index 13c4d51..01432d7 100644
--- a/drivers/net/netoops.c
+++ b/drivers/net/netoops.c
@@ -86,6 +86,8 @@ static struct netpoll *np;
 static struct neighbour *netoops_neighbour;
 static DEFINE_SPINLOCK(netoops_lock);
 static struct netoops_msg msg;
+static int network_dumper_one_shot = 1;
+static int network_dumper_disabled;
 
 static char netoops_fw_version[80];
 static char netoops_board_name[80];
@@ -209,6 +211,7 @@ static void enable_netoops(char *dev_name, u32 dest_ip, u32 src_ip,
 	np = new_np;
 	neighbour = netoops_neighbour;
 	netoops_neighbour = dest_neighbour;
+	network_dumper_disabled = 0;
 	spin_unlock_irqrestore(&netoops_lock, flags);
 
 	/* refcount cannot be decreased with interrupt disabled. */
@@ -415,7 +418,7 @@ static void netoops(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
 	if (!spin_trylock(&netoops_lock))
 		return;
 
-	if (np == NULL || np->dev == NULL) {
+	if (np == NULL || np->dev == NULL || network_dumper_disabled) {
 		spin_unlock(&netoops_lock);
 		return;
 	}
@@ -442,6 +445,10 @@ static void netoops(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
 		netoops_send_segment(packet_count_2, s1, l1);
 	}
 
+	/* Should we disable ourselves now? */
+	if (!soft_dump && network_dumper_one_shot)
+		network_dumper_disabled = 1;
+
 	spin_unlock(&netoops_lock);
 }
 
@@ -577,6 +584,13 @@ static struct ctl_table kern_table[] = {
 		.mode           = 0644,
 		.proc_handler   = &proc_netoops_device,
 	},
+	{
+		.procname       = "net_dump_one_shot",
+		.data           = &network_dumper_one_shot,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
 	{},
 };
 

