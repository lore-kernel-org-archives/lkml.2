Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0GETqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 15:46:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50960 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab0GETqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 15:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=vJYtBCb073OnrqJCnsDemGZNGA543t1DWvyFHBJrR/wl1461mVLG13BH/2SBA00+O+
         eQYro+yRtsAnHfTfZUuwjuZqGxw60+jRK/zLLXSNVZN73Fq2/9zgYf7p/ZzYH4/NUcYE
         GlcHH+O6h5AeKB5l7SwmQxgLwY2+05+jLD9m0=
Date: Mon, 5 Jul 2010 22:46:27 +0300
From: =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: ata: failed to IDENTIFY / SRST failed (errno = -16) problems
 on/after booting 2.6.35-rc3
Message-ID: <20100705224627.3a158e8c@debian>
In-Reply-To: <20100627232347.2f1dc4fd@debian>
References: <20100627232347.2f1dc4fd@debian>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jun 2010 23:23:47 +0300
Török Edwin <edwintorok@gmail.com> wrote:

> Hi,
> 
> Using 2.6.35-rc3 I noticed this in my dmesg (see end of email for full dmesg output)
> [28144.351747] ata9: drained 65536 bytes to clear DRQ.
> [28144.460834] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> [28144.460838] sr 8:0:1:0: CDB: Prevent/Allow Medium Removal: 1e 00 00
> 00 00 00 [28144.460846] ata9.01: cmd
> a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0 [28144.460846]          res
> 7f/7f:7f:7f:7f:7f/00:00:00:00:00/7f Emask 0x3 (HSM violation)
> [28144.460849] ata9.01: status: { DRDY DF DRQ ERR } [28144.460867]
> ata9: soft resetting link
> ....
> [32977.433092] ata9: EH complete

The problem has just become worse:
 - an error occurs on ata9 during boot, taking several minutes to bring
   up the link:

Jul  5 09:41:49 debian kernel: [   15.824148] ata9.01: qc timeout (cmd
0xa1)
Jul  5 09:41:49 debian kernel: [   15.824155] ata9.01: failed to
IDENTIFY (I/O error, err_mask=0x4)
Jul  5 09:41:49 debian kernel: [   20.864007] ata9: link is slow to
respond, please be patient (ready=0)
Jul  5 09:41:49 debian kernel: [   25.848007] ata9: device not ready
(errno=-16), forcing hardreset
Jul  5 09:41:49 debian kernel: [   31.044007] ata9: link is slow to
respond, please be patient (ready=0)
Jul  5 09:41:49 debian kernel: [   41.056006] ata9: link is slow to
respond, please be patient (ready=0)
Jul  5 09:41:49 debian kernel: [   51.068007] ata9: link is slow to
respond, please be patient (ready=0)
Jul  5 09:41:49 debian kernel: [   74.492148] ata9.00: qc timeout (cmd
0xa1)
Jul  5 09:41:49 debian kernel: [   74.492154] ata9.00: failed to
IDENTIFY (I/O error, err_mask=0x4)
Jul  5 09:41:49 debian kernel: [   79.532006] ata9: link is slow to
respond, please be patient (ready=0)
Jul  5 09:41:49 debian kernel: [   84.516007] ata9: device not ready
(errno=-16), forcing hardreset
Jul  5 09:41:49 debian kernel: [   89.712006] ata9: link is slow to
respond, please be patient (ready=0)
Jul  5 09:41:49 debian kernel: [   99.724007] ata9: link is slow to
respond, please be patient (ready=0)
Jul  5 09:41:49 debian kernel: [  109.736007] ata9: link is slow to
respond, please be patient (ready=0)
Jul  5 09:41:49 debian kernel: [  138.184642] ata9.00: ATAPI: ASUS
CRW-5232AS, 1.01, max UDMA/33
Jul  5 09:41:49 debian kernel: [  138.192670] ata9.00: configured for
UDMA/33

   - sometimes the link never comes up (well never is ~5m, I
didn't wait longer). it just keeps trying to reset the link saying
that SRST failed with errno -16 ... endlessly, hence booting is
impossible.

This is bad: the CDROM is not required to successfully boot (in this
case anyway), the kernel should IMHO just try reestablishing that link
in a background thread and finish booting normally.

Note that while this DID started to occur soon after I installed
2.6.35-rc3 (like 1 bisection run + 5 more boots later), if I now try to
boot 2.6.34 the same thing happens (i.e. link resets endlessly on boot).
This has NEVER happened with a kernel <2.6.35-rc3 though .. until
now.

Also I noticed that the BIOS sometimes hanged during boot (probably
trying to establish a link to the CDROM too), resetting it a couple of
times allowed it to reach Linux, but then Linux hanged.
It could be a hardware failure of the CDROM that just happened to occur
after I installed 2.6.35-rc3, I don't know.

For now I pulled out the power+data cables from my 2 CDROMs so I can at
least boot. That of course made all these problems go away.

When I have some more time I'll try plugging back the 2 CDROMs one at a
time, exchange the cables, etc. to see if it is a problem with one of
the CDROM drives themselves.

In the meantime are there any debug messages I can enable for the next
time I try booting with the CDROMs?
Is there any diagnostic I can run from Linux to tell where the problem
is:
 - the JMicron PATA controller?
 - the cables?
 - the CDROM drive(s) themselves?
 
Best regards,
--Edwin
