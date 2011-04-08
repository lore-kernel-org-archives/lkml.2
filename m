Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab1DHUrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:47:16 -0400
Received: from mail2.opentransfer.com ([76.162.254.2]:44388 "HELO
	mail2.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757841Ab1DHUrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:47:15 -0400
Message-Id: <E6EFCBFA-65D9-49D4-B042-EA6773F4D209@osndok.com>
From: Robert Hailey <lkml@osndok.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Reply-To: linux-kernel@vger.kernel.org, lkml@osndok.com
Subject: A long overdue fork-bomb defense ?
Mime-Version: 1.0 (Apple Message framework v936)
Date: Fri, 8 Apr 2011 15:47:13 -0500
References: <67B98EE7-9CD6-44E9-9B6E-C1CDF3115737@osndok.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Non-subscriber, please CC me in responses)

An idea inspired by the Out-of-Memory Killer, to catch fork bombs at  
fork-time...

The principal indicator of a fork bomb is that it calls fork() too  
much, filling up the process table. What makes it nearly impossible to  
kill manually is that it continuously spawns new processes. It is  
precisely this odd behavior which should make it exceptionally easy to  
kill automatically in the kernel.

#1	per-process unsigned integer field "fork_count"
	increments at each fork() [if not max_int],
	new processes inherit incremented value from parent process, or
	zero if parent is init, exec() should *not* clear fork_count

(the above statistic alone might be interesting?)

#2 	global unsigned int "fork_alert_level" usually zero
	doubles both as a alert state switch & fork_count at which to kill  
processes
#3	global time value "fork_alert_time"
	to return the kernel to standard operation when threat is abated

fork would no longer return ELIMIT (or the like), but follow this  
pattern:

fork(proc) {
	unsigned fork_count=(proc->fork_count+1);
	//detect overflow
	if (fork_count>proc->fork_count) {
		proc->fork_count=fork_count;
	} else {
		log("fork_count generation");
		divide_all_process_fork_counts_by_two();
		fork_alert_level/=2;
	}
	if (fork_alert_level) {
		if (fork_count >= fork_alert_level) {
			signal(KILL, proc) && log('killed ...');
			//don't: fork_alert_time=now();
			return/dispatch?;
		}
		if (now()-fork_alert_time>10 seconds?) {
			fork_alert_level=0; //Relax
		}
	}

	child=allocate_new_process();
	if (!child) {
		//No more processes in process table
		Proc highest;
		Proc second_place;
		for ( p : process_table) {
			if (init || protected?) continue;
			if (!highest || p->fork_count>highest->fork_count) {
				second_place=highest;
				highest=p;
			}
		}
		assert(highest->fork_count != second_place->fork_count);
		if (afraid_of_killing_innocents) {
			fork_alert_level = second_place->fork_count;
		} else {
			fork_alert_level = second_place->fork_count -
				(highest->fork_count-second_place->fork_count);
		}
		fork_alert_time=now();
		if (fork_count >= fork_alert_level) {
			signal(KILL, proc)    && log('killed ...');
			signal(KILL, highest) && log('killed ...');
			return/dispatch;
		} else {
			signal(KILL, highest) && log('killed ...');
			child=takeover_process_place(highest);
		}
	}
	child->fork_count=fork_count;

	...continue with fork() logic...
}

So in normal operation it would only count forks.

Of course, the concern is killing processes that legitimately fork  
many times over the course of their life (e.g. inetd, cron...). Such a  
process is not really in danger from it's own children (as they  
inherit the fork_count), but might be in danger of another process'  
child.

Seeing that the new systemd puts each service in it's own process  
group, at first I was thinking this could be easily solved by  
isolating the fork-based-killing to the process group which contains  
the most processes at the moment the process table is found to be full.

Does this sound reasonable, or would an out-of-processes-killer also  
need to scan for session ids or be overly complicated (by uid, by tty)?

Would it even work? thoughts/ideas?

--
Robert Hailey


Seen: delivering a fork_bomb_defense as a kernel module
http://memset.wordpress.com/2011/02/10/syscall-hijacking-anti-fork-bomb-lkm-kernel-2-6-x/

Seen: fork bomb defense with OOM-killer by least_common_ancestor
http://lwn.net/Articles/134513/
http://lwn.net/Articles/136061/


