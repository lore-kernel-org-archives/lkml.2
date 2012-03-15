Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031783Ab2COSCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:02:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab2COSCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:02:03 -0400
Message-ID: <4F622E90.5080001@redhat.com>
Date: Thu, 15 Mar 2012 20:01:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Akshay Karle <akshay.a.karle@gmail.com>, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>, kvm@vger.kernel.org,
        ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: Re: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
References: <1331224181.2585.16.camel@aks> <4F621FC0.7050800@redhat.com> <ac318852-4ccd-4739-893c-52f5cddee6c7@default>
In-Reply-To: <ac318852-4ccd-4739-893c-52f5cddee6c7@default>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 07:49 PM, Dan Magenheimer wrote:
> > One of the potential problems with tmem is reduction in performance when
> > the cache hit rate is low, for example when streaming.
> > 
> > Can you test this by creating a large file, for example with
> > 
> >   dd < /dev/urandom > file bs=1M count=100000
> > 
> > and then measuring the time to stream it, using
> > 
> >   time dd < file > /dev/null
> > 
> > with and without the patch?
> > 
> > Should be done on a cleancache enabled guest filesystem backed by a
> > virtio disk with cache=none.
> > 
> > It would be interesting to compare kvm_stat during the streaming, with
> > and without the patch.
>
> Hi Avi --
>
> The "WasActive" patch (https://lkml.org/lkml/2012/1/25/300) 
> is intended to avoid the streaming situation you are creating here.
> It increases the "quality" of cached pages placed into zcache
> and should probably also be used on the guest-side stubs (and/or maybe
> the host-side zcache... I don't know KVM well enough to determine
> if that would work).
>
> As Dave Hansen pointed out, the WasActive patch is not yet correct
> and, as akpm points out, pageflag bits are scarce on 32-bit systems,
> so it remains to be seen if the WasActive patch can be upstreamed.
> Or maybe there is a different way to achieve the same goal.
> But I wanted to let you know that the streaming issue is understood
> and needs to be resolved for some cleancache backends just as it was
> resolved in the core mm code.

Nice.  This takes care of the tail-end of the streaming (the more
important one - since it always involves a cold copy).  What about the
other side?  Won't the read code invoke cleancache_get_page() for every
page? (this one is just a null hypercall, so it's cheaper, but still
expensive).

> The measurement you suggest would still be interesting even
> without the WasActive patch as it measures a "worst case".

It can provide the justification for that patch, yes.

-- 
error compiling committee.c: too many arguments to function

