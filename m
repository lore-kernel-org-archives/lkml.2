Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0FXRTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 13:19:01 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63889 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0FXRTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t9+ziWFGw3f2eTDYBe4N8NHREjXwAtIwGmbjcXAuE0iGC2gOXTy5qzpgS3QO3IzxHy
         xt77gRfdl3Z0JRhu9F+DV1skmzDMhFJu1hlsnUeVYx7m7RiFc5tTWKeNANgGE6z0vfpT
         /7/HYfB2USSKVSVZq47kb4A4aXXOsVLiLelo8=
Subject: RE: TCP stream performance regression due to
 c377411f2494a931ff7facdbb3a6839b1266bcf6
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: "Shi, Alex" <alex.shi@intel.com>, davem@davemloft.net,
       "Chen, Tim C" <tim.c.chen@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <33AB447FBD802F4E932063B962385B351F483A15@shsmsx501.ccr.corp.intel.com>
References: <1276845448.2118.346.camel@debian>
	 <33AB447FBD802F4E932063B962385B351F483A15@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 19:18:54 +0200
Message-ID: <1277399934.2816.659.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 18 juin 2010 à 16:26 +0800, Zhang, Yanmin a écrit :
> More info about the testing:
> It's a loopback testing. We start one client netperf process to communicate with netserver process in a stream TCP testing. To reduce the cpu cache effect, we bind the 2 processes on 2 different physical cpus.
> #taskset -c 0 ./netserver
> #taskset -c 15 ./netperf -t TCP_STREAM -l 60 -H 127.0.0.1 -i 50,3 -I 99,5 -- -s 57344 -S 57344 -m 4096
> 

Thanks guys

We corrected a proven vulnerability in network stack.

If you want better netperf results, just increase size of your sockets
buffers.  57344 is _very_ low for localhost communication, given lo MTU
is 16436.

As we also increased skb->truesize lately, you might also increase
buffer size regardless of this (net: sk_add_backlog() take rmem_alloc
into account) commit.

In my case, I saw following improvement :

Under huge stress from a multiqueue/RPS enabled NIC, a single flow udp
receiver can now process ~200.000 pps (instead of ~100 pps before the
patch) on a 8 core machine.

Thats a 200.000 % increase, in a situation no tuning was possible ;)


> >>-----Original Message-----
> >>From: Shi, Alex
> >>Sent: 2010年6月18日 15:17
> >>To: eric.dumazet@gmail.com; davem@davemloft.net
> >>Cc: Chen, Tim C; Zhang, Yanmin; linux-kernel@vger.kernel.org
> >>Subject: TCP stream performance regression due to
> >>c377411f2494a931ff7facdbb3a6839b1266bcf6
> >>
> >>In our netperf testing, TCP_STREAM56 shows about 20% or more performance
> >>regression on WSM/NHM and tigerton machines. The testing boot up both
> >>netserver and client on localhost. The testing command like this:
> >>./snapshot_script_net TC_STREAM56 127.0.0.1
> >>
> >>We found the following commit causes this issue.
> >>c377411f2494a931ff7facdbb3a6839b1266bcf6
> >>Revert this commit will recover this regression on all machine.
> >>
> >>Regards!
> >>Alex
> 


