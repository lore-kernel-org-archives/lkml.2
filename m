Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab1DIXUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 19:20:45 -0400
Received: from mail2.opentransfer.com ([76.162.254.2]:40444 "HELO
	mail2.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754831Ab1DIXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 19:20:44 -0400
Cc: linux-kernel@vger.kernel.org
Message-Id: <B9B9DCEE-5AAE-4EEA-B89A-403F36A26064@osndok.com>
From: Robert Hailey <lkml@osndok.com>
To: Valdis.Kletnieks@vt.edu
In-Reply-To: <112094.1302389083@localhost>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: A long overdue fork-bomb defense ?
Date: Sat, 9 Apr 2011 18:20:42 -0500
References: <67B98EE7-9CD6-44E9-9B6E-C1CDF3115737@osndok.com> <E6EFCBFA-65D9-49D4-B042-EA6773F4D209@osndok.com> <106827.1302379928@localhost> <009EC62D-F6F7-48C4-9D03-9B1B8D6796ED@osndok.com> <112094.1302389083@localhost>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2011/04/09 (Apr), at 5:44 PM, Valdis.Kletnieks@vt.edu wrote:

> On Sat, 09 Apr 2011 17:25:48 CDT, Robert Hailey said:
>
>> Is there a better way to handle the integer overflows?
> ...
> Might want to think about what situations will cause an integer  
> overflow
> here.  What has to happen before an overflow is a concern?

It's counting forks per-process, so it is theoretically bound to  
overflow eventually.

If we use an unsigned 32-bit counter and take 'cron' as an example  
(say it forks 20 times / minute), it would take about 400 years to  
overflow. If on the other hand, we have a naive transaction processor  
using inetd (which if i'm not mistaken forks at every inbound  
connection) at 60,000/second (!) it will wrap about every 48 days.  
Using the div-2 method the next will come sooner, so maybe every  
month....

I think the cost of lock is well amortized even at 32-bits.

>> Thankfully, this logic would only be triggered when the process table
>> is full. At that point I doubt anyone would miss the compute time of
>> even the most painful lock :)
>
> If you get to the point where it's full, you've already lost.
> ...
> Depends why a fork bomb was allowed to be fatal in the first place...

Can you elaborate as to why "you've already lost" if the process table  
is full?

I am particularly interested in any additional information as to why  
fork bombs are fatal, and what the most evil/elusive fork bomb would  
be. At present I think it's about this:

bomb (rate, memory) {
	while(true) {
		if (root) {
			daemonize();
			new_session();
			new_process_group();
			new_executable_name();
			if (some_chance) change_uid;
		}
		leak_some(memory);
		bomb(rate*2, memory);
		delay(rate);
	}
}
bomb(time_on_target, memory_ceiling_tuned);

>
>> Presuming for a moment that it works, I think the worst case is
>> actually a single (perhaps compromised) process spawning child fork
>> bombs. For that matter it could be a bash shell with the user setting
>> them off. In that case it might *never* cause enough forking it to  
>> get
>> itself automatically killed, but the system would still be  
>> [somewhat?]
>
> bash$ :(){ :|:&};:
>
> Try it and see. ;)

Not yet, but maybe soon... ;-)

>
>> responsive through the attack b/c it no longer denies a legitimate
>> fork, i.e. logging in & using a shell work, even while the process
>> table is *FULL* of active fork bombs.
>
> I suspect recent patches that allow an entire process tree to be  
> sent SIGSTOP
> will be a more productive approach.

Surely you're not relying on a user to catch the fork bomb, so how is  
it detected?

BTW, already starting to get off discussion of original idea & psuedo- 
code.

--
Robert Hailey

