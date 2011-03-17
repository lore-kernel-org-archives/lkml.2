Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1CQCXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:23:44 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:42180 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1CQCXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:23:37 -0400
Message-ID: <4D81708D.5090607@linux.vnet.ibm.com>
Date: Wed, 16 Mar 2011 23:23:09 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Huewe <huewe.external.infineon@googlemail.com>
Subject: [GIT PULL] TPM driver robustness fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11031702-2362-0000-0000-00000234E10E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,


The following changes since commit 2e270d84223262a38d4755c61d55f5c73ea89e56:

   Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2011-03-16 13:26:17 -0700)

are available in the git repository at:

   git://tpmdd.git.sourceforge.net/gitroot/tpmdd/tpmdd/ for-james

Peter Huewe (3):

       This patch changes the call of tpm_transmit by supplying the size of the userspace buffer instead of TPM_BUFSIZE

       This patch fixes information leakage to the userspace by initializing the data buffer to zero

       Since the buffer might contain security related data it might be a good idea to zero the buffer after we have copied it to userspace.

  drivers/char/tpm/tpm.c |    7 ++++---

  1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c

index 1f46f1c..c6d2cde 100644

--- a/drivers/char/tpm/tpm.c

+++ b/drivers/char/tpm/tpm.c

@@ -427,7 +427,7 @@ static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,

      goto out;

  

  out_recv:

-    rc = chip->vendor.recv(chip, (u8 *) buf, bufsiz);

+    rc = chip->vendor.recv(chip, (u8 *) buf, TPM_BUFSIZE);

      if (rc<  0)

          dev_err(chip->dev,

              "tpm_transmit: tpm_recv: error %zd\n", rc);

@@ -980,7 +980,7 @@ int tpm_open(struct inode *inode, struct file *file)

          return -EBUSY;

      }

  

-    chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);

+    chip->data_buffer = kzalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);

      if (chip->data_buffer == NULL) {

          clear_bit(0,&chip->is_open);

          put_device(chip->dev);

@@ -1035,7 +1035,7 @@ ssize_t tpm_write(struct file *file, const char __user *buf,

      }

  

      /* atomic tpm command send and result receive */

-    out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);

+    out_size = tpm_transmit(chip, chip->data_buffer, in_size);

  

      atomic_set(&chip->data_pending, out_size);

      mutex_unlock(&chip->buffer_mutex);

@@ -1064,6 +1064,7 @@ ssize_t tpm_read(struct file *file, char __user *buf,

          mutex_lock(&chip->buffer_mutex);

          if (copy_to_user(buf, chip->data_buffer, ret_size))

              ret_size = -EFAULT;

+        memset(chip->data_buffer, 0, ret_size);

          mutex_unlock(&chip->buffer_mutex);

      }

  

