Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2A3PoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:44:18 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39751 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab2A3PoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:44:17 -0500
Date: Mon, 30 Jan 2012 15:44:13 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>, Milton Miller <miltonm@bga.com>
Subject: Re: [v7 7/8] mm: only IPI CPUs to drain local pages if they exist
Message-ID: <20120130154413.GT25268@csn.ul.ie>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
 <1327572121-13673-8-git-send-email-gilad@benyossef.com>
 <20120130145900.GR25268@csn.ul.ie>
 <CAOtvUMcshnvQs4q4ySbtySWv_qHeEnHiD4USBSiOLGFNHSwzUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOtvUMcshnvQs4q4ySbtySWv_qHeEnHiD4USBSiOLGFNHSwzUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 05:14:37PM +0200, Gilad Ben-Yossef wrote:
> >> +     for_each_online_cpu(cpu) {
> >> +             bool has_pcps = false;
> >> +             for_each_populated_zone(zone) {
> >> +                     pcp = per_cpu_ptr(zone->pageset, cpu);
> >> +                     if (pcp->pcp.count) {
> >> +                             has_pcps = true;
> >> +                             break;
> >> +                     }
> >> +             }
> >> +             if (has_pcps)
> >> +                     cpumask_set_cpu(cpu, &cpus_with_pcps);
> >> +             else
> >> +                     cpumask_clear_cpu(cpu, &cpus_with_pcps);
> >> +     }
> >
> > Lets take two CPUs running this code at the same time. CPU 1 has per-cpu
> > pages in all zones. CPU 2 has no per-cpu pages in any zone. If both run
> > at the same time, CPU 2 can be clearing the mask for CPU 1 before it has
> > had a chance to send the IPI. This means we'll miss sending IPIs to CPUs
> > that we intended to.
> 
> I'm confused. You seem to be assuming that each CPU is looking at its own pcps
> only (per zone).

/me slaps self

I was assuming exactly this.

> Assuming no change in the state of the pcps when both CPUs
> run this code at the same time, both of them should mark the bit for
> their respective
> CPUs the same, unless one of them raced and managed to send the IPI to clear
> pcps from the other, at which point you might see one of them send a
> spurious IPI
> to drains pcps that have been drained - but that isn't bad.
> 

Indeed, the race is tiny and the consequences are not important.

> At least, that is what I meant the code to do and what I believe it
> does. What have I
> missed?
> 

Nothing, the problem was on my side. Sorry for the noise.

-- 
Mel Gorman
SUSE Labs
