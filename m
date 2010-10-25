Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab0JYSLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:11:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52089 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0JYSLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:11:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=l0rZ7CdqFYHLWfrB42y9oZINmp2fJ4oQIXWCBR7yzD6whsdVS66o+9LCinAm7nFO/n
         Dc+QTloHPD7Pm8+ANzq5l0/7kRhPxvQsnFqPyuq7ps9xU2u5890Vj8Ea2GVk5wx/hmQZ
         xp9cyDW7zyFSBbEDVxiziFo1h5cSc9Mgsz3aA=
Message-ID: <4CC5C863.9070801@lwfinger.net>
Date: Mon, 25 Oct 2010 13:11:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Arnd Hannemann <arnd@arndnet.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: b43legacy: fix compile error
References: <1288017690-31248-1-git-send-email-arnd@arndnet.de>	 <4CC5A301.1080606@lwfinger.net> <1288021905.2826.142.camel@edumazet-laptop>
In-Reply-To: <1288021905.2826.142.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 10:51 AM, Eric Dumazet wrote:
> Le lundi 25 octobre 2010 à 10:32 -0500, Larry Finger a écrit :
>> On 10/25/2010 09:41 AM, Arnd Hannemann wrote:
>>> On todays linus tree the following compile error happened to me:
>>>
>>>   CC [M]  drivers/net/wireless/b43legacy/xmit.o
>>> In file included from include/net/dst.h:11,
>>>                  from drivers/net/wireless/b43legacy/xmit.c:31:
>>> include/net/dst_ops.h:28: error: expected ':', ',', ';', '}' or '__attribute__' before '____cacheline_aligned_in_smp'
>>> include/net/dst_ops.h: In function 'dst_entries_get_fast':
>>> include/net/dst_ops.h:33: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>> include/net/dst_ops.h: In function 'dst_entries_get_slow':
>>> include/net/dst_ops.h:41: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>> include/net/dst_ops.h: In function 'dst_entries_add':
>>> include/net/dst_ops.h:49: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>> include/net/dst_ops.h: In function 'dst_entries_init':
>>> include/net/dst_ops.h:55: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>> include/net/dst_ops.h: In function 'dst_entries_destroy':
>>> include/net/dst_ops.h:60: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>> make[4]: *** [drivers/net/wireless/b43legacy/xmit.o] Error 1
>>> make[3]: *** [drivers/net/wireless/b43legacy] Error 2
>>> make[2]: *** [drivers/net/wireless] Error 2
>>> make[1]: *** [drivers/net] Error 2
>>> make: *** [drivers] Error 2
>>>
>>> This patch fixes this issue by adding "linux/cache.h" as an include to
>>> "include/net/dst_ops.h".
>>
>> Strange. Compiling b43legacy from the linux-2.6.git tree (git describe is
>> v2.6.36-4464-g229aebb) works fine on x86_64. I wonder what is different.
> 
> Well, x86_64 must include cache.h, this is probably why I missed it in
> my build tests.
> 
> I wonder also why #include <net/dst.h> is needed at all in this
> driver...
> 
> diff --git a/drivers/net/wireless/b43legacy/xmit.c
> b/drivers/net/wireless/b43legacy/xmit.c
> index 7d177d9..a261aec 100644
> --- a/drivers/net/wireless/b43legacy/xmit.c
> +++ b/drivers/net/wireless/b43legacy/xmit.c
> @@ -28,8 +28,6 @@
>  
>  */
>  
> -#include <net/dst.h>
> -
>  #include "xmit.h"
>  #include "phy.h"
>  #include "dma.h"

I have no idea why that header was included - likely historical in the
transformation from bcm43xx to b43legacy. For completeness, there are 2 more
places to change:

Index: linux-2.6/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/dma.c
+++ linux-2.6/drivers/net/wireless/b43legacy/dma.c
@@ -38,7 +38,6 @@
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
-#include <net/dst.h>

 /* 32bit DMA ops. */
 static
Index: linux-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ linux-2.6/drivers/net/wireless/b43legacy/main.c
@@ -41,7 +41,6 @@
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
-#include <net/dst.h>
 #include <asm/unaligned.h>

 #include "b43legacy.h"
Index: linux-2.6/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/xmit.c
+++ linux-2.6/drivers/net/wireless/b43legacy/xmit.c
@@ -28,8 +28,6 @@

 */

-#include <net/dst.h>
-
 #include "xmit.h"
 #include "phy.h"
 #include "dma.h"

Will you push the complete patch to Linus or DaveM?

Larry

