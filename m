Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1FRUwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 16:52:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64415 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab1FRUwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 16:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MEsvBXSxkrAdCiAUWYNTJN+sCXmyA05ZDnPpzJvxTAPIs3VwxH16HwgYURgRoOXoix
         y9nyUjBTDMkfzJJpE0GMzgu4RyNII977D5xXvSBgqTVExKnVfqzPChkTKl52P1froV2r
         c4ZKyrNw8hTjTO8j8H1aN1ElibaRp8BAvcPVE=
MIME-Version: 1.0
In-Reply-To: <BANLkTikpPzt3B6osydhd6BhiXUHAJsC3oA@mail.gmail.com>
References: <BANLkTi=o06eHLtFvmmz7c4TEjahy=EOrJQ@mail.gmail.com>
	<20110618133957.378b5266@farn.lan>
	<BANLkTikT3qoZhTrd0uF-JNehNhTCRjF6kw@mail.gmail.com>
	<BANLkTinf8X1AUEHteMnU3MMBEPEO1WNtzA@mail.gmail.com>
	<20110618150356.1b9e31cb@farn.lan>
	<BANLkTikpPzt3B6osydhd6BhiXUHAJsC3oA@mail.gmail.com>
Date: Sat, 18 Jun 2011 22:52:06 +0200
Message-ID: <BANLkTikopw_egOuA_jT+-e=DewR8FK9B8Q@mail.gmail.com>
Subject: Re: Lock up when faking MMIO read[bwl] on some machines [WAS: Faking
 MMIO ops? Fooling a driver]
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pekka Paalanen <pq@iki.fi>, David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 18 czerwca 2011 16:43 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> W dniu 18 czerwca 2011 14:03 użytkownik Pekka Paalanen <pq@iki.fi> napisał:
>> Maybe the driver is doing a 16-bit wide access, and happens to
>> store something else in the other 16/48 bits of RAX?
>
> OK, attached is updated version of my patch. I think we can get some
> clue from dmesgs with this patch applied.
>
>
> My system (working):
> [   74.472502] mmiotrace: ZAJEC: overwriting 0x27 with 0xFFFF
> [   74.472511] mmiotrace: [ZAJEC] opcode is 0x8B
> [   74.472515] mmiotrace: [ZAJEC] prf info: shorted:1; enlarged:0, rexr:0, rex:0
> [   74.472517] mmiotrace: [ZAJEC] register is 0x0
> [   74.472520] mmiotrace: [ZAJEC] overwritting 2-byte value 0x0514 with 0xFFFF
> [   74.472523] mmiotrace: [ZAJEC] overwritting resulted in 0xFFFF
>
> [   74.487081] mmiotrace: ZAJEC: overwriting 0x20 with 0xFFFF
> [   74.487086] mmiotrace: [ZAJEC] opcode is 0x8B
> [   74.487089] mmiotrace: [ZAJEC] prf info: shorted:1; enlarged:0, rexr:0, rex:0
> [   74.487092] mmiotrace: [ZAJEC] register is 0x0
> [   74.487095] mmiotrace: [ZAJEC] overwritting 2-byte value 0x427E with 0xFFFF
> [   74.487097] mmiotrace: [ZAJEC] overwritting resulted in 0xFFFF
>
>
> MacBook (with real overwritting commenet out!):
> [  228.248715] mmiotrace: ZAJEC: overwriting 0x810 with 0xFFFF
> [  228.254227] mmiotrace: [ZAJEC] opcode is 0xB70F
> [  228.259784] mmiotrace: [ZAJEC] prf info: shorted:0; enlarged:0, rexr:0, rex:0
> [  228.265399] mmiotrace: [ZAJEC] register is 0x0
> [  228.270955] mmiotrace: [ZAJEC] overwritting 4-byte value 0x00000000
> with 0xFFFF
> [  228.276597] mmiotrace: [ZAJEC] overwritting resulted in 0x00000000
>
> [  228.284284] mmiotrace: ZAJEC: overwriting 0x810 with 0xFFFF
> [  228.289818] mmiotrace: [ZAJEC] opcode is 0xB70F
> [  228.295250] mmiotrace: [ZAJEC] prf info: shorted:0; enlarged:0, rexr:0, rex:0
> [  228.300838] mmiotrace: [ZAJEC] register is 0x0
> [  228.306339] mmiotrace: [ZAJEC] overwritting 4-byte value 0x00000000
> with 0xFFFF
> [  228.311905] mmiotrace: [ZAJEC] overwritting resulted in 0x00000000
>
>
> It's 2-byte vs. 4-byte. I suspect this can be the source of our
> problem. Writing u16 0xFFFF value as u32 write.

Ohh, that was so stupid...

Writing 0xFFFF to PHY register 0x810 causes lockup on BCM4331! That's
all! My code is working fine, just some bits in 0xFFFF value are
really not friendly for the hardware.

-- 
Rafał
