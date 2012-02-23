Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2BWKIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 05:08:37 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:54652 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2BWKIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 05:08:35 -0500
Message-ID: <1329990828.19165.36.camel@ThinkPad-T61>
Subject: Re: [PATCH 0/2 x86] fix some page faults in nmi if kmemcheck is
 enabled
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Date: Thu, 23 Feb 2012 17:53:48 +0800
In-Reply-To: <1329819437.2293.382.camel@twins>
References: <1329717665.3448.28.camel@ThinkPad-T61>
	 <1329735648.2293.307.camel@twins> <1329788560.3448.45.camel@ThinkPad-T61>
	 <1329819437.2293.382.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12022309-8878-0000-0000-00000168D753
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 11:17 +0100, Peter Zijlstra wrote:
> On Tue, 2012-02-21 at 09:42 +0800, Li Zhong wrote:
> 
> > > Hell no, these are some of the ugliest patches I've seen in a while. Not
> > > to mention that their changelogs are utter crap since they don't even
> > > explain why they're doing what they're doing.
> > > 
> > Hi Peter, 
> > 
> > I agree that the fix is ugly. I'm willing to change if there are some
> > better ways. 
> 
> There are always better ways..

Hi Peter,

I will think further about it, and would appreciate it if you could give
some good ideas. 

> 
> > The problem here is: 
> > 1. It seems x86 doesn't allow page faults in nmi, and there are checks
> > in the code, like WARN_ON_ONCE(in_nmi()).
> 
> I bet that's not x86 only..

Maybe, I found this problem on x86, didn't check other archs. 

However, from Documentation/kmemcheck.txt, seems kmemcheck only supports
x86. 

> 
> > 2. If CONFIG_KMEMCHECK is enabled, the pages allocated through slab will
> > be marked as non-present, to capture uninitialized memory access. More
> > information in Documentation/kmemcheck.txt .
> 
> So then kmemcheck is buggy, since the nmiaction structure is initialized
> in register_nmi_handler(), so it should most definitely not be marked
> non-present.
> 

I'm not sure whether I understand it correctly. Do you mean that
nmiaction is initialized in register_nmi_handler(), which indicates it
will be used in nmi, so it shouldn't be marked non-present?

But for kmemcheck, why need it know the information that page fault is
not allowed in nmi? 

Or maybe I misunderstand your point here? 

> > 3. From the log, there are some memories accessed in nmi, which are in
> > pages marked as non-present by kmemcheck, as they are allocated by
> > something like kmalloc(). 
> 
> So figure out why and fix that instead of writing ugly ass patches that
> seemingly work around the problem without actually thinking about it.
> 

I think the reason is that kmalloc ( or kzalloc ... ) uses malloc_sizes
slab caches to allocate memory. The malloc_sizes slab caches is set up
without SLAB_NOTRACK flag, then kmemcheck marks the pages non-present to
do its check in page fault handling code. I think we shouldn't disable
kmemechek for the general malloc_sizes caches. 

Thanks,
Zhong




