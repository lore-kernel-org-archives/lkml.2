Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1ECV1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:27:01 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47768 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754124Ab1ECV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:26:59 -0400
Date: Tue, 3 May 2011 17:26:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC patch 01/32] TRACE_EVENT: gradual semicolon removal
Message-ID: <20110503212656.GG32331@Krystal>
References: <20110502211123.163877033@efficios.com> <20110502213211.250108074@efficios.com> <1304422337.25414.2382.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304422337.25414.2382.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:14:51 up 161 days,  2:17,  5 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I dropped the large CC list from this thread to fit within LKML 20 CC
list limit. I kept them in bcc so they see this message. Please feel
free to follow the rest of the thread on LKML.)

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Mon, 2011-05-02 at 17:11 -0400, Mathieu Desnoyers wrote:
> > plain text document attachment
> > (trace-event-gradual-semicolon-removal.patch)
> >  The side-effect of these extra semicolons are:
> > 
> > a) to pollute the preprocessor output, leaving extra ";" between trace event
> > instances in trace points creation.
> 
> Who cares?

Anyone trying to ensure tracepoints are well implemented (and thus that
their resulting preprocessor output is bug-free). I did the exercise
myself, and ended up with:

commit 881fe4bdcdc899674524e30a76c76d298b447008
    tracing: remove duplicate null-pointer check in skb tracepoint
commit 23036f1a340beec19cc451ba9719526c4ffb3a57
    blktrace: add missing probe argument to block_bio_complete

so I think the preprocessor output should be more digestible by
developers, with event some documentation on how to format it so it
becomes readable. The following bash script does it for instance (I am
certain that there are ton of much better ways to do it, but this is
what I use):

#!/bin/sh

# kcpp:
# Create a .cpp file (c preprocessor output) from the same gcc
# invokation that builds an object file.

# kcpp SOURCE OBJECT
# invoke with e.g. kcpp kernel/sched.c kernel/sched.o
#  output file will be kernel/sched.cpp
# needs gcc, sed and indent

SOURCE=$1
OBJECT=$2
FILECPP=$(echo $1 | sed 's/\.c/\.cpp/')
POBJECT=$(echo ${OBJECT} | sed -e 's/\//\\\//' -e 's/\./\\\./')
PFILECPP=$(echo ${FILECPP} | sed -e 's/\//\\\//' -e 's/\./\\\./')

echo "Preprocessing ${SOURCE} -> ${FILECPP}"
echo "Object build monitored: ${OBJECT}"
touch ${SOURCE}
rm -f ${OBJECT}

CPPCMD=$(make V=1 ${OBJECT} | tail -n 1 | sed 's/ -c / -E /')
CPPCMD=$(echo ${CPPCMD} | sed "s/ -o [^ ]* / -o ${PFILECPP} /")
PCPPCMD=$(echo ${CPPCMD} | sed -e 's/"//g')
echo Invoking:
echo ${PCPPCMD}
${PCPPCMD}

echo "Formatting ${FILECPP}... "
mv ${FILECPP} ${FILECPP}.tmp
indent ${FILECPP}.tmp -o ${FILECPP}
echo "done."
echo
echo "Output preprocessor file can be found in ${FILECPP}"


> 
> > 
> > b) to render impossible creation of an array of events. Extra semicolons are
> > not a matter as long as TRACE_EVENT creates statements, structure elements or
> > functions, because extra semicolons are discarded by the compiler. However,
> > when creating an array, the separator is the comma, and the semicolon causes a
> > parse error.
> 
> This is the important part.

Yep.

> 
> > 
> > 
> > * So what is the motivation for removing these semicolons ?
> > 
> > Currently, Ftrace is creating a "ftrace_define_fields_##call" function for each
> > event to define the event fields, which consumes space. It also has the
> > ".fields" list head to keep a dynamically generated list of event fields.
> > 
> > By allowing creation of arrays of events, we can do the following: turn the
> > dynamically created list of event fields into a first-level const array listing
> > event fields. We can use ARRAY_SIZE() on this array to know its size,
> > statically. Then, in a following trace event stage, we can create another const
> > array containing tuples of (pointers to the event-specific arrays, array size).
> > 
> > So we get all the same information Ftrace currently gets with much less code
> > overall, much less read-write data, and less dynamic initialization code.
> 
> That looks like something worth doing.
> 
> > 
> > 
> > * Why do this incrementally ?
> 
> Preaching to the choir?

