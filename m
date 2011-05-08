Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1EHMfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 08:35:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35457 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab1EHMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 08:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=MKHgtSwO+9TJo+T5d3s9LHBxWFvPvQBWNjqqfVON3lhWxvZx9TMJdubl3FZDv7kMx/
         h9aPrnSoFUjyUpSDKOeho3ydhuf/GHpD/lU/UHmvwBsMdH+TtshctiZ1vVuKD2sKEz9m
         Fd3dt3Mw060/AQM+dSiCJvW7RDMTJ8qGuUWsc=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 8 May 2011 08:35:32 -0400
X-Google-Sender-Auth: AWVDrlGC7u5VBHd_z8pZ-KqdY5M
Message-ID: <BANLkTinWna2sDDjbNC5xyGX3ELROs=Wd0w@mail.gmail.com>
Subject: [RFC] Controlling the ThinkPad battery charger
To: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've figured out how the ThinkPad SMAPI charge control works (at least
well enough to program thresholds on some models), and I'd like to get
this functionality into mainline.  (This is inspired by, and borrows
magic numbers from, tp_smapi, but it has no code at all from tp_smapi
and therefore shouldn't have the lack-of-authorship issue.)  My
question is: what's the best way to expose this functionality?

Currently, I have a little driver (not yet in mergeable shape) that
creates a platform device and sticks some sysfs attributes in it
depending on which thresholds it can figure out how to program.  It's
here:

https://gitorious.org/linux-test-utils/tp_charge/blobs/master/kmod/tp_charge.c

I'd like to find a better way, though.  Some quick Googling suggests
that some Vaio laptops can do this, but I'm afraid that all my laptops
are ThinkPads.  Two ideas:

1. Integrate this with thinkpad_acpi and keep exposing it as a
thinkpad-specific thing (device?  new class_device?) in sysfs.

2. Integrate it with power_supply.

I like option 2 better, since it means that a userspace tool (like
GNOME) could learn how to operate a battery charge controller once and
then other laptops and devices could reuse the same interface.  The
problem is that the ACPI battery driver can't see the charge control.
So either it would need a hook to allow per-vendor control like this
or the power_supply class would need to recognize separate charge
controllers.

I have no intention of creating a kitchen sink like tp_smapi.  But I
might want to add things like forced discharge or outright disabling
of charging.  On possible added complication: on ThinkPads, the charge
thresholds stay in effect until reprogrammed or until the battery is
removed, even if the computer is off.

Any thoughts?  I've never touched the driver model before.

--Andy
