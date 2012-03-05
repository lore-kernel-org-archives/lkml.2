Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab2CEVoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:44:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53301 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753577Ab2CEVoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:44:09 -0500
Message-ID: <4F55337B.4080807@fb.com>
Date: Mon, 5 Mar 2012 13:43:23 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <dsahern@gmail.com>, <ravitillo@lbl.gov>,
        <khandual@linux.vnet.ibm.com>, <robert.richter@amd.com>,
        <ming.m.lin@intel.com>, <vweaver1@eecs.utk.edu>, <andi@firstfloor.org>
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
References: <20120224094048.GA7952@quad> <20120305154753.GA14604@elte.hu> <20120305155011.GA32413@elte.hu> <20120305155642.GB32413@elte.hu> <1330965033.11248.240.camel@twins> <20120305203518.GA5656@infradead.org>
In-Reply-To: <20120305203518.GA5656@infradead.org>
Content-Type: multipart/mixed;
	boundary="------------000906030108040105050308"
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-05_06:2012-03-05,2012-03-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000906030108040105050308
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/12 12:35 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Mar 05, 2012 at 05:30:33PM +0100, Peter Zijlstra escreveu:
>> On Mon, 2012-03-05 at 16:56 +0100, Ingo Molnar wrote:
>>> A third usability bug is that for some reason a branch sampling
>>> 'perf report' defaults to the stdio output on my testsystem -
>>> with --no-branch-stack it gives the regular tui.
>
>> Ah, I would not have noticed that since I still explicitly build my perf
>> without TUI support. That stuff mostly just gets in the way.
>
> Do you have any specific complaints about it?
>

I think --tui code paths have some bugs that cause it to SIGSEGV, while 
the --stdio paths don't. I think much of it has to do with how often 
that particular combination of command line options is used.

Here's an example:

# perf record -ag -- sleep 3
# perf report -G -s pid --tui # SIGSEGV
# perf report -G -s pid --stdio # works fine

Details attached.

  -Arun




--------------000906030108040105050308
Content-Type: text/plain; name="perf-debug.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="perf-debug.txt"

                                                                                                                                                                                                                  
Program received signal SIGSEGV, Segmentation fault.                                                                                                                                                              
[Switching to Thread 139975795275488 (LWP 13155)]                                                                                                                                                                 
symbol__inc_addr_samples (sym=0x91eb90, map=<value optimized out>, evidx=0, addr=120416) at util/annotate.c:73                                                                                                    
73      util/annotate.c: No such file or directory.                                                                                                                                                               
        in util/annotate.c                                                                                                                                                                                        
(gdb) bt                                                                                                                                                                                                          
#0  symbol__inc_addr_samples (sym=0x91eb90, map=<value optimized out>, evidx=0, addr=120416) at util/annotate.c:73                                                                                                
#1  0x0000000000410b5d in process_sample_event (tool=<value optimized out>, event=0x7f4ea28e26b0, sample=0x7fffcc1ca8f0, evsel=0x823ea0, machine=0x822290) at builtin-report.c:127                                
#2  0x00000000004433ca in flush_sample_queue (s=0x822230, tool=0x7fffcc1cc340) at util/session.c:528                                                                                                              
#3  0x0000000000444d16 in __perf_session__process_events (session=0x822230, data_offset=<value optimized out>, data_size=<value optimized out>, file_size=<value optimized out>, tool=0x7fffcc1cc340)             
    at util/session.c:1175                                                                                                                                                                                        
#4  0x0000000000445217 in perf_session__process_events (self=0x822230, tool=0x7fffcc1cc340) at util/session.c:1191                                                                                                
#5  0x000000000041015b in cmd_report (argc=0, argv=0x7fffcc1cc830, prefix=<value optimized out>) at builtin-report.c:311                                                                                          
#6  0x00000000004051b9 in handle_internal_command (argc=4, argv=0x7fffcc1cc830) at perf.c:273                                                                                                                     
#7  0x0000000000405623 in main (argc=4, argv=0x479218) at perf.c:388                                                                                                                                              
                                                                                                                                                                                      
(gdb) p /x sym->start                                                                                                                                                                                          
$5 = 0xffffffff8100fb74                                                                                                                                                                                           
(gdb) p /x addr
$6 = 0x1d660
(gdb) p offset
$7 = 2130762476

54 int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
55                              int evidx, u64 addr)
56 {
57         unsigned offset;
58         struct annotation *notes;
59         struct sym_hist *h;
60 
61         notes = symbol__annotation(sym);
62         if (notes->src == NULL)
63                 return -ENOMEM;
64 
65         pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
66 
67         if (addr >= sym->end)
68                 return 0;
69 
70         offset = addr - sym->start;
71         h = annotation__histogram(notes, evidx);
72         h->sum++;
73         h->addr[offset]++; <-- potential bad memory reference

--------------000906030108040105050308--
