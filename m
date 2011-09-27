Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab1I0H1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 03:27:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59157 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1I0H1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 03:27:07 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <alpine.DEB.2.00.1109261023400.24164@router.home>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	<1316940890-24138-5-git-send-email-gilad@benyossef.com>
	<1317001924.29510.160.camel@sli10-conroe>
	<CAOtvUMddUAATZcU_5jLgY10ocsHNnOO2GC2c4ecYO9KGt-U7VQ@mail.gmail.com>
	<alpine.DEB.2.00.1109261023400.24164@router.home>
Date: Tue, 27 Sep 2011 10:27:06 +0300
Message-ID: <CAOtvUMcvwWFxxxv7tsOj6FO-wrHAU8EYc+U=9u8yT=cz7XajBA@mail.gmail.com>
Subject: Re: [PATCH 4/5] mm: Only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 26, 2011 at 6:24 PM, Christoph Lameter <cl@gentwo.org> wrote:
> On Mon, 26 Sep 2011, Gilad Ben-Yossef wrote:
>
>> I do not know if these scenarios warrant the additional overhead,
>> certainly not in all situations. Maybe the right thing is to make it a
>> config option dependent. As I stated in the patch description, that is
>> one of the thing I'm interested in feedback on.
>
> The flushing of the per cpu pages only done when kmem_cache_shrink() is
> run or when a slab cache is closed. And for diagnostics. So its rare and
> not performance critical.

Yes, I understand. The problem is it pops up in the oddest of place.
An example is in order:

The Ipath Infiniband hardware exports a char device interface to user space.
When a user opens the char device and configures a port, a kmem_cache
is created.
When the user later closes the fd, the release method of the char
device destroys
the kmem_cache.

So, if I have some high performance server with 128 processors, and
I've dedicated
127 processors to run my CPU bound computing tasks (and made sure the interrupt
are serviced by the last CPU)  and then run a shell on  the lone admin
CPU to do a backup,
I can interrupt my 127 CPUs doing computational tasks, even though
they have nothing to do
with Infiniband, or backup and have never allocated a single buffer
form that cache.

I believe there is a similar scenario with software raid if I change
RAID configs and several
other places. In fact, I'm guessing many of the lines that pop up when
doing the following
grep hide a similar scenario:

$ git grep kmem_cache_destroy . | grep '\->'

I hope this explains my interest.

My hope is to come up with a way to do more code on the CPU doing the
flush_all (which
as you said is a rare and none performance critical code path anyway)
and by that gain the ability
to do the job without interrupting CPUs that do not need to flush
their per cpu pages.

Thanks,
Gilad







>
>
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"I've seen things you people wouldn't believe. Goto statements used to
implement co-routines. I watched C structures being stored in
registers. All those moments will be lost in time... like tears in
rain... Time to die. "
