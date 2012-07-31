Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2GaOvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:51:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9332 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2GaOvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:51:53 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=I5RZEMmPgckA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=dK3baWGq6wwTgra2qNsA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343746311.27983.52.camel@gandalf.stny.rr.com>
Subject: Re: __update_max_tr: rcu_read_lock() used illegally while idle!
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Tue, 31 Jul 2012 10:51:51 -0400
In-Reply-To: <20120731144453.GB2422@linux.vnet.ibm.com>
References: <20120724090330.GA9830@localhost>
	 <1343662752.3847.2.camel@fedora> <20120731120556.GB17252@localhost>
	 <1343741625.27983.39.camel@gandalf.stny.rr.com>
	 <20120731144453.GB2422@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 07:44 -0700, Paul E. McKenney wrote:

> > Found it (and Cc'd David).
> > 
> > In __update_max_tr() we have:
> > 
> > 	max_data = task_uid(tsk);
> > 
> > where task_uid() is:
> > 
> > #define task_uid(task)		(task_cred_xxx((task), uid))
> > 
> > #define task_cred_xxx(task, xxx)			\
> > ({							\
> > 	__typeof__(((struct cred *)NULL)->xxx) ___val;	\
> > 	rcu_read_lock();				\
> > 	___val = __task_cred((task))->xxx;		\
> > 	rcu_read_unlock();				\
> > 	___val;						\
> > })
> > 
> > The __update_max_tr() is called at every location interrupts are enabled
> > (and a max time is discovered). But now this can include places that
> > rcu_read_lock can not be called, I'm not sure how to handle this. Is
> > there a non rcu way to get a tasks uid?
> 
> OK, I will bite.  How about using something like RCU_NONIDLE(), either
> directly or open-coded, to make it a legal call site?

OK, then something like:

	RCU_NONIDLE(max_data = task_uid(tsk));

would work when called normally or with idle?

-- Steve


