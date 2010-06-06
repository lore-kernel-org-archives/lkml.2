Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0FFIIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 04:08:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0FFIIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 04:08:46 -0400
Message-ID: <4C0B577F.9050506@redhat.com>
Date: Sun, 06 Jun 2010 11:08:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Stefan Hajnoczi <stefanha@gmail.com>, linux-perf-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Darren Hart <darren@dvhart.com>
Subject: Re: Perf trace event parse errors for KVM events
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>	 <1275083157.22648.593.camel@gandalf.stny.rr.com>	 <4C00FF9B.9000107@redhat.com>	 <1275139177.22648.610.camel@gandalf.stny.rr.com>	 <4C021D7E.1060705@redhat.com>	 <1275228182.15884.1.camel@gandalf.stny.rr.com>	 <4C027131.2010309@redhat.com>	 <1275233656.15884.4.camel@gandalf.stny.rr.com>	 <4C04C739.8050607@redhat.com>	 <1275393544.15884.19.camel@gandalf.stny.rr.com>	 <4C04FF65.8020408@redhat.com> <1275602225.15884.47.camel@gandalf.stny.rr.com>
In-Reply-To: <1275602225.15884.47.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2010 12:57 AM, Steven Rostedt wrote:
> On Tue, 2010-06-01 at 15:39 +0300, Avi Kivity wrote:
>    
>> On 06/01/2010 02:59 PM, Steven Rostedt wrote:
>>      
>    
>> I meant that viewing would be slowed down.  It's an important part of
>> using ftrace!
>>
>> How long does the Python formatter take to process 100k or 1M events?
>>
>>      
> I finally got around to testing this.
>
> I ran a trace on lock_acquire, and traced 1,253,296 events.
>
> I then created a python plugin to analyze the trace:
>
> ----
> def lock_acquire(trace_seq, event):
>      t = ''
>      r = ''
>      if int(event['flags'])&  1:
>          t = 'try'
>      if int(event['flags'])&  2:
>          r = 'read'
>      trace_seq.puts('t %x %s%s%s' % (
>              event['lockdep_addr'], t, r,
>              event['name']))
>
> def register(pevent):
>      pevent.register_event_handler("lock", "lock_acquire", lock_acquire)
> ----
>
> Disclaimer, I'm not a python expert, and I'm sure the above python code
> sucks.
>    

I think Python more or less guarantees your code will suck no matter 
what you do.

> [root@ixf9 trace-cmd.git]# time ./trace-cmd report -N>/dev/null 2>&1
>
> real	0m4.653s
> user	0m4.234s
> sys	0m0.419s
>
> * -N keeps trace-cmd from loading any plugins.
>
>
> [root@ixf9 trace-cmd.git]# time PYTHONPATH=`pwd` ./trace-cmd report>/dev/null 2>&1
>
> real	0m53.916s
> user	0m53.047s
> sys	0m0.859s
>
>
> Yes, running a python interpreter is a bit more expensive. It took 4
> seconds to read the million events with plain C, but 53 seconds to read
> it in python.
>
> That said...  This would only affect you if you were writing this to a
> file. I doubt that you would notice this if you were scanning the trace
> with less.
>    

I'm more worried about searching with less.  But a minute for a million 
events isn't that bad.

> Also, I kicked this off in kernelshark, and it made no difference that I
> can see. This is because kernelshark only evaluates the viewable area of
> the screen.
>    

Neat.  Can it also search?  Where can I find it? <googles, finds, gawks>

-- 
error compiling committee.c: too many arguments to function

