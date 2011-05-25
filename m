Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab1EYXpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:45:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58733 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957Ab1EYXpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:45:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=iTrBrRg5zvAMNFBa1d7BkqhOINiJ4UJ82unXDWVl1vMSnPiVZUi+EgsEPGYihOLY+R
         BgwcYJOm+GC8h/5cnf3tIpDsuwfYaddEiqu1hX0rzp+2FbY4tEjAI8J018xlJfOv2HRo
         yVyp1SM9aHy67JF5FXU2aayQRkbTP0D8aJ8rY=
Date: Wed, 25 May 2011 19:45:25 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu-natty
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Parag Warudkar <parag.lkml@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
In-Reply-To: <BANLkTik+BDbex5-LTjBzhUXf34WuyM0Jmw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105251922520.1749@ubuntu-natty>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com> <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com> <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty> <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
 <4DDD5240.2060308@fusionio.com> <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com> <4DDD55D6.1080909@fusionio.com> <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty> <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com> <alpine.DEB.2.02.1105251613500.8972@ubuntu-natty>
 <BANLkTimndXcBJ9wwJrcTt3Pf3vaNVUUtwg@mail.gmail.com> <alpine.DEB.2.02.1105251638220.8972@ubuntu-natty> <1306356735.1641.61.camel@mulgrave.site> <BANLkTimuomu=_JuMr7SWrMVvboMX4BX0fA@mail.gmail.com> <BANLkTik+BDbex5-LTjBzhUXf34WuyM0Jmw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 May 2011, Linus Torvalds wrote:

> On Wed, May 25, 2011 at 4:00 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> >
> > It doesn't seem to help. Machine locked up and I was dropped to text
> > console. I could only capture the oops by a camera.
> 
> Hmm. That's a different oops. It is now in scsi_prep_state_check().

Different at top but the call trace upto scsi_set_medium_removal is the 
same.

And since now we are upping the refcnt we keep the request queue around it 
was kind of expected that it won't oops on the request queue.

> 
> At the beginning of it too. You can't see the "Code: " line in the
> pictures, but the only dereference I see there is "sdev" itself being
> NULL. And %cr2 is 0x640, which would seem to agree (the 'sdev'
> structure is absolutely disgustingly big, and sdev->sdev_state is
> indeed at an offset in that region.
> 
> That 'sdev' comes from scsi_prep_fn() doing
> 
>     struct scsi_device *sdev = q->queuedata;
> 
> is that queuedata perhaps cleared even if the queue itself stays
> around due to refcounts?


So now the issue is with scsi_device refcnt?

Parag
