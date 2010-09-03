Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0ICCiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:38:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45070 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab0ICCiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:38:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 1/2] Add trace points to mmap, munmap, and brk
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        mingo@redhat.com, hugh.dickins@tiscali.co.uk, riel@redhat.com,
        peterz@infradead.org, anton@samba.org, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100902134827.GA6957@mgebm.net>
References: <20100727201644.2F46.A69D9226@jp.fujitsu.com> <20100902134827.GA6957@mgebm.net>
Message-Id: <20100903112920.B65F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  3 Sep 2010 11:37:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 27 Jul 2010, KOSAKI Motohiro wrote:
> 
> > > On Wed, 21 Jul 2010, KOSAKI Motohiro wrote:
> > > 
> > > > > This patch adds trace points to mmap, munmap, and brk that will report
> > > > > relevant addresses and sizes before each function exits successfully.
> > > > > 
> > > > > Signed-off-by: Eric B Munson <emunson@mgebm.net>
> > > > 
> > > > I don't think this is good idea. if you need syscall result, you should 
> > > > use syscall tracer. IOW, This tracepoint bring zero information.
> > > > 
> > > > Please see perf_event_mmap() usage. Our kernel manage adress space by
> > > > vm_area_struct. we need to trace it if we need to know what kernel does.
> > > > 
> > > > Thanks.
> > > 
> > > The syscall tracer does not give you the address and size of the mmaped areas
> > > so this does provide information above simply tracing the enter/exit points
> > > for each call.
> > 
> > Why don't you fix this?
> > 
> > 
> 
> Sorry for the long delay, 

no problem.

> the enter/exit routines are not compatible with the
> information that these new trace points provides.  When tracing mmap, for
> instance, the addr and len arguments can be altered by the function.  If you
> use the enter/exit trace points you would not see this as the arguments are
> sampled at function entrance and not given again on exit.  

Current output is here. It has rich output than yours. Also you can bind enter and exit output by pid.


            less-2130  [001]  3779.915324: sys_mmap(addr: 0, len: 1000, prot: 3, flags: 22, fd: ffffffff, off: 0)
            less-2130  [001]  3779.915331: sys_mmap -> 0x7fee22b17000
            less-2130  [001]  3779.915350: sys_mmap(addr: 38e8c00000, len: 3788a8, prot: 5, flags: 802, fd: 3, off: 0)
            less-2130  [001]  3779.915357: sys_mmap -> 0x38e8c00000
            less-2130  [001]  3779.915368: sys_mmap(addr: 38e8f6f000, len: 5000, prot: 3, flags: 812, fd: 3, off: 16f000)
            less-2130  [001]  3779.915380: sys_mmap -> 0x38e8f6f000
            less-2130  [001]  3779.915411: sys_mmap(addr: 38e8f74000, len: 48a8, prot: 3, flags: 32, fd: ffffffff, off: 0)
            less-2130  [001]  3779.915421: sys_mmap -> 0x38e8f74000
            less-2130  [001]  3779.915464: sys_mmap(addr: 0, len: 1000, prot: 3, flags: 22, fd: ffffffff, off: 0)
            less-2130  [001]  3779.915468: sys_mmap -> 0x7fee22b16000


> Also, the new
> trace points are only hit on function success, the exit trace point happens
> any time you leave the system call.

Special purpose filtering is no good design. That makes narrowing the feature usefulness.
It should be done on userland.



> I will send out a new series after a rebase.



