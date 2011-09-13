Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab1IMVDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:03:24 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:38479 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691Ab1IMVDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:03:22 -0400
X-ASG-Debug-ID: 1315947800-01de285e7b538d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E6FC514.7070401@fusionio.com>
Date: Tue, 13 Sep 2011 23:03:16 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Eric Seppanen <eds@reric.net>
CC: Christoph Hellwig <hch@infradead.org>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
Subject: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
References: <22A973199D2C2F46933448F6E7990A3002C80026@ntxboimbx31.micron.com> <4E44E782.7090309@fusionio.com> <2A9BE4FF6209B644B6F8EB62DE6AEA1E07663ED4@ntxfrembx01.micron.com> <20110909085433.GA9593@infradead.org> <20110913124906.GA17855@infradead.org> <CAJqx+goSvc75q0gr3AkG3RqXi5_rUCuy+igx9+EZBFvyZLj39A@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
In-Reply-To: <CAJqx+goSvc75q0gr3AkG3RqXi5_rUCuy+igx9+EZBFvyZLj39A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1315947800
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.74438
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-13 18:46, Eric Seppanen wrote:
> On Tue, Sep 13, 2011 at 5:49 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> Btw, there is another _huge_ issue with the driver, and that is the
>> lack of any internal queueing.  Remember the make_request interface is
>> an extremly thin layer (or rather the lack of it) below the filesystem.
>>
>> So for example if eh_active is non-zero you return -EBUSY to the
>> filesystems.  That's an error code it a) doesn't recognize and b)
>> couldn't handle even if it did.  Similarly mtip_hw_get_scatterlist
>> simply blocks if no tag is currently available instead of queueing
>> it up.
> 
> Just out of curiosity, why is blocking on no-tag-available a bad
> thing?  How is it any different than the blocking that will occur when
> a request queue is full?  When the hardware queue depth is bigger than
> that of a request queue, what extra benefit does queuing give?

The blocking for a free tag is fine, the actual implementation is
definitely not optimal (using a rw semaphore with count initialized to
the tag depth, ugh). You'll need to block for a free tag in any case, or
add a thread to restart things on a free tag. The thread would not help
performance.

But the -EBUSY is definitely a bug, that needs to be a waiting condition
as well.

-- 
Jens Axboe

