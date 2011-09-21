Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1IUN0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:26:35 -0400
Received: from h1778886.stratoserver.net ([85.214.133.74]:43847 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab1IUN0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:26:34 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
Date: Wed, 21 Sep 2011 15:26:33 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
        "Clark, Rob" <rob@ti.com>, Archit Taneja <archit@ti.com>,
        Nishant Kamat <nskamat@ti.com>
References: <1316088425.11294.78.camel@lappyti>
In-Reply-To: <1316088425.11294.78.camel@lappyti>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109211526.33687.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Donnerstag, 15. September 2011, 14:07:05 schrieb Tomi Valkeinen:
> Now, I'm quite sure the above framework could work quite well with any
> OMAP like hardware, with unified memory (i.e. the video buffers are in
> SDRAM) and 3D chips and similar components are separate. But what I'm
> not sure is how desktop world's gfx cards change things. Most probably
> all the above components can be found from there also in some form, but
> are there some interdependencies between 3D/buffer management/something
> else and the video output side?
If I have read your proposal right, it could also help in better supporting 
epaper-displays. 

The current drivers each (re-)implement the deferredIo logic needed to drive 
such systems (catching and combining updates to the framebuffer) and combine 
this with the actual display driver which issues specific commands to the 
display hardware. Also a board-specific driver is needed to implement the 
actual transport to the display which seems be done via this i80 command 
protocol over GPIOs or the LCD controllers of SoCs.

If one were to split this it could be realised like

----------------   ---------------   -------------
| deferredIOFb | - | DisplayCtrl | - | Transport |
----------------   ---------------   -------------

An interesting tidbit is that on the ereaders I'm working on the LCD 
controller should be able to do some sort of pseudo DMA operation.
The normal way to transmit data to epaper displays is:
- issue update command with dimension of the regions to update
- read relevant pixeldata from fb and write it to the i80 in a loop
- issue stop-update command

On the S3C2416 it could go like:
- issue update command
- describe to the lcd controller the source memory region
- let the lcd controller transmit exactly one frame
- issue stop update command
So the transport would need to get the memory addresses of the region to 
update from the framebuffer driver.

Also this system could possibly use some of the drawing routines from the 
S3C2416 SoC.

Essentially needed would be a s3c-fb with deferredio-addon and the lcd 
controller separated from it. I'm still not sure how this all could fit 
together but I would guess separating framebuffer and display control would 
help.


Heiko 
