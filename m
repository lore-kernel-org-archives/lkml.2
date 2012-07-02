Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2GBNeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:34:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab2GBNeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:34:24 -0400
Date: Mon, 2 Jul 2012 15:33:41 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com, eranian@google.com
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
Message-ID: <20120702133341.GD967@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
 <87fw9blyhj.fsf@sejong.aot.lge.com>
 <20120702101518.GC967@krava.redhat.com>
 <1341234662.1476.13.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1341234662.1476.13.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 10:11:02PM +0900, Namhyung Kim wrote:
> 2012-07-02 (월), 12:15 +0200, Jiri Olsa:
> > On Mon, Jul 02, 2012 at 10:53:44AM +0900, Namhyung Kim wrote:
> > > Just a question, is there a way to know about the grouping at perf
> > > report time?
> > 
> > nope, AFAIK only ID and perf_event_attr is stored for event
> > grouping is known only for record time
> > 
> 
> I heard that Arnaldo (or Stephane) wanted to make perf report
> group-aware or such so that it can show related events together. But to
> do that, it seems we need to change the data file format first, right?
> 
> Any idea?

The next change I'm working on is to record and report
PERF_FORMAT_GROUP related data. Here's commit comment
from my next patchset:

---
perf, tool: Enable sampling on specified event group leader

Adding the functionality to the group modifier event syntax.
Allowing user to select leader event inside the group using
event index (command line event position in the group).

Following example selects e2 as leader:
  -e '{e1,e2,e3,e4}:2'

The selected event becomes group leader and is the only one
doing samples.

The rest of the events in the group are being read on each leader
event sample by PERF_SAMPLE_READ sample type processing.

Following example:
  perf record -e {cycles,faults}:1 ls

  - creates a group with 'cycles' and 'faults' events
  - 'cycles' event is group leader and has sampling enabled
  - 'faults' event is read each time 'cycles' sample,
    the 'faults' count is attached to the 'cycles sample
    via PERF_SAMPLE_READ sample type.
---

The report does not need any new metadata about grouping, because
the samples are generated/stored only from the group leader. The
other events data are read from the PERF_FORMAT_GROUP leader sample
data.

So no data file format change for my next changes, but I'm not sure
this is the report change you mean.

jirka
