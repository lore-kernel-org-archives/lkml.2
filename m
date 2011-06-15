Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1FORju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:39:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33223 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1FORjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z0Lm1yYnJ6rqrfp1SkptR3c6A+50qCR+2i0HuhafzUvE3wMNkG7Gf1W4xz3A7ceYQa
         wrToCBf2QNNppMZIt9RVt9+FDKk3EdPIfKr64jbEb0kMMa+QPGA2OGxHeWk154F7Ro1f
         YBYW1GDK8h3KkVYSe/mWpJt3ah5SzuLu0KR5g=
Message-ID: <4DF8EE62.3060407@gmail.com>
Date: Wed, 15 Jun 2011 19:39:46 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: device plugged into xhci port not detected after a resume
References: <4DF85A1F.1080001@gmail.com> <20110615165842.GB5382@xanatos>
In-Reply-To: <20110615165842.GB5382@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 15-06-11 18:58, Sarah Sharp schreef:
> On Wed, Jun 15, 2011 at 09:07:11AM +0200, Maarten Lankhorst wrote:
>> I plugged a simple usb mouse in xhci that isn't found after a resume.
>>
>> It's with the same lovely controller as I used with the previous bug.
>> Plugging in the controller to the same port doesn't cause it to be
>> detected again, I need to remodprobe xhci-hcd
> I will have to look at the log closely to be sure that this isn't a
> software issue, but it seems like the host controller just died after
> being suspended.
>
>
>> [  505.821216] xhci_hcd 0000:04:00.0: Queueing ctrl tx for slot id 1, ep 0
> ...
>> [  510.805001] xhci_hcd 0000:04:00.0: Cancel URB ffff8801c7a0ae40
> The xHCI driver submits a control transfer (probably to read the
> descriptor from your mouse) and the host doesn't give it back.  It times
> out, so the xHCI driver issues a Stop Endpoint command to allow the
> driver to take the control transfer off the endpoint ring.
>
>> [  515.794819] xhci_hcd 0000:04:00.0: xHCI host not responding to stop endpoint command.
> But the host doesn't respond to that command, so the xHCI driver assumes
> the hardware is hosed:
>
>> [  515.794823] xhci_hcd 0000:04:00.0: Assuming host is dying, halting host.
>> [  515.794830] xhci_hcd 0000:04:00.0: // Halt the HC
>> [  515.794840] xhci_hcd 0000:04:00.0: Killing URBs for slot ID 1, ep index 0
>> [  515.794847] xhci_hcd 0000:04:00.0: Killing URBs for slot ID 1, ep index 2
>> [  515.794850] xhci_hcd 0000:04:00.0: Killing URBs for slot ID 1, ep index 4
>> [  515.794854] xhci_hcd 0000:04:00.0: Calling usb_hc_died()
>> [  515.794856] xhci_hcd 0000:04:00.0: HC died; cleaning up
>> [  515.794860] xhci_hcd 0000:04:00.0: xHCI host controller is dead.
> Does the host controller work when you don't have any devices plugged
> in during resume?  I.e. unplug the mouse and then re-plug it in on
> resume.  Does suspend work when other devices are left plugged in?
>
> Does hibernate work, either with no devices plugged in, or the mouse
> plugged in?  If it does work, the host controller may not be able to
> handle the context save and restore during suspend/resume, and we may
> need to unconditionally tell the USB core that the host lost power
> across suspend.
Yeah, manually overriding the resume function works. Tested with

-	if ((temp & STS_SRE) || hibernated) {
+	if ((temp & STS_SRE) || hibernated || 1) {

~Maarten

