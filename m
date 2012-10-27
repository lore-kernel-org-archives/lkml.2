Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2J0MNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 08:13:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57131 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2J0MNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 08:13:08 -0400
Message-ID: <508BCFCF.70101@suse.cz>
Date: Sat, 27 Oct 2012 14:13:03 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Randy Dunlap <rdunlap@xenotime.net>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        linux-next@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: mmotm 2012-10-24-17-15 uploaded (uml)
References: <20121025001628.1DEDE100047@wpzn3.hot.corp.google.com> <50889347.4070801@xenotime.net> <20121025134850.76cdb390565dfe5117bdef7e@canb.auug.org.au>
In-Reply-To: <20121025134850.76cdb390565dfe5117bdef7e@canb.auug.org.au>
X-Enigmail-Version: 1.5a1pre
Content-Type: multipart/mixed;
 boundary="------------060203010301090301010206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060203010301090301010206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 10/25/2012 04:48 AM, Stephen Rothwell wrote:
> Hi Randy,
> 
> On Wed, 24 Oct 2012 18:17:59 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>>
>> uml on x86_64 defconfig:
>>
>> arch/um/drivers/chan_kern.c: In function 'tty_receive_char':
>> arch/um/drivers/chan_kern.c:89:42: error: 'struct tty_struct' has no member named 'raw'

Hmm, that code looks doing weird stuff. This patch should fix it. But
I'm not sure why it was there at all, as n_tty should take care of the
raw case perfectly right away. I cannot find any clues in the git log as
to why it was added at all. It's there like since ever.

Could anybody with working UML (I'm unable to run UML ATM, it crashes
heavily during the bootup -- after terminals are shown) check whether
the patch actually works?

thanks,
-- 
js
suse labs

--------------060203010301090301010206
Content-Type: text/x-patch;
 name="0001-UM.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-UM.patch"

>From 3f60aa996467bf4a1bd4e62f80cb714ea6569fde Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Thu, 25 Oct 2012 16:40:59 +0200
Subject: [PATCH] UM:

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/um/drivers/chan_kern.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index c3bba73..e9a0abc 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -83,21 +83,8 @@ static const struct chan_ops not_configged_ops = {
 
 static void tty_receive_char(struct tty_struct *tty, char ch)
 {
-	if (tty == NULL)
-		return;
-
-	if (I_IXON(tty) && !I_IXOFF(tty) && !tty->raw) {
-		if (ch == STOP_CHAR(tty)) {
-			stop_tty(tty);
-			return;
-		}
-		else if (ch == START_CHAR(tty)) {
-			start_tty(tty);
-			return;
-		}
-	}
-
-	tty_insert_flip_char(tty, ch, TTY_NORMAL);
+	if (tty)
+		tty_insert_flip_char(tty, ch, TTY_NORMAL);
 }
 
 static int open_one_chan(struct chan *chan)
-- 
1.7.12.4


--------------060203010301090301010206--
