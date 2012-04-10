Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2DJQNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:13:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52979 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2DJQN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:13:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120410151042.GH21801@redhat.com>
References: <20120410133708.GE21801@redhat.com> <4F843C17.5050004@kernel.dk>
 <20120410142148.GG21801@redhat.com> <20120410151042.GH21801@redhat.com>
From: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 10 Apr 2012 12:13:07 -0400
X-Google-Sender-Auth: foTUoQ7HVlr2RFEKTjSqaIZgpQc
Message-ID: <CAMM=eLf5qi_PL8vFh_b5V_nq_mxg0CN0asE8E9XYJn48J4mdPA@mail.gmail.com>
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline except SATA
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        martin.petersen@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 11:10 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Apr 10, 2012 at 10:21:48AM -0400, Vivek Goyal wrote:
> > On Tue, Apr 10, 2012 at 03:56:39PM +0200, Jens Axboe wrote:

> > > I think it'd be a lot more sane to just use CFQ on rotational single
> > > devices, and default to deadline on raid or non-rotational devices.
> > > This
> > > still isn't perfect, since less worthy SSDs still benefit from the
> > > read/write separation, and some multi device configs will be faster as
> > > well. But it's better.
> >
> > Hi Jens,
> >
> > Thanks. Taking a decision based on rotational flag makes sense. I am
> > not sure that does one get the information that a block device is a
> > single
> > device or not. Especially with HBAs, SCSI Luns over Fiber, iSCSI Luns
> > etc.
> > I have few Scsi Luns exported to me backed by a storage array.
> > Everything
> > runs CFQ by default. And though disks in the array are rotational, they
> > are RAIDed and AFAIK, this information is not available to driver.
> >
> > I am not sure if there is an easy way to get similar info for dm/md
> > devices.
>
> Thinking more about it, even if we have a way to define a request queue
> flag for multi devices (QUEUE_FLAG_MULTI_DEVICE), when can block layer
> take a decision to change the IO scheduler. At queue alloc and init time
> driver might not have even called add_disk() or set all the
> flags/properties of the queue. So doing it at queue alloc/init time might
> not be best.
>
> And later we get control only when actual IO happens on the queue and
> doing one more check or trying to change elevator in IO path is not a
> good idea.
>
> May be when driver tries to set ROTATIONAL or MULTI_DEVICE flag, we can
> check and change elevator then.
>
> So we are back to the question of can scsi devices find out if a Lun
> is backed by single disk or multiple disks.

I'm not aware of any discrete attribute (comparable to 'rotational'
flag) that SCSI devices will advertise that indicates "I'm a raid
array".

That said, we can have a _very_ good hint that a SCSI device is a raid array if:

1) optimal_io_size is not zero, minimum_io_size is not equal to
optimal_io_size, and optimal_io_size is a multiple of minimum_io_size

2) WCE=0 (higher-end arrays with a writeback cache)

Determining 1 could be enough, we should probably ignore 2 as it isn't
an absolute indication that a device is composed of multiple devices
(especially not if considered independently of 1).

Mike
