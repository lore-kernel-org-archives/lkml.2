Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0DYR3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 13:29:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165Ab0DYR3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 13:29:41 -0400
Date: Sun, 25 Apr 2010 10:27:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Rik van Riel <riel@redhat.com>, John Stoffel <john@stoffel.org>,
       Hedi Berriche <hedi@sgi.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
In-Reply-To: <alpine.LFD.2.00.1004251002480.3739@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004251021520.3739@i5.linux-foundation.org>
References: <20100421165934.GN16427@zorg.emea.sgi.com> <4BCF336B.1050706@redhat.com> <19407.20109.308816.104856@stoffel.org> <20100421193350.GU16427@zorg.emea.sgi.com> <19407.23456.469074.256306@stoffel.org> <20100421222414.GA26241@suse.de> <4BCF80F2.2010906@redhat.com>
 <20100421232200.GA22877@suse.de> <20100422102852.72837494@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1004220743080.9086@i5.linux-foundation.org> <20100425071606.GB1275@ucw.cz> <alpine.LFD.2.00.1004251002480.3739@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 25 Apr 2010, Linus Torvalds wrote:
> 
> Iirc, some _really_ old code used 'short' for pid_t, and we wanted to be 
> really safe when we raised the limits. 

.. I dug into the history, and this is from August 2002..

We used to limit it to sixteen bits, but that was too tight even then for 
some people, so first we did this:

    Author: Linus Torvalds <torvalds@home.transmeta.com>
    Date:   Thu Aug 8 03:57:42 2002 -0700
    
        Make pid allocation use 30 of the 32 bits, instead of 15.
    
    diff --git a/include/linux/threads.h b/include/linux/threads.h
    index 880b990..6804ee7 100644
    --- a/include/linux/threads.h
    +++ b/include/linux/threads.h
    @@ -19,6 +19,7 @@
     /*
      * This controls the maximum pid allocated to a process
      */
    -#define PID_MAX 0x8000
    +#define PID_MASK 0x3fffffff
    +#define PID_MAX (PID_MASK+1)
     
     #endif
    diff --git a/kernel/fork.c b/kernel/fork.c
    index d40d246..017740d 100644
    --- a/kernel/fork.c
    +++ b/kernel/fork.c
    @@ -142,7 +142,7 @@ static int get_pid(unsigned long flags)
                    return 0;
     
            spin_lock(&lastpid_lock);
    -       if((++last_pid) & 0xffff8000) {
    +       if((++last_pid) & ~PID_MASK) {
                    last_pid = 300;         /* Skip daemons etc. */
                    goto inside;
            }
    @@ -157,7 +157,7 @@ inside:
                               p->tgid == last_pid  ||
                               p->session == last_pid) {
                                    if(++last_pid >= next_safe) {
    -                                       if(last_pid & 0xffff8000)
    +                                       if(last_pid & ~PID_MASK)
                                                    last_pid = 300;
                                            next_safe = PID_MAX;
                                    }

which just upped the limits.  That, in turn, _did_ end up breaking some
silly old binaries, so then a month later Ingo did a "pid-max" patch
that made the maximum dynamic, with a default of the old 15-bit limit,
and a sysctl to raise it. 

And then a couple of weeks later, Ingo did another patch to fix the
scalability problems we had with lots of pids (avoiding the whole
"for_each_task()" crud to figure out which pids were ok, and using a
'struct pid' instead).

So the whole worry about > 15-bit pids goes back to 2002.  I think we're
pretty safe now. 

			Linus

