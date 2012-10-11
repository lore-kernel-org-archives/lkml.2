Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab2JKOEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:04:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54501 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2JKOEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:04:38 -0400
Message-ID: <5076D1EC.1060100@canonical.com>
Date: Thu, 11 Oct 2012 22:04:28 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121003 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] efivarfs: efivarfs_fill_super() ensure we clean up
 correctly on error
References: <1349416496.810727.310563927016.1.gpush@pecola> <1349951541-20498-1-git-send-email-apw@canonical.com> <1349951541-20498-6-git-send-email-apw@canonical.com>
In-Reply-To: <1349951541-20498-6-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

> @@ -969,16 +970,18 @@
>   		return -ENOMEM;
>
>   	list_for_each_entry_safe(entry, n, &efivars->list, list) {
> -		struct inode *inode;
>   		struct dentry *dentry, *root = efivarfs_sb->s_root;
> -		char *name;
>   		unsigned long size = 0;
>   		int len, i;
>
> +		inode = NULL;
> +
>   		len = utf16_strlen(entry->var.VariableName);
>
>   		/* GUID plus trailing NULL */
>   		name = kmalloc(len + 38, GFP_ATOMIC);
> +		if (!name)
> +			goto fail;
>
>   		for (i = 0; i < len; i++)
>   			name[i] = entry->var.VariableName[i] & 0xFF;
> @@ -991,7 +994,13 @@
>
>   		inode = efivarfs_get_inode(efivarfs_sb, root->d_inode,
>   					  S_IFREG | 0644, 0);
> +		if (!inode)
> +			goto fail_name;
> +			
>   		dentry = d_alloc_name(root, name);
> +		if (!dentry)
> +			goto fail_inode;
> +
>   		/* copied by the above to local storage in the dentry. */
>   		kfree(name);

If we break out of the loop on the second (and onwards) iteration, won't 
we still have the other inodes and dentries remaining allocated?

Cheers,


Jeremy

