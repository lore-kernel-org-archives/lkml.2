Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab0ERTRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:17:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59294 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab0ERTRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:17:16 -0400
Date: Tue, 18 May 2010 21:18:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Joe Perches <joe@perches.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       "Young, Brent" <brent.young@intel.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100518191802.GG25224@aftab>
References: <4BF18995.6070008@redhat.com>
 <4BF2392A.9040409@jp.fujitsu.com>
 <4BF2C3D1.10009@redhat.com>
 <1274204560.17703.82.camel@Joe-Laptop.home>
 <20100518185305.GA23921@elte.hu>
 <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>
Date: Tue, May 18, 2010 at 03:08:58PM -0400

> > It makes sense to use the kernel's performance events 
> > logging framework when we are logging events about how the 
> > system performs.
> 
> Perhaps it makes more sense to say that the Linux "performance
> events logging framework" has become more generic and is really
> now an "event logging framework".

Yep, that's the idea.

> > Furthermore it's NMI safe, offers structured logging, has 
> > various streaming, multiplexing and filtering capabilities 
> > that come handy for RAS purposes and more.
> 
> Those of us present at the mini-summit were not familiar with
> all the features available. One area of concern was how to be
> sure that something is in fact listening to and logging the
> error events.  My understanding is that if there is no process
> attached to an event, the kernel will just drop it.  This is
> of particular concern because the kernel's first scan of the
> machine check banks occurs before there are any processes.
> So errors found early in boot (which might be saved fatal
> errors from before the boot) might be lost.

Well, we have a trace_mce_record tracepoint in the mcheck code which
calls all the necessary callbacks when an mcheck occurs. For the time
being, the idea is to use the mce.c ring buffer for early mchecks and
copy them to the regular ftrace per-cpu buffer after the last has been
initialized. Later, we could switch to a another early bootmem buffer if
there's need to.

Also, we want to have a userspace daemon that reads out the mces from
the trace buffer and does further processing like thresholding etc in
userspace.

Concerning critical errors, there we bypass the perf subsystem and
execute the smallest amount of code possible while trying to shutdown
gracefully if the error type allows that.

These are the rough ideas at least...

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
