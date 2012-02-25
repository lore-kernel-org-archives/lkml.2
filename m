Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab2BYA4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 19:56:07 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:58414
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755396Ab2BYA4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 19:56:05 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F48318E.8070902@am.sony.com>
Date: Fri, 24 Feb 2012 16:55:42 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        linux kernel <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <eric.dumazet@gmail.com>
Subject: RFC: memory leak in udp_table_init
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've uncovered an obscure memory leak in the routine udp_table_init(),
in the file: net/ipv4/udp.c

The allocation sequence is a bit weird, and I've got some questions
about the best way to fix it.

Here's the code:

void __init udp_table_init(struct udp_table *table, const char *name)
{
	unsigned int i;

	if (!CONFIG_BASE_SMALL)
		table->hash = alloc_large_system_hash(name,
			2 * sizeof(struct udp_hslot),
			uhash_entries,
			21, /* one slot per 2 MB */
			0,
			&table->log,
			&table->mask,
			64 * 1024);
	/*
	 * Make sure hash table has the minimum size
	 */
	if (CONFIG_BASE_SMALL || table->mask < UDP_HTABLE_SIZE_MIN - 1) {
		table->hash = kmalloc(UDP_HTABLE_SIZE_MIN *
				      2 * sizeof(struct udp_hslot), GFP_KERNEL);
		if (!table->hash)
			panic(name);
		table->log = ilog2(UDP_HTABLE_SIZE_MIN);
		table->mask = UDP_HTABLE_SIZE_MIN - 1;
	}
	...

We've seen instances where the second allocation of table->hash
is performed, wiping out the first hash table allocation, without a
free.  This ends up leaking the previously allocated hash table.

That is, if we are !CONFIG_BASE_SMALL and for some reason
the alloc_large_system_hash() operation returns less than UDP_HTABLE_SIZE_MIN
hash slots, then it will trigger this.

There's no complementary "free_large_system_hash()" which can be used to
back out of the first allocation, that I can find.

We are currently doing the following to avoid the memory leak, but this
seems like it defeats the purpose of checking for the minimum size
(that is, if the first allocation was too small, we don't re-allocate).

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 5d075b5..2524af4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2194,7 +2194,8 @@ void __init udp_table_init(struct udp_table *table, const char *name)
 	/*
 	 * Make sure hash table has the minimum size
 	 */
-	if (CONFIG_BASE_SMALL || table->mask < UDP_HTABLE_SIZE_MIN - 1) {
+	if ((CONFIG_BASE_SMALL || table->mask < UDP_HTABLE_SIZE_MIN - 1)
+		&& !table->hash) {
 		table->hash = kmalloc(UDP_HTABLE_SIZE_MIN *
 				      2 * sizeof(struct udp_hslot), GFP_KERNEL);
 		if (!table->hash)

Any suggestions for a way to correct for a too-small first allocation, without
a memory leak?

Alternatively - how critical is this UDP_HTABLE_SIZE_MIN for correct operation
of the stack?

Thanks for any information you can provide.

 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

