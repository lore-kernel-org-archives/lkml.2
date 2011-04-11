Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1DKI3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:29:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61604 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab1DKI27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:28:59 -0400
Message-ID: <4DA2BC4E.4010000@cn.fujitsu.com>
Date: Mon, 11 Apr 2011 16:31:10 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <20110406201350.GA9378@linux.vnet.ibm.com> <1302123970.2207.4.camel@laptop> <4D9CDACB.9050705@linux.intel.com> <20110407003041.GD2265@linux.vnet.ibm.com> <4D9D507F.2040006@cn.fujitsu.com> <20110407154737.GF2262@linux.vnet.ibm.com> <20110407162600.GA24227@linux.vnet.ibm.com> <4D9E6438.5030206@cn.fujitsu.com> <20110408051359.GA2318@linux.vnet.ibm.com> <4DA2709E.50902@cn.fujitsu.com> <20110411051241.GB18415@linux.vnet.ibm.com>
In-Reply-To: <20110411051241.GB18415@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-11 16:29:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-11 16:29:38,
	Serialize complete at 2011-04-11 16:29:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 01:12 PM, Paul E. McKenney wrote:

> -static inline struct task_struct *next_thread(const struct task_struct *p)
> -{
> -	return list_entry_rcu(p->thread_group.next,
> -			      struct task_struct, thread_group);
> -}
> +/* Avoid #include hell for inlining rcu_read_lock(). */
> +#define next_thread(p) \
> +	list_entry_rcu((p)->thread_group.next, struct task_struct, thread_group)
>  


It is strange for me.
The user of the API "next_thread(p)" must has two headers included, sched.h and rculist.h

I know this is a very popular pattern of user space code, is it OK for kernel?
I think a file(even a header file) uses API(Marco), it should includes the the corresponding
headers, it reduces surprises(example, the name of "next_thread()" has no "rcu",
it is not expected that rcuxxxx.h is required).

I admit the work will become very much simpler if this pattern is allowed.



man fcntl:
       #include <unistd.h>
       #include <fcntl.h>

       int fcntl(int fd, int cmd, ... /* arg */ );
