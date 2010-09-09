Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0IIUwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 16:52:23 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49402 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0IIUwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 16:52:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6100"; a="53936134"
Message-ID: <4C894903.1050909@codeaurora.org>
Date: Thu, 09 Sep 2010 14:52:19 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Sundar <sunder.svit@gmail.com>
CC: khali@linux-fr.org, ben-linux@fluff.org, srinidhi.kasagar@stericsson.com,
        tsoni@codeaurora.org, linus.walleij@stericsson.com,
        linux-arm-msm@vger.kernel.org, arve@android.com, swetland@google.com,
        sdharia@codeaurora.com, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Crane Cai <crane.cai@amd.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3] i2c: QUP based bus driver for Qualcomm MSM chipsets
References: <1283907557-1874-1-git-send-email-kheitke@codeaurora.org> <AANLkTimHQ=ag5z+SKbGrm5BD-eF+xcDuKp4R_=4tf3cP@mail.gmail.com>
In-Reply-To: <AANLkTimHQ=ag5z+SKbGrm5BD-eF+xcDuKp4R_=4tf3cP@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sundar wrote:
> Hi Kenneth,
> 
> just some error codes and leaks if I am right :)
> 
> On Wed, Sep 8, 2010 at 6:29 AM, Kenneth Heitke <kheitke@codeaurora.org> wrote:
>> +
>> +static int __devinit
>> +qup_i2c_probe(struct platform_device *pdev)
>> +{
>> +
>> +       qup_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>> +                                               "qup_phys_addr");
>> +       if (!qup_mem) {
>> +               dev_err(&pdev->dev, "no qup mem resource?\n");
>> +               return -ENODEV;
> 
> I think this should be -ENXIO instead of -ENODEV?
> 
>> +       gsbi_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>> +                                               "gsbi_qup_i2c_addr");
>> +       if (!gsbi_mem) {
>> +               dev_err(&pdev->dev, "no gsbi mem resource?\n");
>> +               return -ENODEV;
> 
> Ditto here.
> 
>> +       in_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
>> +                                               "qup_in_intr");
>> +
>> +       out_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
>> +                                               "qup_out_intr");
>> +
>> +       err_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
>> +                                               "qup_err_intr");
>> +       if (!err_irq) {
>> +               dev_err(&pdev->dev, "no error irq resource?\n");
>> +               return -ENODEV;
>> +       }
> 
> All the same here too?
> 
>> +
>> +       qup_io = devm_request_mem_region(&pdev->dev, qup_mem->start,
>> +                       resource_size(qup_mem), pdev->name);
>> +       if (!qup_io) {
>> +               dev_err(&pdev->dev, "QUP region already claimed\n");
>> +               return -EBUSY;
>> +       }
>> +
>> +       gsbi_io = devm_request_mem_region(&pdev->dev, gsbi_mem->start,
>> +                       resource_size(gsbi_mem), pdev->name);
>> +       if (!gsbi_io) {
>> +               dev_err(&pdev->dev, "GSBI region already claimed\n");
>> +               return -EBUSY;
>> +       }
>> +
>> +       dev = devm_kzalloc(&pdev->dev, sizeof(struct qup_i2c_dev), GFP_KERNEL);
> 
> [..]
> 
>> +       if (!dev->base)
>> +               return -ENOMEM;
> 
> Missing *_kzfree whilst returning?
> 
>> +       dev->gsbi = devm_ioremap(&pdev->dev,
>> +                       gsbi_mem->start, resource_size(gsbi_mem));
>> +       if (!dev->gsbi)
>> +               return -ENOMEM;
>> +
>> +       clk = clk_get(&pdev->dev, "qup_clk");
>> +       if (IS_ERR(clk)) {
>> +               dev_err(&pdev->dev, "Could not get clock\n");
>> +               ret = PTR_ERR(clk);
>> +               goto err_clk_get_failed;
> 
> Will not the devm_iounmap be needed here?
> 
> Thanx!
> Sundar
> 

Hopefully no leaks since I am using the devm_ calls.  The resources 
should be freed up automatically on device release and if the probe 
function fails.  Please let me know if this assumption is not correct.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
