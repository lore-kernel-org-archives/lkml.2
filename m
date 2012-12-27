Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2L0LVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 06:21:55 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:38251
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841Ab2L0LVx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 06:21:53 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758hbe9i1155h)
From: Liu Hui-R64343 <r64343@freescale.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mgorman@suse.de" <mgorman@suse.de>
Subject: echo 1 > /proc/sys/vm/compact_memory -> sh: write error: Bad address
Thread-Topic: echo 1 > /proc/sys/vm/compact_memory -> sh: write error: Bad
 address
Thread-Index: Ac3kJF/a6SI7D+iJS5WtP6F+qKZUbA==
Date: Thu, 27 Dec 2012 11:21:48 +0000
Message-ID: <AD13664F485EE54694E29A7F9D5BE1AF4D35F3@039-SN2MPN1-021.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.64]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I met one error when does the following command:

sh/$ echo 1 > /proc/sys/vm/compact_memory
sh/$ sh: write error: Bad address

After using strace, I find the following:
...
write(1, "1\n", 2)                              = 3
write(1, "", 4294967295)                = -1 EFAULT (Bad address)
write(2, "echo: write error: Bad address\n", 31echo: write error: Bad address
) = 31

>From the code, we can see it will return COMPACT_COMPLETE = 3 always when write.

/* Compact all nodes in the system */
static int compact_nodes(void)
{
        int nid;

        /* Flush pending updates to the LRU lists */
        lru_add_drain_all();

        for_each_online_node(nid)
                compact_node(nid);

        return COMPACT_COMPLETE;
}

/* The written value is actually unused, all memory is compacted */
int sysctl_compact_memory;

/* This is the entry point for compacting all nodes via /proc/sys/vm */
int sysctl_compaction_handler(struct ctl_table *table, int write,
                        void __user *buffer, size_t *length, loff_t *ppos)
{
        if (write)
                return compact_nodes();

        return 0;
}

I think we can't simply return COMPACT_COMPLETE, instead, we need return *length.

The following patch can fix this issue:

diff --git a/mm/compaction.c b/mm/compaction.c
index c4bc5ac..d3cb27f 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -732,8 +732,10 @@ int sysctl_compact_memory;
 int sysctl_compaction_handler(struct ctl_table *table, int write,
                        void __user *buffer, size_t *length, loff_t *ppos)
 {
-       if (write)
-               return compact_nodes();
+       if (write) {
+               compact_nodes();
+               return *length;
+       }

        return 0;
 }


Anyone can comment on it? Thanks a lot.

Happy Holiday.

Best Regards,
Jason Liu



