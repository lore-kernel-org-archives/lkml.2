Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab1COQbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:31:10 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45230 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab1COQbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:31:09 -0400
Date: Tue, 15 Mar 2011 21:55:08 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 7/20] 7: uprobes: store/restore
 original instruction.
Message-ID: <20110315162508.GZ24254@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
 <alpine.LFD.2.00.1103151538200.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103151538200.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [2011-03-15 15:41:20]:

> On Mon, 14 Mar 2011, Srikar Dronamraju wrote:
> >  static int install_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
> >  {
> > -	int ret = 0;
> > +	struct task_struct *tsk;
> > +	int ret = -EINVAL;
> >  
> > -	/*TODO: install breakpoint */
> > -	if (!ret)
> > +	get_task_struct(mm->owner);
> 
> Increment task ref before checking for NULL ?

In response to earlier comments/suggestions from Stephen Wilson, we
resolved to handle it this way 


static uprobes_get_mm_owner() {
	struct task_struct *tsk; 

	rcu_read_lock()
	tsk = rcu_dereference(mm->owner);
	if (tsk)
		get_task_struct(tsk);	
	rcu_read_unlock();
	return tsk;
}

Both install_uprobe and remove_uprobe will end up calling uprobes_get_mm_owner().


-- 
Thanks and Regards
Srikar
