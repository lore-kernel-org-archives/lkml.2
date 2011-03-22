Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1CVQIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:08:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55581 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab1CVQIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:08:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hD+U548JXlnJ2XhseDGKBkXwMonTk8VqNqohEindcDhGnJql8Vjo//63OaDmuQGNGF
         TAKC3l12ID8HY6jjMlQvolHW9oVvttdOD4/LcOgJZ/gtcgSGlaXruFR9LR8mcg4J2ik/
         6/B0GxjXwpAK/870BoBtxNpVzVRJEQV5m6gHs=
MIME-Version: 1.0
In-Reply-To: <4D88A12D.60301@linux.vnet.ibm.com>
References: <4D81708D.5090607@linux.vnet.ibm.com>
	<alpine.LRH.2.00.1103220956350.14837@tundra.namei.org>
	<AANLkTimS1ss=977x3d-7Wcpj0wGthzW3_G+wqF1wQMc3@mail.gmail.com>
	<AANLkTi=uZME7Pr761VJkEiJYFp7L3iexjV3JeMmL63it@mail.gmail.com>
	<4D88A12D.60301@linux.vnet.ibm.com>
Date: Tue, 22 Mar 2011 17:08:21 +0100
Message-ID: <AANLkTi=+QFL5aMym68Dx=Vgomy9MQRV1AB1AreTua_mW@mail.gmail.com>
Subject: Re: [GIT PULL] TPM driver robustness fixes
From: Peter Huewe <huewe.external.infineon@googlemail.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 2:16 PM, Rajiv Andrade
<srajiv@linux.vnet.ibm.com> wrote:
> On 03/22/2011 09:58 AM, Peter Huewe wrote:
>>
>>> Consider what happens in memset if copy_to_user fails.
>>
>> Sorry I don't see it. Can you please clearify the problem for me?
>>
> memset() is called with the count parameter being a negative value,
> ret_size=-EFAULT.

You're right - sorry.

Do you prefer a temporary variable like this

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index d184d75..d3976f5 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1051,7 +1051,7 @@ ssize_t tpm_read(struct file *file, char __user *buf,
                 size_t size, loff_t *off)
 {
        struct tpm_chip *chip = file->private_data;
-       ssize_t ret_size;
+       ssize_t ret_size, tmp_size;

        del_singleshot_timer_sync(&chip->user_read_timer);
        flush_work_sync(&chip->work);
@@ -1061,9 +1061,11 @@ ssize_t tpm_read(struct file *file, char __user *buf,
                if (size < ret_size)
                        ret_size = size;

+               tmp_size = ret_size;
                mutex_lock(&chip->buffer_mutex);
                if (copy_to_user(buf, chip->data_buffer, ret_size))
                        ret_size = -EFAULT;
+               memset(chip->data_buffer, 0, tmp_size);
                mutex_unlock(&chip->buffer_mutex);
        }


Or an if else like this:

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index d184d75..571c0ca 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1062,8 +1062,12 @@ ssize_t tpm_read(struct file *file, char __user *buf,
                        ret_size = size;

                mutex_lock(&chip->buffer_mutex);
-               if (copy_to_user(buf, chip->data_buffer, ret_size))
+               if (copy_to_user(buf, chip->data_buffer, ret_size)) {
+                       memset(chip->data_buffer, 0, ret_size);
                        ret_size = -EFAULT;
+               } else {
+                       memset(chip->data_buffer, 0, ret_size);
+               }
                mutex_unlock(&chip->buffer_mutex);
        }


Or rather:
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index d184d75..2f2f65e 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1052,6 +1052,7 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 {
        struct tpm_chip *chip = file->private_data;
        ssize_t ret_size;
+       int rc;

        del_singleshot_timer_sync(&chip->user_read_timer);
        flush_work_sync(&chip->work);
@@ -1062,8 +1063,11 @@ ssize_t tpm_read(struct file *file, char __user *buf,
                        ret_size = size;

                mutex_lock(&chip->buffer_mutex);
-               if (copy_to_user(buf, chip->data_buffer, ret_size))
+               rc = copy_to_user(buf, chip->data_buffer, ret_size);
+               memset(chip->data_buffer, 0, ret_size);
+               if (rc)
                        ret_size = -EFAULT;
+
                mutex_unlock(&chip->buffer_mutex);
        }



Thanks,
Peter
