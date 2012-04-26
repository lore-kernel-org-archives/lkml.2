Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2DZOEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:04:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33975 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2DZOEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:04:15 -0400
Message-ID: <1335449039.13683.61.camel@twins>
Subject: Re: [BUG] perf stat: useless output for raw events with new event
 parser
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        David Ahern <dsahern@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Thu, 26 Apr 2012 16:03:59 +0200
In-Reply-To: <CABPqkBQdkWWgOoXU+ugJiTC=X=5+7OYZ5_K71KhUJTw7jq6+Rg@mail.gmail.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
	 <1335178132.28150.117.camel@twins>
	 <CABPqkBQ2w3RLRwq3fsaJQ_L=_=H+5kounBeuxUv_fk1ksimTOQ@mail.gmail.com>
	 <1335436031.13683.6.camel@twins>
	 <CABPqkBQdkWWgOoXU+ugJiTC=X=5+7OYZ5_K71KhUJTw7jq6+Rg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 14:53 +0200, Stephane Eranian wrote:

> > I'd like to use the event names, but really, when you do:
> >
> >  cpu/event=instructions_retired,inv,cmask=16/
> >
> > is it still instructions_retired?
> 
> Yes, to some extent. Remember this is not equivalent to
> unhalted_core_cycles.

Sure, but I think calling it instructions_retired isn't right either. So
I think that when you use cpu/event=instructions_retired/ without
further qualifications its fine to use that as default name, however
when you muck about with it reverting to either a raw or explicit name
is useful.

> I think this new syntax is too heavy. Again, all you need to know
> is the event name + umask + modifiers (inv, cmask, edge, u, k).
> You can structure the event string to make the tool auto detect
> which string is pmu vs. event name vs. umask vs. modifier.

On Intel yes, what about the rest of the world? The current stuff is
designed so it works with arbitrary bitmasks.

Ideally the other arch pmu maintainers would provide suitable format
descriptions as well where appropriate.

> > In SFO we spoke about exporting those event tables you have in libpfm4
> > in some structured file format so that we both might use them, the
> > primary difficulty in that (IIRC) was the umask constraints per event.

> Yes, for now the tables are C tables inside the library. This allows some
> flexibility. Not all tables have the same format. But you can also express
> more sophisticated umask constraints. For instance, offcore_response
> where you need a request umask + a response umask on WSM. On
> SNB is it even more complicated. Of course, the alternative it just
> to have a flat list enumerating ALL the possible valid combinations.
> But you have an explosion with WSM/SNB and offcore_response, though
> maybe only few dozens do really make sense.

Right, for SNB there's an explicit list of offcore events that's
'supported' which is significantly shorter than what the bit-encoding
allows for. See 19.3 table 19-4 (Intel SDM March 2012 edition).

> So I suspect for an extern text file, a flat list would make more sense even
> though is would take up some memory to hold it. But then we'd have only
> a couple of tables loaded per process (core, uncore, ...).

Right, but I suspect you can express most of it in JSON. You'd be able
to associate an event with a MESI umask, or some linear enumeration.


> > I've already spoken with Jiri about adding this before all this parser
> > stuff got implemented, so it should all be quite possible to add.
> >
> You mean as you suggested above?

Mostly in general trends without too much detail. From what my memory
still remembers I think we talked about something like:

If the event= thing has a string instead of number, go to some external
dictionary and get an event description back, this event description
might include umask,inv,etc.. bits. If the rest of the explicit event
specification includes bits that are also part of the event, these
override.

For example:

 cpu/event=BR_MISP_RETIRED.ALL_BRANCHES,umask=1/

would, from the external dictionary, return: event=0xc5,umask=0, the
final event will look like: event=0xc5,umask=1 (aka.
BR_MISP_RETIRED.CONDITIONAL).

But suppose you did:

 cpu/event=BR_MISP_RETIRED/

the dictionary might return a umask object (enumeration in this case),
if it would not include 0, the above might throw a warning to the user
about incomplete events. But it could also be used resolve:

 cpu/event=BR_MISP_RETIRED,umask=CONDITIONAL/

[ now arguably my example above is somewhat unfortunate because both
0x00c5 and 0x04c5 are listed as BR_MISP_RETIRED.ALL_BRANCHES ]

> I tried that 3 weeks ago and as I ran into a major issue having to do
> with loss of semantic of the terms (event, umask) in the parser code.
> Also I wonder how the syntax would accomodate umask combinations.
> The problem is that you need to know that the keyword "event" refers
> to the event code and "umask" to the event umask. Without that, hard
> to lookup the event string and umask string properly. You need to know
> you're looking for an event name vs. a umask name. 

I'm not entirely sure I get this, have the tables have the same names as
the bitfields described in the format.

{
	"event" : {
		"BR_MISP_RETIRED" : {
			"value" : 0xc5,
			"umask" : {
				"ALL_BRANCHES" : 0x00
				"CONDITIONAL" : 0x01
				...
				"NOT_TAKEN" : 0x10
				"TAKEN" : 0x20
			}
		},
		...	
	}
}

> That's regardless
> of the fact that the table is internal to a library or in an external text file.
> To work around that, you'd have to ass the content of the syfs format/event
> file to machine specific code which would recognize the attr  + bit field and
> determine whether or not this corresponds to an event code or umask. That's
> pretty ugly. Especially given that I have proof that you don't need to
> go through
> all of this to get something working.

I'm really not sure what you mean. You need to know how to encode all
that, you have cpuid->encoding rules, we have sysfs encoding rules, how
does that matter?

> The advantage of the library is that is can be used for
> self-monitoring programs.

If we'd stick the perf parser into a library you get the same, that's
what libraries are for.. so?

> Therefore the event syntax would remain identical. It can work on
> non-Linux systems
> as well. The library is layered between HW and OS.

Uhm, no the library is layered on top of the OS since it runs in
userspace and needs to use OS provided interfaces to work, it simply
cannot do anything other. If you want to support other OSs thats fine,
but completely irrelevant.

If we get this event data in a usable format every OS/software on that
particular hardware can use the same names provided they use the same
data-set.

> > Furthermore, once we have a common format, we could even ask Intel/AMD
> > (and other vendors) to provide their data in this format.
> >
> I am already doing that.
> 
> I think having external event tables would make it easier for people
> to customize.
> It would also decrease the memory footprint but it would probably increase the
> startup time as you'd have to identify the event table and load it (parse it) on
> demand. It is definitively something I want to pursue. I already
> started experimenting
> with it using JSON for the external file syntax.

You can further reduce the load-time by adding an index/cache on top of
whatever file-format you use. Also, even if you hard-code this in a C
file the resulting data+code still needs to be loaded, albeit by the OS.

For all I care someone writes a small compiler to compile the JSON into
a DSO which you can link to.. really I don't care. What I do care about
is getting that data in a common usable format.

