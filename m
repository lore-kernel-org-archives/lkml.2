Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab0CSUfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:35:13 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:28302 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab0CSUfL (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 19 Mar 2010 16:35:11 -0400
Date: Fri, 19 Mar 2010 16:04:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LKML] Re: Infinite loop on boot in free_early_partial due to
	start==end on tip/master
Message-ID: <20100319200409.GE31908@phenom.dumpdata.com>
References: <1267801390.11737.38014.camel@zakaz.uk.xensource.com> <20100319182807.GA14985@phenom.dumpdata.com> <4BA3CAB8.7000702@kernel.org> <1269027289.23584.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269027289.23584.0.camel@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BA3DFD9.003D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 07:34:49PM +0000, Ian Campbell wrote:
> On Fri, 2010-03-19 at 19:04 +0000, Yinghai Lu wrote: 
> > On 03/19/2010 11:28 AM, Konrad Rzeszutek Wilk wrote:
> > >> Subject: x86: do not free zero sized per cpu areas
> > >>
> > >> This avoids an infinite loop in free_early_partial().
> > > 
> > > The patch fixed PV guests booting on Xen. I've added my
> > > Tested-by .. Please merge it in the release.
> > > 
> > > Thanks!
> > >>
> > >> Add a warning to free_early_partial to catch future problems.
> > >>
> > >> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > > 
> > > Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > please check update version...
> > 
> > please check if this patch help...
> > 
> > http://patchwork.kernel.org/patch/83832/
> 
> Sorry Konrad, looks like I directed you to an older version of the patch
> by mistake.

Np. I tested this one and it worked succesfully.

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

index ef6370b..89a3205 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -140,7 +140,8 @@  static void __init pcpu_fc_free(void *ptr, size_t
size)
 #ifdef CONFIG_NO_BOOTMEM
 	u64 start = __pa(ptr);
 	u64 end = start + size;
-	free_early_partial(start, end);
+	if (start < end)
+		free_early_partial(start, end);
 #else
 	free_bootmem(__pa(ptr), size);
 #endif
diff --git a/kernel/early_res.c b/kernel/early_res.c
index 3cb2c66..f3a861b 100644
--- a/kernel/early_res.c
+++ b/kernel/early_res.c
@@ -333,6 +333,11 @@  void __init free_early_partial(u64 start, u64 end)
 	struct early_res *r;
 	int i;
 
+	if (WARN_ONCE(start >= end,
+		      "free_early_partial got wrong start/end
%#llx/%#llx\n",
+		      start, end))
+		return;
+
 try_next:
 	i = find_overlapped_early(start, end);
 	if (i >= max_early_res)

> 
> Ian.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
