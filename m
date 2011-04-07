Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab1DGNk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:40:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36122 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1DGNk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uA7e1lAF/sQFatRONrNJnjolXqqDynqrT1CKLarRofkM1nErsYu81nRbg+9MamdZUw
         XwRUOr0No8dLqKASQ19K37fgdG8LBOJptdDXithW+vidp7G4+Cg1wz2M2xHGKA2bcBAt
         RJItJXLnqOKP9hN42/2RsIGq8q0eVc8j1CJ24=
MIME-Version: 1.0
In-Reply-To: <4D9D62CE.7060007@cn.fujitsu.com>
References: <1301570320.4859.242.camel@twins>
	<4D953121.6090901@cn.fujitsu.com>
	<1301657749.4859.531.camel@twins>
	<20110405215450.GK2247@linux.vnet.ibm.com>
	<20110405230745.GA5972@linux.vnet.ibm.com>
	<1302077428.2225.1365.camel@twins>
	<20110406192119.GB2265@linux.vnet.ibm.com>
	<20110406201350.GA9378@linux.vnet.ibm.com>
	<1302123970.2207.4.camel@laptop>
	<4D9CDACB.9050705@linux.intel.com>
	<20110407003041.GD2265@linux.vnet.ibm.com>
	<4D9D62CE.7060007@cn.fujitsu.com>
Date: Thu, 7 Apr 2011 16:40:25 +0300
Message-ID: <BANLkTinrmMT8dE+EuOKegM+CB8+T7AfjEw@mail.gmail.com>
Subject: Re: [PATCH 3/4] rcu: introduce task_rcu_struct and move task's RCU
 code to rcupdate_defs.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 10:07 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> Add struct task_rcu_struct to make code clearer and move
> them to rcupdate_defs.h which help us for code maitainment.

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1232,17 +1232,7 @@ struct task_struct {
>        unsigned int policy;
>        cpumask_t cpus_allowed;
>
> -#ifdef CONFIG_PREEMPT_RCU
> -       int rcu_read_lock_nesting;
> -       char rcu_read_unlock_special;
> -       struct list_head rcu_node_entry;
> -#endif /* #ifdef CONFIG_PREEMPT_RCU */
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> -       struct rcu_node *rcu_blocked_node;
> -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> -#ifdef CONFIG_RCU_BOOST
> -       struct rt_mutex *rcu_boost_mutex;
> -#endif /* #ifdef CONFIG_RCU_BOOST */
> +       struct task_rcu_struct task_rcu_struct;

Oh, wow, all these movements are for this.

You could do

    struct task_rcu {
        ...
    } rcu;

inside sched.h, drop pointless 1:1 current_() et al wrappers and
avoid all this mess.
