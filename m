Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab1EYIqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:46:36 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:33963 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932931Ab1EYIqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:46:34 -0400
X-ASG-Debug-ID: 1306313192-01de28096b65e90001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDCC1E4.706@fusionio.com>
Date: Wed, 25 May 2011 10:46:28 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
References: <20110519222404.GG12600@redhat.com>		 <20110521210013.GJ2271@linux.vnet.ibm.com>		 <20110523152141.GB4019@redhat.com>		 <20110523153848.GC2310@linux.vnet.ibm.com>	 <1306189249.15900.10.camel@t41.thuisdomein> <4DDB7D36.60905@fusionio.com> <1306312155.9059.8.camel@t41.thuisdomein>
X-ASG-Orig-Subj: Re: Mysterious CFQ crash and RCU
In-Reply-To: <1306312155.9059.8.camel@t41.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306313192
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-25 10:28, Paul Bolle wrote:
> On Tue, 2011-05-24 at 11:41 +0200, Jens Axboe wrote:
>> Paul, can we see a dmesg from your running system? Perhaps there's some
>> dependency on a particular driver or device that makes this easier to
>> reproduce.
> 
> Sure. What follows is (1K+ lines output of) the dmesg of a session in
> which I managed to trigger this issue (three times) with my favorite
> testing tool (ie, "mandb -c"). Feel free to prod me for the details of
> my system that are not apparent from the flood of information in this
> log.

Great, thanks Paul. Are you easily able to test a patch out? Having a
test case on your machine that is as easily reproducible as it seems to
be, would be a great place to test ideas out.

I don't think we are dealing with bad RCU usage in CFQ. My gut tells me
that this is related to the merging of cooperating queues. It fits
roughly with the time frame of when this issue started occuring, and
some of that reference logic looks fragile/racy.

So if you _can_ test a patch easily, please try this one. It'll disable
that logic.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ab7a9e6..f37e3df 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1827,6 +1827,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
 static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 					      struct cfq_queue *cur_cfqq)
 {
+#if 0
 	struct cfq_queue *cfqq;
 
 	if (cfq_class_idle(cur_cfqq))
@@ -1870,6 +1871,9 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 		return NULL;
 
 	return cfqq;
+#else
+	return cfqq;
+#endif
 }
 
 /*

-- 
Jens Axboe

