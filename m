Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1DTKb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 06:31:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:52090 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab1DTKb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 06:31:27 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Dave Jones <davej@redhat.com>
Subject: Re: lockdep trace when unplugging usb audio (.39rc4)
Date: Wed, 20 Apr 2011 12:32:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc2-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
References: <20110419180745.GA438@redhat.com>
In-Reply-To: <20110419180745.GA438@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_MZrrNgLR8ubYekB"
Message-Id: <201104201232.44320.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_MZrrNgLR8ubYekB
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Am Dienstag, 19. April 2011, 20:07:45 schrieb Dave Jones:
> I get this trace when I unplug my NuForce uDAC.

Please test this patch.

	Regards
		Oliver

--Boundary-00=_MZrrNgLR8ubYekB
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-usb-audio-fix-potential-deadlock-on-unplug.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-usb-audio-fix-potential-deadlock-on-unplug.patch"

=46rom 24d036ccb418d7cfa5a821d5a70b3d3da2d63bb3 Mon Sep 17 00:00:00 2001
=46rom: Oliver Neukum <oliver@neukum.org>
Date: Wed, 20 Apr 2011 12:29:22 +0200
Subject: [PATCH] usb-audio:fix potential deadlock on unplug

Decrease the scope of a lock to fix a deadlock

Signed-off-by: Oliver Neukum <oneukum@suse.de>
=2D--
 sound/usb/card.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index a90662a..1d3d9f0 100644
=2D-- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -554,6 +554,7 @@ static void snd_usb_audio_disconnect(struct usb_device =
*dev, void *ptr)
 	mutex_lock(&chip->shutdown_mutex);
 	chip->shutdown =3D 1;
 	chip->num_interfaces--;
+	mutex_unlock(&chip->shutdown_mutex);
 	if (chip->num_interfaces <=3D 0) {
 		snd_card_disconnect(card);
 		/* release the pcm resources */
@@ -569,11 +570,9 @@ static void snd_usb_audio_disconnect(struct usb_device=
 *dev, void *ptr)
 			snd_usb_mixer_disconnect(p);
 		}
 		usb_chip[chip->index] =3D NULL;
=2D		mutex_unlock(&chip->shutdown_mutex);
 		mutex_unlock(&register_mutex);
 		snd_card_free_when_closed(card);
 	} else {
=2D		mutex_unlock(&chip->shutdown_mutex);
 		mutex_unlock(&register_mutex);
 	}
 }
=2D-=20
1.7.1


--Boundary-00=_MZrrNgLR8ubYekB--
