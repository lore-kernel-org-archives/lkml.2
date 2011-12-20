Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab1LTU7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:59:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44529 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1LTU7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:59:17 -0500
MIME-Version: 1.0
In-Reply-To: <20111220213120.5e275f10@stein>
References: <20111220213017.75ff380c@stein> <20111220213120.5e275f10@stein>
From: Carl Karsten <carl@personnelware.com>
Date: Tue, 20 Dec 2011 14:58:56 -0600
X-Google-Sender-Auth: nywO2vCPNjkRkE2vLEy3OZFpqr0
Message-ID: <CADmzSSjfFgrAroh8jZfC-q0dNuDgsyoNcUfTik6gBx75zrngFw@mail.gmail.com>
Subject: Re: [PATCH 1/3] firewire: do not expose globally unique IDs in the
 kernel log
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

grumble.

I use those guids like so:

plug in dv cam, dmesg, cut guid to clipboard, run:
dvgrab -guid (paste)

It also kinda helps me keep track of what devices are misbehaving, but
this alone isn't very important.

Any chance of making this configurable?


On Tue, Dec 20, 2011 at 2:31 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Printing worldwide unique IDs in the kernel log is questionable from a
> privacy point of view.  Some people edit such IDs out of the log before
> they post bug reports.  Make life easier for them and do not log GUIDs
> anymore.  For local debugging, GUIDs are still available during the
> lifetime of a device in /sys/bus/firewire/devices/fw*/guid.
>
> Instead, log the vendor-unique part of the device ID (the OUI) in
> firewire-core and bus IDs in firewire-net.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/core-device.c |    8 ++++----
>  drivers/firewire/net.c         |    8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> Index: b/drivers/firewire/core-device.c
> ===================================================================
> --- a/drivers/firewire/core-device.c
> +++ b/drivers/firewire/core-device.c
> @@ -1036,16 +1036,16 @@ static void fw_device_init(struct work_s
>                fw_schedule_device_work(device, SHUTDOWN_DELAY);
>        } else {
>                if (device->config_rom_retries)
> -                       fw_notify("created device %s: GUID %08x%08x, S%d00, "
> +                       fw_notify("created device %s: OUI %06x, S%d00, "
>                                  "%d config ROM retries\n",
>                                  dev_name(&device->device),
> -                                 device->config_rom[3], device->config_rom[4],
> +                                 device->config_rom[3] >> 8,
>                                  1 << device->max_speed,
>                                  device->config_rom_retries);
>                else
> -                       fw_notify("created device %s: GUID %08x%08x, S%d00\n",
> +                       fw_notify("created device %s: OUI %06x, S%d00\n",
>                                  dev_name(&device->device),
> -                                 device->config_rom[3], device->config_rom[4],
> +                                 device->config_rom[3] >> 8,
>                                  1 << device->max_speed);
>                device->config_rom_retries = 0;
>
> Index: b/drivers/firewire/net.c
> ===================================================================
> --- a/drivers/firewire/net.c
> +++ b/drivers/firewire/net.c
> @@ -574,8 +574,8 @@ static int fwnet_finish_incoming_packet(
>                spin_unlock_irqrestore(&dev->lock, flags);
>
>                if (!peer) {
> -                       fw_notify("No peer for ARP packet from %016llx\n",
> -                                 (unsigned long long)peer_guid);
> +                       fw_notify("No peer for ARP packet from %04x\n",
> +                                 source_node_id);
>                        goto no_peer;
>                }
>
> @@ -1545,8 +1545,8 @@ static int fwnet_probe(struct device *_d
>        }
>
>        list_add_tail(&dev->dev_link, &fwnet_device_list);
> -       fw_notify("%s: IPv4 over FireWire on device %016llx\n",
> -                 net->name, (unsigned long long)card->guid);
> +       fw_notify("%s: IPv4 over FireWire on card %d device %s\n",
> +                 net->name, card->index, dev_name(card->device));
>  have_dev:
>        ret = fwnet_add_peer(dev, unit, device);
>        if (ret && allocated_netdev) {
>
> --
> Stefan Richter
> -=====-==-== ==-- =-=--
> http://arcgraph.de/sr/



-- 
Carl K
