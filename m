Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801Ab2LGMQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 07:16:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37149 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab2LGMQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 07:16:35 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVPH=yw_Y3AcnTXUqVd5A0yGiw+hju8__-g7dymAe-Q8dA@mail.gmail.com>
References: <20120524021429.GB12557@kroah.com>
	<Pine.LNX.4.44L0.1205241029260.1349-100000@iolanthe.rowland.org>
	<CACVXFVPu_nbVCVR_HTt9H764+4JKC3=GPyhsf8Lpsch4Fa=xqQ@mail.gmail.com>
	<CANeycqo8sFVeWVEeW3mdPPVRt35+kfkdUzenLB+YgNs4y-T7Cg@mail.gmail.com>
	<CACVXFVPbpbb-PAJAweoLj8uec=KgoUKvybSey+R=L=oY16Ozbw@mail.gmail.com>
	<CANeycqq177AzPdYfBr-VU+ksh+Jwd9i4aLpZo6VwxcO+Xx6ETg@mail.gmail.com>
	<CACVXFVPH=yw_Y3AcnTXUqVd5A0yGiw+hju8__-g7dymAe-Q8dA@mail.gmail.com>
Date: Fri, 7 Dec 2012 04:16:34 -0800
Message-ID: <CANeycqqO06+u6Qy3zL=G_a=_sTYDOzUYf8wu7B7RGFJfuGNoRg@mail.gmail.com>
Subject: Re: Race condition between driver_probe_device and device_shutdown
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Because device_del() will put reference count of the parent, and the patch
> only focuses on race between probe/release and shutdown.

Right. device_del() puts the reference count of the parent -- is it
guaranteed that device_del() won't ever reassign dev->parent though
(e.g., to NULL)? I don't think it is, so I think that patch should
also save the pointer to the parent and use it (instead of what
happens to be in than dev->parent) to release the lock and put the
ref.

> As far as device_move() concerned, looks it might be a problem.
> The problem even exits on driver attach vs. device open/release,
> if device_move is called in open() and open() happens before driver
> attach completes.

Yeah, the pattern of locking the parent followed by the device occurs
in a few places. It looks like they were added by Alan with commit
bf74ad5bc41727d5f2f1c6bedb2c1fac394de731. (And as Greg mentioned,
might be occurring often enough to merit being moved into a common
function.)

I guess the question is whether the callee is allowed to call
device_move(), if not, we're good.

> Your concern on device_remove() might be correct. Also, I am wondering
> if we can walk the 'dpm_list' backwards for device shutdown, which should
> be simpler and more reasonable.

How would that help?
