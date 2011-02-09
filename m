Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1BIWN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:13:26 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52897 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1BIWNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:13:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=PBoCmzHs9/k9wFpc5bVDtp6BHEFzEPeA7FLrbWMJiNNM0d9L3vfpllZcWeTZK7e4Lh
         KdUQdIuXsa5k4mzqqMqbwhMACJsv3xqatF+6njIcbWAkB8VK7bogCWeMvXSTleAEJs7I
         xKHnqTIN9tZ7iOtBi6Qv9xlAhUB0Zzh3wE+Lc=
Date: Wed, 9 Feb 2011 20:11:03 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: perf on 2.6.38-rc4 wedges my box
Message-ID: <20110209221103.GA11103@ghostprotocols.net>
References: <x49k4h9az25.fsf@segfault.boston.devel.redhat.com>
 <4D52D31E.5010801@gmail.com>
 <x49fwrxax02.fsf@segfault.boston.devel.redhat.com>
 <4D52F526.5060101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D52F526.5060101@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 09, 2011 at 01:12:22PM -0700, David Ahern escreveu:
> 
> 
> On 02/09/11 11:22, Jeff Moyer wrote:
> > David Ahern <dsahern@gmail.com> writes:
> > 
> >> Have you tried '-e cpu-clock' for S/W based profiling vs the default H/W
> >> profiling? Add -v to see if the fallback to S/W is happening now.
> > 
> > Thanks for the suggestion, David.  I tried:
> > 
> > # perf record -v ls
> >   Warning:  ... trying to fall back to cpu-clock-ticks
> > 
> > couldn't open /proc/-1/status
> > couldn't open /proc/-1/maps
> > [ls output]
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.008 MB perf.data (~363 samples) ]
> > 
> > If I explicitly set '-e cpu-clock', then the output is the same,
> > except that the warning is gone.  What's up with the /proc/-1/*?
> 
> target_{pid,tid} are initialized to -1 in builtin-record.c I believe the
> tid version is making its way through the event__synthesize_xxx code
> (event__synthesize_thread -> __event__synthesize_thread ->
> event__synthesize_comm and event__synthesize_mmap_events).

Yes, I'm working on a patch, probably just this will fix it:

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 07f8d6d..dd27b9f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -680,7 +680,7 @@ static int __cmd_record(int argc, const char **argv)
 					       perf_event__synthesize_guest_os);
 
 	if (!system_wide)
-		perf_event__synthesize_thread(target_tid,
+		perf_event__synthesize_thread(evsel_list->threads->map[0],
 					      process_synthesized_event,
 					      session);
 	else
 
---

So that it gets the child_pid or the tid passed via --tid.

But thinking more I think that the correct is to pass the thread_map
evsel_list->threads, that will cover the case of just one thread
(--tid), or all a group of threads (--pid, when the thread_map will have
more than one tid).

I'll get a patch done later.

> > 
> > Now, when running perf record -e cpu-clock on the aio-stress run,
> > unsurprisingly, I get the same result:
> > 
> > # perf record -e cpu-clock -v -- ./aio-stress -O -o 0 -r 4 -d 32 -b 16 /dev/sds
> > couldn't open /proc/-1/status
> > couldn't open /proc/-1/maps
> > adding stage write
> > starting with write
> > file size 1024MB, record size 4KB, depth 32, ios per iteration 8
> > max io_submit 16, buffer alignment set to 4KB
> > threads 1 files 1 contexts 1 context offset 2MB verification off
> > adding file /dev/sds thread 0
> > 
> > and there it sits.  In this case, however, I did not see the NOHZ
> > warnings on the console, and this time the machine is still responding
> > to ping, but nothing else.
> 
> cpu-clock is handled through hrtimers if that helps understand the lockup.
> 
> David
> 
> > 
> > Cheers,
> > Jeff
