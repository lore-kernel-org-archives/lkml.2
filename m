Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab2GJEyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 00:54:21 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:36293 "HELO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751685Ab2GJEyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 00:54:18 -0400
Message-ID: <4FFBB575.6050602@liveu.tv>
Date: Tue, 10 Jul 2012 07:54:13 +0300
From: Shachar Shemesh <shachar@liveu.tv>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Subject: [PATCH] tty ldisc: Close/Reopen race prevention should
 check the proper flag
References: <4FEFF3DF.9000909@liveu.tv> <20120706212430.GA454@kroah.com> <4FF94BC6.3000704@liveu.tv> <20120709164402.GA14592@kroah.com>
In-Reply-To: <20120709164402.GA14592@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------070502080805050608020904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070502080805050608020904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/09/2012 07:44 PM, Greg KH wrote:
> Yes, that worked, but then I would have to edit the body to include the
> above information in the patch properly.
>
> So, care to resend it all in a "clean" format that I can apply it in?
>
> thanks,
>
> greg k-h

After a few tests, it seems the only reliable way to get my mailer to 
not munge the tabs is an attachment. I've included the entire details 
inside the attachment. Hopefully, that will be parsable to everyone.

Shachar

--------------070502080805050608020904
Content-Type: text/x-diff;
 name="pppduninterruptible.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pppduninterruptible.patch"

From: Shachar Shemesh <shachar@liveu.tv>

Commit acfa747b introduced the TTY_HUPPING flag to distinguish
closed TTY from currently closing ones. The test in tty_set_ldisc
still remained pointing at the old flag. This causes pppd to
sometimes lapse into uninterruptible sleep when killed and
restarted.

Signed-off-by: Shachar Shemesh <shachar@liveu.tv>
---
Tested with 3.2.20 kernel.

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 24b95db..a662a24 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -658,7 +658,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		goto enable;
 	}
 
-	if (test_bit(TTY_HUPPED, &tty->flags)) {
+	if (test_bit(TTY_HUPPING, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
 		clear_bit(TTY_LDISC_CHANGING, &tty->flags);

--------------070502080805050608020904--
