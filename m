Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab1DAKoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 06:44:44 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55647 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab1DAKol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 06:44:41 -0400
X-AuditID: b753bd60-a46baba000004916-ec-4d95ac9626a1
X-AuditID: b753bd60-a46baba000004916-ec-4d95ac9626a1
Message-ID: <4D95AC94.1080303@hitachi.com>
Date: Fri, 01 Apr 2011 19:44:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC PATCH] perf report: add sort by file lines
References: <1301391136.14111.98.camel@minggr.sh.intel.com>	 <1301392457.4859.74.camel@twins> <1301417155.3620.8.camel@localhost>	 <1301418183.2250.416.camel@laptop> <1301418404.2250.417.camel@laptop>	 <1301418533.2250.419.camel@laptop>	 <20110329174556.GC24129@ghostprotocols.net>  <4D92818A.8020405@hitachi.com>	 <1301561155.14111.288.camel@minggr.sh.intel.com>	 <1301580117.4859.286.camel@twins>  <1301582056.2271.15.camel@localhost> <1301588922.2250.498.camel@laptop>
In-Reply-To: <1301588922.2250.498.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/04/01 1:28), Peter Zijlstra wrote:
> On Thu, 2011-03-31 at 22:34 +0800, Lin Ming wrote:
>> I'm afraid that fwd scan may not work, because of branch instruction.
>>
>> void foo(struct foo *foo, struct tmp *tmp, int flag)
>> { 
>>         if (flag)
>>                 foo->bar->fubar = tmp->blah;   
>>         else    
>>                 tmp->blah = foo->bar->fubar;
>> }
>>
>> ===>
>>
>> void foo(struct foo *foo, struct tmp *tmp, int flag)
>> {
>>   400494:       55                      push   %rbp
>>   400495:       48 89 e5                mov    %rsp,%rbp
>>   400498:       48 89 7d f8             mov    %rdi,-0x8(%rbp)
>>   40049c:       48 89 75 f0             mov    %rsi,-0x10(%rbp)
>>   4004a0:       89 55 ec                mov    %edx,-0x14(%rbp)
>>         if (flag)
>>   4004a3:       83 7d ec 00             cmpl   $0x0,-0x14(%rbp)
>>   4004a7:       74 14                   je     4004bd <foo+0x29>
>>                 foo->bar->fubar = tmp->blah;
>>   4004a9:       48 8b 45 f8             mov    -0x8(%rbp),%rax
>>   4004ad:       48 8b 40 18             mov    0x18(%rax),%rax
>>   4004b1:       48 8b 55 f0             mov    -0x10(%rbp),%rdx
>>   4004b5:       8b 52 20                mov    0x20(%rdx),%edx
>>   4004b8:       89 50 14                mov    %edx,0x14(%rax)
>>   4004bb:       eb 12                   jmp    4004cf <foo+0x3b>
>>         else
>>                 tmp->blah = foo->bar->fubar;
>>   4004bd:       48 8b 45 f8             mov    -0x8(%rbp),%rax
>>   4004c1:       48 8b 40 18             mov    0x18(%rax),%rax
>>   4004c5:       8b 50 14                mov    0x14(%rax),%edx
>>   4004c8:       48 8b 45 f0             mov    -0x10(%rbp),%rax
>>   4004cc:       89 50 20                mov    %edx,0x20(%rax)
>> }
>>   4004cf:       c9                      leaveq
>>   4004d0:       c3                      retq
>>
>> Assume we are at ip 4004c5, the fwd scan from the beginning of
>> function(400494) to 4004c5 will not get what we want about %rax.
> 
> Conversely backwards scans can get confused if there's more places to
> come from (intercal ftw!).
> 
> That said, your example above should not get confused about %rax if it
> knows about the jumps, simply clone your context on any jump instruction
> and follow both branches. That would then give you:
> 
> 400494 -> 4004a7 -> 4004bb -> 4004cf
>                  -> 4004bd

Hm, I think that is the easiest case (like as kprobes does in the kernel)
E.g. an indirect jump makes it hard to find where it jumps to.

> You could even first build the basic block tree and only follow those
> branches that end up covering the region IP is in.

Ah, that's reasonable :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
