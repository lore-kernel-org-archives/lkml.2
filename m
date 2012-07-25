Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab2GYRYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:24:05 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43841 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2GYRYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:24:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVOiXRiqRsE46_xmOzK_dExNvkBaJVwjiZ9adhwqRRwY+g@mail.gmail.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <CA+55aFzKu6xhTPmKPTg+p36Su0GkZgzGWpnvhpsFXJzhp=R16w@mail.gmail.com>
 <CACVXFVMeRQ-Fwk03uVg5LOH193PF+AyCoAAxmXDpqjeZXi7nxw@mail.gmail.com>
 <CA+55aFypmnk8S4JkLui1Z7JxKae=-k88K-wEP9xDwrf1LOX-Vw@mail.gmail.com> <CACVXFVOiXRiqRsE46_xmOzK_dExNvkBaJVwjiZ9adhwqRRwY+g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 Jul 2012 10:23:40 -0700
X-Google-Sender-Auth: 9KqzdKVDoeqTmy2i58_ra4JTaLA
Message-ID: <CA+55aFxF_nSEZGp8h4oXhusJgQ+dvjNL2eMurJMaJFQMPCbu9g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
To: Ming Lei <ming.lei@canonical.com>
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

On Wed, Jul 25, 2012 at 5:35 AM, Ming Lei <ming.lei@canonical.com> wrote:
>
> The below patch should fix the problem above.

Actually, I think we could make this even simpler.

There's nothing wrong with saying "user mode is enabled" *just* before
we unthaw things, if we also simply guarantee that there is no
sleeping lock or similar that we might get caught on (causing a
deadlock or other untimely waking) before we've actually thawed
everything.

So *if* the only problem wrt the USB hub code comes from this area,
then I think the solution might be as simple as just moving the
"usermodehelper_enable()" up a few lines, with a comment. Something
like the *untested* and whitespace-damaged thing below..

Rafael? Who has one of those isight things and has seen the warning to test?

               Linus

---
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 19db29f67558..5bf50e488196 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -181,6 +181,12 @@ void thaw_processes(void)
        pm_freezing = false;
        pm_nosig_freezing = false;

+       /*
+        * User mode helper are available again (or will be,
+        * modulo scheduling)
+        */
+       usermodehelper_enable();
+
        oom_killer_enable();

        printk("Restarting tasks ... ");
@@ -193,8 +199,6 @@ void thaw_processes(void)
        } while_each_thread(g, p);
        read_unlock(&tasklist_lock);

-       usermodehelper_enable();
-
        schedule();
        printk("done.\n");
 }
