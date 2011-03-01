Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab1CAQtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:49:36 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56994 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab1CAQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:49:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Jt+CVVezOUJZBAghiXdZaL0NkXNGQbZMPjrucTu7C9HT8B9Jm/98CB1M8Mlcoowr9o
         /KEnxhFBL/12LkGhBzZS5S6n22RvxH3vIR4EOfi2W+fVssav6AOG29hnBKTmxsnWBcSw
         0E/ulJ3TU8MYCQvx5godc+lu8eG6N4ygRKjmw=
Date: Tue, 1 Mar 2011 13:49:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 4/6] perf script: dump software events too
Message-ID: <20110301164926.GD26068@ghostprotocols.net>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
 <1298865151-23656-5-git-send-email-daahern@cisco.com>
 <AANLkTikwsuBGVfB6uu7=H0jbL+2YbbvX=ea6rLwNP8w-@mail.gmail.com>
 <4D6D004F.5010602@cisco.com>
 <AANLkTi=jmS80Rs13QiTmdA5iUXvNaSKxQ9Gpp2P2nqRU@mail.gmail.com>
 <4D6D1AA8.4060809@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6D1AA8.4060809@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 01, 2011 at 09:11:20AM -0700, David Ahern escreveu:
> On 03/01/2011 08:11 AM, Frederic Weisbecker wrote:
> > Why shouldn't it be designed to dump software events? It's called print_event().
> > Its current version is rather something I would call "limited". But it
> > was not designed to be limited.

> That's because its origins are trace specific. Per last week's thread,
> perf-script was perf-trace until Nov 2010. perf-script deals with
> tracepoints.

> > Ideally, we should have print_tracepoint_event() in
> > trace-event-parse.c, print_software_event()
> > where you want, and have print_event() in builtin-script.c that wraps on those.
> 
> process_event does not take the event sample, it takes elements of it:
> 
> struct scripting_ops {
> ...
>     void (*process_event) (int cpu, void *data, int size,
>                    unsigned long long nsecs, char *comm);

I still have to read the entire thread, but this definetely should
receive "struct perf_sample", i.e. the parsed sample and the 'struct
thread' from where it can get the comm, etc

Look at the process_event for builtin-script.c:

                scripting_ops->process_event(sample->cpu,
					     sample->raw_data,
                                             sample->raw_size,
                                             sample->time,
					     thread->comm);


I'd change it to:

                scripting_ops->process_event(event, sample, thread);

Or even short circuit it completely modulo debugging, becoming:

static int process_sample_event(union perf_event *event,
                                struct perf_sample *sample,
                                struct perf_session *session)
{
	if (debug_mode) {
		if (sample->time < last_timestamp) {
			pr_err("Samples misordered, previous: %" PRIu64
			       " this: %" PRIu64 "\n", last_timestamp,
				sample->time);
				nr_unordered++;
		}
		last_timestamp = sample->time;
	} else {
		scripting_ops->process_event(event, sample, session);
		session->hists.stats.total_period += sample->period;
	}
        return 0;
}

Script modules may then do their thread accounting if comms are asked
for, etc.

- Arnaldo
