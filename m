Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1DGANU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:13:20 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35250 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab1DGANT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=tzLhSlnza3l5En32lGDfrrKh6ffD6gK7Z6iW/IN0F4myqqo4KmHVrtcPv654NAvMac
         O3uyqnhrI0ubPmPLfUaso+2E7A/QAKpShdyX/8qMXlmN+p1B5gfTA7FIc0StFGm5CET9
         3zeOkTEphF9MK+kdPIejSwNkc7fI0oB8kYahc=
Date: Wed, 6 Apr 2011 21:13:11 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Tim Blechmann <tim@klingt.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.39-rc2] perf top fails to mmap - bisected to 70db7533
Message-ID: <20110407001311.GA5780@ghostprotocols.net>
References: <inhgjs$54a$1@dough.gmane.org>
 <4D9C84D5.6090303@gmail.com>
 <20110406175217.GC4987@ghostprotocols.net>
 <201104062248.23853.tim@klingt.org>
 <4D9CE610.4020603@gmail.com>
 <4D9CECF5.3090309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9CECF5.3090309@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 06, 2011 at 04:45:09PM -0600, David Ahern escreveu:
> On 04/06/11 16:15, David Ahern wrote:
> > On 04/06/11 14:48, Tim Blechmann wrote:
> >>>>> this happens when running perf as the same process as the process and
> >>>>> when running perf as root.
> >>>
> >>> yep, works for me as well:
> >>>
> >>> [acme@emilia ~]$ cat vsyscall.c
> >>
> >> after including unistd.h, this compiles and works fine. however i cannot profile 
> >> any multithreaded program. does this work for you?

> > That does fail:
> > # ps -C rsyslogd -L
> >   PID   LWP TTY          TIME CMD
> >   795   795 ?        00:00:00 rsyslogd
> >   795   797 ?        00:00:00 rsyslogd
> >   795   798 ?        00:00:00 rsyslogd

> > # /tmp/build-perf/perf top -p 795
> > Failed to mmap with 22 (Invalid argument)

> > strace shows it failing at:
> > ioctl(4, PERF_EVENT_IOC_SET_OUTPUT, 0x3) = -1 EINVAL (Invalid argument)

> > Changing to use thread only works:
> > # /tmp/build-perf/perf top -t 795
> 
> git bisect points to:
> 
> 70db7533caef02350ec8d6852e589491bca3a951 is the first bad commit
> commit 70db7533caef02350ec8d6852e589491bca3a951
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Wed Jan 12 22:39:13 2011 -0200
> 
> perf evlist: Move the mmap array from perf_evsel
> 
> Adopting the new model used in 'perf record', where we don't have a map
> per thread per cpu, instead we have an mmap per cpu, established on the
> first fd for that cpu and ask the kernel using the
> PERF_EVENT_IOC_SET_OUTPUT ioctl to send events for the other fds on that
> cpu for the one with the mmap.
> 
> The methods moved from perf_evsel to perf_evlist, but for easing review
> they were modified in place, in evsel.c, the next patch will move the
> migrated methods to evlist.c.
> 
> With this 'perf top' now uses the same mmap model used by 'perf record'
> and the next patches will make 'perf record' use these new routines,
> establishing a common codebase for both tools.
> 
> ----------
> 
> Coincidentally, perf-record is also broken. git bisect points to:
> 
> dd7927f4f8ee75b032ff15aeef4bda49719a443a is the first bad commit
> commit dd7927f4f8ee75b032ff15aeef4bda49719a443a
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Wed Jan 12 14:28:51 2011 -0200
> 
> perf record: Use perf_evsel__open
> 
> Now its time to factor out the mmap handling bits into the perf_evsel
> class.

I'll work on that tomorrow, if nobody fixes this till then :-)

- Arnaldo
