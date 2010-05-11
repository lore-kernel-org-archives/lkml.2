Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab0EKJzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 05:55:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49453 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab0EKJy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 05:54:58 -0400
Date: Tue, 11 May 2010 04:54:10 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@vnet.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] pids: init_struct_pid.tasks should never see the
 swapper process
Message-ID: <20100511095410.GA27850@us.ibm.com>
References: <4BE01C86.3050908@secunet.com>
 <20100509184510.GA15219@redhat.com>
 <4BE7B3BD.70901@secunet.com>
 <20100510194917.GA5249@redhat.com>
 <20100510195014.GC5249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510195014.GC5249@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> "statically initialize struct pid for swapper" commit 820e45db says:
> 
> 	Statically initialize a struct pid for the swapper process (pid_t == 0)
> 	and attach it to init_task.  This is needed so task_pid(), task_pgrp()
> 	and task_session() interfaces work on the swapper process also.
> 
> OK, but:
> 
> 	- it doesn't make sense to add init_task.pids[].node into
> 	  init_struct_pid.tasks[], and in fact this just wrong.
> 
> 	  idle threads are special, they shouldn't be visible on any
> 	  global list. In particular do_each_pid_task(init_struct_pid)
> 	  shouldn't see swapper.
> 
> 	  This is the actual reason why kill(0, SIGKILL) from /sbin/init
> 	  (which starts with 0,0 special pids) crashes the kernel. The
> 	  signal sent to pgid/sid == 0 must never see idle threads, even
> 	  if the previous patch fixed the crash itself.
> 
> 	- we have other idle threads running on the non-boot CPUs, see
> 	  the next patch.
> Change INIT_STRUCT_PID/INIT_PID_LINK to create the empty/unhashed
> hlist_head/hlist_node. Like any other idle thread swapper can never exit,
> so detach_pid()->__hlist_del() is not possible, but we could change
> INIT_PID_LINK() to set pprev = &next if needed.
> 
> All we need is the valid swapper->pids[].pid == &init_struct_pid.
> 
> Reported-by: Mathias Krause <mathias.krause@secunet.com>

Crimey, trying to find some way this could get dereferenced, finding
myself impressed with the likes of set_ftrace_swapper().

Anyway, not finding anything, so

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Serge E. Hallyn <serue@us.ibm.com>

thanks,
-serge
