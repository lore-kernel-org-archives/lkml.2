Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0GND3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 23:29:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41044 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab0GND3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 23:29:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JGJ0h9MB7l7Ara5kqgEYTbERbxo61bca29I2O/cTaG06M2AnBNNzEa6//KuAxRYFjm
         YF7+i09vrQTkGTpMe36U9PfU/DZ11NGjnG+o9KTxTfyjy+op+lHqpZzlMRWKI2xjsvOf
         TsYG2lcOV+WGmQde6tTiC0TPlulVTr7U/GmBo=
MIME-Version: 1.0
In-Reply-To: <4C3D1F82.1040907@candelatech.com>
References: <4C3D067C.10507@candelatech.com>
	<4C3D101E.5010605@candelatech.com>
	<4C3D1942.1090207@gmail.com>
	<4C3D1F82.1040907@candelatech.com>
Date: Tue, 13 Jul 2010 21:29:50 -0600
Message-ID: <AANLkTinDv7I4v51j-Lev9Ry_3DyVVv58lAyCQXZV1CwB@mail.gmail.com>
Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected: 
	de08e2c26
From: Robert Hancock <hancockrwd@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
        jacob.jun.pan@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 8:22 PM, Ben Greear <greearb@candelatech.com> wrote:
>> Can you print out bus->number and devfn and look that up in lspci to
>> find out which device it's hitting? It looks like there's a device with
>> a PCI Express extended capability header that has a extended capability
>> ID of 0000h and a next capability offset of 100h, which points to
>> itself, causing the infinite loop. I'm guessing that if pcie_cap >> 20
>> <= pos then it should give up and break out of the loop, since it means
>> that the next capability pointer is invalidly pointing to the same or a
>> previous entry..
>
> Bailing out like that does let it boot.
>
> As for the bus and devfn:  bus: 0   devfn: 129 (decimal)
>
> I'm not sure what to look for in lspci, but here is the output with -n:

That will be device 0x10 function 1, this one:

00:10.1 0600: 8086:25f0 (rev b1)

Intel 5000 Series Chipset FSB Registers, apparently.. What does lspci
-vv show for that device?

>
> [root@ice-si-dmz ~]# lspci -n
> 00:00.0 0600: 8086:25d8 (rev b1)
> 00:02.0 0604: 8086:25f7 (rev b1)
> 00:04.0 0604: 8086:25f8 (rev b1)
> 00:06.0 0604: 8086:25f9 (rev b1)
> 00:08.0 0880: 8086:1a38 (rev b1)
> 00:10.0 0600: 8086:25f0 (rev b1)
> 00:10.1 0600: 8086:25f0 (rev b1)
> 00:10.2 0600: 8086:25f0 (rev b1)
> 00:11.0 0600: 8086:25f1 (rev b1)
> 00:13.0 0600: 8086:25f3 (rev b1)
> 00:15.0 0600: 8086:25f5 (rev b1)
> 00:16.0 0600: 8086:25f6 (rev b1)
> 00:1d.0 0c03: 8086:2688 (rev 09)
> 00:1d.1 0c03: 8086:2689 (rev 09)
> 00:1d.2 0c03: 8086:268a (rev 09)
> 00:1d.7 0c03: 8086:268c (rev 09)
> 00:1e.0 0604: 8086:244e (rev d9)
> 00:1f.0 0601: 8086:2670 (rev 09)
> 00:1f.1 0101: 8086:269e (rev 09)
> 00:1f.2 0106: 8086:2681 (rev 09)
> 00:1f.3 0c05: 8086:269b (rev 09)
> 01:00.0 0604: 8086:3500 (rev 01)
> 01:00.3 0604: 8086:350c (rev 01)
> 02:00.0 0604: 8086:3510 (rev 01)
> 02:02.0 0604: 8086:3518 (rev 01)
> 04:00.0 0200: 8086:1096 (rev 01)
> 04:00.1 0200: 8086:1096 (rev 01)
> 06:00.0 0604: 111d:8018 (rev 04)
> 07:00.0 0604: 111d:8018 (rev 04)
> 07:01.0 0604: 111d:8018 (rev 04)
> 08:00.0 0200: 8086:10a4 (rev 06)
> 08:00.1 0200: 8086:10a4 (rev 06)
> 09:00.0 0200: 8086:10a4 (rev 06)
> 09:00.1 0200: 8086:10a4 (rev 06)
> 0a:00.0 0604: 111d:8018 (rev 04)
> 0b:00.0 0604: 111d:8018 (rev 04)
> 0b:01.0 0604: 111d:8018 (rev 04)
> 0c:00.0 0200: 8086:10a4 (rev 06)
> 0c:00.1 0200: 8086:10a4 (rev 06)
> 0d:00.0 0200: 8086:10a4 (rev 06)
> 0d:00.1 0200: 8086:10a4 (rev 06)
> 0e:01.0 0300: 1002:515e (rev 02)
>
>
> Thanks,
> Ben
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
