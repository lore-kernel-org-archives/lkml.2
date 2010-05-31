Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0EaNNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:13:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41407 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab0EaNNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EkBlWvCqKxyoDP4BniKB3uWEgOd0gLt1wUW5CtJ4CCi+dz9d+a6F2sYW90wx/dEGq5
         BkOCGrHR4EvPi5lHlfN3w2zzK+a9ceHWWpLBwqbFgSIReWaeo/mw9IZ9ir5MISM+uzf8
         Cx4nsXPSEouMR0SpLmXMvKZEzxZIlaNedq9Y0=
Subject: [PATCH] netfilter: xtables: stackptr should be percpu
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Xiaotian Feng <dfeng@redhat.com>, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <alpine.LSU.2.01.1005311350580.31799@obet.zrqbmnf.qr>
References: <1275303998-2435-1-git-send-email-dfeng@redhat.com>
	 <alpine.LSU.2.01.1005311350580.31799@obet.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 15:13:00 +0200
Message-ID: <1275311580.3291.44.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 31 mai 2010 à 13:51 +0200, Jan Engelhardt a écrit :
> On Monday 2010-05-31 13:06, Xiaotian Feng wrote:
> 
> >In xt_register_table, xt_jumpstack_alloc is called first, later
> >xt_replace_table is used. But in xt_replace_table, xt_jumpstack_alloc
> >will be used again. Then the memory allocated by previous xt_jumpstack_alloc
> >will be leaked. We can simply remove the previous xt_jumpstack_alloc because
> >there aren't any users of newinfo between xt_jumpstack_alloc and
> >xt_replace_table.
> 
> Indeed that seems to be so.

An official "Acked-by: ..." would be fine Jan :)

BTW I noticed a _big_ slowdown of iptables lately, and located the
reason.

All cpus share a single cache line for their 'stackptr' storage,
introduced in commit f3c5c1bfd4

This is a stable candidate (2.6.34)

Note : We also should use alloc_percpu() for jumpstack but this is not a
critical thing and can be a net-next patch.


[PATCH] netfilter: xtables: stackptr should be percpu

commit f3c5c1bfd4 (netfilter: xtables: make ip_tables reentrant)
introduced a performance regression, because stackptr array is shared by
all cpus, adding cache line ping pongs. (16 cpus share a 64 bytes cache
line)

Fix this using alloc_percpu()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/netfilter/x_tables.h |    2 +-
 net/ipv4/netfilter/ip_tables.c     |    2 +-
 net/ipv6/netfilter/ip6_tables.c    |    2 +-
 net/netfilter/x_tables.c           |   13 +++----------
 4 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index c00cc0c..24e5d01 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -397,7 +397,7 @@ struct xt_table_info {
 	 * @stacksize jumps (number of user chains) can possibly be made.
 	 */
 	unsigned int stacksize;
-	unsigned int *stackptr;
+	unsigned int __percpu *stackptr;
 	void ***jumpstack;
 	/* ipt_entry tables: one per CPU */
 	/* Note : this field MUST be the last one, see XT_TABLE_INFO_SZ */
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 63958f3..4b6c5ca 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -336,7 +336,7 @@ ipt_do_table(struct sk_buff *skb,
 	cpu        = smp_processor_id();
 	table_base = private->entries[cpu];
 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
-	stackptr   = &private->stackptr[cpu];
+	stackptr   = per_cpu_ptr(private->stackptr, cpu);
 	origptr    = *stackptr;
 
 	e = get_entry(table_base, private->hook_entry[hook]);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 6f517bd..9d2d68f 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -363,7 +363,7 @@ ip6t_do_table(struct sk_buff *skb,
 	cpu        = smp_processor_id();
 	table_base = private->entries[cpu];
 	jumpstack  = (struct ip6t_entry **)private->jumpstack[cpu];
-	stackptr   = &private->stackptr[cpu];
+	stackptr   = per_cpu_ptr(private->stackptr, cpu);
 	origptr    = *stackptr;
 
 	e = get_entry(table_base, private->hook_entry[hook]);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 445de70..7e8a93d 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -699,10 +699,8 @@ void xt_free_table_info(struct xt_table_info *info)
 		vfree(info->jumpstack);
 	else
 		kfree(info->jumpstack);
-	if (sizeof(unsigned int) * nr_cpu_ids > PAGE_SIZE)
-		vfree(info->stackptr);
-	else
-		kfree(info->stackptr);
+
+	free_percpu(info->stackptr);
 
 	kfree(info);
 }
@@ -753,14 +751,9 @@ static int xt_jumpstack_alloc(struct xt_table_info *i)
 	unsigned int size;
 	int cpu;
 
-	size = sizeof(unsigned int) * nr_cpu_ids;
-	if (size > PAGE_SIZE)
-		i->stackptr = vmalloc(size);
-	else
-		i->stackptr = kmalloc(size, GFP_KERNEL);
+	i->stackptr = alloc_percpu(unsigned int);
 	if (i->stackptr == NULL)
 		return -ENOMEM;
-	memset(i->stackptr, 0, size);
 
 	size = sizeof(void **) * nr_cpu_ids;
 	if (size > PAGE_SIZE)


