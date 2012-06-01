Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2FAExe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 00:53:34 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45504 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab2FAExd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 00:53:33 -0400
X-AuditID: b753bd60-98902ba000007aa1-ca-4fc84aca228d
X-AuditID: b753bd60-98902ba000007aa1-ca-4fc84aca228d
Message-ID: <4FC84AC8.3020601@hitachi.com>
Date: Fri, 01 Jun 2012 13:53:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, acme <acme@ghostprotocols.net>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
References: <20120531012829.160060586@goodmis.org>  <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>  <1338473302.13348.336.camel@gandalf.stny.rr.com>  <1338486029.28384.93.camel@twins>  <1338486820.13348.366.camel@gandalf.stny.rr.com>  <1338487413.28384.103.camel@twins>  <1338490218.13348.379.camel@gandalf.stny.rr.com>  <1338491176.28384.114.camel@twins> <20120531195529.GA22976@Krystal>  <1338495006.13348.418.camel@gandalf.stny.rr.com>  <1338495969.28384.119.camel@twins>  <1338496676.13348.430.camel@gandalf.stny.rr.com>  <1338496857.28384.124.camel@twins> <1338497360.13348.438.camel@gandalf.stny.rr.com>
In-Reply-To: <1338497360.13348.438.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/01 5:49), Steven Rostedt wrote:
> On Thu, 2012-05-31 at 22:40 +0200, Peter Zijlstra wrote:
>> On Thu, 2012-05-31 at 16:37 -0400, Steven Rostedt wrote:
>>> On Thu, 2012-05-31 at 22:26 +0200, Peter Zijlstra wrote:
>>>
>>>> Right, but when you loose stop-machine you could simply do 30k
>>>> kmap_atomic/kunmap_atomic's consecutively since you're not holding
>>>> anybody up.
>>>
>>> It requires 3 IPIs per update too. Thus that's 90,000 IPIs you are
>>> blasting^Wsending to all CPUs.
>>
>> Uhm, no. 
>>
> 
> ----------------------------------+
>> for_each() {			|
>>   kmap_atomic()			|
>>   frob int3			|
>>   kunmap_atomic();		|
>> }				|
>> 				|
>> sync-ipi-broadcast();		+--- Break points applied
>> 				|
>> for_each() {			|
>>   kmap_atomic();		|
>>   frob tail			|
>>   kunmap_atomic();		|
>> }				|
> ----------------------------------+
> 
> Note, for the above time, the entire kernel has breakpoints added, and
> every function is taking a hit due to it. By slowing down this process,
> the rest of the system *will* be impacted. Ideally, we want to finish it
> as quick as possible. Not to mention, the kmap_atomics will be slowed
> down by the breakpoints that are attached to them.

Hmm, why don't we have two text_poke interfaces for single and
batch? As like dyn_ftrace, since modifying massive points takes
a lot time, so we may have additional kconfig something like
CONFIG_QUICK_BATCH_TEXT_POKE which switches text area to rw while
batch text_poke.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
