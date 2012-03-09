Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab2CIUPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:15:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62117 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031101Ab2CITtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:46 -0500
Message-Id: <20120309190208.356254146@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Akio Idehara <zbe64533@gmail.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [ 75/95] Input: ALPS - fix touchpad detection when buttons are pressed
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Akio Idehara <zbe64533@gmail.com>

commit 99c90ab31fad855b9da9dee3a5aa6c27f263e9d6 upstream.

ALPS touchpad detection fails if some buttons of ALPS are pressed.
The reason is that the "E6" query response byte is different from
what is expected.

This was tested on a Toshiba Portege R500.

Signed-off-by: Akio Idehara <zbe64533@gmail.com>
Tested-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/alps.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -421,7 +421,9 @@ static const struct alps_model_info *alp
 
 	/*
 	 * First try "E6 report".
-	 * ALPS should return 0,0,10 or 0,0,100
+	 * ALPS should return 0,0,10 or 0,0,100 if no buttons are pressed.
+	 * The bits 0-2 of the first byte will be 1s if some buttons are
+	 * pressed.
 	 */
 	param[0] = 0;
 	if (ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES) ||
@@ -437,7 +439,8 @@ static const struct alps_model_info *alp
 	psmouse_dbg(psmouse, "E6 report: %2.2x %2.2x %2.2x",
 		    param[0], param[1], param[2]);
 
-	if (param[0] != 0 || param[1] != 0 || (param[2] != 10 && param[2] != 100))
+	if ((param[0] & 0xf8) != 0 || param[1] != 0 ||
+	    (param[2] != 10 && param[2] != 100))
 		return NULL;
 
 	/*


