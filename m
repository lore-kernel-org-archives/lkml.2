Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab0JFQOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:14:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:58500 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab0JFQOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:14:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,290,1283756400"; 
   d="scan'208";a="613992113"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Wed, 6 Oct 2010 09:14:07 -0700
Subject: RE: [PATCH 1/5] ACPI: Allow handlers to be installed at the same
 time as methods
Thread-Topic: [PATCH 1/5] ACPI: Allow handlers to be installed at the same
 time as methods
Thread-Index: Actk480LGqAOQNwkTxysB8CftbIFAwAikY+Q
Message-ID: <4911F71203A09E4D9981D27F9D830858B4893B89@orsmsx503.amr.corp.intel.com>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com>
 <1286216549-5438-2-git-send-email-mjg@redhat.com>
 <201010060118.50875.rjw@sisk.pl>
In-Reply-To: <201010060118.50875.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>In fact, what we need to handle is the case in which a GPE is pointed to by
>a _PRW method somewhere and we presume that it's necessary to execute
>Notify() for it regardless of whether or not it has a method, right?



Although there exists a single Windows document mentions this behavior as a windows "feature", I'm not 100% convinced that this is actually true. AFAIK, we've never seen a machine that depends on an "implicit notify" on a device when a wake GPE happens.

That being said, we should probably think about how to implement this if and when it becomes a requirement.

It appears to me that the biggest issue right now is the fact that a Notify() must be performed on a Device object, and the problem is how to associate the GPE with the device object.

In the past, when ACPICA was executing the _PRW methods during initialization, it would have been simple to detect the condition where a _PRW method referenced a GPE that had no GPE method -- and then make an association of the _PRW device with the GPE for use later to generate an implicit notify.

Now that ACPICA no longer executes the _PRW methods, there are two pieces of information that it no longer has:

1) It does not know which GPEs can be used to wake the system. The new GPE model allows the host to tell ACPICA about these GPEs as they are discovered during the _PRW method execution phase.

2) It has no knowledge of which devices are associated with the wake GPEs.

Perhaps we should add some ability for the host to inform ACPICA of the device object associated with the _PRW (in addition to the actual GPE).

Bob



>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>Sent: Tuesday, October 05, 2010 4:19 PM
>To: Matthew Garrett
>Cc: linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
>pci@vger.kernel.org; Moore, Robert
>Subject: Re: [PATCH 1/5] ACPI: Allow handlers to be installed at the same
>time as methods
>
>On Monday, October 04, 2010, Matthew Garrett wrote:
>> There are circumstances under which it may be desirable for GPE handlers
>> to be installable without displacing the existing GPE method. Add support
>> for this via a boolean argument to acpi_install_gpe_handler, and fix up
>the
>> existing users to ensure that their behaviour doesn't change.
>
>Hmm.  I'm not sure this is the best way to do that.
>
>In fact, what we need to handle is the case in which a GPE is pointed to by
>a _PRW method somewhere and we presume that it's necessary to execute
>Notify() for it regardless of whether or not it has a method, right?
>
>So, this GPE will have ACPI_GPE_CAN_WAKE, so can we just put something like
>
>if (gpe_event_info->flags & ACPI_GPE_CAN_WAKE)
>         execute Notify()
>
>somewhere around the switch statement in acpi_ev_gpe_dispatch()?
>
>Or perhaps replace acpi_ev_asynch_enable_gpe() with something that will
>execute Notify() and then do what the original acpi_ev_asynch_enable_gpe()
>does?
>
>That should be easier to implement after the changes we've been discussing
>with
>Bob recently (basically, handle both GPE handlers and _Lxx/_Exx
>analogously).
>
>Rafael
