Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2LBIHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 03:07:05 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:43708 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2LBIHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 03:07:03 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvpbAA8Lu1BV5qjOPGdsb2JhbABEhUOFI7UiFwMBAQEBODSCHgEBBAE6HCMFCwgDLRkUJQoaLodvCr4FFI06glJhA5YAhXuDU4lt
X-IronPort-AV: E=Sophos;i="4.83,357,1352070000"; 
   d="scan'208";a="240168972"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 2 Dec 2012 09:08:37 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] HID: hid-input: export hidinput_allocation function
Message-ID: <20121202080837.GA1875@polaris.bitmath.org>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
 <1353684694-5723-4-git-send-email-benjamin.tissoires@gmail.com>
 <20121127202150.GA895@polaris.bitmath.org>
 <CAN+gG=HqecBrhdnZtfgxhByhtXf+uGELPHGsbcD9OAj6Gx7odg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=HqecBrhdnZtfgxhByhtXf+uGELPHGsbcD9OAj6Gx7odg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> > I can think of two mechanisms that might be useful in finding a
> > way to achieve this cleanly: a) Let a driver return a value telling
> > whether to change input device, and b) Let a second driver have a go
> > at the same device report. Some return value or state could determine
> > logic in the hid core saying "we are not done with this device, try
> > another driver". Or something. Just not this way, please.
> 
> Hi Henrik,
> 
> ok for the implementation of this patch series, it has to be reworked.
> 
> As for your proposals:
> 
> a) We can not rely on input_mapping because there is a temporal issue:
> we already want to have the new input when we are in input_mapping.
> So, this implies to create a new callback.
> 
> b) This would implies just too much work in hid-core for taking into
> account a special case of one type of devices.

I may look like a special case, but perhaps it is not. Routing
different sensors to different drivers is what we do all the time, but
we call that the device-driver bus model. To fit into that concept, we
would need to split the sensors into separate devices first, then
apply the driver logic onto those devices. Thus, the problem is not
really a driver issue at all, but a bus driver one.

Imagine a partition function that is called before device add, and
which distributes the sensors of a usb device onto a set of hid
devices. We already started small in this direction by introducing
device groups, and this particular problem seems to be one of the
issues that would be resolved by such a construct.

> Here, we have in the same usb interface 2 different type of reports
> coming from different sensors. It's far too different from the usual
> configuration we have with legacy devices: when we have several hid
> drivers handling the same usb device, it was when hardware makers
> split the different sensors in different interfaces. This situation is
> correctly handled in the usb subsystem and the hid layer has only to
> deal with one driver at a time for a specific interface.
> 
> So, in the next series, I propose a new callback ("new_report" -- the
> name is awful, but I can not manage to find another one ATM) which
> will be called before we call input_mapping for a whole report.
> The driver will then have the possibility to:
> - continue normally (default behavior)
> - ask for a new input device
> - skip the entire report

This sounds like a better solution, yes, but the root problem still
remains: do we really want to handle both pen and touch in the same
driver? And do we _have_ to?

> Anyway, Henrik , could you also have a look at patches 7 to 11, they

> have nothing to do with pen support, and I'm sure that you want to say
> something on them too.

Indeed, I will just comment here, saying I do not see why you change
the name of the default. I would prefer it if you resend that set
cleaned up, with the default name unchanged.

Thanks,
Henrik
