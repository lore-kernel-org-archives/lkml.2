Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1L0RWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 12:22:30 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40089 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1L0RW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 12:22:27 -0500
MIME-Version: 1.0
In-Reply-To: <4EF3BACA.1080405@gmail.com>
References: <4EF3BACA.1080405@gmail.com>
Date: Tue, 27 Dec 2011 14:22:26 -0300
Message-ID: <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com>
Subject: Re: [bluetooth] linux-3.x regression (bisected)
From: Andre Guedes <andre.guedes@openbossa.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

On Thu, Dec 22, 2011 at 8:18 PM, Rene Herman <rene.herman@gmail.com> wrote:
> Good day.
>
> A while ago, my noname USB Bluetooth adapter stopped working, with from that
> point on only "Bluetooth: hci0 command tx timeout" appearing in the kernel
> messages.
>
> I just now got around to looking at it and bisected this to commit
> eead27da60df80a112d1ac3ea482226e9794c26b:
>
> ===
> Author: Andre Guedes <andre.guedes@openbossa.org>
> Date:   Thu Jun 30 19:20:55 2011 -0300
>
>    Bluetooth: Add lmp_host_le_capable() macro
>
>    Since we have the extended LMP features properly implemented, we
>    should check the LMP_HOST_LE bit to know if the host supports LE.
>
>    Signed-off-by: Andre Guedes <andre.guedes@openbossa.org>
>    Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
> ===
>
> while that commit cannot be reverted outright due to dependencies, reverting
> it functionally fixes things for me. That is, Bluetooth works again after
> applying (to linux-3.1.6):
>
> ===
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 56943ad..c7f794e 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -540,7 +540,7 @@ int hci_dev_open(__u16 dev)
>                ret = __hci_request(hdev, hci_init_req, 0,
>
> msecs_to_jiffies(HCI_INIT_TIMEOUT));
>
> -               if (lmp_host_le_capable(hdev))
> +               if (lmp_le_capable(hdev))
>                        ret = __hci_request(hdev, hci_le_init_req, 0,
>
> msecs_to_jiffies(HCI_INIT_TIMEOUT));
> ===
>
> It seems that my adapter wasn't ready for the change. It is a:
>
> 002 Device 002: ID 1131:1004 Integrated System Solution Corp. Bluetooth
> Device
>
> If more specific information is wanted (to add adapter-specific quirk
> handling, perhaps?) please be verbose on how to obtain it. I don't know
> anything about Bluetooth

Could you please send us the kernel log messages with Bluetooth debug
enabled? Here goes the instructions:

1. Compile kernel with CONFIG_DYNAMIC_DEBUG=y.
2. Load Bluetooth module.
3. Run the following commands to turn debug on (remember to mount debugfs
first):
--
$ echo "file hci_core.c +pf" > /sys/kernel/debug/dynamic_debug/control
$ echo "file hci_event.c +pf" > /sys/kernel/debug/dynamic_debug/control
$ echo "file mgmt.c +pf" > /sys/kernel/debug/dynamic_debug/control
$ echo "file btusb.c +pf" > /sys/kernel/debug/dynamic_debug/control
--
4. Plug the Bluetooth adapter.

Thanks in advance,

Andre
