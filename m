Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2G3P16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:27:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2G3P15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:27:57 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=rLFqv8mQjsYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=g64lCfYfVIDOovzdIZUA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343662074.27983.4.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 30 Jul 2012 11:27:54 -0400
In-Reply-To: <1343660892.20897.3.camel@twins>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
	 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
	 <1343660892.20897.3.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-30 at 17:08 +0200, Peter Zijlstra wrote:
> On Fri, 2012-07-27 at 17:40 +0200, Frederic Weisbecker wrote:
> > +++ b/kernel/user_hooks.c
> > @@ -0,0 +1,56 @@
> > +#include <linux/user_hooks.h>
> > +#include <linux/rcupdate.h>
> > +#include <linux/sched.h>
> > +#include <linux/percpu.h>
> > +
> > +struct user_hooks {
> > +       bool hooking;
> > +       bool in_user;
> > +};
> 
> I really detest using bool in structures.. but that's just me. Also this
> really wants a comment as to wtf 'hooking' means. in_user I can just
> about guess.

I'm curious to what you have against bool in structures? Would you
prefer a:

struct user_hooks {
	unsigned int hooking:1;
	unsigned int in_user:1;
};

instead? I haven't checked, but I would hope that gcc would optimize the
struct into a single word.

But I could see that it can cause races as that would make modifying
hooking and in_user dependent on each other. That is, if one CPU updates
hooking as another CPU updates in_user, that could cause a
read-modify-write race. At least in this case the modification is only
done on local cpu variables.

-- Steve


