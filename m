Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab2C0RHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 13:07:02 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42627 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab2C0RHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:07:00 -0400
Date: Tue, 27 Mar 2012 19:06:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] EDAC: Convert AMD EDAC pieces to use RAS printk
 buffer
Message-ID: <20120327170655.GB7937@aftab>
References: <1331040694-12558-1-git-send-email-bp@amd64.org>
 <1331040694-12558-4-git-send-email-bp@amd64.org>
 <4F563067.1090100@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F15B61916@ORSMSX103.amr.corp.intel.com>
 <20120312162646.GB7255@aftab>
 <3908561D78D1C84285E8C5FCA982C28F15B61A1F@ORSMSX103.amr.corp.intel.com>
 <20120312180359.GA8214@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312180359.GA8214@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 07:03:59PM +0100, Borislav Petkov wrote:
> On Mon, Mar 12, 2012 at 04:59:37PM +0000, Luck, Tony wrote:
> > > Sounds better, especially the close-on-exit part. Please elaborate on
> > > the races...
> > 
> > Errors are happening asynchronously to everything. Race looks like:
> > 
> > Daemon exits (or is killed)
> >    <<<< race begins here
> > kernel close routine called
> > close routine updates your global variable
> >    <<<< race ends here
> 
> Well, in that case, we're going to miss logging a single error, or log
> it incomplete.
> 
> Unless, we make the global variable atomic and make the daemon zero it
> as the first action it does when it starts going away. If it is killed,
> then we probably need some sanity-checking functionality which checks
> periodically whether the daemon is still alive ...
> 
> This probably needs more meditation.

Ok, hm, how about we add a timer which runs for a safe period of say...
a couple of minutes after the error has been logged into the buffer.

Before it expires we expect that the userspace daemon comes in and
consumes the information - we test explicitly whether it wrote to some
file - or implicitly by checking whether the buffer got emptied in the
meantime (the exact method is still TBD).

In any case, if during the safe period of time we haven't received
confirmation from userspace that the item has been consumed, we switch
irreversibly back to the kernel log buffer and reissue the decoded info
through printk.

This way we

* don't introduce a device file with a ->close

* remain races-agnostic: either the timeout has happened and userspace
hasn't consumed the decoded data or it worked just fine and we continue
on with our marry error collection.

If other errors happen while the timer is running, we log them as usual
and restart the timer to give the newest error an equal chance. Error
size shouldn't overflow the buffer because we're reserving 4 pages per
CPU currently and this can easily be enlarged...

Hmm, thoughts..?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
