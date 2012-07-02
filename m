Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2GBOUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:20:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61636 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2GBOUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:20:43 -0400
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com, eranian@google.com
In-Reply-To: <20120702133341.GD967@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
	 <87fw9blyhj.fsf@sejong.aot.lge.com> <20120702101518.GC967@krava.redhat.com>
	 <1341234662.1476.13.camel@leonhard> <20120702133341.GD967@krava.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jul 2012 23:20:34 +0900
Message-ID: <1341238834.1476.50.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-07-02 (월), 15:33 +0200, Jiri Olsa:
> On Mon, Jul 02, 2012 at 10:11:02PM +0900, Namhyung Kim wrote:
> > 2012-07-02 (월), 12:15 +0200, Jiri Olsa:
> > > On Mon, Jul 02, 2012 at 10:53:44AM +0900, Namhyung Kim wrote:
> > > > Just a question, is there a way to know about the grouping at perf
> > > > report time?
> > > 
> > > nope, AFAIK only ID and perf_event_attr is stored for event
> > > grouping is known only for record time
> > > 
> > 
> > I heard that Arnaldo (or Stephane) wanted to make perf report
> > group-aware or such so that it can show related events together. But to
> > do that, it seems we need to change the data file format first, right?
> > 
> > Any idea?
> 
> The next change I'm working on is to record and report
> PERF_FORMAT_GROUP related data. Here's commit comment
> from my next patchset:
> 
> ---
> perf, tool: Enable sampling on specified event group leader
> 
> Adding the functionality to the group modifier event syntax.
> Allowing user to select leader event inside the group using
> event index (command line event position in the group).
> 
> Following example selects e2 as leader:
>   -e '{e1,e2,e3,e4}:2'
> 
> The selected event becomes group leader and is the only one
> doing samples.
> 
> The rest of the events in the group are being read on each leader
> event sample by PERF_SAMPLE_READ sample type processing.
> 
> Following example:
>   perf record -e {cycles,faults}:1 ls
> 
>   - creates a group with 'cycles' and 'faults' events
>   - 'cycles' event is group leader and has sampling enabled
>   - 'faults' event is read each time 'cycles' sample,
>     the 'faults' count is attached to the 'cycles sample
>     via PERF_SAMPLE_READ sample type.
> ---
> 
> The report does not need any new metadata about grouping, because
> the samples are generated/stored only from the group leader. The
> other events data are read from the PERF_FORMAT_GROUP leader sample
> data.
> 
> So no data file format change for my next changes, but I'm not sure
> this is the report change you mean.
> 

What I said is just displaying cycles and faults events in above example
on the same screen/table like:

 (Overhead)
cycles  faults  Command      Shared object              Symbol
......  ......  .......  .................  ..................
92.98%  60.13%  noploop  noploop            [.] main
 3.21%   5.42%  noploop  [kernel.kallsyms]  [k] __lock_acquire
 1.16%  13.13%  noploop  libc-2.11.1.so     [.] _int_malloc
 0.97%   0.33%  noploop  [kernel.kallsyms]  [k] clear_page_c
...

We could pass such information to perf report explicitly, But I guess it
'd better if perf report did it for me automagically by detecting group
relations.


-- 
Regards,
Namhyung Kim


