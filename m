Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab2JWWy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:54:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61635 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab2JWWy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:54:26 -0400
MIME-Version: 1.0
In-Reply-To: <1350615088-14562-2-git-send-email-mporter@ti.com>
References: <1350615088-14562-1-git-send-email-mporter@ti.com>
	<1350615088-14562-2-git-send-email-mporter@ti.com>
Date: Tue, 23 Oct 2012 15:54:25 -0700
X-Google-Sender-Auth: I0YxOCtznY6CI2CY9DaYCNF9ncQ
Message-ID: <CAA9_cmdVfbO+T0iSEf4uTPcejx1Mx+aQ5LidYZkJ89dVR=ydXw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] dmaengine: add dma_get_channel_caps()
From: Dan Williams <djbw@fb.com>
To: Matt Porter <mporter@ti.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 7:51 PM, Matt Porter <mporter@ti.com> wrote:
> Add a dmaengine API to retrieve per channel capabilities.
> Currently, only channel ops and SG segment limitations are
> implemented caps.
>
> The API is optionally implemented by drivers and when
> unimplemented will return a NULL pointer. It is intended
> to be executed after a channel has been requested and, if
> the channel is intended to be used with slave SG transfers,
> then it may only be called after dmaengine_slave_config()
> has executed. The slave driver provides parameters such as
> burst size and address width which may be necessary for
> the dmaengine driver to use in order to properly return SG
> segment limit caps.
>
> Suggested-by: Vinod Koul <vinod.koul@intel.com>
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  include/linux/dmaengine.h |   52 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 11d9e25..0181887 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -371,6 +371,38 @@ struct dma_slave_config {
>         unsigned int slave_id;
>  };
>
> +enum dmaengine_apis {
> +       DMAENGINE_MEMCPY        = 0x0001,
> +       DMAENGINE_XOR           = 0x0002,
> +       DMAENGINE_XOR_VAL       = 0x0004,
> +       DMAENGINE_PQ            = 0x0008,
> +       DMAENGINE_PQ_VAL        = 0x0010,
> +       DMAENGINE_MEMSET        = 0x0020,
> +       DMAENGINE_SLAVE         = 0x0040,
> +       DMAENGINE_CYCLIC        = 0x0080,
> +       DMAENGINE_INTERLEAVED   = 0x0100,
> +       DMAENGINE_SG            = 0x0200,
> +};
> +
> +/* struct dmaengine_chan_caps - expose capability of a channel
> + * Note: each channel can have same or different capabilities
> + *
> + * This primarily classifies capabilities into
> + * a) APIs/ops supported
> + * b) channel physical capabilities
> + *
> + * @ops: or'ed api capability
> + * @seg_nr: maximum number of SG segments supported on a SG/SLAVE
> + *         channel (0 for no maximum or not a SG/SLAVE channel)
> + * @seg_len: maximum length of SG segments supported on a SG/SLAVE
> + *          channel (0 for no maximum or not a SG/SLAVE channel)
> + */
> +struct dmaengine_chan_caps {
> +       enum dmaengine_apis ops;
> +       int seg_nr;
> +       int seg_len;
> +};

This makes sense for the potentially dynamic capability properties
that get set after configuration, but why do we need the operation
types here?  They can be retrieved from the parent device.

--
Dan
