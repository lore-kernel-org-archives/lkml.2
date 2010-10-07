Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0JGWWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:22:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41111 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0JGWWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=weD2nXYm5oOVpPvtq/ZXTWuZOFyVMxZ6VsoL4qDDjTpyw2BDbIy5cEQ0PIhn9ikT/l
         TRJTL+nLuhWkVazVnV2h9uq9qjJS2g015JYAe2hHyCJfSN9Y0i8vhhhnWYCDDcSc++bH
         nARteIOKdDLTmlpxOdWUzYEPpEu3bQrphCNdw=
Subject: Re: IPv4: sysctl table check failed [was: mmotm 2010-10-07-14-08
 uploaded]
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, ML netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4CAE4479.6010606@gmail.com>
References: <201010072140.o97Le69i025659@imap1.linux-foundation.org>
	 <4CAE4479.6010606@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 00:22:15 +0200
Message-ID: <1286490135.6536.75.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 08 octobre 2010 à 00:06 +0200, Jiri Slaby a écrit :
> On 10/07/2010 11:08 PM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2010-10-07-14-08 has been uploaded to
> 
> Hi, I got bunch of "sysctl table check failed" below. All seem to be
> related to ipv4:

I would say, sysctl check is buggy :(

min/max are optional

[PATCH] sysctl: min/max bounds are optional

sysctl check complains when proc_doulongvec_minmax or
proc_doulongvec_ms_jiffies_minmax are used by a vector of longs (with
more than one element), with no min or max value specified.

This is unexpected, given we had a bug on this min/max handling :)

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 kernel/sysctl_check.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index 04cdcf7..10b90d8 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -143,15 +143,6 @@ int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
 				if (!table->maxlen)
 					set_fail(&fail, table, "No maxlen");
 			}
-			if ((table->proc_handler == proc_doulongvec_minmax) ||
-			    (table->proc_handler == proc_doulongvec_ms_jiffies_minmax)) {
-				if (table->maxlen > sizeof (unsigned long)) {
-					if (!table->extra1)
-						set_fail(&fail, table, "No min");
-					if (!table->extra2)
-						set_fail(&fail, table, "No max");
-				}
-			}
 #ifdef CONFIG_PROC_SYSCTL
 			if (table->procname && !table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");


