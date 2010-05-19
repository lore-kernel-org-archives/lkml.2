Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0ESHjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:39:09 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50416 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab0ESHjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ta5fWA6sDsg2xnza98/KP7fJfngiktKimuIs/8M50YsmRpnwEPNSZB4i4S4U9coR2O
         P+kWBdgQ/3QtE057dXijjJg5QXjcNRkVHdehwf4Tx+27VApddj+eRpC9tGrk+R2f8M7Q
         G1AG2sNW/mt5pQSkFP+dJRKKyGI6CCGr9+Rjs=
Date: Wed, 19 May 2010 09:39:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: align raw sample data on 64-bit boundaries
Message-ID: <20100519073908.GE5704@nowhere>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com> <1271190201-25705-13-git-send-email-robert.richter@amd.com> <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com> <20100518151227.GJ21799@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100518151227.GJ21799@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 05:12:27PM +0200, Robert Richter wrote:
> On 19.04.10 14:19:57, Stephane Eranian wrote:
> > > +       perf_sample_data_init(&data, 0);
> > > +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> > > +               for (i = 1; i < size; i++)
> > > +                       rdmsrl(msr++, *buf++);
> > > +               raw.size = sizeof(u64) * size;
> > > +               raw.data = buffer;
> > > +               data.raw = &raw;
> > > +       }
> > > +
> > 
> > Need to add the padding: raw.size = sizeof(u64) * size + sizeof(u32);
> 
> When thinking about this I was wondering if it wouldn't make sense to
> better fix the alignment and move the data buffer to a 64 bit
> boundary. So take a look at the enclosed RFC patch. Though it breaks
> the ABI it would solve some problems. I think more than it introduces.
> Hopefully I found all effected code locations using it.
> 
> -Robert
> 
> --
> 
> From 2427dda67b072f27ecff678f8829b9e2fc537988 Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Fri, 7 May 2010 15:32:45 +0200
> Subject: [PATCH] perf: align raw sample data on 64-bit boundaries
> 
> In the current implementation 64 bit raw sample data values are not
> aligned due to the 32 bit size header. The size header is located
> before the data buffer on a 64 bit boundary. This leads to unaligned
> memory access to the data buffer for arrays or structures containing
> 64 bit values. To avoid this, the patch adds a 32 bit reserved value
> to the raw sample data header. The data buffer starts then at a 64 bit
> boundary.
> 
> This changes the ABI and requires changes in the userland tools. For
> tools/perf this is at a single location in event.c only. This could
> also introduce some overhead on smaller architectures, but currently
> this is only used on x86 or for transferring raw tracepoint
> data.


No this is used on any architectures that event have a minimal support for
perf events.

I use tracepoint raw samples in sparc 64 for example (which has much more
than the minimal support).



> Though an ABI change should be avoided, it is worth to align raw
> sample data on 64-bit boundaries as the change fixes unaligned memory
> access, eases the implementation for raw sample data and reduces the
> risk of data corruption due to different pad structures inserted by
> the compiler.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---


I don't think we should do this. Ok it's true we've screwed up
something there but breaking the ABI is going to make the things
even worst I think.

I would feel better with a new PERF_SAMPLE_RAW_ALIGNED sample_type
and schedule the deprecation of PERF_SAMPLE_RAW for later but keep
it for some releases.

What do you think?

