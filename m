Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2ADRoC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:44:02 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44523 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab2ADRn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:43:59 -0500
MIME-Version: 1.0
In-Reply-To: <4F048905.5060004@lwfinger.net>
References: <4f034b6c.ypfAbSdXSgMHtfqa%Larry.Finger@lwfinger.net>
 <CALSq=BaJSURcKU8RkCxxG=Mht4y04dVefKMESuHmiEdhwzc2Eg@mail.gmail.com> <4F048905.5060004@lwfinger.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 4 Jan 2012 09:43:37 -0800
Message-ID: <CALSq=BYvjtTxwRCKJ1BTJkyd6vHiUwHFSZ669wWisd_b50yB9Q@mail.gmail.com>
Subject: Re: [PATCH] rtl8192cu: Fix WARNING on suspend/resume
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, chaoming_li@realsil.com.cn,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 9:14 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 01/04/2012 10:16 AM, Daniel Halperin wrote:
>>
>> Sorry, Larry, I didn't see this til it was included in John's mail this
>> morning.
>>
>> On Tue, Jan 3, 2012 at 10:39 AM, Larry Finger<Larry.Finger@lwfinger.net>
>>  wrote:
>>>
>>>
>>> +#ifdef CONFIG_PM
>>> +static int rtl8192cu_usb_suspend(struct usb_interface *pusb_intf,
>>> +                                pm_message_t message)
>>> +{
>>> +       /* Increase usage_count to Save loaded fw across suspend/resume
>>> */
>>> +       atomic_inc(&usage_count);
>>> +       return 0;
>>> +}
>>> +
>>> +static int rtl8192cu_usb_resume(struct usb_interface *pusb_intf)
>>> +{
>>> +       atomic_dec(&usage_count);       /* after resume, decrease usage
>>> count */
>>> +       return 0;
>>> +}
>>> +#endif
>>
>>
>> Based on the warning-fix I submitted yesterday, this probably produces
>> a warning if CONFIG_PM is set but not CONFIG_PM_SLEEP. My patch was
>> for an ethernet driver, but iwlwifi and ath5k appear to follow the
>> same pattern using CONFIG_PM_SLEEP instead of the above.
>>
>> See: http://www.spinics.net/lists/netdev/msg184717.html for the patch
>> and http://www.spinics.net/lists/netdev/msg184715.html for the
>> discussion.
>
>
> Thanks for the note. I will prepare a revised patch.
>
> What architecture gave the warning? Of x86_64, I was unable to get
> CONFIG_PM_SLEEP without CONFIG_PM.
>

x86-64. I realized that I actually explained this problem rather
clearly when I fixed it for iwlwifi 5 months ago. :)
https://github.com/mirrors/linux/commit/f090fba305658fe6e464e2fbd25fad81957ece26

"""
CC [M]  drivers/net/wireless/iwlwifi/iwl-pci.o
  drivers/net/wireless/iwlwifi/iwl-pci.c:506: warning:
‘iwl_pci_suspend’ defined but not used
  drivers/net/wireless/iwlwifi/iwl-pci.c:519: warning:
‘iwl_pci_resume’ defined but not used

These are only used if CONFIG_PM_SLEEP is enabled. CONFIG_PM depends
(CONFIG_PM_SLEEP || CONFIG_PM_RUNTIME), so it can be set without
CONFIG_PM_SLEEP selected.
"""

Dan
