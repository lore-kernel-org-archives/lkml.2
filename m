Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab1HSIj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 04:39:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40184 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1HSIjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 04:39:25 -0400
MIME-Version: 1.0
In-Reply-To: <op.v0esx9lx3l0zgt@mnazarewicz-glaptop>
References: <1313659726-9406-1-git-send-email-per.forlin@stericsson.com>
	<op.v0esx9lx3l0zgt@mnazarewicz-glaptop>
Date: Fri, 19 Aug 2011 10:39:24 +0200
Message-ID: <CAJ0pr18LYtsPXghNeL_z4qvpd9Td3KtGR4R-x2dfu8s_S+dfYg@mail.gmail.com>
Subject: Re: [PATCH v4] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
From: Per Forlin <per.forlin@linaro.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Per Forlin <per.forlin@stericsson.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/18 Michal Nazarewicz <mina86@mina86.com>:
> On Thu, 18 Aug 2011 11:28:46 +0200, Per Forlin wrote:
>>
>> diff --git a/drivers/usb/gadget/f_mass_storage.c
>> b/drivers/usb/gadget/f_mass_storage.c
>> index 5b93395..3e546d9 100644
>> --- a/drivers/usb/gadget/f_mass_storage.c
>> +++ b/drivers/usb/gadget/f_mass_storage.c
>> @@ -363,7 +363,6 @@ struct fsg_common {
>>        struct fsg_buffhd       *next_buffhd_to_fill;
>>        struct fsg_buffhd       *next_buffhd_to_drain;
>> -       struct fsg_buffhd       buffhds[FSG_NUM_BUFFERS];
>>        int                     cmnd_size;
>>        u8                      cmnd[MAX_COMMAND_SIZE];
>> @@ -407,6 +406,8 @@ struct fsg_common {
>>        char inquiry_string[8 + 16 + 4 + 1];
>>        struct kref             ref;
>> +       /* Must be the last entry */
>> +       struct fsg_buffhd       buffhds[0];
>
> I would rather see it as “struct fsg_buffhd *buffhds;” since this change
> requires both mass_storage.c and multi.c to be changed.
>
If the allocation of buffhds is done separately in fsg_common_init().
mass_storage.c and multi.c doesn't need to be changed. But it's little
tricky to know whether buffhds should be allocated or not.

if (!common->buffhds)
  common->buffhds = kzalloc()
This works fine if the common is declared static since all data is 0
by default. If common is allocated by kmalloc and then passed to
fsg_commin_init() this check isn't reliable.
memset of common will erase buffhds pointer as well. A minor issue,
storing this pointer before running memset will fix it. I would like
to propose a different approach.

+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -363,7 +363,7 @@ struct fsg_common {
-	struct fsg_buffhd	buffhds[FSG_NUM_BUFFERS];
+	struct fsg_buffhd	buffhds[CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS];

+++ b/drivers/usb/gadget/file_storage.c
@@ -461,7 +461,7 @@ struct fsg_dev {
-	struct fsg_buffhd	buffhds[FSG_NUM_BUFFERS];
+	struct fsg_buffhd	buffhds[CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS];

+++ b/drivers/usb/gadget/storage_common.c
@@ -52,6 +52,12 @@
+/*
+ * There is a num_buffers module param when USB_GADGET_DEBUG is defined.
+ * This parameter sets the length of the fsg_buffhds array.
+ * The valid range of num_buffers is:
+ * num >= 2 && num <= CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS.
+ */

+#ifdef CONFIG_USB_GADGET_DEBUG_FILES
I am in favor of #ifdef some Kconfig option. This simplifies for
automated build/tests farms where def_configs are being used to
configure the system.
This option should not affect the performance significantly.

+
+static unsigned int fsg_num_buffers = CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS;
+module_param_named(num_buffers, fsg_num_buffers, uint, S_IRUGO);
+MODULE_PARM_DESC(fsg_num_buffers, "Number of pipeline buffers");
+
+#else
+
+/*
+ * Number of buffers we will use.
+ * 2 is usually enough for good buffering pipeline
+ */
+#define fsg_num_buffers	CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS
+
+#endif /* CONFIG_USB_DEBUG */
+
+#define FSG_NUM_BUFFERS_IS_VALID(num) ((num) >= 2 && \
+		(num) <= CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS)

Keep the length of the buffhds array constant. Use a variable
fsg_num_buffers when iterating that array.
This minimize the code to change. But to the price of using
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS to declare
and fsg_num_buffers to access.

Is this proposal better or worse?

Thanks,
Per
