Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1FEG4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 02:56:46 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:57972 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab1FEG4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 02:56:44 -0400
X-ASG-Debug-ID: 1307257002-01de280c1e24760001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DEB28A1.5090109@fusionio.com>
Date: Sun, 5 Jun 2011 08:56:33 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
References: <20110519222404.GG12600@redhat.com>	 <20110521210013.GJ2271@linux.vnet.ibm.com>	 <20110523152141.GB4019@redhat.com>	 <20110523153848.GC2310@linux.vnet.ibm.com>	 <1306401337.27271.3.camel@t41.thuisdomein>	 <20110603050724.GB2304@linux.vnet.ibm.com>	 <1307191830.23387.24.camel@t41.thuisdomein>	 <20110604160326.GA6093@linux.vnet.ibm.com> <1307227686.28359.23.camel@t41.thuisdomein>
X-ASG-Orig-Subj: Re: Mysterious CFQ crash and RCU
In-Reply-To: <1307227686.28359.23.camel@t41.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1307257002
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65534
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-05 00:48, Paul Bolle wrote:
> I think I finally found it!
> 
> The culprit seems to be io_context.ioc_data (not the most clear of
> names!). It seems to be a single entry "last-hit cache" of an hlist
> called cic_list. (There are three, subtly different, cic_lists in the
> CFQ code!) It is not entirely clear, but that last-hit cache can get out
> of sync with the hlist it is supposed to cache. My guess it that every
> now and then a member of the hlist gets deleted while it's still in that
> (single entry) cache. If it then gets retrieved from that cache it
> already points to poisoned memory. For some strange reason this only
> results in an Oops if one or more debugging options are set (as are set
> in the Fedora Rawhide non-stable kernels that I ran into this). I have
> no clue whatsoever, why that is ...
> 
> Anyhow, after ripping out ioc_data this bug seems to have disappeared!
> Jens, Vivek, could you please have a look at this? In the mean time I
> hope to pinpoint this issue and draft a small patch to really solve it
> (ie, not by simply ripping out ioc_data).

Does this fix it? It will introduce a hierarchy that is queue -> ioc
lock, but as far as I can remember (and tell from a quick look), we
don't have any dependencies on that order of locking at this moment. So
should be OK.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3c7b537..fa7ef54 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2772,8 +2772,11 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 	smp_wmb();
 	cic->key = cfqd_dead_key(cfqd);
 
-	if (ioc->ioc_data == cic)
+	if (ioc->ioc_data == cic) {
+		spin_lock(&ioc->lock);
 		rcu_assign_pointer(ioc->ioc_data, NULL);
+		spin_unlock(&ioc->lock);
+	}
 
 	if (cic->cfqq[BLK_RW_ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);

-- 
Jens Axboe

