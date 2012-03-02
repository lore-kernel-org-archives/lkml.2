Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030448Ab2CBTpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:45:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759200Ab2CBTpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:45:22 -0500
Date: Fri, 2 Mar 2012 14:44:54 -0500
From: Don Zickus <dzickus@redhat.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, paulus@samba.org,
        mingo@elte.hu, acme@ghostprotocols.net,
        Vegard Nossum <vegardno@ifi.uio.no>
Subject: Re: [PATCH 0/2 x86] fix some page faults in nmi if kmemcheck is
 enabled
Message-ID: <20120302194454.GL3083@redhat.com>
References: <1329717665.3448.28.camel@ThinkPad-T61>
 <1329735648.2293.307.camel@twins>
 <1329788560.3448.45.camel@ThinkPad-T61>
 <1329819437.2293.382.camel@twins>
 <1329990828.19165.36.camel@ThinkPad-T61>
 <1330340324.11248.60.camel@twins>
 <1330397141.4112.23.camel@ThinkPad-T61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330397141.4112.23.camel@ThinkPad-T61>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:45:41AM +0800, Li Zhong wrote:
> > > I'm not sure whether I understand it correctly. Do you mean that
> > > nmiaction is initialized in register_nmi_handler(), which indicates it
> > > will be used in nmi, so it shouldn't be marked non-present?
> > 
> > No, you said that it marks memory non-present to detect uninitialized
> > stuff, but since it is initialized, it shouldn't then be non-present,
> > right?
> 
> From my understanding of kmemcheck, the checking is based on the
> non-present page. So while handling page fault, if the memory hasn't
> been written before read, kmemcheck knows that it is uninitialized. 
> 
> I think it is used to find code errors, so it need mark all non-present,
> to check if there are any access to uninitialized memory. 

I am not sure if this is what your tool is catching, but someone pointed
out to me privately that when panic'ing in an NMI, either the shutdown
path I modified or the kdump path will register an NMI handler in an NMI
context.  Thus they will try to allocate memory in the NMI context.

So I will have to fix that.  Wonder if that popular lockless memory
allocator can help me there... otherwise I have to go back to pass in
structs like the notifier blocks do.

Cheers,
Don
