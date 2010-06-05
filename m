Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0FETek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:34:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54673 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab0FETej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NtBgJY3bigT3KR/C6FwH2NJ9WoHhVdDXuBQwqlLYYxq3SxUA5uFzQShRxsrsi7VbfW
         CJphWjgnvMeFKANuXKuB45xpSGOk4WE7Tk+hdd+puff9P0eVQukPTIwD85nXhLYkFZdC
         /ypK203hGXYiBNw1Nos16xVTQuxV5q3S0d8y8=
Date: Sat, 5 Jun 2010 21:33:01 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pekka Paalanen <pq@iki.fi>, Stuart Bennett <stuart@freedesktop.org>,
       Christoph Bumiller <e0425955@student.tuwien.ac.at>,
       Shinpei KATO <shinpei@il.is.s.u-tokyo.ac.jp>,
       nouveau@lists.freedesktop.org, x86@kernel.org
Subject: Re: [PATCH] kmmio/mmiotrace: fix double free of kmmio_fault_pages
Message-ID: <20100605193301.GA2674@joi.lan>
References: <20100605164919.GA2816@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100605164919.GA2816@joi.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 05, 2010 at 06:49:42PM +0200, Marcin Slusarz wrote:
> After every iounmap mmiotrace has to free kmmio_fault_pages, but it
> can't do it directly, so it defers freeing by RCU.
> 
> It usually works, but when mmiotraced code calls ioremap-iounmap
> multiple times without sleeping between (so RCU won't kick in and
> start freeing) it can be given the same virtual address, so at
> every iounmap mmiotrace will schedule the same pages for release.
> Obviously it will explode on second free.
> 
> Fix it by marking kmmio_fault_pages which are scheduled for release
> and not adding them second time.
> 

Attached patch for mmiotrace testing module allows to reliably reproduce
the bug. It can be folded into the main patch.

---
diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index 8565d94..5f0937b 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -90,6 +90,19 @@ static void do_test(unsigned long size)
 	iounmap(p);
 }
 
+static void do_test2(void)
+{
+	void __iomem *p;
+	int i;
+	
+	for (i = 0; i < 10; ++i) {
+		p = ioremap_nocache(mmio_address, 4096);
+		if (p)
+			iounmap(p);
+	}
+	synchronize_rcu(); /* will freeing work? */
+}
+
 static int __init init(void)
 {
 	unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
@@ -104,6 +117,7 @@ static int __init init(void)
 		   "and writing 16 kB of rubbish in there.\n",
 		   size >> 10, mmio_address);
 	do_test(size);
+	do_test2();
 	pr_info("All done.\n");
 	return 0;
 }

