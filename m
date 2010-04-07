Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab0DGJUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 05:20:49 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59706 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0DGJUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 05:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oNHzn7EOy+HWj5p30ooouJLUd9k4MKQ+4cRpkLfq7cl6D3bHbqtvB4ODJKV/J/62dd
         cKvoAR2a6P2skT2GzYy38nps6mAXcWa5gh+78/GoITDIr+dftZ0xHFK/rKu5HvCohgGO
         FVRZ7ACua2d83q6MSv+t2YuXK+c+5CezLmoqw=
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       netdev <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1270631267.2078.380.camel@ymzhang.sh.intel.com>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
	 <1270114166.2078.107.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004011050340.16531@router.home>
	 <1270195589.2078.116.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004050853300.23149@router.home>
	 <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>
	 <4BBA8DF9.8010409@kernel.org>
	 <1270542497.2078.123.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004061033330.18750@router.home>
	 <alpine.DEB.2.00.1004061552500.19151@router.home>
	 <1270591841.2091.170.camel@edumazet-laptop>
	 <1270607668.2078.259.camel@ymzhang.sh.intel.com>
	 <1270622352.2091.702.camel@edumazet-laptop>
	 <1270631267.2078.380.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 11:20:33 +0200
Message-ID: <1270632033.2091.875.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 avril 2010 à 17:07 +0800, Zhang, Yanmin a écrit :
> > 
> > One experiment on your Nehalem machine would be to change hackbench so
> > that each group (20 senders/ 20 receivers) run on a particular NUMA
> > node.
> I expect process scheduler to work well in scheduling different groups
> to different nodes.
> 
> I suspected dynamic percpu data didn't take care of NUMA, but kernel dump shows
> it does take care of NUMA.
> 

hackbench allocates all unix sockets on one single node, then
forks/spans its children.

Thats huge node imbalance.

You can see this with lsof on a running hackbench :


# lsof -p 14802
COMMAND     PID USER   FD   TYPE             DEVICE    SIZE     NODE NAME
hackbench 14802 root  cwd    DIR              104,7    4096 12927240 /data/src/linux-2.6
hackbench 14802 root  rtd    DIR              104,2    4096        2 /
hackbench 14802 root  txt    REG              104,2   17524   697317 /usr/bin/hackbench
hackbench 14802 root  mem    REG              104,2  112212   558042 /lib/ld-2.3.4.so
hackbench 14802 root  mem    REG              104,2 1547588   558043 /lib/tls/libc-2.3.4.so
hackbench 14802 root  mem    REG              104,2  107928   557058 /lib/tls/libpthread-2.3.4.so
hackbench 14802 root  mem    REG                0,0                0 [heap] (stat: No such file or directory)
hackbench 14802 root    0u   CHR              136,0                3 /dev/pts/0
hackbench 14802 root    1u   CHR              136,0                3 /dev/pts/0
hackbench 14802 root    2u   CHR              136,0                3 /dev/pts/0
hackbench 14802 root    3u  unix 0xffff8800ac0da100            28939 socket
hackbench 14802 root    4u  unix 0xffff8800ac0da400            28940 socket
hackbench 14802 root    5u  unix 0xffff8800ac0da700            28941 socket
hackbench 14802 root    6u  unix 0xffff8800ac0daa00            28942 socket
hackbench 14802 root    8u  unix 0xffff8800aeac1800            28984 socket
hackbench 14802 root    9u  unix 0xffff8800aeac1e00            28986 socket
hackbench 14802 root   10u  unix 0xffff8800aeac2400            28988 socket
hackbench 14802 root   11u  unix 0xffff8800aeac2a00            28990 socket
hackbench 14802 root   12u  unix 0xffff8800aeac3000            28992 socket
hackbench 14802 root   13u  unix 0xffff8800aeac3600            28994 socket
hackbench 14802 root   14u  unix 0xffff8800aeac3c00            28996 socket
hackbench 14802 root   15u  unix 0xffff8800aeac4200            28998 socket
hackbench 14802 root   16u  unix 0xffff8800aeac4800            29000 socket
hackbench 14802 root   17u  unix 0xffff8800aeac4e00            29002 socket
hackbench 14802 root   18u  unix 0xffff8800aeac5400            29004 socket
hackbench 14802 root   19u  unix 0xffff8800aeac5a00            29006 socket
hackbench 14802 root   20u  unix 0xffff8800aeac6000            29008 socket
hackbench 14802 root   21u  unix 0xffff8800aeac6600            29010 socket
hackbench 14802 root   22u  unix 0xffff8800aeac6c00            29012 socket
hackbench 14802 root   23u  unix 0xffff8800aeac7200            29014 socket
hackbench 14802 root   24u  unix 0xffff8800aeac0f00            29016 socket
hackbench 14802 root   25u  unix 0xffff8800aeac0900            29018 socket
hackbench 14802 root   26u  unix 0xffff8800aeac7b00            29020 socket
hackbench 14802 root   27u  unix 0xffff8800aeac7500            29022 socket

All sockets structures (where all _hot_ locks reside) are on a single node.



