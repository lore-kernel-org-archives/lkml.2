Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0KGNjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 08:39:54 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43494 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab0KGNjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 08:39:53 -0500
Date: Sun, 7 Nov 2010 05:39:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Davidlohr Bueso <dave@gnu.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mce: fix RCU lockdep from mce_log()
Message-ID: <20101107133950.GV15561@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1288993499.2065.4.camel@cowboy>
 <20101106185350.GA23824@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101106185350.GA23824@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 07:53:50PM +0100, Andi Kleen wrote:
> On Fri, Nov 05, 2010 at 06:44:59PM -0300, Davidlohr Bueso wrote:
> > Hi,
> > 
> > Please review this patch, I am not very familiar with MCE/RCU so I'm not sure that this is the correct fix (otherwise consider it a bug report :)).
> > This does "fix" the message though and I can use MCE normally.
> 
> The patch is certainly not correct. The variable needs to be read
> independently of the mutex.

This code is simply checking the value of the pointer, and therefore
need not protect any actual dereferences.  So why not replace the
rcu_dereference_check_mce() with rcu_access_pointer()?  If this is
OK, please see the patch below.

BTW, assigning the value returned by rcu_access_pointer() into a
variable often indicates a bug.  ;-)

							Thanx, Paul

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7a35b72..4d29d50 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1625,7 +1625,7 @@ out:
 static unsigned int mce_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &mce_wait, wait);
-	if (rcu_dereference_check_mce(mcelog.next))
+	if (rcu_access_pointer(mcelog.next))
 		return POLLIN | POLLRDNORM;
 	if (!mce_apei_read_done && apei_check_mce())
 		return POLLIN | POLLRDNORM;
