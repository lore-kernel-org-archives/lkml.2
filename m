Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1AYE4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 23:56:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57259 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab1AYE4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 23:56:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X9C1CBEIY0u0SFSZ1YtUAXf3SNlPtNdpA73aneeOMHxGcZH8AN+fpid8/LvjFiqbN2
         uuopN4e1+u4WAxXleAP+UzQvf1q3T8EtupmEVZz/AKJEWlviF24gHyBpI0aaRy6zgX8j
         6LRwurY/FrYq8AufRGVLzTdmcAsDu0i4i4YMw=
Date: Mon, 24 Jan 2011 20:55:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110125045559.GB7850@core.coreip.homeip.net>
References: <4D3C5F73.2050408@teksavvy.com>
 <20110124175456.GA17855@core.coreip.homeip.net>
 <4D3E1A08.5060303@teksavvy.com>
 <20110125005555.GA18338@core.coreip.homeip.net>
 <4D3E4DD1.60705@teksavvy.com>
 <20110125042016.GA7850@core.coreip.homeip.net>
 <4D3E5372.9010305@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3E5372.9010305@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:37:06PM -0500, Mark Lord wrote:
> On 11-01-24 11:20 PM, Dmitry Torokhov wrote:
> > On Mon, Jan 24, 2011 at 11:13:05PM -0500, Mark Lord wrote:
> >> On 11-01-24 07:55 PM, Dmitry Torokhov wrote:
> >>>
> >>> No, as far as I know we kept ABI intact.
> >>
> >>
> >> Okay, I hacked lsinput and input-kbd to ignore the protocol number.
> >> input-kbd is still broken: it thinks my remote control (Hauppauge)
> >> has only ten buttons, and won't allow me to remap codes larger than 10.
> >>
> >> I've now hacked around that too, but without determining exactly
> >> where the interface got broken.
> >>
> >> Ugh.
> >>
> >
> > Where are the sources? I can take a look...
> 
> I used "apt-get source input-utils" under Ubuntu-10.10.
> The problem seems to be here somewhere:
> 
> static struct kbd_map* kbd_map_read(int fd)
> {
>         struct kbd_entry entry;
>         struct kbd_map *map;
>         int rc;
> 
>         map = malloc(sizeof(*map));
>         memset(map,0,sizeof(*map));
>         for (map->size = 0; map->size < 65536; map->size++) {
>                 entry.scancode = map->size;
>                 entry.keycode  = KEY_RESERVED;
>                 rc = ioctl(fd, EVIOCGKEYCODE, &entry);
>                 if (rc < 0) {
>                         break;
>                 }
>                 if (map->size >= map->alloc) {
>                         map->alloc += 64;
>                         map->map = realloc(map->map, map->alloc * sizeof(entry));
>                 }
>                 map->map[map->size] = entry;
> 
>                 if (KEY_RESERVED != entry.keycode)
>                         map->keys++;
>         }
>         if (map->keys) {
>                 printf("map: %d keys, size: %d/%d\n",
>                         map->keys, map->size, map->alloc);
>                 return map;
>         } else {
>                 free(map);
>                 return NULL;
>         }
> }
> 
> This results in (map->size==10) for 2.6.36+ (wrong),
> and a much larger map->size for 2.6.35 and earlier.
> 
> So perhaps EVIOCGKEYCODE has changed?
> 

So the utility expects that all devices have flat scancode space and
driver might have changed so it does not recognize scancode 10 as valid
scancode anymore.

The options are:

1. Convert to EVIOCGKEYCODE2
2. Ignore errors from EVIOCGKEYCODE and go through all 65536 iterations.

Thanks.

-- 
Dmitry
