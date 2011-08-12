Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1HNQQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:16:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab1HNQJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:57 2011
Message-Id: <20110812210557.805423660@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [65/90] sparc: Dont do expensive hypervisor PCR write unless necessary.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 314ff52727fe94dfbe07f3a9a489ab3ca8d8df5a ]

The hypervisor call is only necessary if hypervisor events are
being requested.

So if we're not tracking hypervisor events, simply do a direct
register write.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/pcr.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/pcr.c
+++ b/arch/sparc/kernel/pcr.c
@@ -80,8 +80,11 @@ static void n2_pcr_write(u64 val)
 {
 	unsigned long ret;
 
-	ret = sun4v_niagara2_setperf(HV_N2_PERF_SPARC_CTL, val);
-	if (ret != HV_EOK)
+	if (val & PCR_N2_HTRACE) {
+		ret = sun4v_niagara2_setperf(HV_N2_PERF_SPARC_CTL, val);
+		if (ret != HV_EOK)
+			write_pcr(val);
+	} else
 		write_pcr(val);
 }
 


