Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab0JWLka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:40:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40150 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab0JWLk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VlywWeaV7t1z360v2TY2ldLMxZ4h5gEh4kExwpV323VT0XdJn8J+Htiv05yVqsiuXM
         2ioJz8nEg0iA861iBWHEbmfx86pTfRzj5nKz5TEhdVMctPFihlagAMto/OMzrOOupePE
         ePNu4QeFfVfLQKnFPVvsZ2T9LDllRMBJ/MzDE=
Message-ID: <4CC2C9A8.1040003@suse.cz>
Date: Sat, 23 Oct 2010 13:40:24 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, "Dr. Werner Fink" <werner@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 28/49] tty: Add a new file /proc/tty/consoles
References: <20101022175112.GC13489@kroah.com> <1287771688-14805-28-git-send-email-gregkh@suse.de>
In-Reply-To: <1287771688-14805-28-git-send-email-gregkh@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 08:21 PM, Greg Kroah-Hartman wrote:
> +/*
> + * Used for open /proc/tty/consoles. Before this detect
> + * the device ID of file descriptor 0 of the current
> + * reading task if a character device...
> + */
> +static int tty_consoles_open(struct inode *inode, struct file *file)
> +{
> +	struct files_struct *curfiles;
> +
> +	current_dev = 0;
> +	curfiles = get_files_struct(current);
> +	if (curfiles) {
> +		const struct file *curfp;
> +		spin_lock(&curfiles->file_lock);
> +		curfp = fcheck_files(curfiles, 0);
> +		if (curfp && curfp->private_data) {
> +			const struct inode *inode;
> +			dget(curfp->f_dentry);
> +			inode = curfp->f_dentry->d_inode;
> +			if (S_ISCHR(inode->i_mode)) {
> +				struct tty_struct *tty;
> +				tty = (struct tty_struct *)curfp->private_data;
> +				if (tty && tty->magic == TTY_MAGIC) {

Ah, I've just understood what this code does. It seems, that the 'tty'
at this point may be already freed (e.g. people don't set private_data
to NULL). Please explain in the code why it can't...

Maybe I wouldn't bother with marking the "current" console by star at
all as it seems not to pay off.

> +					tty = tty_pair_get_tty(tty);
> +					current_dev = tty_devnum(tty);
> +				}
> +			}
> +			dput(curfp->f_dentry);
> +		}
> +		spin_unlock(&curfiles->file_lock);
> +		put_files_struct(curfiles);
> +	}
> +	return seq_open(file, &tty_consoles_op);
> +}

regards,
-- 
js
suse labs
