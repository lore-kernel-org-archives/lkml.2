Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab2JDKbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:31:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:16372 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2JDKbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:31:37 -0400
X-IronPort-AV: E=Sophos;i="4.80,533,1344211200"; 
   d="scan'208";a="210269354"
Message-ID: <506D6587.7010100@citrix.com>
Date: Thu, 4 Oct 2012 11:31:35 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/6] xen-blkfront: handle backend CLOSED without
 CLOSING
References: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com> <1348243464-15903-3-git-send-email-david.vrabel@citrix.com> <5061EFB2.1080407@citrix.com> <506D7D9A020000780009F9C8@nat28.tlf.novell.com>
In-Reply-To: <506D7D9A020000780009F9C8@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/12 11:14, Jan Beulich wrote:
>>>> On 25.09.12 at 19:53, David Vrabel <david.vrabel@citrix.com> wrote:
>> @@ -1167,7 +1168,8 @@ blkfront_closing(struct blkfront_info *info)
>>  
>>  	mutex_lock(&bdev->bd_mutex);
>>  
>> -	if (bdev->bd_openers) {
>> +	/* If the backend is already CLOSED, close now. */
>> +	if (bdev->bd_openers && backend_state != XenbusStateClosed) {
>>  		xenbus_dev_error(xbdev, -EBUSY,
>>  				 "Device in use; refusing to close");
>>  		xenbus_switch_state(xbdev, XenbusStateClosing);
> 
> This looks wrong to me on a second glance: As long as there
> are users of the device, I don't think we want to go into Closed
> ourselves, irrespective of the backend state.

Any users of the frontend device are screwed either way, as the backend
is gone.  It seems sensible to handle this case the same as (e.g.,) a
physical unplug of a USB storage device.  Removing the device and
forcing all outstanding I/O to fail immediately rather than lingering in
the rings, going nowhere.

David
