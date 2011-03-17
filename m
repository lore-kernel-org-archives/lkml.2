Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1CQQyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:54:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58631 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1CQQyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=E19Vk+6dm8hl+GeUPm3FHhQnbfbGH2k0L8G3uxJNLHMJy7RkrbFAhIItsCr4CjxVGl
         AzRF1x45o23NZYTt+Mzwj8k3hlLb1FBJz6tyVTesk7n6OVEehEj/IjADujNGkqrWQRr/
         gyz1z6iEeEx3J99swIXmSSuBvyaMxFnqTrhBA=
Subject: Re: Poll about irqsafe_cpu_add and others
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1103171016270.12540@router.home>
References: <1300371834.6315.93.camel@edumazet-laptop>
	 <20110317.081420.71114992.davem@davemloft.net>
	 <alpine.DEB.2.00.1103171016270.12540@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 17:53:21 +0100
Message-ID: <1300380801.6315.306.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 mars 2011 à 10:18 -0500, Christoph Lameter a écrit :
> On Thu, 17 Mar 2011, David Miller wrote:
> 
> >
> > I had been meaning to bring this up from another perspective.
> >
> > In networking, we often only ever access objects in base or
> > BH context.  Therefore in BH context cases we can do just
> > normal counter bumps without any of the special atomic or
> > IRQ disabling code at all.
> 
> We have the __ functions for that purpose. __this_cpu_inc f.e. falls back
> to a simply ++ operation if the arch cannot provide something better.
> irqsafe_xx are only used if the context does not provide any protection
> and if there is the potential of the counter being incremented from an
> interrupt context.
> 

What David and I have in mind is to use one array per mib instead of
two. This is an old idea.

https://patchwork.kernel.org/patch/15883/

When we know we run from BH context, we can use __this_cpu_inc(), but if
we dont know or run from user/process context, we would need irqsafe_inc
variant.

For x86 this maps to same single instruction, but for other arches, this
might be too expensive.

BTW, I think following patch is possible to save some text and useless
tests (on 64bit platform at least)

size vmlinux.old vmlinux

Thanks

[PATCH] snmp: SNMP_UPD_PO_STATS_BH() always called from softirq

We dont need to test if we run from softirq context.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/net/snmp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/snmp.h b/include/net/snmp.h
index 762e2ab..be2424d 100644
--- a/include/net/snmp.h
+++ b/include/net/snmp.h
@@ -149,8 +149,8 @@ struct linux_xfrm_mib {
 	} while (0)
 #define SNMP_UPD_PO_STATS_BH(mib, basefield, addend)	\
 	do { \
-		__typeof__(*mib[0]) *ptr = \
-			__this_cpu_ptr((mib)[!in_softirq()]); \
+		__typeof__(*mib[0]) *ptr = __this_cpu_ptr((mib)[0]);	\
+									\
 		ptr->mibs[basefield##PKTS]++; \
 		ptr->mibs[basefield##OCTETS] += addend;\
 	} while (0)


