Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0IITB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:01:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58610 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab0IITBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZvMpfS2Wrv8vGA+NhaSGwdi3DU54E/G6bOt3H8e6kBSZnPzJjRZDvtjs2qIcD38u3w
         isV7bbCSj4ce8AW45vv1SHCew8i3kseXokdSOxFPtQomEQzjs6qUXUCH35tOJroZRXzz
         5qUuB6KEr3syzMts07AYyXBgCeiDKSzAyL+yE=
MIME-Version: 1.0
In-Reply-To: <1283907557-1874-1-git-send-email-kheitke@codeaurora.org>
References: <1283907557-1874-1-git-send-email-kheitke@codeaurora.org>
Date: Fri, 10 Sep 2010 00:31:52 +0530
Message-ID: <AANLkTimHQ=ag5z+SKbGrm5BD-eF+xcDuKp4R_=4tf3cP@mail.gmail.com>
Subject: Re: [PATCH v3] i2c: QUP based bus driver for Qualcomm MSM chipsets
From: Sundar <sunder.svit@gmail.com>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: khali@linux-fr.org, ben-linux@fluff.org, srinidhi.kasagar@stericsson.com,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenneth,

just some error codes and leaks if I am right :)

On Wed, Sep 8, 2010 at 6:29 AM, Kenneth Heitke <kheitke@codeaurora.org> wrote:
> +
> +static int __devinit
> +qup_i2c_probe(struct platform_device *pdev)
> +{
> +
> +       qup_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +                                               "qup_phys_addr");
> +       if (!qup_mem) {
> +               dev_err(&pdev->dev, "no qup mem resource?\n");
> +               return -ENODEV;

I think this should be -ENXIO instead of -ENODEV?

> +       gsbi_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +                                               "gsbi_qup_i2c_addr");
> +       if (!gsbi_mem) {
> +               dev_err(&pdev->dev, "no gsbi mem resource?\n");
> +               return -ENODEV;

Ditto here.

> +       in_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
> +                                               "qup_in_intr");
> +
> +       out_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
> +                                               "qup_out_intr");
> +
> +       err_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
> +                                               "qup_err_intr");
> +       if (!err_irq) {
> +               dev_err(&pdev->dev, "no error irq resource?\n");
> +               return -ENODEV;
> +       }

All the same here too?

> +
> +       qup_io = devm_request_mem_region(&pdev->dev, qup_mem->start,
> +                       resource_size(qup_mem), pdev->name);
> +       if (!qup_io) {
> +               dev_err(&pdev->dev, "QUP region already claimed\n");
> +               return -EBUSY;
> +       }
> +
> +       gsbi_io = devm_request_mem_region(&pdev->dev, gsbi_mem->start,
> +                       resource_size(gsbi_mem), pdev->name);
> +       if (!gsbi_io) {
> +               dev_err(&pdev->dev, "GSBI region already claimed\n");
> +               return -EBUSY;
> +       }
> +
> +       dev = devm_kzalloc(&pdev->dev, sizeof(struct qup_i2c_dev), GFP_KERNEL);

[..]

> +       if (!dev->base)
> +               return -ENOMEM;

Missing *_kzfree whilst returning?

> +       dev->gsbi = devm_ioremap(&pdev->dev,
> +                       gsbi_mem->start, resource_size(gsbi_mem));
> +       if (!dev->gsbi)
> +               return -ENOMEM;
> +
> +       clk = clk_get(&pdev->dev, "qup_clk");
> +       if (IS_ERR(clk)) {
> +               dev_err(&pdev->dev, "Could not get clock\n");
> +               ret = PTR_ERR(clk);
> +               goto err_clk_get_failed;

Will not the devm_iounmap be needed here?

Thanx!
Sundar
