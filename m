Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1FVKB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:01:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42028 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1FVKB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:01:56 -0400
MIME-Version: 1.0
In-Reply-To: <1308699521-20556-4-git-send-email-per.forlin@linaro.org>
References: <1308699521-20556-1-git-send-email-per.forlin@linaro.org>
	<1308699521-20556-4-git-send-email-per.forlin@linaro.org>
Date: Wed, 22 Jun 2011 12:01:56 +0200
Message-ID: <BANLkTikU_gToOwzVrb3jUpJX9-XucLsNoQ@mail.gmail.com>
Subject: Re: [PATCH v7 03/11] mmci: implement pre_req() and post_req()
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Venkatraman S <svenkatr@ti.com>,
        Nickolay Nickolaev <nicknickolaev@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 June 2011 01:38, Per Forlin <per.forlin@linaro.org> wrote:
> pre_req() runs dma_map_sg() and prepares the dma descriptor
> for the next mmc data transfer. post_req() runs dma_unmap_sg.
> If not calling pre_req() before mmci_request(), mmci_request()
> will prepare the cache and dma just like it did it before.
> It is optional to use pre_req() and post_req() for mmci.
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> ---
>  drivers/mmc/host/mmci.c |  146 ++++++++++++++++++++++++++++++++++++++++++----
>  drivers/mmc/host/mmci.h |    8 +++
>  2 files changed, 141 insertions(+), 13 deletions(-)
>
...
> @@ -1005,6 +1123,8 @@ static int __devinit mmci_probe(struct amba_device *dev,
>        host->gpio_cd = -ENOSYS;
>        host->gpio_cd_irq = -1;
>
> +       host->next_data.cookie = 1;
> +
Doesn't compile without DMA_ENGINE. Issue reported by Nickolay.

I simply move the initialization to mmci_dma_setup. I will update in
the next patchset.

@@ -215,6 +215,9 @@ static void __devinit mmci_dma_setup(struct mmci_host *host)
+       /* initialize pre request cookie */
+       host->next_data.cookie = 1;
+
@@ -1121,8 +1124,6 @@ static int __devinit mmci_probe(struct amba_device *dev,
-       host->next_data.cookie = 1;
