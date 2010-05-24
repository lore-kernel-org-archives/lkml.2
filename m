Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab0EXVZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 17:25:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35590 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab0EXVZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 17:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NRTN8fj1cNVhyjnnfyV5BM/djJlAEMHfDCdvSCaZsa6XqXxMDRKkUV/s06BUCY3SPv
         Enw2bGT1NgqVb70b/zpYkPwoIcxR8nZFnWBsIrNsw9hZS4W5rwkYfoEleehumQD81NZP
         eB0PBdhN/2Laa1YIP7Kxjc5WwbYjGnNmVPX+8=
Date: Mon, 24 May 2010 23:25:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: align raw sample data on 64-bit boundaries
Message-ID: <20100524212459.GA9707@nowhere>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com> <1271190201-25705-13-git-send-email-robert.richter@amd.com> <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com> <20100518151227.GJ21799@erda.amd.com> <20100519073908.GE5704@nowhere> <20100519093100.GL21799@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519093100.GL21799@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 11:31:00AM +0200, Robert Richter wrote:
> On 19.05.10 03:39:10, Frederic Weisbecker wrote:
> 
> > > This changes the ABI and requires changes in the userland tools. For
> > > tools/perf this is at a single location in event.c only. This could
> > > also introduce some overhead on smaller architectures, but currently
> > > this is only used on x86 or for transferring raw tracepoint
> > > data.
> > 
> > 
> > No this is used on any architectures that event have a minimal support for
> > perf events.
> > 
> > I use tracepoint raw samples in sparc 64 for example (which has much more
> > than the minimal support).
> 
> Isn't here the same alignment problem on archs there unsigned long is
> 64 bit? Also, most samples I found have a size of multiples of 8
> bytes, so even on 32 bit archs there would be a padding of 4 bytes
> somethere in the sample.



Yeah there was an alignment problem in sparc 64 that I fixed in perf
tools lately. The fix is more a hack though, the real solution would
be to have this alignment thing fixed.

And yeah, probably most samples need padding.


 
> > I don't think we should do this. Ok it's true we've screwed up
> > something there but breaking the ABI is going to make the things
> > even worst I think.
> 
> I was not sure how hard an ABI breakage would be. I think the small
> number of users of raw samples is manageable, but I understand if you
> feel uncomfortable with it.


I don't know how many people use it. But I prefer not to take that
risk.



> 
> > I would feel better with a new PERF_SAMPLE_RAW_ALIGNED sample_type
> > and schedule the deprecation of PERF_SAMPLE_RAW for later but keep
> > it for some releases.
> 
> This could be an alternative. Though, it duplicates code paths and
> introduces ugly sample type checks. Another alternative would be to
> check the size value, if it is (n * sizeof(u64)) we could asume 64 bit
> alignment. But maybe this makes things much worse.
> 
> -Robert


It doesn't duplicate much code paths, we only have a few corner cases to
plug in. And more importantly, that would be temporary if we schedule the
older PERF_SAMPLE_RAW in, say, three releases from now.

This ensures an easy forward compatibility (older perf tools -> newer kernel).
But the backward compatibility is less easy (newer perf tools -> older kernel)
as it means we need to test dynamically if we have PERF_SAMPLE_RAW_ALIGNED,
otherwise we need to fall back to using the older one.

