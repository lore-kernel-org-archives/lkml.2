Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab0DJJrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 05:47:40 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47328 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab0DJJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 05:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=x4oV7tgiGrU7cbiZPu4EgF5XNcHg1T/mz7SA+q/VTNTlAEEHOOphr7qM40rIfhnfHy
         VH0M37I8FZucgWgeFEKaNGyMD0QpCH7UU5eB1t9EKG838N9rsXVmclJ7c6XYwcivdKws
         sdnqFlqUatrnDk/mKY+BmofeHEg3MDnWGwOzU=
Subject: Re: Linux 2.6.34-rc3 + CAN build problem
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
       Urs Thuermann <urs.thuermann@volkswagen.de>,
       socketcan-core@lists.berlios.de,
       Network Development <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BC03340.5020500@freemail.hu>
References: <4BC03340.5020500@freemail.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Apr 2010 11:47:31 +0200
Message-ID: <1270892851.2093.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 10 avril 2010 à 10:13 +0200, Németh Márton a écrit :
> Hi,
> 
> I have some problem building Liunux kernel 2.6.34-rc3 with the attached .config:
> 
> $ make clean bzImage modules
> [...]
>   CC      net/socket.o
>   LD      net/802/built-in.o
>   LD      net/can/built-in.o
>   CC [M]  net/can/bcm.o
>   CC [M]  net/can/raw.o
> In file included from /mnt/store/nmarci/src/linux-2.6.34-rc3/arch/x86/include/asm/uaccess.h:571,
>                  from include/net/checksum.h:25,
>                  from include/linux/skbuff.h:28,
>                  from include/linux/if_ether.h:124,
>                  from include/linux/netdevice.h:29,
>                  from net/can/raw.c:48:
> In function ‘copy_from_user’,
>     inlined from ‘raw_setsockopt’ at net/can/raw.c:447:
> /mnt/store/nmarci/src/linux-2.6.34-rc3/arch/x86/include/asm/uaccess_32.h:212: error: call to ‘copy_from_user_overflow’ declared with attribute error:
> copy_from_user() buffer size is not provably correct
> make[2]: *** [net/can/raw.o] Error 1
> make[1]: *** [net/can] Error 2
> make: *** [net] Error 2
> 
> 

Could you give us your compiler version ?

Code is fine, but compiler a bit dumb :(

[PATCH] can: avoids a false warning

At this point optlen == sizeof(sfilter) but some compilers are dumb.

Reported-by: Németh Márton <nm127@freemail.h
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/net/can/raw.c b/net/can/raw.c
index 3a7dffb..da99cf1 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -445,7 +445,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 				return -EFAULT;
 			}
 		} else if (count == 1) {
-			if (copy_from_user(&sfilter, optval, optlen))
+			if (copy_from_user(&sfilter, optval, sizeof(sfilter)))
 				return -EFAULT;
 		}
 


