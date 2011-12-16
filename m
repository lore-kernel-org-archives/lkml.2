Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab1LPIE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:04:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab1LPIEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:04:24 -0500
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
Subject: [PATCH] Do not round per_cpu_ptr_to_phys to page boundary
Date: Fri, 16 Dec 2011 09:04:23 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.9-default; KDE/4.6.0; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        surovegin@google.com, gthelen@google.com
References: <201112140033.58951.ptesarik@suse.cz> <201112151139.32224.ptesarik@suse.cz> <CAOS58YP8o9xQvZJtpEJobChhJ+pSDQ9PqDwaXFS_h+JFd65jOw@mail.gmail.com>
In-Reply-To: <CAOS58YP8o9xQvZJtpEJobChhJ+pSDQ9PqDwaXFS_h+JFd65jOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112160904.23252.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The phys_addr_t per_cpu_ptr_to_phys() function ignores the offset within a 
page, whenever not using a simple translation using __pa().

Without this patch /sys/devices/system/cpu/cpu*/crash_notes shows incorrect 
values, which breaks kdump. Other things may also be broken.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

diff --git a/mm/percpu.c b/mm/percpu.c
index 3bb810a..1a1b5ac 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -998,6 +998,7 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
 	bool in_first_chunk = false;
 	unsigned long first_low, first_high;
 	unsigned int cpu;
+	phys_addr_t page_addr;
 
 	/*
 	 * The following test on unit_low/high isn't strictly
@@ -1023,9 +1024,10 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
 		if (!is_vmalloc_addr(addr))
 			return __pa(addr);
 		else
-			return page_to_phys(vmalloc_to_page(addr));
+			page_addr = page_to_phys(vmalloc_to_page(addr));
 	} else
-		return page_to_phys(pcpu_addr_to_page(addr));
+		page_addr = page_to_phys(pcpu_addr_to_page(addr));
+	return page_addr + offset_in_page(addr);
 }
 
 /**
