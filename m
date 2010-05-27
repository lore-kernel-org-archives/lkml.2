Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab0E0LUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:20:51 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:46388 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab0E0LUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:20:49 -0400
Date: Thu, 27 May 2010 16:50:44 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: Tracing configuration review
Message-ID: <20100527112044.GA2713@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1274815906.9757.83.camel@cndougla-ubuntu>
 <20100525201259.GA5370@nowhere>
 <1274821799.9346.17.camel@cndougla-ubuntu>
 <20100525230656.GD5370@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525230656.GD5370@nowhere>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 01:06:57AM +0200, Frederic Weisbecker wrote:
> On Tue, May 25, 2010 at 05:09:59PM -0400, Chase Douglas wrote:
> > On Tue, 2010-05-25 at 22:13 +0200, Frederic Weisbecker wrote:
> > > On Tue, May 25, 2010 at 03:31:46PM -0400, Chase Douglas wrote:

<snipped>

> > > IMO, it is deprecated. The perf interface is much more powerful and flexible.
> > > Prasad, do you agree if I remove this ftrace plugin?

Sure, go ahead.

> > 
> > If there isn't any use in enabling it due to perf's features, then we
> > can turn it off. However, if there's any use to be gained by this over
> > perf's features, then I'd prefer to leave it on. Thoughts?
> 
> 
> 
> No, perf does much more:
> 
> - stacktraces recording
> - "top" alike view with perf top
> - stat with perf stat, etc...
> - userspace memory accesses
> 
> 
> Here is a quick example:
> 
> $ cat test.c
> int var;
> 
> void func_c(void)
> {
> 	var++;
> }
> 
> void func_b(void)
> {
> 	func_c();
> }
> 
> 
> void func_a(void)
> {
> 	func_c();
> }
> 
> 
> int main(int argc, char **argv)
> {
> 	int i;
> 
> 	for (i = 0; i < 1000; i++)
> 		if (i % 2)
> 			func_a();
> 		else
> 			func_b();
> 
> 	return 0;
> }
> //end test.c
> 
> $ gcc test.c -fno-omit-frame-pointer -o test
> 
> $ readelf -s test | grep var
>     74: 000000000060102c     4 OBJECT  GLOBAL DEFAULT   25 var
> 
> $ perf record -g -c 1 -e mem:0x000000000060102c:w ./test
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.069 MB perf.data (~3020 samples) ]
> 
> $ perf report
> 
> # Events: 1K cycles
> #
> # Overhead  Command      Shared Object  Symbol
> # ........  .......  .................  ......
> #
>     99.90%     test  test               [.] func_c
>                |
>                --- func_c
>                   |          
>                   |--49.95%-- func_a
>                   |          |          
>                   |          |--99.60%-- main
>                   |          |          __libc_start_main
>                   |           --0.40%-- [...]
>                   |          
>                   |--49.85%-- func_b
>                   |          main
>                   |          |          
>                   |          |--99.60%-- __libc_start_main
>                   |           --0.40%-- [...]
>                    --0.20%-- [...]
> 
> 
> To sum up, there is nothing the ksym tracer does that perf can't.
> 

I second Frederic's opinion on this. 

Thanks,
K.Prasad

> Well, may be perf doesn't offer the time ordered view of memory
> accesses, I must confess. Although this is still something we can
> easily provide if people want it.
> 