I've been asked to explain myself on this topic by Frederic last time I
posted this patchset, so I added the explanation to the changelog.

> 
> > 
> > After this preliminary patch, the semicolon removal can be done gradually
> > without breaking the build: we can be in an intermediate state with some files
> > having semicolons and others without. This is therefore good for
> > bissectability, and seems like a nice way to bring in an internal API change
> > without making developers suffer too much. Then, once things are stabilized, we
> > can start modifying the Ftrace code to generate the more space-efficient arrays
> > (possibly in a release-cycle or so), knowing that this enforces a strict
> > requirement on semicolon removal.
> 
> Mathieu, I like the patch, but I think you explain too much ;)

Or too little, depending on the maintainer. ;-)

More seriously, I can remove pieces of changelog text if you think this
is too much. It's your call.

> 
> 
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Alexander Graf <agraf@suse.de>
> > CC: Alex Elder <aelder@sgi.com>
> > CC: Anton Blanchard <anton@samba.org>
> > CC: Arjan van de Ven <arjan@linux.intel.com>
> > CC: Avi Kivity <avi@redhat.com>
> > CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > CC: Christoph Hellwig <hch@lst.de>
> > CC: Chris Wilson <chris@chris-wilson.co.uk>
> > CC: Dave Airlie <airlied@redhat.com>
> > CC: Dave Chinner <david@fromorbit.com>
> > CC: Dave Chinner <dchinner@redhat.com>
> > CC: David S. Miller <davem@davemloft.net>
> > CC: Gleb Natapov <gleb@redhat.com>
> > CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: James Bottomley <James.Bottomley@suse.de>
> > CC: Jean Pihet <j-pihet@ti.com>
> > CC: Jeff Moyer <jmoyer@redhat.com>
> > CC: Jens Axboe <axboe@kernel.dk>
> > CC: Jeremy Kerr <jk@ozlabs.org>
> > CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> > CC: Joerg Roedel <joerg.roedel@amd.com>
> > CC: Johannes Berg <johannes@sipsolutions.net>
> > CC: John W. Linville <linville@tuxdriver.com>
> > CC: Josh Stone <jistone@redhat.com>
> > CC: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
> > CC: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
> > CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > CC: Larry Woodman <lwoodman@redhat.com>
> > CC: Len Brown <len.brown@intel.com>
> > CC: Li Zefan <lizf@cn.fujitsu.com>
> > CC: Marcelo Tosatti <mtosatti@redhat.com>
> > CC: Martin K. Petersen <martin.petersen@oracle.com>
> > CC: Masami Hiramatsu <mhiramat@redhat.com>
> > CC: Mel Gorman <mel@csn.ul.ie>
> > CC: Neil Horman <nhorman@tuxdriver.com>
> > CC: Oleg Nesterov <oleg@redhat.com>
> > CC: Paul Mackerras <paulus@samba.org>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > CC: Reinette Chatre <reinette.chatre@intel.com>
> > CC: Rik van Riel <riel@redhat.com>
> > CC: Roland McGrath <roland@redhat.com>
> > CC: Rusty Russell <rusty@rustcorp.com.au>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: Steven Whitehouse <swhiteho@redhat.com>
> > CC: Tejun Heo <tj@kernel.org>
> > CC: Theodore Ts'o <tytso@mit.edu>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Thomas Renninger <trenn@suse.de>
> > CC: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
> > CC: Vadim Rozenfeld <vrozenfe@redhat.com>
> > CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > CC: Zhu Yi <yi.zhu@intel.com>
> 
> I don't think you have enough Cc's
> 

Yeah, I'll cut down this list. Given your explanation in another mail,
people interested to know the context of a patch should have enough
information with the patch changelog to know what is happening, and to
get to LKML to find the other relevant changes.

Thanks,

Mathieu



> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
