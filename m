Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab1CXAUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:20:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933023Ab1CXAUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:20:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1300826506-23192-1-git-send-email-vapier@gentoo.org>
References: <1300826506-23192-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>, graf.yang@analog.com
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
        Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOMMU: support SMP dynamic percpu_alloc
Date: Thu, 24 Mar 2011 00:20:12 +0000
Message-ID: <10444.1300926012@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> The percpu code requires more functions to be implemented in the mm core
> which nommu currently does not provide.  So add inline implementations
> since these are largely meaningless on nommu systems.

Under what conditions are these required?

I've seen one percpu compilation bug that I've made a patch for (see
attached), but none of these.  Is SMP required to trigger them?

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: percpu should use is_vmalloc_addr().

per_cpu_ptr_to_phys() uses VMALLOC_START and VMALLOC_END to determine if an
address is in the vmalloc() region or not.  This is incorrect on NOMMU as
there is no real vmalloc() capability (vmalloc() is emulated by kmalloc()).

The correct way to do this is to use is_vmalloc_addr().  This encapsulates the
vmalloc() region test in MMU mode and just returns 0 in NOMMU mode.

On FRV in NOMMU mode, the percpu compilation fails without this patch:

mm/percpu.c: In function 'per_cpu_ptr_to_phys':
mm/percpu.c:1011: error: 'VMALLOC_START' undeclared (first use in this function)
mm/percpu.c:1011: error: (Each undeclared identifier is reported only once
mm/percpu.c:1011: error: for each function it appears in.)
mm/percpu.c:1012: error: 'VMALLOC_END' undeclared (first use in this function)
mm/percpu.c:1018: warning: control reaches end of non-void function

Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/percpu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/mm/percpu.c b/mm/percpu.c
index 3f93001..55d4d11 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1008,8 +1008,7 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
 	}
 
 	if (in_first_chunk) {
-		if ((unsigned long)addr < VMALLOC_START ||
-		    (unsigned long)addr >= VMALLOC_END)
+		if (!is_vmalloc_addr(addr))
 			return __pa(addr);
 		else
 			return page_to_phys(vmalloc_to_page(addr));
