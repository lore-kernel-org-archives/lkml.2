Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab1GUOH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:07:56 -0400
Received: from ltw.loris.tv ([85.14.220.160]:60767 "EHLO ltw.loris.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1GUOHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:07:54 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jul 2011 10:07:53 EDT
Message-ID: <4E28313E.60900@drcomp.erfurt.thur.de>
Date: Thu, 21 Jul 2011 16:01:34 +0200
From: Adrian Knoth <adi@drcomp.erfurt.thur.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>
CC: General Discussion about Arch Linux <arch-general@archlinux.org>,
        Fons Adriaensen <fons@linuxaudio.org>, Takashi Iwai <tiwai@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [arch-general] Panic - no sound devices after upgrade
References: <20110719143758.GA15283@linuxaudio.org> <CAFEhRJf-5U=cS3iptpvGEVSHV+S=aBF_mWfWkC_QMRty_WnoPA@mail.gmail.com> <20110720131120.GA1836@linuxaudio.org> <CAFEhRJd9ZCSpx52S__vMdWK18mhMQrRoU9R5zNaZE=wksLRTvg@mail.gmail.com> <20110720153023.GA11502@linuxaudio.org> <CAFEhRJczj=_B7fK7GvBEnqpB2GJGnCnGkoA2w5vzbFfM2wAGZw@mail.gmail.com> <20110720163844.GB16901@linuxaudio.org> <CAG-2HqWqATSJ=oJTTvULXwPEG82yN+8e6GJFs759hPA-=krAOQ@mail.gmail.com> <20110721100944.GA13971@linuxaudio.org> <CAG-2HqX23C79vfccnu0tMqx+6K9Z5pS0_HekaLizQx7XfkPQ1Q@mail.gmail.com> <20110721112331.GA15059@linuxaudio.org> <CAG-2HqWK3x5-szkyzX8AMxuMpDZNVRXHYtQ0AkAPMsGcLK0Z9w@mail.gmail.com>
In-Reply-To: <CAG-2HqWK3x5-szkyzX8AMxuMpDZNVRXHYtQ0AkAPMsGcLK0Z9w@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------010609000806010908080601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010609000806010908080601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07/21/11 15:00, Tom Gundersen wrote:

Hi!

>>>>>> * The driver for my card (RME HDSP MADI, snd_hdpsm) is loaded.
>>>> [   48.057757] HDSPM: unknown firmware revision cc

> firmware revision is 0xCC, which is not recognised. If your card is
> MADI, the kernel expects the firmware revision to be 0xD2 (or starting
> in 3.0, it also accepts 0xCF).

Exactly.

> I guess this can be fixed easily by adding your firmware revision to
> the list of accepted revs.

I hope so, too. Please try the attached patch.


JFTR: You need at least ALSA-1.0.24 userland (or the corresponding
hdspm.h respectively) for the new driver (2.6.39 and above). Likewise,
if you intend to use hdspmixer, you need the yet unreleased 1.0.24.2
version of alsa-tools, so go for the git version:

   http://git.alsa-project.org/?p=alsa-tools.git


HTH

--------------010609000806010908080601
Content-Type: text/x-diff;
 name="hdspm-cc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hdspm-cc.patch"

diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 7222151..18d3424 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -521,6 +521,7 @@ MODULE_SUPPORTED_DEVICE("{{RME HDSPM-MADI}}");
 #define HDSPM_DMA_AREA_KILOBYTES (HDSPM_DMA_AREA_BYTES/1024)
 
 /* revisions >= 230 indicate AES32 card */
+#define HDSPM_MADI_ANCIENT_REV	204
 #define HDSPM_MADI_OLD_REV	207
 #define HDSPM_MADI_REV		210
 #define HDSPM_RAYDAT_REV	211
@@ -6484,6 +6485,7 @@ static int __devinit snd_hdspm_create(struct snd_card *card,
 	switch (hdspm->firmware_rev) {
 	case HDSPM_MADI_REV:
 	case HDSPM_MADI_OLD_REV:
+	case HDSPM_MADI_ANCIENT_REV:
 		hdspm->io_type = MADI;
 		hdspm->card_name = "RME MADI";
 		hdspm->midiPorts = 3;

--------------010609000806010908080601--
