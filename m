Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab2IMObU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:31:20 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58960 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab2IMObT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:31:19 -0400
Date: Thu, 13 Sep 2012 07:31:13 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>, xiaoguangrong@linux.vnet.ibm.com,
        avi@redhat.com, mtosatti@redhat.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
Message-ID: <20120913143113.GI10019@ghostprotocols.net>
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com>
 <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com>
 <503FB105.9000205@gmail.com>
 <5051678C.1070209@gmail.com>
 <20120913134541.GH10019@ghostprotocols.net>
 <5051EA4D.5080707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051EA4D.5080707@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 13, 2012 at 08:14:37AM -0600, David Ahern escreveu:
> On 9/13/12 7:45 AM, Arnaldo Carvalho de Melo wrote:
> >Em Wed, Sep 12, 2012 at 10:56:44PM -0600, David Ahern escreveu:

> >>So, I spent a fair amount of time today implementing a live mode.
> >>And after a lot of swearing at the tracepoint processing code I

> >What kind of swearing? I'm working on 'perf test' entries for
> >tracepoints to make sure we don't regress on the perf/libtraceevent
> >junction, doing that as prep work for further simplifying tracepoint
> >tools like sched, kvm, kmem, etc.
 
> Have you seen how the tracing initialization is done? ugly. record
> generates tracing data events and report uses those to do the init
> so you can access the raw_data. I ended up writing this:

And all we need is the list of fields so that we can use
perf_evsel__{int,str}val like I did in my 'perf sched' patch series (in
my perf/core branch), and even those accessors I'll tweak some more as
we don't need to check the endianness of the events, its in the same
machine, etc.

I'm trying to get by without using a 'pevent' just using 'event_format',
its doable when everything is local, as a single machine top tool is.

I want to just create the tracepoint events and process them like in
'top', using code more or less like what is in test__PERF_RECORD.

This still needs more work, so I think you can continue in your path and
eventually we'll have infrastructure to do it the way I'm describing,
optimizing the case where the "record" and "top" are in the same
machine, i.e. a short circuited 'live mode' with the top machinery
completely reused for tools, be it written in C, like 'sched', 'kvm',
'kmem', etc, or in perl or python.

- Arnaldo
 
> static int perf_kvm__tracing_init(void)
> {
>     struct tracing_data *tdata;
>     char temp_file[] = "/tmp/perf-XXXXXXXX";
>     int fd;
> 
>     fd = mkstemp(temp_file);
>     if (fd < 0) {
>         pr_err("mkstemp failed\n");
>         return -1;
>     }
>     unlink(temp_file);
> 
>     tdata = tracing_data_get(&kvm_events.evlist->entries, fd, false);
>     if (!tdata)
>         return -1;
>     lseek(fd, 0, SEEK_SET);
>     (void) trace_report(fd, &kvm_events.session->pevent, false);
>     tracing_data_put(tdata);
> 
>     return 0;
> }
> 
> 
> >
> >>finally have it working. And the format extends easily (meaning <
> >>day and the next step) to a perf-based kvm_stat replacement. Example
> >>syntax is:
> >>
> >>    perf kvm stat [-p <pid>|-a|...]
> >>
> >>which defaults to an update delay of 1 second, and vmexit analysis.
> >>
> >>The guts of the processing logic come from the existing kvm-events
> >>code. The changes focus on combining the record and report paths
> >>into one. The display needs some help (Arnaldo?), but it seems to
> >>work well.
> >>
> >>I'd like to get opinions on what next? IMO, the record/report path
> >>should not get a foot hold from a backward compatibility perspective
> >>and having to maintain those options. I am willing to take the
> >>existing patches into git to maintain authorship and from there
> >>apply patches to make the live mode work - which includes a bit of
> >>refactoring of perf code (like the stats changes).
> >>
> >>Before I march down this path, any objections, opinions, etc?
> >
> >Can I see the code?
> 
> Let me clean it up over the weekend and send out an RFC for it.
> 
> David
