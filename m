Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab1F0KIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 06:08:31 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:32999 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab1F0KG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 06:06:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: Re: Oops while modprobing uvcvideo module
Date: Mon, 27 Jun 2011 12:07:07 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.4; x86_64; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20110625191929.GA4411@Xye>
In-Reply-To: <20110625191929.GA4411@Xye>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106271207.08227.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Raghavendra,

On Saturday 25 June 2011 21:19:29 Raghavendra D Prabhu wrote:
> Hi,
> 
>      While modprobing uvcvideo I am getting the following oops. This is
>      on a kernel built with latest linus master
>      (536142f950f7ea4f3d146a138ad6938f28a34f33). I have also attached the
>      full dmesg.
> 
> =============================================================
> [ 1985.732475] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_2HDM
> (0408:2fb1)

Could you please send me the output of

lsusb -v -d 0408:2fb1

running as root if possible ?

> [ 1985.759844] uvcvideo: No streaming interface found for terminal 6.
> [ 1985.759863] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000050
> [ 1985.759871] IP: [<ffffffffa0da23e0>] media_entity_init+0x40/0xa0 [media]

[snip]

> I was able to observe this at boot and also reproduce it later.
> 
> Further analyzing the oops revealed this:
> ========================================================
> perl scripts/markup_oops.pl < ~/oops
> 
> No vmlinux specified, assuming /lib/modules/3.0.0-rc4-LYM/build/vmlinux
>          unsigned int max_links = num_pads + extra_links;
>          unsigned int i;
> 
>          links = kzalloc(max_links * sizeof(links[0]), GFP_KERNEL);
>   ffffffffa01573d2:      48 c1 e7 05             shl    $0x5,%rdi   |  %edi
> => ffff88013ac31200 ffffffffa01573d6:      e8 00 00 00 00          callq 
> ffffffffa01573db <media_entity_init+0x3b> if (links == NULL)
>   ffffffffa01573db:      48 85 c0                test   %rax,%rax   |  %eax
> => ffff88013ac311e0 ffffffffa01573de:      74 56                   je    
> ffffffffa0157436 <media_entity_init+0x96> entity->max_links = max_links;
>          entity->num_links = 0;
>          entity->num_backlinks = 0;
>          entity->num_pads = num_pads;
>          entity->pads = pads;
>          entity->links = links;
> *ffffffffa01573e0:      48 89 43 50             mov    %rax,0x50(%rbx) | 
> %eax = ffff88013ac311e0 <--- faulting instruction

It looks like entity is NULL.

>          for (i = 0; i < num_pads; i++) {
>                  pads[i].entity = entity;
>                  pads[i].index = i;
>          }
> 
>          return 0;
>   ffffffffa01573e4:      31 c0                   xor    %eax,%eax
>          entity->num_backlinks = 0;
>          entity->num_pads = num_pads;
>          entity->pads = pads;
>          entity->links = links;
> ==================================================================

I can't reproduce the problem with my webcams. Can you try a diagnosis patch 
if needed ?

-- 
Regards,

Laurent Pinchart
