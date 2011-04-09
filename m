Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1DIWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 18:25:56 -0400
Received: from mail2.opentransfer.com ([76.162.254.2]:43415 "HELO
	mail2.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754424Ab1DIWZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 18:25:54 -0400
Cc: linux-kernel@vger.kernel.org
Message-Id: <009EC62D-F6F7-48C4-9D03-9B1B8D6796ED@osndok.com>
From: Robert Hailey <lkml@osndok.com>
To: Valdis.Kletnieks@vt.edu
In-Reply-To: <106827.1302379928@localhost>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: A long overdue fork-bomb defense ?
Date: Sat, 9 Apr 2011 17:25:48 -0500
References: <67B98EE7-9CD6-44E9-9B6E-C1CDF3115737@osndok.com> <E6EFCBFA-65D9-49D4-B042-EA6773F4D209@osndok.com> <106827.1302379928@localhost>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2011/04/09 (Apr), at 3:12 PM, Valdis.Kletnieks@vt.edu wrote:

> On Fri, 08 Apr 2011 15:47:13 CDT, Robert Hailey said:
>
>> 		log("fork_count generation");
>> 		divide_all_process_fork_counts_by_two();
>
> This will involve painful locking on large systems with lots of  
> procs running.

This logic (and the related painful locks) would be triggered only  
once in a small fractional proportion to the number of forks of the  
single greatest forker. But it is a solid observation, that if such a  
patch was in place there would be an overhead to it's use; I imagine  
it would take a considerable amount of time for a long running system  
to wrap it's fork counts.

Is there a better way to handle the integer overflows?

>
>
>> 		for ( p : process_table) {
>
> Ditto.

Thankfully, this logic would only be triggered when the process table  
is full. At that point I doubt anyone would miss the compute time of  
even the most painful lock :)

>
>> 	if (fork_alert_level) {
>> 		if (fork_count >= fork_alert_level) {
>> 			signal(KILL, proc) && log('killed ...');
>> 			//don't: fork_alert_time=now();
>> 			return/dispatch?;
>> 		}
>> 		if (now()-fork_alert_time>10 seconds?) {
>> 			fork_alert_level=0; //Relax
>> 		}
>> 	}
>
> A smart attacker can probably use this to  game the fork rate to fly  
> just under
> the wire, while still piling up lots of processes, *and* adding  
> extra overhead
> as it goes. If the rate limit is 5000 forks every 10 seconds, it can  
> do 4500
> every 10 seconds, and in a few minutes the poor scaling sections  
> will eat your
> system alive.

Perhaps there is a misunderstanding.... Although this logic is  
*sensitive* to forking rate, this is not directly acting on (or  
measuring) a forking rate. It is simply providing a metric by which  
processes can be compared (number of forks in self and ancestors), and  
providing something to do if we find that we are out of process table  
space (the limited resource in question). Of course... if the memory  
ceiling is reached first (fork/malloc), then that is a concern of the  
OOM-killer (a separate but related discussion).

Presuming for a moment that it works, I think the worst case is  
actually a single (perhaps compromised) process spawning child fork  
bombs. For that matter it could be a bash shell with the user setting  
them off. In that case it might *never* cause enough forking it to get  
itself automatically killed, but the system would still be [somewhat?]  
responsive through the attack b/c it no longer denies a legitimate  
fork, i.e. logging in & using a shell work, even while the process  
table is *FULL* of active fork bombs.

Even if a fork bomb is downgraded from "fatal" to "makes things darn  
slow", it's worth considering, no?

--
Robert Hailey


