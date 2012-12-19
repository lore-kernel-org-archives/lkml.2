Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2LSRiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:38:12 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54944 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2LSRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:38:07 -0500
Message-ID: <50D1FB7B.4090002@wwwdotorg.org>
Date: Wed, 19 Dec 2012 10:38:03 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: tegra: Using devm API for memory allocation
References: <1355811683-29981-1-git-send-email-vbyravarasu@nvidia.com> <50D09AC7.9050503@wwwdotorg.org> <D958900912E20642BCBC71664EFECE3E6E19E0BFC4@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E19E0BFC4@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 10:38 PM, Venu Byravarasu wrote:
>> -----Original Message-----
>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
>> Sent: Tuesday, December 18, 2012 10:03 PM
>> To: Venu Byravarasu
>> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-
>> kernel@vger.kernel.org; linux-usb@vger.kernel.org
>> Subject: Re: [PATCH] usb: phy: tegra: Using devm API for memory allocation
>>
>> On 12/17/2012 11:21 PM, Venu Byravarasu wrote:
>>> Using devm_kzalloc for allocating memory needed for PHY
>>> pointer and hence removing kfree calls to PHY pointer.
>>
>> Since the kfree() here used to be in tegra_usb_phy_close() rather than
>> any remove() function, does it actually make sense to use
>> devm_kzalloc(); would plain using kzalloc() instead, and not removing
>> the kfree() calls, be better?
>>
>  
> Stephen,
> As you mentioned I can replace kmalloc with kzalloc in the original code 
> and push an updated patch.
> However, I just wanted to understand if there exists any issue
> in using devm_kzalloc instead of kzalloc?

devm_* are intended for objects allocated during probe(), and free()d
during remove(). The object you're allocating here isn't that case.

Now, once you convert the Tegra PHY driver to be a true device, perhaps
this object will be allocated/freed during probe/remove, so the devm_
functions will be useful then?

The problem this may cause is a memory leak. Consider the Tegra EHCI and
PHY drivers being built as modules, the PHY driver module being inserted
and never removed, yet the EHCI driver being continually inserted and
removed. Since the PHY is never removed, the memory allocated by its
devm_kzalloc() call is never freed, but it's continually re-allocated
since tegra_usb_phy_open() is called whenever the EHCI driver module is
inserted. You need the explicit kfree() to avoid that, and since you're
kfree()ing somewhere other than remove(), using devm_* to make the
allocation isn't appropriate.
