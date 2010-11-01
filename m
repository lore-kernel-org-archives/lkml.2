Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab0KARzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:55:42 -0400
Received: from canuck.infradead.org ([134.117.69.58]:48483 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab0KARzk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:55:40 -0400
Subject: Re: [PATCH] Perf, AMD: Prefer kzalloc() over kmalloc()+memset() in
 amd_alloc_nb()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <bp@amd64.org>
In-Reply-To: <alpine.LNX.2.00.1010302101240.1572@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302101240.1572@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 01 Nov 2010 18:55:13 +0100
Message-ID: <1288634113.2039.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 21:06 +0200, Jesper Juhl wrote:
> Hi,
> 
> I believe this would be an improvement?
> 
> Prefer kzalloc() over kmalloc()+memset() in amd_alloc_nb().
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---


I've changed it to..

---
Subject: perf, amd: Use kmalloc_node(,__GFP_ZERO) for northbridge structure allocation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Nov 01 18:52:05 CET 2010

Jasper suggested we use the zeroing capability of the allocators
instead of calling memset ourselves. Add node affinity while we're at
it.

Reported-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_amd.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
@@ -280,11 +280,10 @@ static struct amd_nb *amd_alloc_nb(int c
 	struct amd_nb *nb;
 	int i;
 
-	nb = kmalloc(sizeof(struct amd_nb), GFP_KERNEL);
+	nb = kmalloc_node(sizeof(struct amd_nb), GFP_KERNEL | __GFP_ZERO, nb_id);
 	if (!nb)
 		return NULL;
 
-	memset(nb, 0, sizeof(*nb));
 	nb->nb_id = nb_id;
 
 	/*

