Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1FLWMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 18:12:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42608 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab1FLWMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 18:12:46 -0400
MIME-Version: 1.0
In-Reply-To: <1307859728-3446-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1307859728-3446-1-git-send-email-benjamin.tissoires@enac.fr>
Date: Sun, 12 Jun 2011 17:12:45 -0500
Message-ID: <BANLkTi=878_nkp=BKF0MFKL5RniQCsrGNw@mail.gmail.com>
Subject: Re: [PATCH] hid-multitouch: fix broken eGalax
From: Chris Bagwell <chris@cnpbagwell.com>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 1:22 AM, Benjamin Tissoires
<benjamin.tissoires@enac.fr> wrote:
> Since the inclusion of eGalax devices in 2.6.39, I've got some
> bug reports for 480d and other devices.
> The problem lies in the reports descriptors: eGalax supports both
> pen and fingers, and so the reports descriptors contained both.
> But hid-multitouch relies on them to detect the last item in each
> field to send the multitouch events. In 480d, the last item is not
> Y as it should but Pressure. That means that the fields are not
> aligned and X,Y are at 0,0 (the other touch coordinates of the report).
>
> With this patch, the detection is made only when the field ContactID
> has been detected inside the collection.
>
> There is still a problem with the detections of the range as stylus
> and fingers may not have the same min/max, but it's a start.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>

This patch was good timing for me.  I was giving the latest
hid-multitouch a try on my MosArt touchscreen (0486:0186).  hid-mosart
was basically working but once merged into hid-multitouch,
hid-multitouch was not.

The symptom was once you touched screen, it acted like user never
released touch.

I tracked it down today to last_field_index being reset from 14 to 2
because of an unused extra input in descriptor that looked like a
mouse (X/Y and 2 buttons).  This to small index caused a delay of
sending valid data by 1 packet and since no packets sent after touch
release, you'd not get the release at appropriate time.

In my case, only the input with ContactID's are useful (there are 2
ContactID's spread between 2 collections) so this patch should prevent
last_field_index from being reset by the unused X/Y's.

Chris
