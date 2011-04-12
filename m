Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab1DLR3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:29:36 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:35206 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab1DLR3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:29:35 -0400
X-ASG-Debug-ID: 1302629374-03d6a569fb98300001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA48BF9.4050304@fusionio.com>
Date: Tue, 12 Apr 2011 19:29:29 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "hch@infradead.org" <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>, NeilBrown <neilb@suse.de>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <4DA2F00E.6010907@fusionio.com> <20110411223623.4278fad1@notabene.brown> <4DA2F8AD.1060605@fusionio.com> <20110412011255.GA29236@infradead.org> <4DA40F0E.1070903@fusionio.com> <20110412122248.GC31057@dastard> <4DA4456F.3070301@fusionio.com> <20110412124134.GD31057@dastard> <4DA44C86.3090305@fusionio.com> <20110412133117.GE31057@dastard> <20110412165830.GC23764@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110412165830.GC23764@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302629374
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60658
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-12 18:58, hch@infradead.org wrote:
> On Tue, Apr 12, 2011 at 11:31:17PM +1000, Dave Chinner wrote:
>> I don't think so. e.g. in the XFS allocation path we do btree block
>> readahead, then go do the real work. The real work can end up with a
>> deeper stack before blocking on locks or completions unrelated to
>> the readahead, leading to schedule() being called and an unplug
>> being issued at that point.  You might think it contrived, but if
>> you can't provide a guarantee that it can't happen then I have to
>> assume it will happen.
> 
> In addition to the stack issue, which is a killer to this also has
> latency implications.  Before we could submit a synchronous metadata
> read request inside readpage or writepage and kick it off to the disk
> immediately, while now it won't get submitted until we block the next
> time, i.e. have done some more work that could have been used for
> doing I/O in the background.  With the kblockd offload not only have
> we spent more time but at the point where we finally kick it we
> also need another context switch.  It seem like we really need to
> go through the filesystems and explicitly flush the plugging queue
> for such cases.  In fact a bio flag marking things as synchronous
> metadata reads would help, but then again we need to clean up our
> existing bio flags first..

I think it would be a good idea to audit the SYNC cases, and if feasible
let that retain the 'immediate kick off' logic. If not, have some way to
signal that at least. Essentially allow some fine grained control of
what goes into the plug and what does not.

-- 
Jens Axboe

