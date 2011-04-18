Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1DRJqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:46:40 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:37439 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1DRJqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:46:33 -0400
X-ASG-Debug-ID: 1303119990-01de284cf815c280001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAC0876.1050506@fusionio.com>
Date: Mon, 18 Apr 2011 11:46:30 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "hch@infradead.org" <hch@infradead.org>
CC: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <20110411205928.13915719@notabene.brown> <4DA2E03A.2080607@fusionio.com> <20110411212635.7959de70@notabene.brown> <4DA2E7F0.9010904@fusionio.com> <20110411220505.1028816e@notabene.brown> <4DA2F00E.6010907@fusionio.com> <20110418081922.1651474a@notabene.brown> <4DABDC60.2090009@fusionio.com> <20110418172551.55629fc6@notabene.brown> <4DABF1EA.3070301@fusionio.com> <20110418091959.GA32013@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110418091959.GA32013@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303119990
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61203
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-18 11:19, hch@infradead.org wrote:
> Btw, I really start to wonder if the request level is the right place
> to do this on-stack plugging.  Wouldn't it be better to just plug
> bios in the on-stack queue?  That way we could also stop doing the
> special case merging when adding to the plug list, and leave all the
> merging / I/O schedule logic in the __make_request path.  Probably
> not .39 material, but worth a prototype?
> 
> Also what this dicussion brought up is that the block layer data
> structures are highly confusing.  Using a small subset of the
> request_queue also for make_request based driver just doesn't make
> sense.  It seems like we should try to migrate the required state
> to struct gendisk, and submit I/O through a block_device_ops.submit
> method, leaving the request_queue as an internal abstraction for
> the request based drivers.

Partially agree, I've never really liked the two methods we have where
the light light version was originally meant for stacked devices but
gets used elsewhere now too. It also causes IO scheduling problems, and
then you get things like request based dm to work around that.

But the idea is really to move more towards private queueing more
localized, the multiqueue setup will really apply well there too. I'm
trying to flesh out the design of that, ideally it would be nice to
unify the different bits we have now.

But agree on pulling the stacked bits into some lower part, like the
gendisk. It would clean that up nicely.


-- 
Jens Axboe

