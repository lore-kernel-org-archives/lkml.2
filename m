Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab0FRULy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:11:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43010 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab0FRULx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:11:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e3QSPcQtIq0UnVcXv0GB0ZXefFpL/Vwz4fjzX3lvnVHmVfUWd2EHSQB4nLnmHVPMf3
         Lj8XS9NEAxocQEU0MsY9bHJ/q9m3UPOODX+b+KhJdwKos+e5VR2lSp0n29AnEQzgEBfs
         0G3fLLDddBUBsQfxw6ItYarUtW3yLYncrmL+A=
Date: Fri, 18 Jun 2010 22:11:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] fix the racy
	check_hung_uninterruptible_tasks()->rcu_lock_break() logic
Message-ID: <20100618201149.GA5280@nowhere>
References: <20100618190251.GA17297@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618190251.GA17297@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 09:02:51PM +0200, Oleg Nesterov wrote:
> check_hung_uninterruptible_tasks()->rcu_lock_break() introduced by
> "softlockup: check all tasks in hung_task" commit ce9dbe24 looks
> absolutely wrong.
> 
> 	- rcu_lock_break() does put_task_struct(). If the task has exited
> 	  it is not safe to even read its ->state, nothing protects this
> 	  task_struct.
> 
> 	- The TASK_DEAD checks are wrong too. Contrary to the comment, we
> 	  can't use it to check if the task was unhashed. It can be unhashed
> 	  without TASK_DEAD, or it can be valid with TASK_DEAD.
> 
> 	  For example, an autoreaping task can do release_task(current)
> 	  long before it sets TASK_DEAD in do_exit().
> 
> 	  Or, a zombie task can have ->state == TASK_DEAD but release_task()
> 	  was not called, and in this case we must not break the loop.
> 
> Change this code to check pid_alive() instead, and do this before we
> drop the reference to the task_struct.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>



Very nice!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

