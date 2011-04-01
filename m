Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1DAN6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:58:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab1DAN6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:58:40 -0400
Date: Fri, 1 Apr 2011 09:58:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Juerg Haefliger <juergh@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Support for global block IO throttling?
Message-ID: <20110401135838.GA20986@redhat.com>
References: <AANLkTikEYDdL08=DdJ7fLR08r6sWDCHbNoOuGhxGhm7G@mail.gmail.com>
 <20110323142505.GD13315@redhat.com>
 <AANLkTi=EoPKcBE1miW_-RHgHTBCSDKJ1My=Z40rrhm1x@mail.gmail.com>
 <20110323145418.GE13315@redhat.com>
 <AANLkTi=rMdCz97QLkz=xHy7AxfxFVEgsf=qmXKc5ORWE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=rMdCz97QLkz=xHy7AxfxFVEgsf=qmXKc5ORWE@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 10:05:41AM +0200, Juerg Haefliger wrote:
> Hi Vivek,
> 
> 
> > Also current IO controller does not work for NFS. So if a global limit
> > is imposed in higher layers it will solve that issue too.
> >
> > Also if you implement it above page cache then it should automatically
> > handle the case of async writes too. The downside is that if limits
> > are low, buffered writers will be throttled very frequently.
> 
> I'm not exactly sure where in the stack you see this global bandwidth
> controller. What do you mean by 'above the page cache'? I interpret
> this such that access to the page cache would be bandwidth limited as
> well? That doesn't sound right to me.

You are right. For reads it will not make sense to implement it above
page cache as reads coming out of page cache need not be throttled.

So it will probably boil down to that implement buffered write throttling
when entring the page cache and read throttling somewhere below.
generic_make_request()? But that will not take care of network file system
case I think. 

May be we can enhance blk_throtl_bio() itself to also check for global
rules and subject bio to first global rules and put in a global
queue. This probably will work for your virtual machine cases but
it does not take care of buffered writes and NFS IO. May be that is
still a good first step towards global IO limit implementation.

Thanks
Vivek
