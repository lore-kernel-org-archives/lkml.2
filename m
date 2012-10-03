Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002Ab2JCQCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:02:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964989Ab2JCQCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:02:13 -0400
Message-ID: <1349280029.2682.221.camel@springer.wildebeest.org>
Subject: Re: [PATCH -tip ] [BUGFIX] perf probe: Add a workaround for GCC
 -mfentry
From: Mark Wielaard <mjw@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Michal Marek <mmarek@suse.cz>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        systemtap@sourceware.org, yrl.pp-manager.tt@hitachi.com
Date: Wed, 03 Oct 2012 18:00:29 +0200
In-Reply-To: <1349272435.22822.165.camel@gandalf.local.home>
References: <20121003121707.4186.28696.stgit@ltc138.sdl.hitachi.co.jp>
	 <1349272435.22822.165.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 09:53 -0400, Steven Rostedt wrote:
> On Wed, 2012-10-03 at 21:17 +0900, Masami Hiramatsu wrote:
> >  <1><9a58>: Abbrev Number: 86 (DW_TAG_subprogram)
> >     <9a59>   DW_AT_external    : 1
> >     <9a59>   DW_AT_name        : (indirect string, offset: 0xd82): unregister_di
> > e_notifier
> >     <9a5d>   DW_AT_decl_file   : 1
> >     <9a5e>   DW_AT_decl_line   : 551
> >     <9a60>   DW_AT_prototyped  : 1
> >     <9a60>   DW_AT_type        : <0x7c>
> >     <9a64>   DW_AT_low_pc      : 0x740
> >     <9a6c>   DW_AT_high_pc     : 0x75a
> >     <9a74>   DW_AT_frame_base  : 1 byte block: 9c       (DW_OP_call_frame_cfa)
> >     <9a76>   DW_AT_GNU_all_call_sites: 1
> >     <9a76>   DW_AT_sibling     : <0x9aac>
> >  <2><9a7a>: Abbrev Number: 87 (DW_TAG_formal_parameter)
> >     <9a7b>   DW_AT_name        : nb
> >     <9a7e>   DW_AT_decl_file   : 1
> >     <9a7f>   DW_AT_decl_line   : 551
> >     <9a81>   DW_AT_type        : <0x2a96>
> >     <9a85>   DW_AT_location    : 0x172f (location list)
> > ...
> >     0000172f 0000000000000745 0000000000000750 (DW_OP_reg5 (rdi))
> >     0000172f 0000000000000750 0000000000000757 (DW_OP_reg4 (rsi))
> >     0000172f 0000000000000757 000000000000075a (DW_OP_GNU_entry_value: (DW_OP_reg5 (rdi)); DW_OP_stack_value)
> >     0000172f <End of list>
> > -----
> > 
> > As you can see, the location of the parameter "nb", starts from 0x745
> > but unregister_die_notifier() function itself starts from 0x740.
> 
> Um, no I can't see. I guess I need to go and read up on DWARF formats.
> Any good recommended links?
> 
> A quick google gives me:
> 
> http://en.wikipedia.org/wiki/DWARF
> http://wiki.dwarfstd.org/index.php?title=Dwarf_FAQ
> http://www.eagercon.com/dwarf/dwarf-2.0.0.pdf
> 
> Is this what you recommend reading? Or is there better documentation?

DWARF2 is pretty old, the latest DWARF standard is
http://www.dwarfstd.org/Dwarf4Std.php
If you like details then you'll want to read section 2.5 DWARF
Expressions and 2.6 Location Descriptions. (That is what the
DW_AT_location attribute for the DW_TAG_formal_parameter points at.) You
might also want to read a bit about some of the DWARF5/GNU extensions
commonly used. I tried to add references to them on this page:
https://fedorahosted.org/elfutils/wiki/DwarfExtensions
(Look for the Expression Opcodes)

So in the above example it tries to say that for function (subprogram)
"unregister_di_notifier" runs from (low_pc) 0x740 till (high_pc) 0x75a
and for the parameter "nb" the value can be found in the rdi register
from address 0x745 till 0x750, in register rsi from address 0x750 till
0x575 and for 0x757 till 0x75a it would be the value of register rsi as
it was on function entry (yes, that just means it isn't available
anymore and you need to either unwind to function start to get it or
have it recorded on function entry to retrieve it at this point). The
above also implies that from address 0x740 till 0x745 GCC didn't record
the location of nb (or it just hasn't materialized yet).

Note that the GCC hackers already seem to have identified why that is in
this case: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=54793#c2

Cheers,

Mark
