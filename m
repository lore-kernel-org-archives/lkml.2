Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966861Ab0GSVgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:36:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65058 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966832Ab0GSVgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:36:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CsFU8j0aDTE0HY8XmA4KMQahNouE797Y7k1VPCp/a9raaLRUFMcagTV2FDAPYXJP9w
         BUJIfoZ1E0cWOMu25xA9nt0Ksx1g1NGtJN5m98ONdVeY5MA04bEwyZZPU34+HQNiY5t6
         ZM4zLwWvXJcbBLbslqlJkP7dO9L32n4fzrXPk=
MIME-Version: 1.0
In-Reply-To: <AANLkTinqKHCYeGTLuTtKikcR2IA8TY0vy2tSznxLay0N@mail.gmail.com>
References: <1277770577-11024-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimYqUZvxaWVvT5FPsW36NTpqLLCqCiSuRAy_ER5@mail.gmail.com>
	<AANLkTinqKHCYeGTLuTtKikcR2IA8TY0vy2tSznxLay0N@mail.gmail.com>
Date: Mon, 19 Jul 2010 14:36:16 -0700
X-Google-Sender-Auth: ZuZYDlxd2GcA_BK43VF-xcGvV6w
Message-ID: <AANLkTimHBWMYAeFrET2EpeA8KogcUmQldAHM_uhSv-gt@mail.gmail.com>
Subject: Re: [PATCH 1/3] DMAENGINE: generic slave channel control
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        vinod.koul@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 4:11 PM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> Ping on this subject, I have the PL08x driver depending on this
> so if it's not OK I have to rewrite that patch soonish.
>
> Also the DMA for PrimeCells use it so I would like to respin that
> patch series using this generic control if it is accepted.
>
> As mentions something like this will be needed for us anyway,
> so in case it's not OK I'll likely go for more or less the same
> struct, just that it is for DMA40 and its clients solely, then on
> top of that a PrimeCell interface more or less redefining the
> same things again or wrapping it.
>

I think it looks ok, I just want to get one other dmaslave driver
author to nod that dma_slave_config has the right amount of fields.  I
initially put too much into dma_async_tx_descriptor.  I'll take this
as is if we don't get feedback, but that would remove my hesitation.

The recently submitted intel_mid driver [1] seems to have a similar structure:

+/**
+ * struct intel_mid_dma_slave - DMA slave structure
+ *
+ * @dma_dev: DMA master client
+ * @tx_reg: physical address of data register used for
+ *     memory-to-peripheral transfers
+ * @rx_reg: physical address of data register used for
+ *     peripheral-to-memory transfers
+ * @tx_width: tx register width
+ * @rx_width: rx register width
+ * @dirn: DMA trf direction
+
+ * @cfg_hi: Platform-specific initializer for the CFG_HI register
+ * @cfg_lo: Platform-specific initializer for the CFG_LO register
+
+ * @ tx_width: width of src and dstn
+ * @ hs_mode: SW or HW handskaking mode
+ * @ cfg_mode: Mode configuration, DMA mem to mem to dev & mem
+ */
+struct intel_mid_dma_slave {
+       enum dma_data_direction         dirn;
+       enum intel_mid_dma_width        src_width; /*width of DMA src txn*/
+       enum intel_mid_dma_width        dst_width; /*width of DMA dst txn*/
+       enum intel_mid_dma_hs_mode      hs_mode;  /*handshaking*/
+       enum intel_mid_dma_mode         cfg_mode; /*mode configuration*/
+       enum intel_mid_dma_msize        src_msize; /*size if src burst*/
+       enum intel_mid_dma_msize        dst_msize; /*size of dst burst*/
+       dma_async_tx_callback           callback; /*callback function*/
+       void                            *callback_param; /*param for callback*/
+       unsigned int            device_instance; /*0, 1 for periphral instance*/
+};
+

Vinod, would you consider switching to dma_slave_config [2] for this
information, or at a minimum wrapping dma_slave_config with your
intel_mid specific fields?

--
Dan

[1]: http://marc.info/?l=linux-kernel&m=127687775404278&w=2
[2]: http://marc.info/?l=linux-kernel&m=127777055428648&w=2
