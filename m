Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab1DZCwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 22:52:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39476 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab1DZCwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 22:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jKS6lKA5e60CUmQXkyTYK3kAcADCtERLbUqR3C+9CBFmSW2ZTN0Iq9MXwd4nN49005
         vI8GG9jKf7wyDypV4XcCimGCT3nsQg9aOcErMUpKrWFqPTxqJ7rV02io69SKGcUhf73O
         Tp3kVzpEZd6JCYDsEnGfsvr5JYZdxYllpcTWE=
Message-ID: <4DB63349.3070808@gmail.com>
Date: Tue, 26 Apr 2011 14:51:53 +1200
From: Michael Schmitz <schmitzmic@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Michael Schmitz <schmitzmic@googlemail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
        "tg@mirbsd.de >> Thorsten Glaser" <tg@mirbsd.de>
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211500170.5741@router.home> <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com> <4DB3840F.3060503@gmail.com> <alpine.DEB.2.00.1104251355410.31884@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1104251355410.31884@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> Ok, would you like to write a changelog for this similar to mine and then 
> propose it as an alternative?
>
> Thanks!
>   
Will this one do?

Cheers,

  Michael


commit 99b9c43cfb18a8e2222e9ef80b04a5c3e1dad254
Author: Michael Schmitz <schmitz@debian.org>
Date:   Tue Apr 26 14:51:54 2011 +1200

[m68k]      For m68k, N_NORMAL_MEMORY represents all nodes that have 
present memory
        since it does not support HIGHMEM.  This patch sets the bit at 
the time
        node_present_pages has been set by free_area_init_node.
        At the time the node is brought online, the the node state would 
have to
        be done unconditionally since information about present memory 
has not yet
        been recorded.
              
        If N_NORMAL_MEMORY is not accurate, slub may encounter errors 
since it
        uses this nodemask to setup per-cache kmem_cache_node data 
structures.

         This pach is an alternative to the one proposed by David 
Rientjes <rientjes@google.com>
         attempting to set node state immediately when bringing the node 
online.

Signed-off-by: Michael Schmitz <schmitz@debian.org>
---
 arch/m68k/mm/motorola.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index 02b7a03..b806c19 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -300,6 +300,8 @@ void __init paging_init(void)
                zones_size[ZONE_DMA] = m68k_memory[i].size >> PAGE_SHIFT;
                free_area_init_node(i, zones_size,
                                    m68k_memory[i].addr >> PAGE_SHIFT, 
NULL);
+                if (node_present_pages(i))
+                        node_set_state(i, N_NORMAL_MEMORY);
        }
 }

