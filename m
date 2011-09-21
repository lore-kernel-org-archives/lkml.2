Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1IUKtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:49:35 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60318 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab1IUKte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:49:34 -0400
Date: Wed, 21 Sep 2011 12:49:36 +0200
From: Borislav Petkov <bp@amd64.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andi Kleen <ak@linux.intel.com>, Corey Minyard <minyard@acm.org>,
        Jack Steiner <steiner@sgi.com>, Alan Cox <alan@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [V5][PATCH 3/6] x86, nmi: wire up NMI handlers to new routines
Message-ID: <20110921104935.GA2451@gere.osrc.amd.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
 <1316529792-6560-4-git-send-email-dzickus@redhat.com>
 <4E797913.5050906@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E797913.5050906@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Tony.

On Wed, Sep 21, 2011 at 01:41:39PM +0800, Huang Ying wrote:
> On 09/20/2011 10:43 PM, Don Zickus wrote:
> > Just convert all the files that have an nmi handler to the new routines.
> > Most of it is straight forward conversion.  A couple of places needed some
> > tweaking like kgdb which separates the debug notifier from the nmi handler
> > and mce removes a call to notify_die (as I couldn't figure out why it was
> > there).
> 
> It is used to call a debugger on a machine check, according to following
> thread:
> 
> https://lkml.org/lkml/2010/5/27/114

Thanks for digging that out - I couldn't find anywhere in the git logs
why was this added in the first place.

> So maybe we can turn that into a kgdb direct call?

After reading the thread, the semi-legitimate usage of using it as
a jump into the debugger just because some hardware reports certain
conditions through an MCE sounds pretty hacky to me.

Besides, if the driver developer needs that, he can add the code for the
duration of her/his development cycle as aid, and remove it in the end.

This early-exit deal is especially inacceptable if you get an
uncorrectable error and some notifier call in the chain consumes it and
we never get to report it or decode it, or do recovery action. And thus
the box merrily continues on although a corruption just happened and we
didn't even get a chance to panic.

So I really really want to remove it, actually.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
