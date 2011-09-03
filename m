Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1ICBLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 21:11:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35580 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752326Ab1ICBLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 21:11:04 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18LKEp2aagLgLx68ygyXf6W9jQY8NX0TBOEIe+Aqp
	1nZBZLU6+0lBgq
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Bernie Thompson <bernie@plugable.com>, Martin Decky <martin@decky.cz>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [RFC v2] allow multiple concurrent visible displays
Date: Sat,  3 Sep 2011 01:29:19 +0000
Message-Id: <1315013361-3191-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this is the second version of my multi-display support.

Compared to the first version:
The bug reported in the first patch that prevented booting when 
"fbcon=cmap:01" was given is fixed (annoying NULL pointer in vc)
and a dummy vc_display_fg management was added to prevent 
modifying vc structures we do not "own".
The second patch is new and a hack that allows graphic and console 
applications to work concurrently.

Background:
At the moment only one display (in multi-display setups) will be 
updated when
(1) multiple console applications run on different displays
(2) a graphic application runs in the active vt on one display and a 
    console application on another display
(3) multiple graphic (framebuffer) applications run on different
    displays (usually)

The first patch fixes (1) and I'm pretty happy with it. Works well 
for me except rarely cursor visibility glitches but that might be a 
bug somewhere else.

(2) requires some sort of policy change. At the moment we forbid 
any console from working just because on one vt a graphic 
application started. Obviously that's not what I want and also not 
what most applications require. Therefore changing it to only allow 
the application to use the graphic resource associated with the vt 
it switches to KD_GRAPHIC seems reasonable to me. If there are 
concerns about compatiblity we could make this change an option or 
introduce a new KD_PGRAPHICS which behaves as I want (though the 
last one would be ugly and require changing all userspace to work).
My second patch gives this functionality but I do not expect it to 
be acceptable as is. At first I wanted to revert f700d6e5 but for 
some reason the result did not even boot so I hacked my way around 
it. Basically my question here aside the policy change is why do we 
blank when entering graphics mode and why do we not allow updates 
to other consoles when one is blanked?

(3) is a completly different beast which will probably require 
changes in userspace applications. Most framebuffer applications at 
the moment just access the framebuffer if they are in the current 
vt and stop on vt change. To make this working concurrently the 
applications would need a way to get a notification when its 
visibility changes. As this one requires much more work and thought 
than the (1) and (2) I'll at first concentrate on solving those.
But if anyone has any suggestions on this one I'd be verry happy.


Best regards,

Florian Tobias Schandinat


Florian Tobias Schandinat (2):
  fbdev: allow multiple concurrent visible consoles
  vt: dirty hack

 drivers/tty/vt/vt.c           |    4 +---
 drivers/video/console/fbcon.c |   34 ++++++++++++++++++++++++++++++----
 drivers/video/console/fbcon.h |    1 +
 3 files changed, 32 insertions(+), 7 deletions(-)

