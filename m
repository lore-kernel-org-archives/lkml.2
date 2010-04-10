Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab0DJMgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 08:36:51 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:24266 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0DJMgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 08:36:49 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXJ75k/Dr7GSgWf1
X-RZG-CLASS-ID: mo00
Message-ID: <4BC070E0.6070601@hartkopp.net>
Date: Sat, 10 Apr 2010 14:36:48 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>
CC: Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
       Urs Thuermann <urs.thuermann@volkswagen.de>,
       socketcan-core@lists.berlios.de,
       Network Development <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc3 + CAN build problem
References: <4BC03340.5020500@freemail.hu> <1270892851.2093.32.camel@edumazet-laptop> <4BC054AE.7040303@freemail.hu>
In-Reply-To: <4BC054AE.7040303@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> Eric Dumazet írta:
>> Le samedi 10 avril 2010 à 10:13 +0200, Németh Márton a écrit :
>>> Hi,
>>>
>>> I have some problem building Liunux kernel 2.6.34-rc3 with the attached .config:
>>>
>>> $ make clean bzImage modules
>>> [...]
>>>   CC      net/socket.o
>>>   LD      net/802/built-in.o
>>>   LD      net/can/built-in.o
>>>   CC [M]  net/can/bcm.o
>>>   CC [M]  net/can/raw.o
>>> In file included from /mnt/store/nmarci/src/linux-2.6.34-rc3/arch/x86/include/asm/uaccess.h:571,
>>>                  from include/net/checksum.h:25,
>>>                  from include/linux/skbuff.h:28,
>>>                  from include/linux/if_ether.h:124,
>>>                  from include/linux/netdevice.h:29,
>>>                  from net/can/raw.c:48:
>>> In function ‘copy_from_user’,
>>>     inlined from ‘raw_setsockopt’ at net/can/raw.c:447:
>>> /mnt/store/nmarci/src/linux-2.6.34-rc3/arch/x86/include/asm/uaccess_32.h:212: error: call to ‘copy_from_user_overflow’ declared with attribute error:
>>> copy_from_user() buffer size is not provably correct
>>> make[2]: *** [net/can/raw.o] Error 1
>>> make[1]: *** [net/can] Error 2
>>> make: *** [net] Error 2
>>>
>>>
>> Could you give us your compiler version ?
> 
> $ gcc --version
> gcc (Debian 4.4.2-9) 4.4.3 20100108 (prerelease)
> Copyright (C) 2009 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
>> Code is fine, but compiler a bit dumb :(
>>
>> [PATCH] can: avoids a false warning
>>
>> At this point optlen == sizeof(sfilter) but some compilers are dumb.
>>
>> Reported-by: Németh Márton <nm127@freemail.h
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Acked-by: Oliver Hartkopp <oliver@hartkopp.net>

Btw. i'm using the same compiler here (Debian Squeeze), and i did not have any
build problems with 2.6.24-rc3 and the following kernels like the currently
running 2.6.34-rc3-00288-gab195c5:

$ cat /proc/version
Linux version 2.6.34-rc3-00288-gab195c5 (hartko@vwagwolkf320) (gcc version
4.4.3 20100108 (prerelease) (Debian 4.4.2-9) ) #70 SMP Tue Apr 6 19:14:52 CEST
2010

So i wonder why Nemeth trapped into this problem ... probably an include file
mix-up?

Regards,
Oliver


>> ---
>> diff --git a/net/can/raw.c b/net/can/raw.c
>> index 3a7dffb..da99cf1 100644
>> --- a/net/can/raw.c
>> +++ b/net/can/raw.c
>> @@ -445,7 +445,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>>  				return -EFAULT;
>>  			}
>>  		} else if (count == 1) {
>> -			if (copy_from_user(&sfilter, optval, optlen))
>> +			if (copy_from_user(&sfilter, optval, sizeof(sfilter)))
>>  				return -EFAULT;
>>  		}
>>  
