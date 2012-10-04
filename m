Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab2JDB4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:56:03 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47664 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab2JDB4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:56:00 -0400
X-AuditID: b753bd60-94a4dba000002f78-bd-506cecac1b76
X-AuditID: b753bd60-94a4dba000002f78-bd-506cecac1b76
Message-ID: <506CECAA.6080205@hitachi.com>
Date: Thu, 04 Oct 2012 10:55:54 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Wielaard <mjw@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        systemtap@sourceware.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH -tip ] [BUGFIX] perf probe: Add a workaround for
 GCC -mfentry
References: <20121003121707.4186.28696.stgit@ltc138.sdl.hitachi.co.jp>  <1349272435.22822.165.camel@gandalf.local.home> <1349280029.2682.221.camel@springer.wildebeest.org>
In-Reply-To: <1349280029.2682.221.camel@springer.wildebeest.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/04 1:00), Mark Wielaard wrote:
> On Wed, 2012-10-03 at 09:53 -0400, Steven Rostedt wrote:
>> On Wed, 2012-10-03 at 21:17 +0900, Masami Hiramatsu wrote:
>>>  <1><9a58>: Abbrev Number: 86 (DW_TAG_subprogram)
>>>     <9a59>   DW_AT_external    : 1
>>>     <9a59>   DW_AT_name        : (indirect string, offset: 0xd82): unregister_di
>>> e_notifier
>>>     <9a5d>   DW_AT_decl_file   : 1
>>>     <9a5e>   DW_AT_decl_line   : 551
>>>     <9a60>   DW_AT_prototyped  : 1
>>>     <9a60>   DW_AT_type        : <0x7c>
>>>     <9a64>   DW_AT_low_pc      : 0x740
>>>     <9a6c>   DW_AT_high_pc     : 0x75a
>>>     <9a74>   DW_AT_frame_base  : 1 byte block: 9c       (DW_OP_call_frame_cfa)
>>>     <9a76>   DW_AT_GNU_all_call_sites: 1
>>>     <9a76>   DW_AT_sibling     : <0x9aac>
>>>  <2><9a7a>: Abbrev Number: 87 (DW_TAG_formal_parameter)
>>>     <9a7b>   DW_AT_name        : nb
>>>     <9a7e>   DW_AT_decl_file   : 1
>>>     <9a7f>   DW_AT_decl_line   : 551
>>>     <9a81>   DW_AT_type        : <0x2a96>
>>>     <9a85>   DW_AT_location    : 0x172f (location list)
>>> ...
>>>     0000172f 0000000000000745 0000000000000750 (DW_OP_reg5 (rdi))
>>>     0000172f 0000000000000750 0000000000000757 (DW_OP_reg4 (rsi))
>>>     0000172f 0000000000000757 000000000000075a (DW_OP_GNU_entry_value: (DW_OP_reg5 (rdi)); DW_OP_stack_value)
>>>     0000172f <End of list>
>>> -----
>>>
>>> As you can see, the location of the parameter "nb", starts from 0x745
>>> but unregister_die_notifier() function itself starts from 0x740.
>>
>> Um, no I can't see. I guess I need to go and read up on DWARF formats.
>> Any good recommended links?
>>
>> A quick google gives me:
>>
>> http://en.wikipedia.org/wiki/DWARF
>> http://wiki.dwarfstd.org/index.php?title=Dwarf_FAQ
>> http://www.eagercon.com/dwarf/dwarf-2.0.0.pdf
>>
>> Is this what you recommend reading? Or is there better documentation?
> 
> DWARF2 is pretty old, the latest DWARF standard is
> http://www.dwarfstd.org/Dwarf4Std.php
> If you like details then you'll want to read section 2.5 DWARF
> Expressions and 2.6 Location Descriptions. (That is what the
> DW_AT_location attribute for the DW_TAG_formal_parameter points at.) You
> might also want to read a bit about some of the DWARF5/GNU extensions
> commonly used. I tried to add references to them on this page:
> https://fedorahosted.org/elfutils/wiki/DwarfExtensions
> (Look for the Expression Opcodes)
> 
> So in the above example it tries to say that for function (subprogram)
> "unregister_di_notifier" runs from (low_pc) 0x740 till (high_pc) 0x75a
> and for the parameter "nb" the value can be found in the rdi register
> from address 0x745 till 0x750, in register rsi from address 0x750 till
> 0x575 and for 0x757 till 0x75a it would be the value of register rsi as
> it was on function entry (yes, that just means it isn't available
> anymore and you need to either unwind to function start to get it or
> have it recorded on function entry to retrieve it at this point). The
> above also implies that from address 0x740 till 0x745 GCC didn't record
> the location of nb (or it just hasn't materialized yet).
> 
> Note that the GCC hackers already seem to have identified why that is in
> this case: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=54793#c2

Thanks for the perfect explanation!

And sorry, I should explain not why but what happened...

Without this patch, perf probe doesn't work correctly about finding
function parameters on function entries.

----
# ./perf probe -V vfs_read
Available variables at vfs_read
        @<vfs_read+0>
                (No matched variables)
----

Not only showing parameters, but also setting parameters failed.

----
# ./perf probe vfs_read buf
Failed to find the location of buf at this address.
 Perhaps, it has been optimized out.
Failed to find 'buf' in this function.
  Error: Failed to add events. (-2)
----

With this patch, perf can handle parameters again.

----
# ./perf probe -V vfs_read
Available variables at vfs_read
        @<vfs_read+0>
                char*   buf
                loff_t* pos
                size_t  count
                struct file*    file
----

and

----
# ./perf probe vfs_read buf
Added new event:
  probe:vfs_read       (on vfs_read with buf)

You can now use it in all perf tools, such as:

        perf record -e probe:vfs_read -aR sleep 1
----

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


