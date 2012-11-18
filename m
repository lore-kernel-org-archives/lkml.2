Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2KRSDD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 13:03:03 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51668 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2KRSDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 13:03:02 -0500
MIME-Version: 1.0
In-Reply-To: <20121118174720.GX3290@n2100.arm.linux.org.uk>
References: <CAMW5UfYUi-Zz2r5K9GeVzShSub2rDJVuoWR56+89+ytaqo_uxQ@mail.gmail.com>
	<20121118174720.GX3290@n2100.arm.linux.org.uk>
Date: Sun, 18 Nov 2012 13:03:00 -0500
Message-ID: <CAMW5Ufb9D+BYGtZUWPBWKMtk11QMpR1N+2Q1yb4w_GdvV17p+w@mail.gmail.com>
Subject: Re: [Patch v1 1/1] RTL8712 alignment bug in 3.6.5 on ARM
From: Josh Coombs <josh.coombs@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux ARM <linux-arm-kernel@lists.infradead.org>, wlanfae@realtek.com,
        Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 12:47 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Nov 18, 2012 at 12:06:40PM -0500, Josh Coombs wrote:
>> Starting with 3.6.5 on a Marvell Kirkwood based GoFlex Net I began
>> observing scheduler bugs when using a USB based RTL8712 WiFi NIC.
>> These would eventually overwhelm systemd's logger under moderate
>> network activity and crash the box.
>
> Cool, yet another systemd feature :)  sysvinit was less hastle...
>
>> [   53.173973] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> [   54.191655] BUG: scheduling while atomic: crond/144/0x40000300
>> [   54.197537] Modules linked in: rmd160 sha1_generic hmac
>> blowfish_generic blowfish_common sr_mod cdrom fbcon bitblit softcursor
>> font udlfb syscopyarea sysfillrect sysimgblt fb_sys_fops fb
>> hid_generic snd_usb_audio snd_usbmidi_lib snd_hwdep mct_u232
>> snd_rawmidi snd_seq_device snd_pcm snd_page_alloc usbhid usbserial
>> snd_timer snd hid soundcore mv_cesa cryptodev(O) ipv6 autofs4
>> [   54.231214] [<c000d020>] (unwind_backtrace+0x0/0xe0) from
>> [<c03fd1d0>] (__schedule_bug+0x48/0x60)
>> [   54.240171] [<c03fd1d0>] (__schedule_bug+0x48/0x60) from
>> [<c0401258>] (__schedule+0x4c/0x4bc)
>> [   54.248773] [<c0401258>] (__schedule+0x4c/0x4bc) from [<c003b470>]
>> (__cond_resched+0x24/0x34)
>> [   54.257365] [<c003b470>] (__cond_resched+0x24/0x34) from
>> [<c040175c>] (_cond_resched+0x3c/0x44)
>> [   54.266134] [<c040175c>] (_cond_resched+0x3c/0x44) from
>> [<c0010288>] (do_alignment+0x29c/0x784)
>> [   54.274895] [<c0010288>] (do_alignment+0x29c/0x784) from
>> [<c00083d8>] (do_DataAbort+0x34/0x98)
>
> This is actually a known problem... and I have a patch which resolves it
> but I've lost track of where things are with that patch through being
> distracted by modern platforms... that said, it does seem to be pointing
> at a problem which can be sorted in the driver which makes it more
> efficient on ARM hardware.
>
>> diff -ruN a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
>> b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
>> --- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c 2012-11-05
>> 03:57:06.000000000 -0500
>> +++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c 2012-11-13
>> 12:54:28.000000000 -0500
>> @@ -55,8 +55,8 @@
>>     NUM_STA + 4);
>>   if (pstapriv->pallocated_stainfo_buf == NULL)
>>   return _FAIL;
>> - pstapriv->pstainfo_buf = pstapriv->pallocated_stainfo_buf + 4 -
>> - ((addr_t)(pstapriv->pallocated_stainfo_buf) & 3);
>> + pstapriv->pstainfo_buf = pstapriv->pallocated_stainfo_buf + 8 -
>> + ((addr_t)(pstapriv->pallocated_stainfo_buf) & 7);
>
> Are you sure this is safe?  Is the allocated buffer large enough for
> those additional 4 bytes of alignment you're adding?

I'm not certain on that, I bumped the allocations at Andrew's
suggestion, but don't know enough to certify the changes as 100%
correct.
