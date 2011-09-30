Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1I3Aka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 20:40:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52830 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1I3Ak3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 20:40:29 -0400
Date: Thu, 29 Sep 2011 21:40:18 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        Stephane Eranian <eranian@google.com>, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
Message-ID: <20110930004018.GA9369@ghostprotocols.net>
References: <20110929230613.GA20083@ghostprotocols.net>
 <4E850056.1090101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E850056.1090101@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 29, 2011 at 05:33:42PM -0600, David Ahern escreveu:
> On 09/29/2011 05:06 PM, Arnaldo Carvalho de Melo wrote:
> >> >From what I can see sample_type has to be the same for all samples:
> >> https://lkml.org/lkml/2011/8/15/6

> > We could add a PERF_SAMPLE_ID2 that if present would be guaranteed
> > to be the last, or we can, as PeterZ prefers/suggests, to use one
> > mmap per sample id, then we know that if we're getting it on that
> > mmap, it has that sample_type.

> > For record that means we need to dump each per-sample_id mmap onto a
> > separate file, i.e. use a directory, etc.
 
> That seems like a major re-write of perf. Why not keep the existing
> restriction and have users who want different sample_types run
> multiple perf commands?
 
> What's to be gained by refactoring the code to support multiple
> sample_types in a single command invocation?

This comes from time to time:

http://us.generation-nt.com/answer/bug-perf-event-sampling-buffer-format-cannot-handle-multi-event-sampling-help-202985832.html

The whole point of sample_type is to ask for just what is needed for
some specific event so that we reduce the per sample footprint.

So we allow for multiple types of events to be on the same stream, but
not for them to have just what each need, its a limitation, one that we
can solve. I see no reason not to solve it :-)

The evsel/evlist classes were designed to abstract away such details,
i.e. perf_evlist__mmap should notice different sample_types and sort
this out transparently.

And then perf_evlist__mmap_read(evlist, idx), evlist->nr_mmaps should be
enough to process the events :-)

- Arnaldo
