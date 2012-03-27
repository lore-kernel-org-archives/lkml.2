Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2C0TLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 15:11:20 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43371 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2C0TLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 15:11:17 -0400
Date: Tue, 27 Mar 2012 21:11:12 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] EDAC: Convert AMD EDAC pieces to use RAS printk
 buffer
Message-ID: <20120327191112.GA11587@aftab>
References: <1331040694-12558-1-git-send-email-bp@amd64.org>
 <1331040694-12558-4-git-send-email-bp@amd64.org>
 <4F563067.1090100@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F15B61916@ORSMSX103.amr.corp.intel.com>
 <20120312162646.GB7255@aftab>
 <3908561D78D1C84285E8C5FCA982C28F15B61A1F@ORSMSX103.amr.corp.intel.com>
 <20120312180359.GA8214@aftab>
 <20120327170655.GB7937@aftab>
 <3908561D78D1C84285E8C5FCA982C28F15B72395@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F15B72395@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 06:35:37PM +0000, Luck, Tony wrote:
> > In any case, if during the safe period of time we haven't received
> > confirmation from userspace that the item has been consumed, we switch
> > irreversibly back to the kernel log buffer and reissue the decoded info
> > through printk.
> 
> I'm not sure I like irreversible things.
> 
> Here's the life cycle:
> 
> 1) System boots ... we have a window during this time where there is
>    no daemon (or any user space at all).
> 
> 2) Daemon gets started from /etc/init.d or systemd script
> 
> 3) (optional) New version of daemon installed in update (old daemon is terminated, new one starts).
> 
> 4) System is shutdown - all daemons terminated
> 
> 5) System actually halts.
> 
> 
> So we clearly have some gaps where there isn't a daemon.  Most of them should
> be pretty short ... but I worry about the gap from #1 to #2 - which can be pretty
> long if we need to fsck some disks (or we on some crazy big system that takes
> many minutes just to find and spin-up all the disks).

Well, currenty we queue MCEs for later consumption before the decoder
chains have been registered etc: 0937195715713. We probably could delay
the draining of the buffer until we have userspace and daemon running.

Problems with this is that buffer size is limited: 32 struct mce's and
it can overflow pretty fast on a b0rked system which spews a lot of MCEs
during boot.

We probably could provide for enlarging that when needed as a Kconfig or
a boot option using early memblock allocations or whatever...

Then, after maybe a configurable period of uptime (it should be chosen
to be safe for most systems out there and the others could configure in
a higher timeout if they need to) we start spewing out decoded MCEs into
dmesg unless a daemon has drained the buffers before that.

Or something to that effect...

Concerning the irreversibility, we could probably teach the code to stop
printk'ing MCEs if the daemon has been restarted in the meantime...

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
