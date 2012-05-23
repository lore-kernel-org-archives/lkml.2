Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab2EWBCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab2EWBCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:02:08 -0400
Date: Tue, 22 May 2012 22:01:57 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
Message-ID: <20120523010157.GB19962@infradead.org>
References: <1337081295-10303-1-git-send-email-eranian@google.com>
 <1337081295-10303-5-git-send-email-eranian@google.com>
 <4FB32032.3000509@gmail.com>
 <CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
 <4FB67DE5.8050000@gmail.com>
 <20120518171911.GH2636@infradead.org>
 <1337708035.9698.44.camel@twins>
 <CABPqkBTQ=K-=qkgzC0TZPi1xyHtqT6QQroRg-7o0k8rFmjH_Bw@mail.gmail.com>
 <87obpf209z.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obpf209z.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 23, 2012 at 09:45:12AM +0900, Namhyung Kim escreveu:
> On Tue, 22 May 2012 19:51:15 +0200, Stephane Eranian wrote:
> > On Tue, May 22, 2012 at 7:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> On Fri, 2012-05-18 at 14:19 -0300, Arnaldo Carvalho de Melo wrote:
> >>
> >>> PeterZ was the one objecting to adding more userspace only events,
> >>
> >> Ah, yes I was ;-)
> >>
> >> So uhm the argument was something like perf_event_type is a kernel enum
> >> and userspace stealing space there is going to get us into trouble
> >> eventually since userspace doesn't register its types in our enum.
> >>
> > Yes, I did not start this but I understand why it was done that way.
> >
> > The problem is that the headers as they are written to the file need
> > seeking in the file to update the offset table. That is NOT possible when
> > you operate in pipe mode. As such you need to inject the header infos
> > very much like kernel PERF_RECORD_*. That is also why you have
> > perf inject -b. Buildids are added at the end of the run in file mode,
> > and that's another seek to the offset table if I recall correctly.
> >
> 
> IIUC, to add build-ids we should check all dso's whether hits or not,
> but it's not same as the case of meta-data since we can know it before
> processing. Am I missing something?

To add build ids properly we should read it when the kernel loads a DSO,
so that when PERF_RECORD_MMAP is sent to the event stream, the build id
is there, so no need for post processing, etc.

The way we do it now is racy, long running sessions may experience DSO
updating, etc.

I think we can figure out a way to avoid the seeks Stephane mentions so
to get something done as Peter suggests.

But at the same time I don't think reusing the existing mechanism is
such a big problem as Peter makes of it :-\

- Arnaldo
