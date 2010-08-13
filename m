Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979Ab0HMSPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 14:15:46 -0400
Received: from smtp-out.google.com ([74.125.121.35]:58986 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab0HMSPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 14:15:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=x4mZFJA3QV25RF9f7mAU0qg5QIzG3Ma5/fye/XOBxdvHb0+L7spX6E/d+CHYI27HJ
	Z4sTL4T5xyOuwKcv9ALVg==
MIME-Version: 1.0
In-Reply-To: <20100813115424.GA24737@infradead.org>
References: <4C58C528.4000606@tuxonice.net>
	<4C5960B0.7020003@teksavvy.com>
	<4C59DA16.4020500@tuxonice.net>
	<AANLkTik_PH-7T7OFtzaCtPbAHE6pqnYMUsjP25KtsRnR@mail.gmail.com>
	<4C5A59FC.1030304@tuxonice.net>
	<AANLkTi=NMHkKduZzsLiiYt3=w8++8epb5aGrqv7V3-vB@mail.gmail.com>
	<4C5B925A.5000409@tuxonice.net>
	<AANLkTinU24v6Mty54YL3gv3M5S+4jdN5vHD54KknchAG@mail.gmail.com>
	<20100813115424.GA24737@infradead.org>
Date: Fri, 13 Aug 2010 11:15:38 -0700
Message-ID: <AANLkTik5osZR12nZVVvJY7LimiUZtBdZcnDi4VYNXhwr@mail.gmail.com>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't used!
From: Hugh Dickins <hughd@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nigel Cunningham <nigel@tuxonice.net>, Mark Lord <kernel@teksavvy.com>,
        LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 4:54 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Aug 06, 2010 at 03:07:25PM -0700, Hugh Dickins wrote:
>> If REQ_SOFTBARRIER means that the device is still free to reorder a
>> write, which was issued after discard completion was reported, before
>> the discard (so later discarding the data written), then certainly I
>> agree with Christoph (now Cc'ed) that the REQ_HARDBARRIER is
>> unavoidable there; but if not, then it's not needed for the swap case.
>>  I hope to gain a little more enlightenment on such barriers shortly.
>
> REQ_SOFTBARRIER is indeed purely a reordering barrier inside the block
> elevator.
>
>> What does seem over the top to me, is for mm/swapfile.c's
>> blkdev_issue_discard()s to be asking for both BLKDEV_IFL_WAIT and
>> BLKDEV_IFL_BARRIER: those swap discards were originally written just
>> to use barriers, without needing to wait for completion in there.  I'd
>> be interested to hear if cutting out the BLKDEV_IFL_WAITs makes the
>> swap discards behave acceptably again for you - but understand that
>> you won't have a chance to try that until later next week.
>
> That does indeed look incorrect to me.  Any kind of explicit waits
> usually mean the caller provides ordering.  Getting rid of
> BLKDEV_IFL_BARRIER in the swap code ASAP would indeed be beneficial
> given that we are trying to get rid of hard barriers completely soon.
> Auditing the existing blkdev_issue_discard callers in filesystems
> is high on the todo list for me.

Yes.

Above I was suggesting for Nigel to experiment with cutting out swap
discard's BLKDEV_IFL_WAITs - and the results of cutting those out but
leaving its BLKDEV_IFL_BARRIERs would still be interesting.  But after
digesting the LSF discussion and the email thread that led up to it, I
came to the same conclusion as you, that going forward we want to keep
its BLKDEV_IFL_WAITs (swapfile.c already provides all the other
synchronization for that to fit into - things like never freeing swap
while its still under writeback) and simply remove its
BLKDEV_IFL_BARRIERs.

However, I am still not quite sure that we can already make that
change for 2.6.35 (-stable).  Can you reassure me on the question I
raise above: if we issue a discard to a device with cache, wait for
"completion", then issue a write into the area spanned by that
discard, can we be certain that the write to backing store will not be
reordered before the discard of backing store (unless the device is
just broken)?  Without a  REQ_HARDBARRIER in the 2.6.35 scheme?  It
seems a very reasonable assumption to me, but I'm learning not to
depend upon reasonable assumptions here.  (By the way, it doesn't
matter at all whether writes not spanned by the discard pass it or
not.)

Hugh
