Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2KFFqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 00:46:14 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62332 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab2KFFqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 00:46:09 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVN8qPTgiYKXaeKFJXLXMjLE=+=8Vev2otD3v1VMk+Ez_w@mail.gmail.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<s5hobjia6vj.wl%tiwai@suse.de>
	<20121031173728.GA18615@srcf.ucam.org>
	<s5h390utqv3.wl%tiwai@suse.de>
	<1351743715.21227.95.camel@linux-s257.site>
	<20121101131849.752df6fd@pyramind.ukuu.org.uk>
	<s5hip9k9dng.wl%tiwai@suse.de>
	<s5hhap49den.wl%tiwai@suse.de>
	<CACVXFVN8qPTgiYKXaeKFJXLXMjLE=+=8Vev2otD3v1VMk+Ez_w@mail.gmail.com>
Date: Tue, 6 Nov 2012 13:46:08 +0800
Message-ID: <CAGLnvc_2-ZbzFP16bdNar2x8bp8F-uU+NunHOEeg_jtOSohh_A@mail.gmail.com>
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
From: lee joey <joeyli.kernel@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, joeyli <jlee@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/6 Ming Lei <tom.leiming@gmail.com>:
> On Tue, Nov 6, 2012 at 1:18 AM, Takashi Iwai <tiwai@suse.de> wrote:
>>
>> To be noted, it doesn't support the firmwares via udev but only the
>> direct loading, and the check for built-in firmware is missing, too.
>
> Generally, both direct loading and udev may request one same firmware
> image. And after check failed, current firmware load will fallback on udev
> to complete loading, so looks a check-failed firmware still can be loaded
> into kernel no matter if there is firmware signature check or not.
>
>
> Thanks,
> --
> Ming Lei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

The udev direct write firmware through data attribute, maybe we can do
the same signature verification in firmware_data_write? The following
patch didn't test yet.


Thanks
Joey Lee

>From 035dde5fadc9e7f4b7811b18d3a5094ef88e8bbb Mon Sep 17 00:00:00 2001
From: Lee, Chun-Yi <jlee@suse.com>
Date: Tue, 6 Nov 2012 13:07:04 +0800
Subject: [PATCH] firmware: Add signature check to firmware_data_write

---
 drivers/base/firmware_class.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8945f4e..40d8cc6 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -621,6 +621,7 @@ static ssize_t firmware_data_write(struct file
*filp, struct kobject *kobj,
        struct firmware_priv *fw_priv = to_firmware_priv(dev);
        struct firmware_buf *buf;
        ssize_t retval;
+       bool success = false;

        if (!capable(CAP_SYS_RAWIO))
                return -EPERM;
@@ -655,6 +656,23 @@ static ssize_t firmware_data_write(struct file
*filp, struct kobject *kobj,
        }

        buf->size = max_t(size_t, offset, buf->size);
+
+#ifdef CONFIG_FIRMWARE_SIG
+       for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
+               snprintf(path, PATH_MAX, "%s/%s.sig", fw_path[i], buf->fw_id);
+               if (verify_signature(buf, path))
+                       success = true;
+       }
+       if (!success) {
+               pr_err("Invalid signature file %s\n", path);
+               if (sig_enforce) {
+                       vfree(buf->data);
+                       buf->data = NULL;
+                       buf->size = 0;
+               }
+               retval = -ENOENT;
+       }
+#endif /* CONFIG_FIRMWARE_SIG */
 out:
        mutex_unlock(&fw_lock);
        return retval;
-- 
1.6.4.2
