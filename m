Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab1KII7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:59:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50806 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1KII7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:59:13 -0500
Message-ID: <1320829149.2315.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Large file copy to NFS mounted directory causes delay in other
 application packets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Manavalan Krishnan <manavalan_k@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Wed, 09 Nov 2011 09:59:09 +0100
In-Reply-To: <1320826389.47194.YahooMailNeo@web160716.mail.bf1.yahoo.com>
References: <1320816503.73813.YahooMailNeo@web160718.mail.bf1.yahoo.com>
	 <1320819875.26025.48.camel@edumazet-laptop>
	 <1320826389.47194.YahooMailNeo@web160716.mail.bf1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please dont top post on these lists, thanks.

Le mercredi 09 novembre 2011 à 00:13 -0800, Manavalan Krishnan a écrit :
> (1) NFS is using TCP
> (2) yes eth0 is dedicated to heartbeat and eth1 is dedicated to NFS
> (3) I notice the following at the system where file copy is occuring
> 
> The kernel Recv-Q of the heartbeat application socket grows but not delivered to the socket recv call. 
> Here is the netstat output.
> 
> Proto  Recv-Q  Send-Q   Local Address         Foreign Address
> 
> udp    11522                0  *:23435                     *:*
> 

OK so the sending side is OK : The delay is at receiver side.

Note that since netstat shows receive queue has some skbs, it should be
available to heartbeat daemon immediately.

> As soon as I stop the file transfer, the socket recv call receives the packets and Recv-Q goes 0.
> (4) The server has 4 cpu cores and 25G RAM
> 

1) How many nfsd threads are running ?
   grep th /proc/net/rpc/nfsd

2) WHat kind of NIC do you use ?
   lsmod , lspci

3) Hmm, are IRQ to eth0/eth1 handled by same cpu ?
  grep eth /proc/interrupts

4) You could try to cpu affine all nfsd to cpu0,cpu1,cpu2  and heartbeat
daemon to cpu3.
   man taskset

5) You could 'strace -ttt' heartbeat daemon to check if it is not
blocked on some local disk access (it competes with all nfsd threads)



