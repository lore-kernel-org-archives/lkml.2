Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232Ab3AIVXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:23:05 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:39118 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609Ab3AIVWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:22:54 -0500
MIME-Version: 1.0
In-Reply-To: <F9E001219150CB45BEDC82A650F360C901496034@G9W0717.americas.hpqcorp.net>
References: <F9E001219150CB45BEDC82A650F360C901496034@G9W0717.americas.hpqcorp.net>
From: Blue Swirl <blauwirbel@gmail.com>
Date: Wed, 9 Jan 2013 21:22:33 +0000
Message-ID: <CAAu8pHt63J4h_c2HbwSDRxJCg4675WT7m_xmYwE69MTp_E=igg@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH 2/2] QEMU-AER: Qemu changes to support AER
 for VFIO-PCI devices
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Gleb Natapov <gleb@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 6:26 AM, Pandarathil, Vijaymohan R
<vijaymohan.pandarathil@hp.com> wrote:
>         - Create eventfd per vfio device assigned to a guest and register an
>           event handler
>
>         - This fd is passed to the vfio_pci driver through a new ioctl
>
>         - When the device encounters an error, the eventfd is signaled
>           and the qemu eventfd handler gets invoked.
>
>         - In the handler decide what action to take. Current action taken
>           is to terminate the guest.
>
> Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> ---
>  hw/vfio_pci.c              | 56 ++++++++++++++++++++++++++++++++++++++++++++++
>  linux-headers/linux/vfio.h |  9 ++++++++
>  2 files changed, 65 insertions(+)
>
> diff --git a/hw/vfio_pci.c b/hw/vfio_pci.c
> index 28c8303..9c3c28b 100644
> --- a/hw/vfio_pci.c
> +++ b/hw/vfio_pci.c
> @@ -38,6 +38,7 @@
>  #include "qemu/error-report.h"
>  #include "qemu/queue.h"
>  #include "qemu/range.h"
> +#include "sysemu/sysemu.h"
>
>  /* #define DEBUG_VFIO */
>  #ifdef DEBUG_VFIO
> @@ -130,6 +131,8 @@ typedef struct VFIODevice {
>      QLIST_ENTRY(VFIODevice) next;
>      struct VFIOGroup *group;
>      bool reset_works;
> +    EventNotifier errfd;
> +    __u32 dev_info_flags;

QEMU is not kernel code, please use uint32_t.

>  } VFIODevice;
>
>  typedef struct VFIOGroup {
> @@ -1805,6 +1808,8 @@ static int vfio_get_device(VFIOGroup *group, const char *name, VFIODevice *vdev)
>      DPRINTF("Device %s flags: %u, regions: %u, irgs: %u\n", name,
>              dev_info.flags, dev_info.num_regions, dev_info.num_irqs);
>
> +    vdev->dev_info_flags = dev_info.flags;
> +
>      if (!(dev_info.flags & VFIO_DEVICE_FLAGS_PCI)) {
>          error_report("vfio: Um, this isn't a PCI device\n");
>          goto error;
> @@ -1900,6 +1905,55 @@ static void vfio_put_device(VFIODevice *vdev)
>      }
>  }
>
> +static void vfio_errfd_handler(void *opaque)
> +{
> +    VFIODevice *vdev = opaque;
> +
> +    if (!event_notifier_test_and_clear(&vdev->errfd)) {
> +        return;
> +    }
> +
> +    /*
> +     * TBD. Retrieve the error details and decide what action
> +     * needs to be taken. One of the actions could be to pass
> +     * the error to the guest and have the guest driver recover
> +     * the error. This requires that PCIe capabilities be
> +     * exposed to the guest. At present, we just terminate the
> +     * guest to contain the error.
> +     */
> +    error_report("%s(%04x:%02x:%02x.%x) "
> +        "Unrecoverable error detected... Terminating guest\n",
> +        __func__, vdev->host.domain, vdev->host.bus, vdev->host.slot,
> +        vdev->host.function);
> +
> +    qemu_system_shutdown_request();
> +    return;
> +}
> +
> +static void vfio_register_errfd(VFIODevice *vdev)
> +{
> +    int32_t pfd;
> +    int ret;
> +
> +    if (!(vdev->dev_info_flags & VFIO_DEVICE_FLAGS_AER_NOTIFY)) {
> +        error_report("vfio: Warning: Error notification not supported for the device\n");
> +        return;
> +    }
> +    if (event_notifier_init(&vdev->errfd, 0)) {
> +        error_report("vfio: Warning: Unable to init event notifier for error detection\n");
> +        return;
> +    }
> +    pfd = event_notifier_get_fd(&vdev->errfd);
> +    qemu_set_fd_handler(pfd, vfio_errfd_handler, NULL, vdev);
> +
> +    ret = ioctl(vdev->fd, VFIO_DEVICE_SET_ERRFD, pfd);
> +    if (ret) {
> +        error_report("vfio: Warning: Failed to setup error fd: %d\n", ret);
> +        qemu_set_fd_handler(pfd, NULL, NULL, vdev);
> +        event_notifier_cleanup(&vdev->errfd);
> +    }
> +    return;
> +}
>  static int vfio_initfn(PCIDevice *pdev)
>  {
>      VFIODevice *pvdev, *vdev = DO_UPCAST(VFIODevice, pdev, pdev);
> @@ -2010,6 +2064,8 @@ static int vfio_initfn(PCIDevice *pdev)
>          }
>      }
>
> +    vfio_register_errfd(vdev);
> +
>      return 0;
>
>  out_teardown:
> diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
> index 4758d1b..0ca4eeb 100644
> --- a/linux-headers/linux/vfio.h
> +++ b/linux-headers/linux/vfio.h
> @@ -147,6 +147,7 @@ struct vfio_device_info {
>         __u32   flags;
>  #define VFIO_DEVICE_FLAGS_RESET        (1 << 0)        /* Device supports reset */
>  #define VFIO_DEVICE_FLAGS_PCI  (1 << 1)        /* vfio-pci device */
> +#define VFIO_DEVICE_FLAGS_AER_NOTIFY (1 << 2)   /* Supports aer notification */
>         __u32   num_regions;    /* Max region index + 1 */
>         __u32   num_irqs;       /* Max IRQ index + 1 */

These are verbatim copies of kernel headers so it's OK here.

>  };
> @@ -288,6 +289,14 @@ struct vfio_irq_set {
>   */
>  #define VFIO_DEVICE_RESET              _IO(VFIO_TYPE, VFIO_BASE + 11)
>
> +/**
> + * VFIO_DEVICE_SET_ERRFD - _IO(VFIO_TYPE, VFIO_BASE + 12)
> + *
> + * Pass the eventfd to the vfio-pci driver for signalling any device
> + * error notifications
> + */
> +#define VFIO_DEVICE_SET_ERRFD           _IO(VFIO_TYPE, VFIO_BASE + 12)
> +
>  /*
>   * The VFIO-PCI bus driver makes use of the following fixed region and
>   * IRQ index mapping.  Unimplemented regions return a size of zero.
> --
> 1.7.11.3
>
>
