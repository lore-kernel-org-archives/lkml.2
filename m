Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab2BBX7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:59:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45363 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab2BBX7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:59:32 -0500
Message-ID: <4F2B235E.9040004@gmail.com>
Date: Thu, 02 Feb 2012 16:59:26 -0700
From: Tim Gardner <rtg.canonical@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Tim Gardner <tim.gardner@canonical.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix PCI probe error path orphaned memory
References: <1328215686-126550-1-git-send-email-tim.gardner@canonical.com> <4F2B1BB7.6020608@lwfinger.net>
In-Reply-To: <4F2B1BB7.6020608@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 04:26 PM, Larry Finger wrote:
> On 02/02/2012 02:48 PM, Tim Gardner wrote:
>> Memory allocated by ieee80211_alloc_hw() will get orphaned
>> if any subsequent initializations fail.
>>
>> Also don't pci_set_drvdata(pdev, NULL) until just before disabling
>> the PCI device. Functions called by rtl_deinit_core(hw) may eventually
>> need
>> the context (when its actually implemented).
>>
>> Cc: Larry Finger<Larry.Finger@lwfinger.net>
>> Cc: Chaoming Li<chaoming_li@realsil.com.cn>
>> Cc: John W. Linville<linville@tuxdriver.com>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Tim Gardner<tim.gardner@canonical.com>
>> ---
>> drivers/net/wireless/rtlwifi/pci.c | 19 ++++++++++++-------
>> 1 files changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rtlwifi/pci.c
>> b/drivers/net/wireless/rtlwifi/pci.c
>> index 5cb2199..6b18063 100644
>> --- a/drivers/net/wireless/rtlwifi/pci.c
>> +++ b/drivers/net/wireless/rtlwifi/pci.c
>> @@ -1760,8 +1760,8 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
>> if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
>> RT_ASSERT(false,
>> "Unable to obtain 32bit DMA for consistent allocations\n");
>> - pci_disable_device(pdev);
>> - return -ENOMEM;
>> + err = -ENOMEM;
>> + goto fail1;
>
> I would probably added a new label after the ieee80211_free_hw() and
> used it here to avoid the "if (hw)" test, but that is a matter of
> choice. In any case this patch is correct.
>
> ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> Thanks,
>
> Larry
>

Actually, I started doing that but it turned into a huge patch, so I 
just decided to solved the immediate issue (discovered by inspection). 
There are some other setup/teardown nonorthogonalities that need fixing 
first (which I'm pursuing as time allows).

rtg
-- 
Tim Gardner tim.gardner@canonical.com
