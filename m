Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1EYUUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:20:23 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46484 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922Ab1EYUUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:20:21 -0400
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
In-Reply-To: <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar>
	 <4DDB8BF6.2000304@fusionio.com>
	 <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty>
	 <4DDCB1C8.7040708@fusionio.com>
	 <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty>
	 <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
	 <4DDD5240.2060308@fusionio.com>
	 <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com>
	 <4DDD55D6.1080909@fusionio.com>
	 <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty>
	 <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 15:20:18 -0500
Message-ID: <1306354818.1641.55.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 13:03 -0700, Linus Torvalds wrote:
> On Wed, May 25, 2011 at 12:52 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> >
> > +static inline int sdev_early_check(struct scsi_device *sdev)
> > +{
> > +       if (!sdev || sdev->sdev_state == SDEV_DEL
> > +               || sdev->sdev_state > SDEV_QUIESCE)
> > +               return -ENXIO;
> > +       return 0;
> > +}
> 
> Can somebody explain why it's those states, and nothing else?

The states are definitely wrong.  QUIESCE shouldn't cause an error.

Can we back up a bit.  I agree with Jens that sdev->request_queue looks
to be NULL, but that *only* happens in the final sdev release, so this
must be a refcounting problem higher up the stack.  Something is holding
an unrefcounted pointer to the sdev.

James


