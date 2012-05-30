Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab2E3H3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:29:00 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49446 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007Ab2E3H26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:28:58 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Tejun Heo <tj@kernel.org>
CC: Glauber Costa <glommer@parallels.com>,
        Suleiman Souhlal <suleiman@google.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Li Zefan <lizefan@huawei.com>, "devel@openvz.org" <devel@openvz.org>,
        Greg Thelen <gthelen@google.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Devel] Re: [PATCH v3 13/28] slub: create duplicate cache
Thread-Topic: [Devel] Re: [PATCH v3 13/28] slub: create duplicate cache
Thread-Index: AQHNPakBQH1c2qpSQ0a8B2BucL44lpbhYTeAgAACfACAABDmgIAABW8AgAAAgwCAACFAAIAAA+kAgAAEaYCAAAOUAIAAA4mAgAABNQCAAFUGgIAAZCwA
Date: Wed, 30 May 2012 07:28:26 +0000
Message-ID: <1338362906.3229.4.camel@dabdike>
References: <alpine.DEB.2.00.1205291101580.6723@router.home>
	 <4FC501E9.60607@parallels.com>
	 <alpine.DEB.2.00.1205291222360.8495@router.home>
	 <4FC506E6.8030108@parallels.com>
	 <alpine.DEB.2.00.1205291424130.8495@router.home>
	 <4FC52612.5060006@parallels.com>
	 <alpine.DEB.2.00.1205291454030.2504@router.home>
	 <4FC52CC6.7020109@parallels.com>
	 <alpine.DEB.2.00.1205291514090.2504@router.home>
	 <4FC530C0.30509@parallels.com> <20120530012955.GA4854@google.com>
In-Reply-To: <20120530012955.GA4854@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [195.214.232.10]
Content-Type: text/plain; charset="utf-8"
Content-ID: <09D17D0C0938FA4987E8804C68CDC32A@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4U7T7WV031248

On Wed, 2012-05-30 at 10:29 +0900, Tejun Heo wrote:
> Hello, Christoph, Glauber.
> 
> On Wed, May 30, 2012 at 12:25:36AM +0400, Glauber Costa wrote:
> > >We have never worked container like logic like that in the kernel due to
> > >the complicated logic you would have to put in. The requirement that all
> > >objects in a page come from the same container is not necessary. If you
> > >drop this notion then things become very easy and the patches will become
> > >simple.
> > 
> > I promise to look at that in more detail and get back to it. In the
> > meantime, I think it would be enlightening to hear from other
> > parties as well, specially the ones also directly interested in
> > using the technology.
> 
> I don't think I'm too interested in using the technology ;) and
> haven't read the code (just glanced through the descriptions and
> discussions), but, in general, I think the approach of duplicating
> memory allocator per-memcg is a sane approach.  It isn't the most
> efficient one with the possibility of wasting considerable amount of
> caching area per memcg but it is something which can mostly stay out
> of the way if done right and that's how I want cgroup implementations
> to be.

Exactly: we at parallels initially disliked the cgroup multipled by slab
approach (Our beancounters do count objects) because we feared memory
wastage and density is very important to us (which tends to mean
efficient use of memory) however, when we ran through the calculations
in Prague, you can show that we have ~200 slabs and if each wastes half
a page, thats ~4MB memory lost per container.  Since most virtual
environments are of the order nowadays of 0.5GB, we feel it's an
annoying but acceptable price to pay.

James

> The two goals for cgroup controllers that I think are important are
> proper (no, not crazy perfect but good enough) isolation and an
> implementation which doesn't impact !cg path in an intrusive manner -
> if someone who doesn't care about cgroup but knows and wants to work
> on the subsystem should be able to mostly ignore cgroup support.  If
> that means overhead for cgroup users, so be it.
> 
> Without looking at the actual code, my rainbow-farting unicorn here
> would be having a common slXb interface layer which handles
> interfacing with memory allocator users and cgroup and let slXb
> implement the same backend interface which doesn't care / know about
> cgroup at all (other than using the correct allocation context, that
> is).  Glauber, would something like that be possible?
> 
> Thanks.
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
