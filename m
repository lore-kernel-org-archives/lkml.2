Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2EYNIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:08:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34109 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2EYNIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:08:32 -0400
Date: Fri, 25 May 2012 14:08:26 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lantianyu1986@gmail.com
Subject: Re: USB device PM oddity in 3.5
Message-ID: <20120525130826.GA13258@srcf.ucam.org>
References: <20120524203655.GK1143@zod.bos.redhat.com>
 <Pine.LNX.4.44L0.1205241646080.1186-100000@iolanthe.rowland.org>
 <20120525113936.GA23824@zod.bos.redhat.com>
 <4FBF826B.1040101@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBF826B.1040101@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

udev is being a little too aggressive in enabling autosuspend. I've just 
sent a patch upstream, but here it is:

commit 35c62663b93adb6ab321ca1e6ac6f1ba580b37aa
Author: Matthew Garrett <mjg@redhat.com>
Date:   Fri May 25 08:00:05 2012 -0400

    rules: Limit USB autosuspend on USB HID devices
    
    Some USB ports on external hubs may be reported as "fixed". We only want
    to auto-enable this on ports that are internal to the machine, so check
    the parent state as well.

diff --git a/rules/42-usb-hid-pm.rules b/rules/42-usb-hid-pm.rules
index d5d5897..fc44b94 100644
--- a/rules/42-usb-hid-pm.rules
+++ b/rules/42-usb-hid-pm.rules
@@ -46,4 +46,10 @@ ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="04b3", ATTR{idProduct}=="4012
 ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="14dd", ATTR{idProduct}="0002", TEST=="power/control", ATTR{power/control}="auto"
 
 # USB HID devices that are internal to the machine should also be safe to autosuspend
+
+ACTION=="add", SUBSYSTEM=="usb", SUBSYSTEMS=="usb", ATTRS{removable}=="removable", GOTO="usb_hid_pm_end"
+ACTION=="add", SUBSYSTEM=="usb", SUBSYSTEMS=="usb", ATTRS{removable}=="unknown", GOTO="usb_hid_pm_end"        
+
 ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="03", ATTRS{removable}=="fixed", TEST=="../power/control", ATTR{../power/control}="auto"
+
+LABEL="usb_add_pm_end"

-- 
Matthew Garrett | mjg59@srcf.ucam.org
