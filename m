Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1CJWCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:02:14 -0500
Received: from blu0-omc1-s4.blu0.hotmail.com ([65.55.116.15]:51171 "EHLO
	blu0-omc1-s4.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120Ab1CJWCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:02:13 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP1023B0562D792E4BCE035E96C80@phx.gbl>
Date: Thu, 10 Mar 2011 17:02:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
References: <cover.1299702291.git.jbaron@redhat.com> <1299728191.15854.319.camel@gandalf.stny.rr.com> <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl> <1299771504.15854.347.camel@gandalf.stny.rr.com> <BLU0-SMTP2489AC44910467F37596A496C80@phx.gbl> <1299792860.15854.423.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1299792860.15854.423.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:41:37 up 337 days,  7:31,  3 users,  load average: 0.05, 0.08,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 10 Mar 2011 22:02:11.0678 (UTC) FILETIME=[CEA927E0:01CBDF6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2011-03-10 at 16:14 -0500, Mathieu Desnoyers wrote:
> 
> > > Just insert a long "Reserved" word.
> > 
> > I agree that this solution can work, but it's only because the
> > "object" definition is done in assembly in this case (and not in C, like
> > we did for trace event and tracepoints). Padding to power of 2 multiples
> > should make the linker happy. There should be a nice comment beside
> > these padding elements though.
> 
> Rereading what David and even what you wrote just now, I don't think
> this is even needed. As you said. The issue with us is that we had
> defined structs in C as static which lost all bets. Not to mention,
> these structures were not natural word aligned.
> 
> The linker should not be adding holes more than natural word alignment.
> Why waste space?

Here is what I am concerned about (maybe wongly, we'll see):

if we take a few objects, chosen arbitrarily, which will end up being
linked together, e.g.

in kernel/

Sections:
Idx Name          Size      VMA               LMA               File off  Algn

objdump -h *.o |grep jump
 28 __jump_table  000007e0  0000000000000000  0000000000000000  000ba614  2**0
  5 __jump_table  00000030  0000000000000000  0000000000000000  0000077c  2**0
  6 __jump_table  00000048  0000000000000000  0000000000000000  000027d8  2**0
  9 __jump_table  00000048  0000000000000000  0000000000000000  00002788  2**0
  3 __jump_table  000000c0  0000000000000000  0000000000000000  00000f60  2**0
  3 __jump_table  00000048  0000000000000000  0000000000000000  0000092c  2**0
  6 __jump_table  00000018  0000000000000000  0000000000000000  000008db  2**0
  8 __jump_table  00000018  0000000000000000  0000000000000000  00002744  2**0
  5 __jump_table  00000030  0000000000000000  0000000000000000  000008ea  2**0
  6 __jump_table  00000078  0000000000000000  0000000000000000  000066ad  2**0
  7 __jump_table  00000018  0000000000000000  0000000000000000  000023f0  2**0
 13 __jump_table  00000120  0000000000000000  0000000000000000  00010c9a  2**0
  7 __jump_table  00000060  0000000000000000  0000000000000000  00005126  2**0
  5 __jump_table  00000138  0000000000000000  0000000000000000  000020f4  2**0
  6 __jump_table  00000180  0000000000000000  0000000000000000  000045c6  2**0
 10 __jump_table  00000078  0000000000000000  0000000000000000  00005060  2**0

We see here that the section alignment is 2**0 for each object (that is
for a 2.6.38-rc7-tip kernel). Now as long as the alignment stays like
this, it's OK, because the linker won't add padding between the
sections. So my question is: is there any guarantee that the linker will
keep this alignment to 2**0, or is there a possibility that it bumps it
to an higher value ?

For instance, if we have two objects linked together in a first linking
phase, thus generating a resulting object that uses the 8-byte alignment
specified by the linker script, and then we have a second link phase
that uses this intermediate object and links it into the kernel, this
might add such a whole on a 32-bit architecture, no ? (e.g. see the
e1000e Makefile, it seems to use this 2-steps method when built as =Y).

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
