Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab2FYNd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:33:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2804 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab2FYNd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:33:57 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=hVM6Fzsi8tMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=rHrc0Nk8MSUYGYZ6zfIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340631235.27036.304.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2] printk: Have printk() never buffer its data
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "kay.sievers" <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Mon, 25 Jun 2012 09:33:55 -0400
In-Reply-To: <1340630505.27036.294.camel@gandalf.stny.rr.com>
References: <1340630505.27036.294.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 09:21 -0400, Steven Rostedt wrote:

> This brings back the old way of printk() that always prints to the console
> and does not buffer the data. As printk_emit() is used by other 'facilities'
> this only affects printk(), but keeps pretty much the new behavior.

Note, this patch brings back the old printk() behavior of not buffering
the output to the console, without the need of printk_flush() or any
helper function, and it does so without a revert of the changes that Kay
has made.

Even with Kay's changes, if multiple partial lines are printed on SMP,
those would be interleaved as well, as the new method can only save one
partial line at a time. Only full lines will not flush out the buffer.

At least with my patch, if two interleaving printks were coming out at
the same time, they would each get their own line (better than the old
way).

We could probably even add a task id output if necessary, and an
external tool could easily put them back together. Only print the task
id if a partial line was preempted by another task. But that would come
after a later debate.

I'm thinking that this patch is the best of both worlds. Most of Kay's
work is still intact, and printk() still behaves as we expect it to.

-- Steve


