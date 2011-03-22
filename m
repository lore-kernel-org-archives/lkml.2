Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1CVRW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:22:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab1CVRWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:22:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Oren Weil <oren.jer.weil@intel.com>
Subject: Re: [PATCH 1/7] char/mei: PCI device and char driver support.
Date: Tue, 22 Mar 2011 18:22:43 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@linux.intel.com,
        david@woodhou.se
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com> <1300791092-14319-2-git-send-email-oren.jer.weil@intel.com>
In-Reply-To: <1300791092-14319-2-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201103221822.43780.arnd@arndb.de>
X-Provags-ID: V02:K0:rwbRAz77NQpicqReJ7xNmIBVFX0NFpYQrdOdXZc0/VR
 LUA1CeLAbyDZp7mjZuXp9X0FNoGYiYjAFoSPIy0SUkWQcrvtMF
 GOE7xSj9O/1wq9b4SEUNzmj6NhP3d9TsXNbz8xIghTrYmT846t
 KNpxFWHhQAXMDxA60bnyNvBk1s012bkZL724zCBDlZ5sB/sU1z
 99yHrDje2gAzrvPdbmhxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 March 2011, Oren Weil wrote:
> +static ssize_t mei_read(struct file *file, char __user *ubuf,
> +                        size_t length, loff_t *offset)
> +{
> +       int i;
> +       int rets;
> +       int err;
> +       int if_num = iminor(file->f_dentry->d_inode);
> +       struct mei_file_private *file_ext = file->private_data;
> +       struct mei_cb_private *priv_cb_pos = NULL;
> +       struct mei_cb_private *priv_cb = NULL;
> +       struct mei_device *dev;
> +
> +       if (!mei_device)
> +               return -ENODEV;
> +
> +       dev = pci_get_drvdata(mei_device);
> +       if (if_num != MEI_MINOR_NUMBER || !dev || !file_ext)
> +               return -ENODEV;
> +

I'm very confused by this code and how you support multiple
instances of PCI devices, cb_list entries and concurrent connections:

* You look up a global pointer to mei_device, when there could
  be multiple PCI devices.

* You use the minor number of the chardev as an index throughout
  the code, but bail out if it does not match a constant.

* You walk a list of mei_cb_private entries when you should have
  just a single one for this file. In other places, you walk a list
  of mei_file_private entries.

I think you should try to document your data structures and how
they relate to each other, and remove all that turn out not to
be needed in the process.

>From the brief look I had at this rather complex code, I would
assume that it could look something like this:

* In the PCI probe function, create a misc character device for
  every instance you find behind each device. Remove the global
  variables and constants.

* Unify mei_file_private and mei_cb_private, allocate at open
  time but fill when the ioctl gets called.

Would that work, or am I missing something major?

	Arnd
