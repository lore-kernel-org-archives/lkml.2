Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1CUIoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:44:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59551 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab1CUIog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=g4LqH1vRaUnz7o6DkQntzQ3EMVuCHdQXIK1qupHNx0Rk38O7tWlhgUqXByhfWaFUfV
         NI/UD5AsK50NVgtSICexpzu4xzQIVo5Y9+a/67GCuK/F1FoXetM6eIxJwqdpSIWiA0Qo
         Hcf+O4buSbIqVlbbnp9c3bjx9nrhf/9Bls/iI=
Message-ID: <4D870FEF.6040009@suse.cz>
Date: Mon, 21 Mar 2011 09:44:31 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: =?UTF-8?B?TWlyZWsgU2x1Z2XFiA==?= <thunder.m@email.cz>
CC: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: PATCH: Leadtek DTVb1800H require longer delay for tuner reset
References: <4D867A0C.7050809@email.cz>
In-Reply-To: <4D867A0C.7050809@email.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2011 11:05 PM, Mirek Slugeň wrote:
> Hi,
> 
>     I am using alot of tuners Leadtek DTV1800H under Linux, minimum 5
> devices per one PC with kernel 2.6.37.4. I discovered bug which I can se
> very often but not always. When device tuner is reseted there is not
> enough time to do all needed stuff and sometimes (randomly) kernel show
> this message:
> 
> [  821.369647] cx88[0]/1: IRQ loop detected, disabling interrupts
> 
> Patch is again very simple, we need to adjust time in reset function
> after cx_clear and cx_set calls from 50 to 75 us. I tested this patch on
> 4 PC with similar problems and all are without this issue.
> 
> M. Slugen
> 
> 
> kernel_cx88_reset.diff
> 
> 
> diff -Naur linux-2.6.37.4.old//drivers/media/video/cx88/cx88-cards.c linux-2.6.37.4/drivers/media/video/cx88/cx88-cards.c
> --- linux-2.6.37.4.old//drivers/media/video/cx88/cx88-cards.c	2011-03-20 21:30:52.000000000 +0100
> +++ linux-2.6.37.4/drivers/media/video/cx88/cx88-cards.c	2011-03-20 22:25:54.710228001 +0100
> @@ -3019,9 +3019,9 @@
>  		cx_set(MO_GP1_IO, 0x1010);
>  		mdelay(50);
>  		cx_clear(MO_GP1_IO, 0x10);
> -		mdelay(50);
> +		mdelay(75);
>  		cx_set(MO_GP1_IO, 0x10);
> -		mdelay(50);
> +		mdelay(75);

Wow, 75 ms of busy-waiting. Since others use msleep, all these should be
converted to msleep too. Or is this an atomic context, so that the
others are broken (e.g. cx88_dvico_xc2028_callback)?

Also for instance I don't understand this code:
                cx_write(MO_GP2_IO, 0xcf7);
                mdelay(50);
                cx_write(MO_GP2_IO, 0xef5);
                mdelay(50);
                cx_write(MO_GP2_IO, 0xcf7);
                msleep(10);

Delays of 50 ms and sleep of 10 ms? Given [um]delay spin _at least_ the
time specified, what was the intention of this?

regards,
-- 
js
suse labs
