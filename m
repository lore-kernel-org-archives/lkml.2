Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab2HWU3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:29:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35524 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754027Ab2HWU3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:29:30 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19VHbNdpzhVDcaqdo3q91282OLKxqslyhHDBaPCn8
	iA7KGMwXzS4ypN
Message-ID: <503692A4.7000209@gmx.de>
Date: Thu, 23 Aug 2012 20:29:24 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbcon: Fix bit_putcs() call to kmalloc(s, GFP_KERNEL)
References: <20120730210949.5ccc5164@neptune.home>
In-Reply-To: <20120730210949.5ccc5164@neptune.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 07:09 PM, Bruno Prémont wrote:
> Switch to kmalloc(,GFP_ATOMIC) in bit_putcs to fix below trace:
> 
> [    9.771812] BUG: sleeping function called from invalid context at /usr/src/linux-git/mm/slub.c:943
> [    9.771814] in_atomic(): 1, irqs_disabled(): 1, pid: 1063, name: mount
> [    9.771818] Pid: 1063, comm: mount Not tainted 3.5.0-jupiter-00003-g8d858b1-dirty #2
> [    9.771819] Call Trace:
> [    9.771838]  [<c104f79b>] __might_sleep+0xcb/0xe0
> [    9.771844]  [<c10c00d4>] __kmalloc+0xb4/0x1c0
> [    9.771851]  [<c1041d4a>] ? queue_work+0x1a/0x30
> [    9.771854]  [<c1041dcf>] ? queue_delayed_work+0xf/0x30
> [    9.771862]  [<c1205832>] ? bit_putcs+0xf2/0x3e0
> [    9.771865]  [<c1041e01>] ? schedule_delayed_work+0x11/0x20
> [    9.771868]  [<c1205832>] bit_putcs+0xf2/0x3e0
> [    9.771875]  [<c12002b8>] ? get_color.clone.14+0x28/0x100
> [    9.771878]  [<c1200d2f>] fbcon_putcs+0x11f/0x130
> [    9.771882]  [<c1205740>] ? bit_clear+0xe0/0xe0
> [    9.771885]  [<c1200f6d>] fbcon_redraw.clone.21+0x11d/0x160
> [    9.771889]  [<c120383d>] fbcon_scroll+0x79d/0xe10
> [    9.771892]  [<c12002b8>] ? get_color.clone.14+0x28/0x100
> [    9.771897]  [<c124c0b4>] scrup+0x64/0xd0
> [    9.771900]  [<c124c22b>] lf+0x2b/0x60
> [    9.771903]  [<c124cc95>] vt_console_print+0x1d5/0x2f0
> [    9.771907]  [<c124cac0>] ? register_vt_notifier+0x20/0x20
> [    9.771913]  [<c102b335>] call_console_drivers.clone.5+0xa5/0xc0
> [    9.771916]  [<c102c58e>] console_unlock+0x2fe/0x3c0
> [    9.771920]  [<c102ca16>] vprintk_emit+0x2e6/0x300
> [    9.771924]  [<c13f01ae>] printk+0x38/0x3a
> [    9.771931]  [<c112e8fe>] reiserfs_remount+0x2ae/0x3e0
> [    9.771934]  [<c112e650>] ? reiserfs_fill_super+0xb00/0xb00
> [    9.771939]  [<c10ca0ab>] do_remount_sb+0xab/0x150
> [    9.771943]  [<c1034476>] ? ns_capable+0x46/0x70
> [    9.771948]  [<c10e059c>] do_mount+0x20c/0x6b0
> [    9.771955]  [<c10a7044>] ? strndup_user+0x34/0x50
> [    9.771958]  [<c10e0acc>] sys_mount+0x6c/0xa0
> [    9.771964]  [<c13f2557>] sysenter_do_call+0x12/0x26
> 
> According to comment in bit_putcs() that kammloc() call only happens
> when fbcon is drawing to a monochrome framebuffer (which is my case with
> hid-picolcd).
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/console/bitblit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
> index 28b1a83..61b182b 100644
> --- a/drivers/video/console/bitblit.c
> +++ b/drivers/video/console/bitblit.c
> @@ -162,7 +162,7 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
>  	image.depth = 1;
>  
>  	if (attribute) {
> -		buf = kmalloc(cellsize, GFP_KERNEL);
> +		buf = kmalloc(cellsize, GFP_ATOMIC);
>  		if (!buf)
>  			return;
>  	}

