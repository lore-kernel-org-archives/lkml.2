Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab2AEUqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:46:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:46424 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab2AEUqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:46:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92833111"
From: "Moore, Robert" <robert.moore@intel.com>
To: Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>
Subject: RE: [PATCH v2 4/4] toshiba_acpi: Add blacklist for models with
 hotkey problems
Thread-Topic: [PATCH v2 4/4] toshiba_acpi: Add blacklist for models with
 hotkey problems
Thread-Index: AQHMykrx6e2dclWZuE2ZaiXTpmxihpX+oJmAgAAScgD//4140A==
Date: Thu, 5 Jan 2012 20:46:43 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E3256C799D@ORSMSX101.amr.corp.intel.com>
References: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
 <1325617358-8286-5-git-send-email-seth.forshee@canonical.com>
 <20120105182627.GE24242@srcf.ucam.org>
 <20120105193228.GB25386@ubuntu-macmini>
In-Reply-To: <20120105193228.GB25386@ubuntu-macmini>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My only guess is that Windows is more permissive about this sort of
> thing than ACPICA is, but by my reading of the spec throwing a fatal
> error is what's supposed to happen.

If it is true that Windows will execute this code without error, then ACPICA should be changed to match the Windows behavior. ACPICA is now a "Windows compatible" implementation of ACPI, but that of course means we are attempting to be compatible with a black box ACPI implementation. On the other hand, it may be the case that Windows never executes this code, so the error is not seen on Windows.

We would like to investigate this further. Please send or point me to the acpidump for this machine.

Thanks,
Bob

> -----Original Message-----
> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
> owner@vger.kernel.org] On Behalf Of Seth Forshee
> Sent: Thursday, January 05, 2012 11:32 AM
> To: Matthew Garrett
> Cc: Len Brown; Azael Avalos; Thomas Renninger; platform-driver-
> x86@vger.kernel.org; linux-acpi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v2 4/4] toshiba_acpi: Add blacklist for models with
> hotkey problems
> 
> On Thu, Jan 05, 2012 at 06:26:27PM +0000, Matthew Garrett wrote:
> > On Tue, Jan 03, 2012 at 01:02:38PM -0600, Seth Forshee wrote:
> > > Several Satellite models have a buggy implementation of the INFO
> method
> > > that causes ACPI exceptions when executed:
> > >
> > >  ACPI Error: Result stack is empty! State=ffff88012d70f800
> (20110413/dswstate-98)
> > >  ACPI Exception: AE_AML_NO_RETURN_VALUE, Missing or null operand
> (20110413/dsutils-646)
> > >  ACPI Exception: AE_AML_NO_RETURN_VALUE, While creating Arg 0
> (20110413/dsutils-763)
> > >  ACPI Error: Method parse/execution failed [\_SB_.VALZ.GETE] (Node
> ffff880131175eb0), AE_AML_NO_RETURN_VALUE (20110413/psparse-536)
> > >  ACPI Error: Method parse/execution failed [\_SB_.VALZ.INFO] (Node
> ffff880131175ed8), AE_AML_NO_RETURN_VALUE (20110413/psparse-536)
> > >  toshiba_acpi: ACPI INFO method execution failed
> > >  toshiba_acpi: Failed to query hotkey event
> >
> > Ugh, in several ways. The hotkeys on these machines are presumably
> > supposed to work - do we have any idea what we should be doing?
> 
> Here's a run-down of why this happens. First, the relevant sections of
> the DSDT:
> 
>     Name (EVCD, Package (0x64) {})
>     Name (EVCT, 0x00)
> 
>     Method (PUTE, 1, Serialized)
>     {
>         <snip>
> 
>         If (LLess (EVCT, 0x64))
>         {
>             Store (Arg0, Index (EVCD, EVCT))
>             Increment (EVCT)
>         }
> 
> 	<snip>
> 
>         Notify (VALZ, 0x80)
>         Sleep (0x64)
>         Return (0x00)
>     }
> 
>     Method (GETE, 0, Serialized)
>     {
>         <snip>
> 
>         If (LEqual (EVCT, 0x00))
>         {
>             Release (MUEV)
>             Return (0x00)
>         }
> 
>         Store (DerefOf (Index (EVCD, 0x00)), Local0)
>         Store (0x00, Local1)
>         While (LLess (Local1, Subtract (0x64, 0x01)))
>         {
>             Store (DerefOf (Index (EVCD, Add (Local1, 0x01))), Index (
>                 EVCD, Local1))
>             Increment (Local1)
>         }
> 
>         Decrement (EVCT)
>         Release (MUEV)
>         If (LNotEqual (EVCT, 0x00))
>         {
>             And (HKEV, 0x02, Local0)
>             If (LEqual (Local0, 0x02))
>             {
>                 Return (0x00)
>             }
> 
>             Notify (VALZ, 0x80)
>             Sleep (0x64)
>         }
> 
>         Return (Local0)
>     }
> 
>     Method (INFO, 0, Serialized)
>     {
>         Store (GETE (), Local0)
>         Return (Local0)
>     }
> 
> So EVCD is a queue of events, and EVCT is the number of events in the
> queue. NTFY calls PUTE, which puts an event in the queue. INFO calls
> GETE to read an event from the queue. Reading an event consists of
> copying out the first object out of EVCD, then copying each subsequent
> object to the previous element in EVCD. Inefficient, but it should
> work.
> 
> Except for that fact that EVCD will initially contain uninitialized
> objects. So until/unless PUTE writes every element in EVCD that copy
> loop is going to dereference unintialized objects, which causes the
> exceptions.
> 
> GETE/PUTE are the only methods which write to EVCD, so there's not some
> initialization method or something like that which we're forgetting to
> call. We could do something like call PUTE 64 times during
> initialization, but that's relying on a BIOS implementation detail
> which
> just seems like a bad idea.
> 
> My only guess is that Windows is more permissive about this sort of
> thing than ACPICA is, but by my reading of the spec throwing a fatal
> error is what's supposed to happen.
> 
> Also a side note of interest: The machines that suffer from this all
> also have a WMI interface with code to support hotkeys, and that code
> shouldn't suffer from this problem. Unfortunately these models are the
> only ones I've seen with this WMI interface, and the code to generate
> the hotkey events isn't executed if the OS reports itself as Vista or
> newer.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
