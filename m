Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424289Ab2LGDmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 22:42:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41654 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424226Ab2LGDmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 22:42:50 -0500
MIME-Version: 1.0
In-Reply-To: <CANeycqq177AzPdYfBr-VU+ksh+Jwd9i4aLpZo6VwxcO+Xx6ETg@mail.gmail.com>
References: <20120524021429.GB12557@kroah.com>
	<Pine.LNX.4.44L0.1205241029260.1349-100000@iolanthe.rowland.org>
	<CACVXFVPu_nbVCVR_HTt9H764+4JKC3=GPyhsf8Lpsch4Fa=xqQ@mail.gmail.com>
	<CANeycqo8sFVeWVEeW3mdPPVRt35+kfkdUzenLB+YgNs4y-T7Cg@mail.gmail.com>
	<CACVXFVPbpbb-PAJAweoLj8uec=KgoUKvybSey+R=L=oY16Ozbw@mail.gmail.com>
	<CANeycqq177AzPdYfBr-VU+ksh+Jwd9i4aLpZo6VwxcO+Xx6ETg@mail.gmail.com>
Date: Fri, 7 Dec 2012 11:42:47 +0800
Message-ID: <CACVXFVPH=yw_Y3AcnTXUqVd5A0yGiw+hju8__-g7dymAe-Q8dA@mail.gmail.com>
Subject: Re: Race condition between driver_probe_device and device_shutdown
From: Ming Lei <ming.lei@canonical.com>
To: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 8:09 AM, Wedson Almeida Filho <wedsonaf@gmail.com> wrote:
> I don't have the setup anymore, I'll give it a shot if I ever get back it back.
>
> I have a question though: why do we need to get a reference to the
> parent? If the assumption is that the callee can release its reference

Because device_del() will put reference count of the parent, and the patch
only focuses on race between probe/release and shutdown.

> to the parent, then one may also expect callees to reassign
> dev->parent (e.g., by calling device_move), so it wouldn't be safe to
> later call device_unlock on the potentially different dev->parent.

As far as device_move() concerned, looks it might be a problem.
The problem even exits on driver attach vs. device open/release,
if device_move is called in open() and open() happens before driver
attach completes.

> If we expect dev->parent to remain unchanged, then there's no need to
> get an extra reference to the parent as the device itself already
> holds one (and we hold an extra one on the device).

As I said above, device_del() will put reference count of parent, but I forget
why the parent's lock has to be held in this patch.

> What am I missing?

Your concern on device_remove() might be correct. Also, I am wondering
if we can walk the 'dpm_list' backwards for device shutdown, which should
be simpler and more reasonable.


Thanks,
--
Ming Lei
