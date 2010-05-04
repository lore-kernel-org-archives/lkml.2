Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953Ab0EDUU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:20:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:50455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933927Ab0EDUU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:20:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,328,1270450800"; 
   d="scan'208";a="618867696"
Date: Tue, 4 May 2010 20:42:36 +0100
From: Alan Cox <alan@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: possible locking bug in tty_open
Message-ID: <20100504204236.5dc6a34e@linux.intel.com>
In-Reply-To: <201005022247.33857.arnd@arndb.de>
References: <201005022247.33857.arnd@arndb.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 May 2010 22:47:33 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> While playing some more with my TTY BKL patches, I stumbled over
> what looks like a bug in tty_open, introduced in e8c6210 
> "tty: push the BKL down into the handlers a bit":
> 
> After the "retry_open:" label, we first get the tty_mutex
> and then the BKL. However a the end of tty_open, we jump
> back to retry_open with the BKL still held. If we run into
> this case, the tty_open function will be left with the BKL
> still held.
> 
> It may be impossible to actually trigger this bug, because
> the path is only taken if a tty driver open function returns
> -ERESTARTSYS without setting signal_pending().
> 
> 	Arnd

I think all we need is probably this

tty: Fix unbalanced BKL handling in error path
    
Arnd noted:
    
After the "retry_open:" label, we first get the tty_mutex
and then the BKL. However a the end of tty_open, we jump
back to retry_open with the BKL still held. If we run into
this case, the tty_open function will be left with the BKL
still held.
    
Signed-off-by: Alan Cox <alan@linux.intel.com>

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 6da962c..fe810a7 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1875,6 +1875,7 @@ got_driver:
 		 */
 		if (filp->f_op == &hung_up_tty_fops)
 			filp->f_op = &tty_fops;
+		unlock_kernel();
 		goto retry_open;
 	}
 	unlock_kernel();
