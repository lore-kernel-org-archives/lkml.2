Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1GNRq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 13:46:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab1GNRqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 13:46:55 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=MwenTAR9eMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=nXRwqVl0ZYJEq3lX1vUA:9 a=cGKv22rQX8FBYEPuD9UA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: INFO: possible circular locking dependency detected
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1310664742.27864.45.camel@gandalf.stny.rr.com>
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
	 <1310662707.27864.38.camel@gandalf.stny.rr.com>
	 <1310662929.27864.40.camel@gandalf.stny.rr.com>
	 <20110714170540.GE2349@linux.vnet.ibm.com>
	 <1310664742.27864.45.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 14 Jul 2011 13:46:53 -0400
Message-ID: <1310665613.27864.50.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

egad! Looking at this code more, there's nothing keeping
t->rcu_read_unlock_special safe! If it can be modified by the kthread,
and current, then we must use atomic operations or modify under lock.
Otherwise the old read/modify/write can corrupt it.

		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;

is done before the lock is taken in rcu_read_unlock_special. If the
kthread is running rcu_boost() then its code:

	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;

Can even negate the removing of the RCU_READ_UNLOCK_BLOCKED!

-- Steve


