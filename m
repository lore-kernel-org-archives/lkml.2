Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2CEBtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 20:49:55 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:34114 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2CEBty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 20:49:54 -0500
Message-ID: <1330912188.24353.37.camel@ThinkPad-T61>
Subject: Re: [PATCH 0/2 x86] fix some page faults in nmi if kmemcheck is
 enabled
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, paulus@samba.org,
        mingo@elte.hu, acme@ghostprotocols.net,
        Vegard Nossum <vegardno@ifi.uio.no>
Date: Mon, 05 Mar 2012 09:49:48 +0800
In-Reply-To: <20120302194454.GL3083@redhat.com>
References: <1329717665.3448.28.camel@ThinkPad-T61>
	 <1329735648.2293.307.camel@twins> <1329788560.3448.45.camel@ThinkPad-T61>
	 <1329819437.2293.382.camel@twins> <1329990828.19165.36.camel@ThinkPad-T61>
	 <1330340324.11248.60.camel@twins> <1330397141.4112.23.camel@ThinkPad-T61>
	 <20120302194454.GL3083@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12030501-2000-0000-0000-000006A30283
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 14:44 -0500, Don Zickus wrote:
> On Tue, Feb 28, 2012 at 10:45:41AM +0800, Li Zhong wrote:
> > > > I'm not sure whether I understand it correctly. Do you mean that
> > > > nmiaction is initialized in register_nmi_handler(), which indicates it
> > > > will be used in nmi, so it shouldn't be marked non-present?
> > > 
> > > No, you said that it marks memory non-present to detect uninitialized
> > > stuff, but since it is initialized, it shouldn't then be non-present,
> > > right?
> > 
> > From my understanding of kmemcheck, the checking is based on the
> > non-present page. So while handling page fault, if the memory hasn't
> > been written before read, kmemcheck knows that it is uninitialized. 
> > 
> > I think it is used to find code errors, so it need mark all non-present,
> > to check if there are any access to uninitialized memory. 
> 
> I am not sure if this is what your tool is catching, but someone pointed
> out to me privately that when panic'ing in an NMI, either the shutdown
> path I modified or the kdump path will register an NMI handler in an NMI
> context.  Thus they will try to allocate memory in the NMI context.
> 

Maybe I didn't describe it clearly. 
This is not what kmemcheck is catching, and normally I think it is fine
to allocate memory that would be accessed in nmi. 

What is not allowed is page fault ( maybe also other exceptions) in nmi.
And if CONFIG_KMEMCHECK is enabled, for example, if kmemcheck needs
check whether any fields in the allocated nmiaction is read before
written (reading uninitialized memory), it marks the pages the nmiaction
belongs to as non-present, so the check could be done in the page fault
handling. 
In this case, as all the fields in nmiaction are assigned values in
register_nmi_handler, so no errors would be reported by kmemcheck. The
problem is there would be page fault when the nmi code calling the nmi
handlers, as it accesses the memory of nmiaction. 

> So I will have to fix that.  Wonder if that popular lockless memory
> allocator can help me there... otherwise I have to go back to pass in
> structs like the notifier blocks do.

I need check what lockless memory allocator is, but guessing from its
name "lockless", seems it couldn't help this problem.

By the way, I have done a draft fix to make the nmiaction using static
storage, will send out for review soon. 

Thanks,
Zhong
 
> 
> Cheers,
> Don
> 


