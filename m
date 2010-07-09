Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab0GIFzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 01:55:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:51590 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751317Ab0GIFzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 01:55:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX193PwJu2GB356df8bz1P1aV7ofrLHKO3EZndLMCFD
	yYYTaBiirf89IB
Subject: Re: high power consumption in recent kernels
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Norbert Preining <preining@logic.at>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>,
       tglx <tglx@linutronix.de>
In-Reply-To: <1278621854.1900.188.camel@laptop>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
	 <1278579992.1900.17.camel@laptop> <20100708045711.398d4e26@infradead.org>
	 <1278590303.1900.91.camel@laptop>
	 <20100708120421.GF20841@gamma.logic.tuwien.ac.at>
	 <1278591779.1900.97.camel@laptop>
	 <20100708124627.GA7754@gamma.logic.tuwien.ac.at>
	 <1278595426.1900.130.camel@laptop>  <1278604779.1900.157.camel@laptop>
	 <1278618040.7498.21.camel@marge.simson.net>
	 <1278621854.1900.188.camel@laptop>
Content-Type: text/plain
Date: Fri, 09 Jul 2010 07:55:09 +0200
Message-Id: <1278654909.7637.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 22:44 +0200, Peter Zijlstra wrote:
> On Thu, 2010-07-08 at 21:40 +0200, Mike Galbraith wrote:
> > > Mike could you re-run your netperf tests that showed the 10% throughput
> > > gain? Hopefully the fixed governor will yield the same result and we can
> > > kill off this ratelimit thing.
> > 
> > The gain is (well was last time I checked), but as noted, I'd just call
> > it a misguided optimization and be done with it. 
> 
> It would still be good to know what your machine does, if you can still
> see a difference there might still be something to look at.

git .today.

marge:..git/linux-2.6 # netperf.sh 30
Starting netserver at port 12865     
Starting netserver at hostname 0.0.0.0 port 12865 and family AF_UNSPEC
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1 (127.0.0.1) port 0 AF_INET
Local /Remote                                                                                          
Socket Size   Request  Resp.   Elapsed  Trans.                                                         
Send   Recv   Size     Size    Time     Rate                                                           
bytes  Bytes  bytes    bytes   secs.    per sec                                                        

16384  87380  1        1       30.00    102272.73   
16384  87380                                        
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1 (127.0.0.1) port 0 AF_INET : cpu bind
Local /Remote                                                                                                     
Socket Size   Request  Resp.   Elapsed  Trans.                                                                    
Send   Recv   Size     Size    Time     Rate                                                                      
bytes  Bytes  bytes    bytes   secs.    per sec                                                                   

16384  87380  1        1       30.00    97638.99   
16384  87380  

turns ratelimiting off

marge:..git/linux-2.6 # netperf.sh 30
Starting netserver at port 12865
Starting netserver at hostname 0.0.0.0 port 12865 and family AF_UNSPEC
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1 (127.0.0.1) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

16384  87380  1        1       30.00    92991.02
16384  87380
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1 (127.0.0.1) port 0 AF_INET : cpu bind
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

16384  87380  1        1       30.00    97665.27
16384  87380

btw, if you don't set governor to performance, you can get crud
throughput like below, because the ondemand governor doesn't necessarily
notice that the CPUs really are busy when waking cross-cpu.

marge:..git/linux-2.6 # netperf.sh 10
Starting netserver at port 12865
Starting netserver at hostname 0.0.0.0 port 12865 and family AF_UNSPEC
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1 (127.0.0.1) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

16384  87380  1        1       10.00    73341.95 <== blech
16384  87380
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1 (127.0.0.1) port 0 AF_INET : cpu bind
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

16384  87380  1        1       10.00    97695.45
16384  87380



