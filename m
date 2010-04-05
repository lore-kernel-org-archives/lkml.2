Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab0DEVEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:04:20 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62323 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab0DEVEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Sqtc8AP7Uj1MXmRU7QAzoBw8LWLmi2InLw9OyJQ9MiZoHHW5KPVqCvByoxDW8f+kD+
         EM7TnGQW83LuatMSRxdQpcssjhVNLeD1uq1kkqT9qWdvh9HLw59w3cywsuZugVgwMD8i
         F6N8hrPgcKVgot0MMvi9GXhuftYkZLJ7gtZUY=
Subject: Re: [BUG] x86info fails on 2.6.34 ?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1270499041.9013.15.camel@edumazet-laptop>
References: <1270499041.9013.15.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Apr 2010 23:04:08 +0200
Message-ID: <1270501448.9013.23.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 05 avril 2010 à 22:24 +0200, Eric Dumazet a écrit :
> Hi Dave
> 
> I just noticed x86info was not working anymore on latest kernel
> 
> x86info v1.24.  Dave Jones 2001-2009
> Feedback to <davej@redhat.com>.
> 
> type seek: Value too large for defined data type
> 
> 
> Offending syscall is an lseek(fd, -1, SEEK_CUR) on /dev/mem file
> 
> 
> 
> open("/dev/mem", O_RDONLY)              = 3
> ...
> lseek(3, 1023092, SEEK_SET)             = 1023092
> read(3, "PCMP\4\3\4\266HP      PROLIANT    \0\0\0\0\0"..., 44) = 44
> read(3, "\0"..., 1)                     = 1
> lseek(3, -1, SEEK_CUR)                  = -1 EOVERFLOW (Value too large
> for defined data type)
> 
> It seems -1 is taken as an unsigned quantity ?
> 

Andrew, commit dcefafb6ac90ece8d68a6c203105f3d313e52da4 seems to be the
problem. 

It breaks rewinds (negative offsets to lseek (... SEEK_CUR))


commit dcefafb6ac90ece8d68a6c203105f3d313e52da4
Author: Wu Fengguang <fengguang.wu@intel.com>
Date:   Wed Mar 10 15:21:51 2010 -0800

    /dev/mem: dont allow seek to last page
    
    So as to return a uniform error -EOVERFLOW instead of a random one:
    
    # kmem-seek 0xfffffffffffffff0
    seek /dev/kmem: Device or resource busy
    # kmem-seek 0xfffffffffffffff1
    seek /dev/kmem: Block device required
    
    Suggested by OGAWA Hirofumi.
    
    Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>



