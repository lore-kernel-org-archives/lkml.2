Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab2APLXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 06:23:39 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38434 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab2APLXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 06:23:38 -0500
MIME-Version: 1.0
Date: Mon, 16 Jan 2012 09:23:36 -0200
Message-ID: <CAAA8XhPgd_ZBE30eg3LbpY4dy4Ko=d2XbEa1E=kueoBW+eGRUQ@mail.gmail.com>
Subject: Re: Re: Re: XFS deadlock fixed?
From: Kelbel Junior <jymmyjr@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, everybody.
It appeared that same error message when using kernel version 2.6.38.8 ...

Several lines in /var/log/messages with:
kernel: XFS: possible memory allocation deadlock in kmem_alloc (mode: 0x250)

Does anyone know know if this bug has been fixed in newer versions of
Linux kernel? 3.x maybe?



Thanks.
Kelbel Junior


2011/5/11 Christoph Hellwig <>

    And here's the actual patch, sorry:


    Index: linux-2.6/fs/xfs/linux-2.6/kmem.c
    ===================================================================
    --- linux-2.6.orig/fs/xfs/linux-2.6/kmem.c	2011-05-11
17:29:51.729191621 +0200

    +++ linux-2.6/fs/xfs/linux-2.6/kmem.c	2011-05-11 17:30:22.915689382 +0200
    @@ -56,10 +56,12 @@ kmem_alloc(size_t size, unsigned int __n
     		ptr = kmalloc(size, lflags);
     		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))

     			return ptr;
    -		if (!(++retries % 100))
    +		if (!(++retries % 100)) {
     			xfs_err(NULL,
     		"possible memory allocation deadlock in %s (mode:0x%x)",
     					__func__, lflags);
    +			dump_stack();

    +		}
     		congestion_wait(BLK_RW_ASYNC, HZ/50);
     	} while (1);
     }
    @@ -112,10 +114,12 @@ kmem_zone_alloc(kmem_zone_t *zone, unsig
     		ptr = kmem_cache_alloc(zone, lflags);
     		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))

     			return ptr;
    -		if (!(++retries % 100))
    +		if (!(++retries % 100)) {
     			xfs_err(NULL,
     		"possible memory allocation deadlock in %s (mode:0x%x)",
     					__func__, lflags);
    +			dump_stack();

    +		}
     		congestion_wait(BLK_RW_ASYNC, HZ/50);
     	} while (1);
     }


    2011/5/11 Christoph Hellwig <>

        You're probably running into a different issue.  Any chance you can try
        the attached patch to see where you're stuck exactly?

        Also in case you're using slub (CONFIG_SLUB) can you check if it still

        happens when using slab (CONFIG_SLAB) instead?


        2011/5/10 Felipe Wilhelms Damasio - Taghos <>

                Hi Mr. Hellwig,

                I saw the XFS deadlock thread regarding 2.6.38:

            http://www.linux.sgi.com/archives/xfs/2011-03/msg00185.html


                I'm seeing too in 2.6.38.4. A lot of

            XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)

                I checked the changelog for 2.6.38.6 and can't be sure
if the fix got
            in...could you tell me if it did?


                Thanks,

            --

            Felipe Wilhelms Damasio


            TAGHOS - Tecnologia
            Rua Prof. Alvaro Alvim, 211
            Porto Alegre - RS - (51) 3239-3180
            www.taghos.com.br <http://www.taghos.com.br/>
