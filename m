Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab2GYMfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:35:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917Ab2GYMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:35:31 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFypmnk8S4JkLui1Z7JxKae=-k88K-wEP9xDwrf1LOX-Vw@mail.gmail.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<CA+55aFzKu6xhTPmKPTg+p36Su0GkZgzGWpnvhpsFXJzhp=R16w@mail.gmail.com>
	<CACVXFVMeRQ-Fwk03uVg5LOH193PF+AyCoAAxmXDpqjeZXi7nxw@mail.gmail.com>
	<CA+55aFypmnk8S4JkLui1Z7JxKae=-k88K-wEP9xDwrf1LOX-Vw@mail.gmail.com>
Date: Wed, 25 Jul 2012 20:35:28 +0800
Message-ID: <CACVXFVOiXRiqRsE46_xmOzK_dExNvkBaJVwjiZ9adhwqRRwY+g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC usb guys and list

On Wed, Jul 25, 2012 at 1:53 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I really think the isight thing is a totally different thing entirely.
>
> And quite frankly, that's just a BUG in the USB implementation. If the
> USB ID changes, it shouldn't be considered a "resume" thing at all,
> but a probe thing, and that should not be done in early resume - it
> should be done *after* the resume is done.

IMO, usbcore may have found the ID changes during resume(reset_resume),
and make the device disconnect. The disconnect event will be handled
in hubd kthread, which is woken up before usermodehelper_enable()(see
thaw_processes), so request_firmware will return failure during probe()
inside hubd kthread.

The cache firmware patch set may not help the situation, because the
original isight usb device for downloading firmware has been disconnected
before system suspend, so firmware loader can't cache the firmware for
the device.

The below patch should fix the problem above.

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 19db29f..eb8355f 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -185,16 +185,18 @@ void thaw_processes(void)

 	printk("Restarting tasks ... ");

-	thaw_workqueues();
-
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
-		__thaw_task(p);
+		if (!(p->flags & (PF_KTHREAD | PF_WQ_WORKER)))
+			__thaw_task(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);

 	usermodehelper_enable();

+	/* let kthread see usermodehelper enabled flag */
+	thaw_kernel_threads();
+
 	schedule();
 	printk("done.\n");
 }


Thanks,
--
Ming Lei
