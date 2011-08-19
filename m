Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1HSPRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:17:11 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55090 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab1HSPRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:17:08 -0400
MIME-Version: 1.0
In-Reply-To: <1313764105-28437-1-git-send-email-per.forlin@stericsson.com>
References: <1313764105-28437-1-git-send-email-per.forlin@stericsson.com>
Date: Fri, 19 Aug 2011 17:17:07 +0200
Message-ID: <CAJ0pr1_4ib6yvScd0eC=pW+dsbPTyoYnNZGbeLWeiwb9Vdt3ww@mail.gmail.com>
Subject: Re: [PATCH v5] usb: gadget: storage: make FSG_NUM_BUFFERS variable size
From: Per Forlin <per.forlin@linaro.org>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Michal Nazarewicz <mina86@mina86.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2011 16:28, Per Forlin <per.forlin@stericsson.com> wrote:
> From: Per Forlin <per.forlin@linaro.org>
>
> FSG_NUM_BUFFERS is set to 2 as default.
> Usually 2 buffers are enough to establish a good buffering pipeline.
> The number may be increased in order to compensate a for bursty VFS
> behaviour.
>
> Here follows a description of system that may require more than
> 2 buffers.
>  * CPU ondemand governor active
>  * latency cost for wake up and/or frequency change
>  * DMA for IO
>
> Use case description.
>  * Data transfer from MMC via VFS to USB.
>  * DMA shuffles data from MMC and to USB.
>  * The CPU wakes up every now and then to pass data in and out from VFS,
>   which cause the bursty VFS behaviour.
>
> Test set up
>  * Running dd on the host reading from the mass storage device
>  * cmdline: dd if=/dev/sdb of=/dev/null bs=4k count=$((256*100))
>  * Caches are dropped on the host and on the device before each run
>
> Measurements on a Snowball board with ondemand_govenor active.
>
> FSG_NUM_BUFFERS 2
> 104857600 bytes (105 MB) copied, 5.62173 s, 18.7 MB/s
> 104857600 bytes (105 MB) copied, 5.61811 s, 18.7 MB/s
> 104857600 bytes (105 MB) copied, 5.57817 s, 18.8 MB/s
>
> FSG_NUM_BUFFERS 4
> 104857600 bytes (105 MB) copied, 5.26839 s, 19.9 MB/s
> 104857600 bytes (105 MB) copied, 5.2691 s, 19.9 MB/s
> 104857600 bytes (105 MB) copied, 5.2711 s, 19.9 MB/s
>
> There may not be one optimal number for all boards. This is why
> the number is added to Kconfig. If selecting USB_GADGET_DEBUG_FILES
> this value may be set by a module parameter as well.
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> ---
> Change log.
> v2: Update after proofreading comments from Michal Nazarewicz
> v3: Clarify the description of this patch based on input from Alan Stern
> v4: - Introduce a module_param to set number of pipeline buffers
>    if USB_DEBUG is set. In order to add this support fsg_common is
>    allocated at runtime. The fsg_buffhd list size is appended to fsg_dev
>    and fsg_common at runtime allocation.
>    - The previous acks from Michal and Alan on v3 are not applicable
>    for this version since it's a new implementation.
> v5: - Separate allocation of buffhds in f_mass_storage.c
>    - Change FSG_NUM_BUFFERS to fsg_num_buffers to indicate variable value.
>    - code clean up and document module param, all thanks to Michal and Alan.
>
>  drivers/usb/gadget/Kconfig          |   16 ++++++++++++++++
>  drivers/usb/gadget/f_mass_storage.c |   24 ++++++++++++++++--------
>  drivers/usb/gadget/file_storage.c   |   26 ++++++++++++++++----------
>  drivers/usb/gadget/mass_storage.c   |    3 +++
>  drivers/usb/gadget/multi.c          |    3 +++
>  drivers/usb/gadget/storage_common.c |   25 +++++++++++++++++++++++--
>  6 files changed, 77 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 44b6b40..65ceecf 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -96,6 +96,22 @@ config USB_GADGET_VBUS_DRAW
>           This value will be used except for system-specific gadget
>           drivers that have more specific information.
>
> +config USB_GADGET_STORAGE_NUM_BUFFERS
> +       int "Number of storage pipeline buffers"
> +       range 2 4
> +       default 2
> +       help
> +          Usually 2 buffers are enough to establish a good buffering
> +          pipeline. The number may be increased in order to compensate
> +          for a bursty VFS behaviour. For instance there may be cpu wake up
> +          latencies that makes the VFS to appear bursty in a system with
> +          an cpu on-demand governor. Especially if DMA is doing IO to
> +          offload the CPU. In this case the CPU will go into power
> +          save often and spin up occasionally to move data within VFS.
> +          If selecting USB_GADGET_DEBUG_FILES this value may be set by
> +          a module parameter as well.
> +          If unsure, say 2.
> +
>  #
>  # USB Peripheral Controller Support
>  #
> diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
> index 5b93395..49da6a1 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -363,7 +363,7 @@ struct fsg_common {
>
>        struct fsg_buffhd       *next_buffhd_to_fill;
>        struct fsg_buffhd       *next_buffhd_to_drain;
> -       struct fsg_buffhd       buffhds[FSG_NUM_BUFFERS];
> +       struct fsg_buffhd       *buffhds;
>
>        int                     cmnd_size;
>        u8                      cmnd[MAX_COMMAND_SIZE];
> @@ -2348,7 +2348,7 @@ reset:
>        if (common->fsg) {
>                fsg = common->fsg;
>
> -               for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
> +               for (i = 0; i < fsg_num_buffers; ++i) {
>                        struct fsg_buffhd *bh = &common->buffhds[i];
>
>                        if (bh->inreq) {
> @@ -2406,7 +2406,7 @@ reset:
>        clear_bit(IGNORE_BULK_OUT, &fsg->atomic_bitflags);
>
>        /* Allocate the requests */
> -       for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
> +       for (i = 0; i < fsg_num_buffers; ++i) {
>                struct fsg_buffhd       *bh = &common->buffhds[i];
>
>                rc = alloc_request(common, fsg->bulk_in, &bh->inreq);
> @@ -2475,7 +2475,7 @@ static void handle_exception(struct fsg_common *common)
>
>        /* Cancel all the pending transfers */
>        if (likely(common->fsg)) {
> -               for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
> +               for (i = 0; i < fsg_num_buffers; ++i) {
>                        bh = &common->buffhds[i];
>                        if (bh->inreq_busy)
>                                usb_ep_dequeue(common->fsg->bulk_in, bh->inreq);
> @@ -2487,7 +2487,7 @@ static void handle_exception(struct fsg_common *common)
>                /* Wait until everything is idle */
>                for (;;) {
>                        int num_active = 0;
> -                       for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
> +                       for (i = 0; i < fsg_num_buffers; ++i) {
>                                bh = &common->buffhds[i];
>                                num_active += bh->inreq_busy + bh->outreq_busy;
>                        }
> @@ -2510,7 +2510,7 @@ static void handle_exception(struct fsg_common *common)
>         */
>        spin_lock_irq(&common->lock);
>
> -       for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
> +       for (i = 0; i < fsg_num_buffers; ++i) {
>                bh = &common->buffhds[i];
>                bh->state = BUF_STATE_EMPTY;
>        }
> @@ -2737,6 +2737,14 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
>                common->free_storage_on_release = 0;
>        }
>
> +       common->buffhds = kcalloc(fsg_num_buffers,
> +                                 sizeof *(common->buffhds), GFP_KERNEL);
Need to add a kfree() at release too. This data is never freed
otherwise. I'll update fix that in the next version together with any
new comments from Michal and Alan.

/Per
