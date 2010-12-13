Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab0LMNvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:51:17 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:64936 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775Ab0LMNvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:51:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=SoSg3lL14CcsCbhKMV3S7rQePbzvFgZr5d64XP7XXC9VXpUOOQTJHOGr/C0iqL8cjS
         wdejxGeX7IffCEv+4TlkFWcTKApoHwlwi5o7pFn9dCZpS80rPNkO5CnrO13V89TAf0gX
         Pd5SK2wVTfnDTohw5a874/HCEHiN9vYDtbTkw=
Date: Mon, 13 Dec 2010 11:51:04 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andres Freund <andres@anarazel.de>
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Costly Context Switches
Message-ID: <20101213135104.GE5407@ghostprotocols.net>
References: <20101212151112.GE26583@charite.de>
 <201012122007.07372.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012122007.07372.andres@anarazel.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Dec 12, 2010 at 08:07:07PM +0100, Andres Freund escreveu:
> On Sunday 12 December 2010 16:11:12 Ralf Hildebrandt wrote:
> > I recently made a parallel installation of dovecot-2.0 on my mailbox
> > server, which is running dovecot-1.2 without any problems whatsoever.

> > Using dovecot-2.0 on the same hardware, same kernel, with the same
> > users and same mailboxes and usage behaviour results in an immense
> > increase in the load numbers.

> > Switching back to 1.2 results in a immediate decrease of the load back
> > to "normal" numbers.

> > This is mainly due to a 10-20 fold increase of the number of context
> > switches. The same problem has been reported independently by Cor
> > Bosman of XS4All, on different hardware (64bit instead of 32bit,
> > real hardware instead of virtual hardware).

> > So, now the kernel related question: How can I find out WHY the
> > context switches are happening? Are there any "in kernel" statistics
> > I could look at?

> "strace" or "perf trace syscall-counts" would be a good start.

Better to record just "cs" (Context Switches) events and also to collect
callchains when those events take place:

[acme@felicio ~]$ perf record -e cs -g chromium-browser
^C
[acme@felicio ~]$ perf report
# Overhead          Command      Shared Object  Symbol
# ........  ...............  .................  ......
#
    91.32%  chromium-browse  [kernel.kallsyms]  [k] perf_event_task_sched_out
            |
            --- perf_event_task_sched_out
               |          
               |--37.80%-- sysret_careful
               |          |          
               |          |--85.11%-- 0x365300e42d
               |          |          
               |           --14.89%-- 0x365300e24a
               |          
               |--30.29%-- retint_careful
               |          |          
               |          |--29.20%-- 0x3652809658
               |          |          
               |          |--28.32%-- 0x7fcb90463603
               |          |          
               |          |--15.04%-- 0x7fcb8bca2e20
               |          |          
               |          |--14.16%-- 0x7fcb903ff36e
               |          |          
               |           --13.27%-- 0x3652809d2f
               |          
               |--23.86%-- schedule_timeout
               |          |          
               |          |--83.15%-- sys_epoll_wait
               |          |          system_call_fastpath
               |          |          0x3652ce5013
               |          |          
               |           --16.85%-- __skb_recv_datagram
               |                     skb_recv_datagram
               |                     unix_dgram_recvmsg
               |                     __sock_recvmsg
               |                     sock_recvmsg
               |                     __sys_recvmsg
               |                     sys_recvmsg
               |                     system_call_fastpath
               |                     __recvmsg
               |          
               |--4.02%-- __cond_resched
               |          _cond_resched
               |          might_fault
               |          memcpy_toiovec
               |          unix_stream_recvmsg
               |          __sock_recvmsg

               |          sock_aio_read
               |          do_sync_read
               |          vfs_read
               |          sys_read
               |          system_call_fastpath
               |          0x365300e48d
               |          (nil)
               |          
                --4.02%-- futex_wait_queue_me
                          futex_wait
                          do_futex
                          sys_futex
                          system_call_fastpath
                          __pthread_cond_timedwait

     7.05%   chrome-sandbox  [kernel.kallsyms]  [k] perf_event_task_sched_out
             |
             --- perf_event_task_sched_out
                 __cond_resched
                 _cond_resched
                 might_fault
                 filldir
                 proc_fill_cache
                 proc_readfd_common
                 proc_readfd
                 vfs_readdir
                 sys_getdents
                 system_call_fastpath
                 __getdents64

     1.34%      gconftool-2  [kernel.kallsyms]  [k] perf_event_task_sched_out
                |
                --- perf_event_task_sched_out
                    sysret_careful
                   |          
                   |--51.61%-- __recv
                   |          
                    --48.39%-- __recvmsg


- Arnaldo
