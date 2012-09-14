Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2INOzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:55:32 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:18803 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2INOz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:55:29 -0400
Message-ID: <1347634143.14107.30.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Enable SCI_EMULATE to manually simulate physical
 hotplug testing.
From: Toshi Kani <toshi.kani@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>
Date: Fri, 14 Sep 2012 08:49:03 -0600
In-Reply-To: <CAE9FiQWYSJmCUfjET8UdWHfhbDP45xMdZ+_pd212u_esbsYVhg@mail.gmail.com>
References: <1346707623-31476-1-git-send-email-yinghai@kernel.org>
	 <1346776024.4732.196.camel@misato.fc.hp.com>
	 <CAE9FiQXN1kDwSPTH5UWvDPbrtqGgcEKR4dWwYrP57H4aSA-UMA@mail.gmail.com>
	 <1346794495.4732.221.camel@misato.fc.hp.com>
	 <1347582132.3569.13.camel@misato.fc.hp.com>
	 <CAE9FiQWYSJmCUfjET8UdWHfhbDP45xMdZ+_pd212u_esbsYVhg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 20:50 -0700, Yinghai Lu wrote:
> On Thu, Sep 13, 2012 at 5:22 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> >> > >> +
> >> > >> +     /*
> >> > >> +      * Check for internal object and make sure there is a handler
> >> > >> +      * registered for this object
> >> > >> +      */
> >> > >> +     obj_desc = acpi_ns_get_attached_object(node);
> >> > >> +     if (obj_desc) {
> >> > >> +             if (obj_desc->common_notify.notify_list[0]) {
> >> > >
> >> > > Is the above check necessary?  acpi_ev_queue_notify_request() sets up to
> >> > > call the global handler, acpi_gbl_global_notify[0], even if the object
> >> > > does not have a local handler registered.
> >> >
> >> > Not sure.
> >> >
> >> > maybe Len or other acpi guyes could answer your questions.
> >>
> >> I think this check should be removed, but would like someone to
> >> verify...
> >
> >
> > Hi Yinghai,
> >
> > Attached is my suggested update to your patch. It allows a SCI to be
> > sent to any object, and therefore can be used for testing the global
> > notify handler. Some drivers such as dock.c only register their handler
> > to the global notify handler. I also made a few minor changes. I have
> > been testing with this update and it is working fine. I like this
> > feature, so I hope we can make progress with this update.
> 
> len, can you check them?

Len and others can double check, but let me explain why this update is
necessary. acpi_ev_queue_notify_request() has the following internal
procedure and checks.

1. Call acpi_ev_is_notify_object() to make sure that notify is allowed
on the target object.

2. Get a proper list ID to notify_list[] for the notify value. Your
patch hardcodes this ID as 0, which is not correct.

3. Check if the target object has global handler or local handler
registered. Technically, your patch can copy this code to fix it.
However, I do not recommend copying such code since it is ACPICA
internal code and should not be exposed to drivers. ACPICA update can
break such code. Hence, I deleted the check from your patch.

4. If all checks passed, call acpi_ev_notify_dispatch() with the notify
request.

Feel free to add my sign-off when you update the patch. I take the
responsibility for the update.
Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

