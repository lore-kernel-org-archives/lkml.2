Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab2EXOhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:37:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54190 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932686Ab2EXOhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:37:41 -0400
Date: Thu, 24 May 2012 10:37:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@linuxfoundation.org>
cc: Ming Lei <ming.lei@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Subject: Re: Race condition between =?utf-8?Q?drive?=
 =?utf-8?Q?r=5Fprobe=5Fdevice_and_device=5Fshutdown=E2=80=8F?=
In-Reply-To: <20120524021429.GB12557@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1205241029260.1349-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Greg KH wrote:

> On Thu, May 24, 2012 at 09:39:46AM +0800, Ming Lei wrote:
> > On Wed, May 23, 2012 at 11:06 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > On Wed, 23 May 2012, Ming Lei wrote:
> > >> The .shutdown callback pointer is got from device->driver, which is
> > >> changed in probe and release path. Also runtime PM thing has been
> > >> involved into shutting down recently, so looks not only hardware parts
> > >> are involved now.
> > >
> > > This is a tricky question.  Overall I think you're probably right.
> > >
> > > It's certainly true that holding the device lock across the shutdown
> > > callback is the easiest and most reliable way to prevent these races.
> > 
> > But holding device lock across .shutdown is very inefficient because
> > most of devices' driver have not shutdown callback, so I think it is better

The code there is racy already.  It does:

		} else if (dev->driver && dev->driver->shutdown) {

without any locking protection.  If the driver is unbound while this 
statement runs then dev->driver could be non-NULL for the first test 
and NULL for the second.

> > to fix the race by prevent driver core from probing or releasing once
> > shutdown is started.
> > 
> > How about the below patch?
> 
> How about waiting for the original poster to respond as to exactly how
> they are hitting this race before doing anything?

In addition, the patch is too complicated.  For this type of
synchronization you should use SRCU.  See
Documentation/RCU/whatisRCU.txt and related files.

Alan Stern

