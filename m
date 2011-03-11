Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1CKMbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:31:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52002 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab1CKMbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:31:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: andy.green@linaro.org
Subject: Re: RFC: Platform data for onboard USB assets
Date: Fri, 11 Mar 2011 13:31:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <4D79F068.2080009@linaro.org>
In-Reply-To: <4D79F068.2080009@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111331.13932.arnd@arndb.de>
X-Provags-ID: V02:K0:v6fKKEYUVLPb0ppd0GhErVyjDCBTZfvF4d/srN4J9iX
 NfEfapAcczVbtt/QOqYaS3tlceoQtEQWZ10RRONd5nM1s+vfqT
 FSZ53rcK/165qtsHFaRMxrDxHWj2D0UMbZfBZoXRohuys7CNZ9
 q6/lJKIynWSZ0MOK1LwKj0N8cPHHrfYmJ5B7M4DlwKe+ARvyt7
 c9OdwuZYTCzLAiMq75sBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Friday 11 March 2011, Andy Green wrote:
> 
> platform_data is a well established way in Linux to pass configuration 
> data up to on-board assets from a machine file like mach-xyz.c.  It's 
> also supported to pass platform_data up to devices that are probed 
> asynchronously from busses like i2c as well, which is very handy.
> 
> However AFAIK it's not possible to bind platform_data to probed USB 
> devices as it stands.
> 
> There are now boards which have on-board USB assets, for example OMAP4 
> Panda which has a USB <-> Ethernet bridge wired up permanently.  It'd be 
> convenient to also be able to pass optional platform_data to these 
> devices when they are asynchronously probed.

Sorry, but I think it's a bad idea to use platform data for this.
USB is a bus that we can reasonably probe, while we use platform_data
only for stuff that we can by definition not probe at all.

> The particular use that suggested this is on Panda, it would be ideal to 
> be able to set a flag in the usb device's platform data that forces it 
> to be named eth%d since it's a hardwired asset on the board with an RJ45 
> socket.

I understand the problem, but IMHO there really needs to be a better
solution for this. As far as I understand, the underlying problem is
that USB ethernet devices with a proper MAC address get a different
device name from devices with a generated random MAC address, and
the people that designed this board were trying to save a few cents
by not allocating a MAC address for the ethernet device [1], right?

I believe we should fix this particular problem locally, instead of
coming up with generic infrastructure for broken hardware.

One relatively easy solution would be to allow passing a MAC address
to this particular device driver as a module parameter, and generating
a fixed MAC address in the regular vendor space when installing the
boot loader. That would also solve the problem that a DHCP server
currently assigns a new IP address to a panda board at every boot.

	Arnd
---
[1] https://bugs.launchpad.net/linux-linaro/+bug/622429
