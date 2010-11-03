Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0KCI76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 04:59:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34309 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab0KCI7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 04:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v+43sDcjlIRU/1TOdavnsGmYOPbalEgpJpCfjmD/rIRAK8zJMhiob3LqVKtd1oktDh
         q4KV4BE8WWC3k5KpqMHPrAV8KOvSRbSRwP2LRFrgxcrFM3SaeJaLt5PLC6o3HrU3lzrG
         OW7rIHeofNbxd9cYqKvLJdq0y/v/lUjmVruMg=
Date: Wed, 3 Nov 2010 08:59:48 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.35->2.6.36 regression, vanilla kernel panic, ppp or
	hrtimers crashing
Message-ID: <20101103085948.GC7279@ff.dom.local>
References: <20101028070550.GA7647@ff.dom.local> <201011030947.54464.nuclearcat@nuclearcat.com> <20101103080258.GB7279@ff.dom.local> <201011031018.21178.nuclearcat@nuclearcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011031018.21178.nuclearcat@nuclearcat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 10:18:20AM +0200, Denys Fedoryshchenko wrote:
> 
> On Wednesday 03 November 2010 10:02:58 Jarek Poplawski wrote:
> > On Wed, Nov 03, 2010 at 09:47:53AM +0200, Denys Fedoryshchenko wrote:
> > > I try to reverse and got very weird lockups (no netconsole logs and no
> > > watchdog triggered reboot on that remote machine).
> > > I will try to cook something to reboot it, because it is very remote
> > > machine
> > 
> > OK, I only wanted to know if reverting could be a fast fix. Since it
> > isn't, please stay with 2.6.35 until there is some new idea (patch).
> > 
> Well, still i want to try (if i can) more debug, and maybe i'll catch 
> something, also i have around 145 NAS servers to go, to try 2.6.36 :-)

I think the current debugging needs analyzing first. But here is
a patch which probably could matter at least wrt your first oopses.
(Please try this first on something you can easily reboot.)

Jarek P.
---

diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 09cf56d..1b98c4c 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -409,6 +409,8 @@ static ssize_t ppp_read(struct file *file, char __user *buf,
 
 	if (!pf)
 		return -ENXIO;
+
+	atomic_inc(&pf->refcnt);
 	add_wait_queue(&pf->rwait, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -440,6 +442,17 @@ static ssize_t ppp_read(struct file *file, char __user *buf,
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&pf->rwait, &wait);
 
+	if (atomic_dec_and_test(&pf->refcnt)) {
+		switch (pf->kind) {
+		case INTERFACE:
+			ppp_destroy_interface(PF_TO_PPP(pf));
+			break;
+		case CHANNEL:
+			ppp_destroy_channel(PF_TO_CHANNEL(pf));
+			break;
+		}
+	}
+
 	if (!skb)
 		goto out;
 
@@ -504,6 +517,8 @@ static unsigned int ppp_poll(struct file *file, poll_table *wait)
 
 	if (!pf)
 		return 0;
+
+	atomic_inc(&pf->refcnt);
 	poll_wait(file, &pf->rwait, wait);
 	mask = POLLOUT | POLLWRNORM;
 	if (skb_peek(&pf->rq))
@@ -518,6 +533,17 @@ static unsigned int ppp_poll(struct file *file, poll_table *wait)
 			mask |= POLLIN | POLLRDNORM;
 	}
 
+	if (atomic_dec_and_test(&pf->refcnt)) {
+		switch (pf->kind) {
+		case INTERFACE:
+			ppp_destroy_interface(PF_TO_PPP(pf));
+			break;
+		case CHANNEL:
+			ppp_destroy_channel(PF_TO_CHANNEL(pf));
+			break;
+		}
+	}
+
 	return mask;
 }
 
