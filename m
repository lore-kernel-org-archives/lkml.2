Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1K3XPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 18:15:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab1K3XPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 18:15:52 -0500
Date: Wed, 30 Nov 2011 15:15:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@laptop.org>
Cc: x86@kernel.org, mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        dilinger@queued.net, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH resend 2] x86, olpc-xo15-sci: Enable lid close wakeup
 control through sysfs
Message-Id: <20111130151551.97371bdb.akpm@linux-foundation.org>
In-Reply-To: <20111129222447.E56959D401E@zog.reactivated.net>
References: <20111129222447.E56959D401E@zog.reactivated.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 22:24:47 +0000 (GMT)
Daniel Drake <dsd@laptop.org> wrote:

> Like most systems, OLPC's ACPI LID switch wakes up the system when the
> lid is opened, but not when it is closed.
> 
> Under OLPC's opportunistic suspend model, the lid may be closed while
> the system was oportunistically suspended with the screen running.
> In this event, we want to wake up to turn the screen off.
> 
> Enable control of normal ACPI wakeups through lid close events through
> a new sysfs attribute "lid_wake_on_closed". When set, and when
> LID wakeups are enabled through ACPI, the system will wake up on both
> open and close lid events.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  arch/x86/platform/olpc/olpc-xo15-sci.c |   55 ++++++++++++++++++++++++++++++++
>  1 files changed, 55 insertions(+), 0 deletions(-)
> 
> Resending after 6 weeks with no feedback.
> 
> diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
> index 2b235b7..649230c 100644
> --- a/arch/x86/platform/olpc/olpc-xo15-sci.c
> +++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
> @@ -24,6 +24,50 @@
>  #define XO15_SCI_DEVICE_NAME		"OLPC XO-1.5 SCI"
>  
>  static unsigned long xo15_sci_gpe;
> +static bool lid_wake_on_close;

I'd have thought that a few code comments which describe what all this
is doing wouldn't hurt.  Oh well.

> +static int set_lid_wake_behavior(bool wake_on_close)
> +{
> +	struct acpi_object_list arg_list;
> +	union acpi_object arg;
> +	acpi_status status;
> +
> +	arg_list.count = 1;
> +	arg_list.pointer = &arg;
> +	arg.type = ACPI_TYPE_INTEGER;
> +	arg.integer.value = wake_on_close;
> +	status = acpi_evaluate_object(NULL, "\\_SB.PCI0.LID.LIDW", &arg_list,
> +				      NULL);
> +	if (ACPI_FAILURE(status)) {
> +		pr_warning(PFX "failed to set lid behaviour\n");
> +		return 1;
> +	}
> +
> +	lid_wake_on_close = wake_on_close;
> +	return 0;
> +}
> +
> +static ssize_t lid_wake_on_close_show(struct kobject *s,
> +				      struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%u\n", lid_wake_on_close);
> +}
> +
> +static ssize_t lid_wake_on_close_store(struct kobject *s,
> +				       struct kobj_attribute *attr,
> +				       const char *buf, size_t n)
> +{
> +	unsigned int val;
> +	if (!sscanf(buf, "%u", &val) == 1)
> +		return -EINVAL;
> +
> +	set_lid_wake_behavior(!!val);
> +	return n;
> +}

Let me fix that for you.

--- a/arch/x86/platform/olpc/olpc-xo15-sci.c~x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix
+++ a/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -58,7 +58,8 @@ static ssize_t lid_wake_on_close_store(s
 				       const char *buf, size_t n)
 {
 	unsigned int val;
-	if (!sscanf(buf, "%u", &val) == 1)
+
+	if (sscanf(buf, "%u", &val) != 1)
 		return -EINVAL;
 
 	set_lid_wake_behavior(!!val);

It's kinda irritating that this will cheerfully accept bogus input of
the form "42foo".  This happens about eleven billion times in sysfs
write() handlers but afaik we've never implemented a nice
sysfs_int_from_buffer() thingy which handles all the possible errors.
