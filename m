Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1LLSAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:00:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38380 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1LLSAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <1323682702.16764.59.camel@twins>
References: <1323643735-1999-1-git-send-email-vincent.mc.li@gmail.com>
	<1323682702.16764.59.camel@twins>
Date: Mon, 12 Dec 2011 10:00:38 -0800
Message-ID: <CAK3+h2w8LZAD2ZvOD2wBHRZZv1-JznSWZw_byfOYuhLOmFRoDA@mail.gmail.com>
Subject: Re: [PATCH] Softlockup (out of cpu) killer
From: Vincent Li <vincent.mc.li@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Your whole premise is broken. Being a cpu hog and the softlockup
> mechanism aren't related at all.
>
I fully understand that I may misunderstand the the cpu hog and
softlockup mechanism :)

> Furthermore, since the normal scheduling policy is a proportional one, a
> cpu hog can't in fact starve anybody (although a fork bomb could). And
> FIFO/RR are privileged ops.
>

I have a test program with FIFO privileges
http://www.vcn.bc.ca/~vli/schedrtcpu.c.txt that reliably eat 100% cpu
in top and the patch can kill it reliably, we have an user-space
traffic processing program that runs on FIFO similar like the test
program, under some condition, that user-space program could stuck on
the cpu and we want to kill it for high availability reason. with this
patch, we were able to do that.

I do notice that in the schedrtcpu.c test program, if I fork two
process like below:

pid_t spawn() {
        pid_t pid = fork();
        if (pid == 0)
                busyloop();
        return pid;
}



	pid1 = spawn();
	pid2 = spawn();
	
	waitpid(pid1, &status, 0);
	waitpid(pid2, &status, 0);

and run it on two cpu box, I got "sched: RT throttling activated" on
console and the test program wouldn't stuck on cpu, and can only reach
to 95% percent, it is strange that if I don't fork process, and only
runs the busyloop, it would not activate RT throttling and
consistently eat 100% single cpu.

 in our corner case, it appears that patch does help solve our problem.


> Furthermore the distinction between memory and cpu-time is that memory
> isn't a renewable resource, whereas time is. There's always more time,
> but there's not always more memory.
>
understood, thanks

> So no, I don't think either you patch nor your concept make any sense.
> Consider it nacked.
