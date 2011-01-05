Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab1AEBGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 20:06:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919Ab1AEBGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 20:06:07 -0500
Date: Tue, 4 Jan 2011 17:05:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yannick Heneault <yannick_heneault@matrox.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        airlied@redhat.com, hpa@zytor.com
Subject: Re: [BUG] VGA palette corruption in vgacon.c for EFI machine
Message-Id: <20110104170533.ce207a46.akpm@linux-foundation.org>
In-Reply-To: <4CEFC7E3.4060402@matrox.com>
References: <4CEFC7E3.4060402@matrox.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010 09:44:51 -0500
Yannick Heneault <yannick_heneault@matrox.com> wrote:

> Hi,
> 
> It seems there is a small problem of VGA palette corruption on EFI 
> machine. When the kernel initializes the architecture, it checks if the 
> machine is a EFI machine and if the memory at 0xa0000 is not tagged as 
> conventional memory, which should not be the case because this is VGA 
> memory. In that case, the kernel assumes that a VGA console can exist. I 
> would think that this assumption is correct.
> 
> When the kernel initialize the console in vgacon_startup it checks if it 
> can really use the VGA console. I think this is where a check is 
> missing. Currently, the function can fail if a VESA boot mode is 
> detected but not if a EFI boot mode was used. I think the code should be 
> modified like this :
> 
> --- a/drivers/video/console/vgacon.c
> +++ b/drivers/video/console/vgacon.c
> @@ -377,7 +377,8 @@ static const char *vgacon_startup(void)
>          u16 saved1, saved2;
>          volatile u16 *p;
> 
> -       if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB) {
> +       if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB ||
> +           screen_info.orig_video_isVGA == VIDEO_TYPE_EFI) {
>                no_vga:
>   #ifdef CONFIG_DUMMY_CONSOLE
>                  conswitchp = &dummy_con;
> 
> 
> In that case, the VGA console will fail and a dummy console will be 
> temporary used until the EFI driver get loaded. At that point the 
> console will be mapped to the EFI driver and graphics (splash screen and 
> penguins) will appear correctly.
> 
> Currently, the function vgacon_startup doesn't fail and initialize the 
> video card for a real VGA mode. This function change the first 16 
> entries of the VGA palette. When the efifb driver kick-in, the palette 
> is not restored to default ramp value, thus the 16 first entry remain in 
> a modified state.
> 

If that fix worked for you then please send it as a formal, tested,
signed-off kernel patch and we'll put it in the pipeline and see what
emerges from the other end.

