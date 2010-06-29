Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab0F2QAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:00:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60667 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab0F2QAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZoeSHvEdYfJSx0v391er52xid/BSn6phmAfV1RpYDUuenzN0P1YgHbUw2s/HmQJJzA
         i37T7vu3qSAh5A9NfIFcn+ZaLvY2n15EPRtgDqjfmu4rVKcyDiEIzm8qp+NpIdwACih7
         YF4ChePJDRVD2eAeMxTdnT5HUkYOk/sZDrNK4=
Date: Tue, 29 Jun 2010 18:01:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 12/35] workqueue: update cwq alignement
Message-ID: <20100629160100.GL5318@nowhere>
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-13-git-send-email-tj@kernel.org> <20100628224755.GA10104@nowhere> <4C29A33D.2060407@kernel.org> <20100629123632.GB5318@nowhere> <4C2A145E.8030608@kernel.org> <20100629154738.GJ5318@nowhere> <4C2A1672.20700@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2A1672.20700@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 05:51:14PM +0200, Tejun Heo wrote:
> Hello, Frederic.
> 
> On 06/29/2010 05:47 PM, Frederic Weisbecker wrote:
> > It means the size of the struct itself doesn't need to aligned to anything.
> 
> Yeah, it could be that I'm kinda dense today but your mode of
> communication is a bit too implicit for me.  So, can you please
> elaborate what problem you see in the patch and how you want it to be
> changed?
> 
> Thanks.


So, imagine you allocate your struct with alloc_percpu(align).

The per cpu pointer is 0x400 (purely imagination).

Now you have two cpus and they have the following base offsets for
per cpu allocations:

CPU 0 = 0xf1000000
CPU 1 = 0xf2000000


So, the true pointers for your cpu workqueue structs will be:

CPU 0 = 0xf1000400
CPU 1 = 0xf2000400


These addresses are aligned like you wanted to, and it seems it is what
matters, to store these addresses in the work flags.

So why does the size of the struct need to be aligned too? All you want
is that the two above addresses are aligned. Now why the size of the struct
itself needs this alignment too. That's the obscure point for me. If it's
useless, this could avoid all this alignment maintainance, except during
the allocation itself.

