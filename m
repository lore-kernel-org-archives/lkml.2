Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab1KBUUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:20:01 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22259 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1KBUUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:20:00 -0400
MIME-Version: 1.0
Message-ID: <dfda9890-f0e3-4a4a-ab9d-b4475a4f7a66@default>
Date: Wed, 2 Nov 2011 13:19:39 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Cyclonus J <cyclonusj@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
 <75efb251-7a5e-4aca-91e2-f85627090363@default>
 <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy>
 <CAOzbF4fnD=CGR-nizZoBxmFSuAjFC3uAHf3wDj5RLneJvJhrOQ@mail.gmail.comCAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
 <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default>
 <20111031181651.GF3466@redhat.com> <1320142590.7701.64.camel@dabdike
 4EB16572.70209@redhat.com>
In-Reply-To: <4EB16572.70209@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EB1A5DF.002C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Avi Kivity [mailto:avi@redhat.com]
> Sent: Wednesday, November 02, 2011 9:45 AM
> To: James Bottomley
> Cc: Andrea Arcangeli; Dan Magenheimer; Pekka Enberg; Cyclonus J; Sasha Levin; Christoph Hellwig; David
> Rientjes; Linus Torvalds; linux-mm@kvack.org; LKML; Andrew Morton; Konrad Wilk; Jeremy Fitzhardinge;
> Seth Jennings; ngupta@vflare.org; Chris Mason; JBeulich@novell.com; Dave Hansen; Jonathan Corbet
> Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
> 
> On 11/01/2011 12:16 PM, James Bottomley wrote:
> > Actually, I think there's an unexpressed fifth requirement:
> >
> > 5. The optimised use case should be for non-paging situations.
> >
> > The problem here is that almost every data centre person tries very hard
> > to make sure their systems never tip into the swap zone.  A lot of
> > hosting datacentres use tons of cgroup controllers for this and
> > deliberately never configure swap which makes transcendent memory
> > useless to them under the current API.  I'm not sure this is fixable,
> > but it's the reason why a large swathe of users would never be
> > interested in the patches, because they by design never operate in the
> > region transcended memory is currently looking to address.
> >
> > This isn't an inherent design flaw, but it does ask the question "is
> > your design scope too narrow?"
> 
> If you look at cleancache, then it addresses this concern - it extends
> pagecache through host memory.  When dropping a page from the tail of
> the LRU it first goes into tmem, and when reading in a page from disk
> you first try to read it from tmem.  However in many workloads,
> cleancache is actually detrimental.  If you have a lot of cache misses,
> then every one of them causes a pointless vmexit; considering that
> servers today can chew hundreds of megabytes per second, this adds up.
> On the other side, if you have a use-once workload, then every page that
> falls of the tail of the LRU causes a vmexit and a pointless page copy.

I agree with everything you've said except "_many_ workloads".
I would characterize this as "some" workloads, and increasingly
fewer machines... because core-counts are increasing faster than
the ability to attach RAM to them (according to published research).

I did code a horrible hack to fix this, but haven't gotten back
to RFC'ing it to see if there were better, less horrible, ideas.
It essentially only puts into tmem pages that are being reclaimed
but previously had the PageActive bit set... a smaller but
higher-hit-ratio source of pages, I think.

Anyway, I've been very open about this (see
https://lkml.org/lkml/2011/8/29/225 , but it affects cleancache.
Frontswap ONLY deals with pages that would have otherwise
been swapin/swapout to a physical swap device.

Dan
