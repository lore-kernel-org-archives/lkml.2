Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0JTSuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:50:15 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47571 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754956Ab0JTSuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:50:13 -0400
Date: Wed, 20 Oct 2010 14:50:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
        ltt-dev@lists.casi.polymtl.ca, Steven Rostedt <rostedt@goodmis.org>,
        mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Elena Zannoni <elena.zannoni@oracle.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Aaron Spear <aaron_spear@mentor.com>,
        Tasneem Brutch - SISA <t.brutch@sisa.samsung.com>,
        Tim Bird <tim.bird@am.sony.com>, dominique.toupin@ericsson.com,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Philippe Maisonneuve <Philippe.Maisonneuve@windriver.com>,
        Felix Burton <Felix.Burton@windriver.com>,
        Andrew McDermott <Andrew.McDermott@windriver.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [RFC] Common Trace Format Proposal for Linux (v1)
Message-ID: <20101020185009.GA28779@Krystal>
References: <20101005193712.GB25605@Krystal> <y0miq166qme.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0miq166qme.fsf@fche.csb>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:01:11 up 27 days, 22:03,  4 users,  load average: 0.09, 0.10,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> 
> Hi -
> 
> mathieu wrote:
> 
> > [...]
> > Metadata attribute representation:
> >   align = value;                                /* value in bits */
> > [...]
> >   byte_order = native OR network OR be OR le;	/* network and be are aliases */
> > [...]
> 
> Is there some reason to invent a new textual syntax for describing
> how to pack structs?  There is DWARF, ASN.1, C, ....

Hi Frank,

I discussed with the TIWG this morning, and in a nutshell, these standard seems
to be to some degree incompatible with our requirements. In more detail:

DWARF:

- Represents a language such as C. We want to represent trace events, not C
  structures.
- To examplify, the way bitfields are encoded by gcc is sub-optimal for our
  trace format (see the proposal document for explanation).
- Another example is the difficulty to represent dynamically sized strings and
  sequences contained *within* a structure in DWARF.
- We want to keep meta-data along with the trace, which means that we want to
  keep the size of this information relatively low.
- We fear that DWARF is too complex for our needs.
- We want to generate the meta-data from TRACE_EVENT() macros. We'd like to keep
  a 1-1 mapping between the types as described by programmers and the meta-data,
  which argues against the DWARF binary format.
- We would like to keep the meta-data in text format for human readability
  reasons, which is not possible with DWARF.

ASN.1:

I must admit I am still reading through the various encoding rules (BER, CER,
DER, PER, XER, ....). So far, some ideas are interesting, but I don't think it
applies directly to what we're trying to achieve.

For the following discussion, I'm referring to:

Standards describing the ASN.1 notation:

ISO/IEC 8824-4
http://www.itu.int/ITU-T/studygroups/com17/languages/X.683-0207.pdf

Standards describing the ASN.1 encoding rules:

ISO/IEC 8825-1 (BER, CER and DER)
http://www.itu.int/ITU-T/studygroups/com17/languages/X.690-0207.pdf
ISO/IEC 8825-2 (PER)
http://www.itu.int/ITU-T/studygroups/com17/languages/X.691-0207.pdf
ISO/IEC 8825-4 (XER)
http://www.itu.int/ITU-T/studygroups/com17/languages/X.693-0112.pdf
ISO/IEC 8825-5 (XSD mapping)
http://www.itu.int/ITU-T/studygroups/com17/languages/X694.pdf
(GSER)
http://tools.ietf.org/html/rfc3641

For instance, the BER encoding (Basic encoding rules), CER (Canonical encoding
rules) and DER (Distinguished encoding rules), XER (XML encoding rules) and GSER
are rejected because they encode the identifier with the data. They also encode
the length as prefix to each content, which is wasteful. We need to split the
metadata from the actual data to stay compact.


PER (Packed encoding rules) has some interesting concepts, which might (or not)
be interesting for us:
- "choices", basically unions with a preceding selector. Seems overkill.
- optional fields, which require one bit in the trace to specify if field is
  present or not. Seems overkill, consumes space, especially with non-packed
alignment.

For performance reasons, we want to allow the tracer to write into the trace
with either packed or naturally aligned writes (the choice depends on the
architecture's ability to do unaligned writes efficiently). Therefore, some
choices done in PER that are specifically tuned for the packed representation
don't make sense on architectures where we have to use naturally aligned writes.
Their "ALIGNED" vs "UNALIGNED" distiction does not align on the natural type
size, but rather on the byte size.

Another issue is the bitfield description for PER. A "range" (e.g. 65 to 128)
must be specified to map to a bitfield size. The natural way for a programmer to
express a bitfield size is to specify the number of bits directly, not a range.

That being said, PER is probably the closest to our binary representation so
far, except for the fact that it does not take "natural alignment" into account.

XSD mapping is rejected because I don't think we'll generate XML from the
TRACE_EVENT() macro.


In general:

We also have to represent our event categorization (not just structures) in this
metadata, for which neither ASN.1 nor DWARF looks like a good fit. Also, we are
trying to come up with a simple representation of what we need, which ends up
being a small subset of DWARF and ASN.1. So far, our understanding is that
aiming for compatibility with these standards would bring much more restriction
and fail to meet our requirements, for very little gain.

It's very good to have a look at these through, because encodings like PER have
very interesting ways to tackle the problem.

Thanks for your input, please feel free to tell me if I missed important
elements.

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
