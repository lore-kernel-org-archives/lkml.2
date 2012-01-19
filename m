Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab2ASSVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 13:21:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14385 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2ASSVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 13:21:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 19 Jan 2012 10:21:45 -0800
From: Rakesh Iyer <riyer@nvidia.com>
To: Shubhrajyoti <shubhrajyoti@ti.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 19 Jan 2012 10:21:43 -0800
Subject: RE: [PATCH v1] Input: tegra-kbc - enable key interrupt for wakeup
Thread-Topic: [PATCH v1] Input: tegra-kbc - enable key interrupt for wakeup
Thread-Index: AczWbduJ2tEr7EpWSeaTpEhCsAWrwgAZ5KTQ
Message-ID: <1FC56210173BB445BD77F608D6FB8D034F401D296F@HQMAIL03.nvidia.com>
References: <1326925981-14723-1-git-send-email-riyer@nvidia.com>
 <4F17AE75.6000605@ti.com>
In-Reply-To: <4F17AE75.6000605@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	if (device_may_wakeup(&pdev->dev)) {
>  		disable_irq_wake(kbc->irq);
>  		tegra_kbc_setup_wakekeys(kbc, false);
> +		/* We will use fifo interrupts for key detection. */
> +		tegra_kbc_set_keypress_interrupt(kbc, false);
Why do yo disable on resume why not have it enabled always?

>  
>  		/* Restore the resident time of continuous polling mode. */
>  		writel(kbc->cp_to_wkup_dly, kbc->mmio + KBC_TO_CNT_0);

For the relevant discussion, Tegra KBC provides the following interrupts - 
a) The keypress interrupt which is generated as soon as a key is pressed, 
      before matrix scanning begins.
b) FIFO interrupt which is generated when actual keys are decoded from the matrix, 
     and put into the FIFO. 

During normal operation the keypress interrupt is not useful as we have to wait for the 
keys to make it into the FIFO before reporting it to the higher layers.

Since we have turned off scanning(in the following commit) we cannot use the FIFO interrupt 
during the resume, so we rely on the keypress interrupt and generate the wakeup key.

Commit that turned off scanning

    Input: tegra-kbc - fix wakeup from suspend

    For wakeup to be reliable, kbc needs to be in interrupt mode before suspend.
    Created common routine to control the FIFO interrupt.
    Added synchronization to ensure orderly suspend.


Regards
Rakesh
