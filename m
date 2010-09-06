Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0IFRvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 13:51:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab0IFRvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 13:51:40 -0400
Message-ID: <4C8529FF.6090500@redhat.com>
Date: Mon, 06 Sep 2010 20:50:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
References: <4C84B088.5050003@redhat.com>	<1283772256.1930.303.camel@laptop>	<4C84D1CE.3070205@redhat.com>	<1283774045.1930.341.camel@laptop>	<4C84D77B.6040600@redhat.com>	<20100906124330.GA22314@elte.hu>	<4C84E265.1020402@redhat.com>	<20100906125905.GA25414@elte.hu>	<4C850147.8010908@redhat.com>	<20100906163041.3677fd66@lxorguk.ukuu.org.uk>	<4C8506B5.1040808@redhat.com> <20100906164824.339cd82e@lxorguk.ukuu.org.uk>
In-Reply-To: <20100906164824.339cd82e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 06:48 PM, Alan Cox wrote:
>> No, I want the ability to terminate the code at any time and clean up
>> any resources used.  We have exactly the same requirements for ordinary
>> userspace.
> So you intend to prevent its use at any point where we have a kernel only
> resource held in any way manner or form ? Remember we don't hold locks or
> many kinds of kernel resource across syscalls.

I don't think we can allow the downloaded code to hold any kernel 
locks.  If the locks are necessary for correct operation, then the 
untrusted code can "forget" to take them.  If they aren't necessary, 
don't expose them in the first place.  All APIs exposed to the code have 
to be thread safe.  We can allow locks that only protect user data 
structures (and so we can just wipe them out if we need to kill the 
code, just like with futexes[1]).

Other resources are easy, we do this everywhere, including for userspace.

> Likewise I'm interested
> how you will keep it compatible with real time ?

It's just like other executing any user code.  Whatever thread executes 
that code is impacted by its real time characteristics.  If a 
non-realtime thread executes it, who cares.  If a real time thread 
executes it, then it's up to the user to guarantee real time behaviour.  
The kernel need only ensure that user code given by a low-priority task 
is not executed in a high priority task.

>> So you do want to jit?
> Depends what you mean by jit. JIT normally implies compiling/recompiling
> as you go. Do we want to compile it once at load time - probably,
> assuming the tool is present.

That's jit enough for me.  These would usually be small code snippets, 
not megabytes of junk, though that would no doubt follow if we do a good 
job.

We could probably s/netfilter/call to user code/ and remove tons of 
potentially vulnerable kernel code, and gain lots of flexibility into 
the bargain.  I'd like to use this for kvm as well.


[1] Ignoring robust futexes, IIUC

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

