Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab1KVTcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:32:35 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:51003 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1KVTcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:32:33 -0500
Date: Tue, 22 Nov 2011 20:32:31 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: slub: Lockout validation scans during freeing of object
Message-ID: <20111122193231.GB1627@x4.trippels.de>
References: <alpine.DEB.2.00.1111221033350.28197@router.home>
 <alpine.DEB.2.00.1111221040300.28197@router.home>
 <alpine.DEB.2.00.1111221052130.28197@router.home>
 <1321982484.18002.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <alpine.DEB.2.00.1111221139240.28197@router.home>
 <20111122185540.GA1627@x4.trippels.de>
 <alpine.DEB.2.00.1111221319070.30368@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111221319070.30368@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.11.22 at 13:20 -0600, Christoph Lameter wrote:
> On Tue, 22 Nov 2011, Markus Trippelsdorf wrote:
> 
> > On 2011.11.22 at 11:40 -0600, Christoph Lameter wrote:
> > > On Tue, 22 Nov 2011, Eric Dumazet wrote:
> > >
> > > > This seems better, but I still have some warnings :
> > >
> > > Trying to reproduce with a kernel configured to do preempt. This is
> > > actually quite interesting since its always off by 1.
> >
> > BTW there are some obvious overflows in the "slabinfo -l" output on my machine:
> 
> Could you get me the value of the "slabs" field for the slabs showing the
> wierd values. I.e. do
> 
> cat /sys/kernel/slab/signal_cache/slabs
> 
> > signal_cache               268     920   360.4K 18446744073709551614/7/24   17 2  31  68 A
> 

It's quite easy to explain. You're using unsigned ints in:
snprintf(dist_str, 40, "%lu/%lu/%d", s->slabs - s->cpu_slabs, s->partial, s->cpu_slabs);

and  (s->slabs - s->cpu_slabs) can get negative. For example:

task_struct                269    1504   557.0K 18446744073709551601/5/32   21 3  29  72

Here s-slabs is 17 and s->cpu_slabs is 32. 
That gives: 17-32=18446744073709551601.

-- 
Markus
