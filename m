Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0KGRIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 12:08:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60951 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0KGRIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 12:08:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ccgIVEQmqeMqrwej3WRtxVEfwHBPLC9Rkd2fpF2rJ1hmB4aCK7rKOmcTGG/Hg7z/0m
         3cxESg3yZTkMSj9ZESxzjiJuP3OSDWzDDG3dyH1EAd+8D7usLMx+vCJag5zjh1mwsYRx
         o0FXdEq7lVhYf3KlfChvioUCqXaXyV7m4PHVM=
MIME-Version: 1.0
In-Reply-To: <20101107165745.GB1759@n2100.arm.linux.org.uk>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<20101107165745.GB1759@n2100.arm.linux.org.uk>
Date: Sun, 7 Nov 2010 20:08:45 +0300
Message-ID: <AANLkTimFJ=Brx4pDiUqZOKDfABaDg0s_yFC7EkZGi7D8@mail.gmail.com>
Subject: Re: [PATCH 1/6 v2] ARM: Add basic architecture support for
 VIA/WonderMedia 85xx SoC's
From: Alexey Charkov <alchark@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/7 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Sun, Nov 07, 2010 at 07:28:52PM +0300, Alexey Charkov wrote:
>> +static inline void preallocate_fb(struct vt8500fb_platform_data *p,
>> +                               unsigned long align) {
>> +     p->video_mem_len = (p->xres_virtual * p->yres_virtual * 4) >>
>> +                     (p->bpp > 16 ? 0 : (p->bpp > 8 ? 1 :
>> +                                     (8 / p->bpp) + 1));
>> +     p->video_mem_phys = (unsigned long)memblock_alloc(p->video_mem_len,
>> +                                                       align);
>> +     p->video_mem_virt = phys_to_virt(p->video_mem_phys);
>> +}
> ...
>> +void __init vt8500_map_io(void)
>> +{
>> +     wmt_current_regs = &wmt_regmaps[VT8500_INDEX];
>> +     wmt_current_irqs = &wmt_irqs[VT8500_INDEX];
>> +     set_data();
>> +#ifdef CONFIG_FB_VT8500
>> +     panels[current_panel_idx].bpp = 16; /* Always use RGB565 */
>> +     preallocate_fb(&panels[current_panel_idx], SZ_4M);
>> +     vt8500_device_lcdc.dev.platform_data = &panels[current_panel_idx];
>> +#endif
>> +     iotable_init(vt8500_io_desc, ARRAY_SIZE(vt8500_io_desc));
>> +}
> ...
>> +void __init wm8505_map_io(void)
>> +{
>> +     wmt_current_regs = &wmt_regmaps[WM8505_INDEX];
>> +     wmt_current_irqs = &wmt_irqs[WM8505_INDEX];
>> +     set_data();
>> +#ifdef CONFIG_FB_WM8505
>> +     panels[current_panel_idx].bpp = 32; /* Always use RGB888 */
>> +     preallocate_fb(&panels[current_panel_idx], 32);
>> +     vt8500_device_wm8505_fb.dev.platform_data = &panels[current_panel_idx];
>> +#endif
>> +     iotable_init(vt8500_io_desc, ARRAY_SIZE(vt8500_io_desc));
>> +}
>
> I'd much prefer that the allocation of memblock memory is done via the
> 'reserve' machine callback, rather than trying to group it into the IO
> mapping callback.  Is there a reason it can't be?
>

I believe it can. Thanks for the info, I just didn't know about that.
Will fix this shortly.

Is it OK to leave resources assignment in map_io or is there a better
place to do that as well?
