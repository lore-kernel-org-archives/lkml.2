Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2IUQPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:15:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46009 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab2IUQPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:15:01 -0400
Message-ID: <505C9282.3050001@wwwdotorg.org>
Date: Fri, 21 Sep 2012 10:14:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3] USB: PHY: Re-organize Tegra USB PHY driver
References: <1348230054-7402-1-git-send-email-vbyravarasu@nvidia.com> <CAAe_U6K2hANpRqzyoiiP2mR97=M2Mb35+FVor11DaaZi7W9Pnw@mail.gmail.com>
In-Reply-To: <CAAe_U6K2hANpRqzyoiiP2mR97=M2Mb35+FVor11DaaZi7W9Pnw@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 07:09 AM, ABRAHAM, KISHON VIJAY wrote:
> Hi,
> 
> On Fri, Sep 21, 2012 at 5:50 PM, Venu Byravarasu <vbyravarasu@nvidia.com> wrote:
>> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
>> In order to support USB PHY drivers on these SoCs, existing
>> PHY driver is split into SoC agnostic common USB PHY driver
>> and Tegra20-specific USB phy driver. This will facilitate
>> easy addition and deletion of phy drivers for Tegra SoCs.

>> @@ -618,6 +618,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
...
>>         pdata = pdev->dev.platform_data;
>>         if (!pdata) {

Some missing lines of context are:

                dev_err(&pdev->dev, "Platform data missing\n");
                return -EINVAL;
        }

...
>> +       params.mode = TEGRA_USB_PHY_MODE_HOST;
>> +       params.config = pdata->phy_config;
> 
> I fail to understand how pdata is not NULL in dt boot. I know i've
> already given this comment and you replied that you dint see any
> crash. But I'd like to know where and how pdata gets populated.

In practice, the platform uses AUXDATA to provide platform data to the
driver even when it's instantiated using device tree; see
arch/arm/mach-tegra/board-dt-tegra20.c variables tegra_ehci*_pdata and
tegra20_auxdata_lookup[].

In the slightly (very very slightly, hopefully) longer term, I would
like to completely remove the AUXDATA setup from board-dt-tegra20.c;
tegra_ehci_probe() should do something like:

pdata = pdev->dev.platform_data
if (!pdata)
    pdata = parse_pdata_from_dt();
/* user didn't specify any in DT either */
if (!pdata)
    pdata = default_pdata_for_port();

... where perhaps the use of defaults could be folded into
parse_pdata_from_dt().
