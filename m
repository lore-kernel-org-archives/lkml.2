Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab1DPBsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 21:48:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38392 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1DPBsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 21:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sEw409ETx9CdGurra3Jy14zbh408taGjjv+AOjCfJxb2g0HJLZ8e2C9bv5x9F+OAu3
         yKfLrqL9QL1NIT7e1iEZZtAATWB8C3l1CIXrwWL1w6fkLXpTjx8CU5xPtxN9MyS16q2D
         l1T2xBLif22e207eXfjAAI9MsosD9BHJxFV9k=
Date: Fri, 15 Apr 2011 20:48:40 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-s390@vger.kernel.org
Cc: Stephen Powell <zlinuxman@wowway.com>, linux-kernel@vger.kernel.org
Subject: [OOPS s390] Unable to handle kernel pointer dereference at virtual
 kernel address (null)
Message-ID: <20110416014811.GA6150@elie>
References: <2099315211.286690.1302917498637.JavaMail.root@md01.wow.synacor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2099315211.286690.1302917498637.JavaMail.root@md01.wow.synacor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's an oops that was reported to Debian[1].  It cannot be
reproduced on demand but it is reproducible with enough time.  It did
not appear on v2.6.32; it does appear on Debian 2.6.38-3 (which is
based on gregkh's v2.6.38.2) and pristine v2.6.39-rc3, so looks like
a regression.

Stephen Powell wrote:

> I installed linux-image-2.6.38-2-s390x version 2.6.38-3 on my up-to-date Wheezy
> system today.  It runs in a virtual machine under z/VM 5.4.0 running in an LPAR
> on an IBM z/890.  It IPLed just fine.  After the IPL, the system fell idle for a while.
> Then a CRON job kicked off, which caused a page fault, which caused a kernel oops.
> Here is the log:
>
> [ 2697.934752] Unable to handle kernel pointer dereference at virtual kernel address           (null)
> [ 2697.982153] Oops: 0004 [#1] SMP
> [ 2698.001730] Modules linked in: nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc loop qeth_l3 qeth vmur ccwgroup ext3 jbd mbcache dm_mod dasd_eckd_mod dasd_diag_mod dasd_mod
> [ 2698.003407] CPU: 0 Not tainted 2.6.38-2-s390x #1
> [ 2698.003430] Process cron (pid: 1106, task: 000000001f962f78, ksp: 000000001fa0f9d0)
> [ 2698.003455] Krnl PSW : 0404200180000000 000000000002c03e (pfault_interrupt+0xa2/0x138)
> [ 2698.021870]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
> [ 2698.021902] Krnl GPRS: 0000000000000000 0000000000000001 0000000000000000 0000000000000001
> [ 2698.021943]            000000001f962f78 0000000000518968 0000000090000002 000000001ff03280
> [ 2698.021979]            0000000000000000 000000000064f000 000000001f962f78 0000000000002603
> [ 2698.022016]            0000000006002603 0000000000000000 000000001ff7fe68 000000001ff7fe48
> [ 2698.022096] Krnl Code: 000000000002c036: 5820d010            l       %r2,16(%r13)
> [ 2698.051390]            000000000002c03a: 1832                lr      %r3,%r2
> [ 2698.051407]            000000000002c03c: 1a31                ar      %r3,%r1 
> [ 2698.051430]           >000000000002c03e: ba23d010            cs      %r2,%r3,16(%r13)
> [ 2698.051448]            000000000002c042: a744fffc            brc     4,2c03a 
> [ 2698.051466]            000000000002c046: a7290002            lghi    %r2,2
> [ 2698.051486]            000000000002c04a: e320d0000024        stg     %r2,0(%r13)
> [ 2698.051502]            000000000002c050: 07f0                bcr     15,%r0
> [ 2698.051514] Call Trace:
> [ 2698.051521] ([<000000001f962f78>] 0x1f962f78)
> [ 2698.051537]  [<000000000001acda>] do_extint+0xf6/0x138                       
> [ 2698.051555]  [<000000000039b6ca>] ext_no_vtime+0x30/0x34
> [ 2698.052373]  [<000000007d706e04>] 0x7d706e04
> [ 2698.052387] Last Breaking-Event-Address:
> [ 2698.052395]  [<0000000000000000>] 0x0
> [ 2698.052406]
> [ 2698.053263] Kernel panic - not syncing: Fatal exception in interrupt
> [ 2698.053316] CPU: 0 Tainted: G      D      2.6.38-2-s390x #1
> [ 2698.053502] Process cron (pid: 1106, task: 000000001f962f78, ksp: 000000001fa0f9d0)
> [ 2698.053516]        0000000000000000 000000001ff7fa70 0000000000000002 0000000000000000
> [ 2698.053539]        000000001ff7fb10 000000001ff7fa88 000000001ff7fa88 0000000000397b9e
> [ 2698.053576]        0000000000000001 0000000000000000 000000001ff03280 0000000000000000
> [ 2698.053623]        0000000000000008 0000000000000000 000000000000000e 0000000000000078
> [ 2698.053674]        000000001ff7faf0 0000000000011b36 000000001ff7fa70 000000001ff7fab8
> [ 2698.053740] Call Trace:
> [ 2698.053762] ([<0000000000011a60>] show_trace+0x5c/0xa4)
> [ 2698.053801]  [<00000000003979de>] panic+0x9e/0x214
> [ 2698.054443]  [<0000000000012046>] die+0x15e/0x170
> [ 2698.054485]  [<000000000002c5d6>] do_no_context+0xd6/0xe0
> [ 2698.054529]  [<000000000002cd52>] do_protection_exception+0x46/0x2a0
> [ 2698.054577]  [<000000000039b208>] pgm_exit+0x0/0x4
> [ 2698.054627]  [<000000000002c03e>] pfault_interrupt+0xa2/0x138
> [ 2698.054679] ([<000000001f962f78>] 0x1f962f78)
> [ 2698.056408]  [<000000000001acda>] do_extint+0xf6/0x138
> [ 2698.056424]  [<000000000039b6ca>] ext_no_vtime+0x30/0x34
> [ 2698.056439]  [<000000007d706e04>] 0x7d706e04
> HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 0001DE26
[...]

> On Thu, 14 Apr 2011 21:48:56 -0400 (EDT), Stephen Powell wrote:

>> The problem appears to be fixed in the latest vanilla upstream kernel
>> source, which at the time of this writing is 2.6.39-rc3.
>> ...
>
> Oops!  I spoke too soon.  I checked the server before I went to bed
> last night, and it was still up at that time; but when I got up this
> morning I checked it again, and it had crashed during the night with
> the same protection exception at the same offset in the same function.
> That's the trouble with these kind of bugs.

Ideas?

> The problem can't be
> reproduced on demand; so one can never say with 100% certainty that
> the bug is fixed.  One can say for sure that it isn't fixed, if the
> oops occurs, but one can never say for sure that it works.  Anyway,
> I guess it's time to bisect the kernel.  Oh joy.

Hopefully knowledgeable folks can come up with more efficient things
to try out.  I suppose one round of bisection (i.e., trying the
version half-way between produced by

	git bisect bad v2.6.38
	git bisect good v2.6.32

for a few days) would be worthwhile though.

Thanks again.
Jonathan

[1] http://bugs.debian.org/622570
