Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab2EWU2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:28:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:41978 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab2EWU2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:28:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170531762"
From: "Drews, Paul" <paul.drews@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Benjamin Tissoires (benjamin.tissoires@gmail.com)" 
	<benjamin.tissoires@gmail.com>
Subject: Re: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
Thread-Topic: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
Thread-Index: Ac05IhC3V5BUIYenTRO57OH9QmQHHg==
Date: Wed, 23 May 2012 20:27:38 +0000
Message-ID: <6008DE3C35C7C04D85C2A4C813D36515481E68E2@ORSMSX101.amr.corp.intel.com>
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

Hi Benjamin,

> Hi Paul,
> 
> On Fri, May 18, 2012 at 11:14 PM, Drews, Paul <paul.drews@intel.com> wrote:
> >
> >
> >> -----Original Message-----
> >> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> >> owner@vger.kernel.org] On Behalf Of Benjamin Tissoires
> >> Sent: Wednesday, May 09, 2012 12:04 PM
> >> To: Henrik Rydberg
> >> Cc: Dmitry Torokhov; Jiri Kosina; Stephane Chatty; linux-
> input@vger.kernel.org;
> >> linux-kernel@vger.kernel.org
> >> Subject: Re: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
> >>
...
> > If this is the case, how about avoiding storing all the slot-field values
> > and just detecting the point of repetition to use the most-recently-seen
> > usage value as the last-slot-field marker.  I have been successfully using
> > the patch below based on this notion.  It took the failure rate from about
> > 1-per-10 boots to 250+ boots with no failures on an Atmel MaXTouch.
> > I don't have others to try it with, including the "buggy" one that led
> > to all this trouble in the first place.
> 
> Thank you very much for this patch. However, Jiri already applied mine
> with the allocation/free mechanism.
> 
> You're idea is good but it has one big problem with Win8 devices:
> As we can have 2 X and 2 Y per touch report, if these dual-X reporting
> or dual-Y reporting is present in the report, we will stop at the
> second X or the second Y seen, which will lead to a buggy touchscreen
> (the first touch won't get it's second coordinate). However, without
> this particularity, the patch would have worked ;-)
> 
> If the Win8 norm has came earlier, the initial implementation that
> relies on the collection would have suffice, but some hardware makers
> made a bad use of it, leading us to stop using this, and relying on a
> more brutal approach.

Oops.  Didn't know about that.  If the first item is duplicated somewhere
in the sequence, that's a fatal problem for my approach.

> > +static void update_last_slot_field(struct hid_usage *usage,
> > +               struct mt_device *td)
> >  {
> > -       if (!test_bit(usage->hid, hi->input->absbit))
> > -               td->last_slot_field = usage->hid;
> > +       if (!td->last_slot_field_found) {
> > +               if (td->first_slot_field_found) {
> > +                       if (td->last_slot_field == usage->hid)
> 
> I'm sure you wanted to put here:
>                        if (td->first_slot_field == usage->hid)
> 
> Cheers,
> Benjamin

Good catch.  And as you point out, irrelevant since your patch is in
linux-next already.  I tested your commit 3ac36d1 from there with
a 3.4 (final) kernel on a Atmel MaXTouch Digitizer tablet and it is
working fine.
