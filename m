Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1DTCSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 22:18:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35599 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1DTCSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 22:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GMid2SUKbqGZJjMsuOnpxIHPghWgscAgtcQW3OeRf018q+8v7jwsssqP8UV9KrZLHX
         B/BvpMzX9YzyakaIXpjok2EC3ZyNB9hyWeHmnvkMgRdSEiC5UYWY8n8kNaDeTx1F6Y6Y
         AGXoYumIjEfurBstDHGpfWn1iCnHpg2Vcmfiw=
MIME-Version: 1.0
In-Reply-To: <87tydu3t4p.fsf_-_@tucsk.pomaz.szeredi.hu>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
	<BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
	<BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
	<BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
	<BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com>
	<BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
	<BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
	<C450CD68-10AE-4527-B6BF-A5D5F0BF005F@dilger.ca>
	<BANLkTinMNL8Q+_MCHDqAGSdYNAvHB2GdLw@mail.gmail.com>
	<87tydu3t4p.fsf_-_@tucsk.pomaz.szeredi.hu>
Date: Wed, 20 Apr 2011 03:18:20 +0100
Message-ID: <BANLkTinXVDrLnMOo17pqua5+38yQsezG6g@mail.gmail.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Michal Suchanek <hramrach@centrum.cz>, Andreas Dilger <adilger@dilger.ca>,
        Jiri Kosina <jkosina@suse.cz>, Ric Wheeler <ricwheeler@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Hugh Dickins <hughd@google.com>, Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 9:04 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

> +static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)

> +       spin_lock(&dentry->d_inode->i_lock);
> +       list_for_each_entry(xattr, &info->xattr_list, list) {
> +               /* skip "trusted." attributes for unprivileged callers */
> +               if (!trusted && xattr_is_trusted(xattr->name))
> +                       continue;
> +
> +               used += strlen(xattr->name) + 1;
> +               if (buffer) {
> +                       if (size < used) {
> +                               used = -ERANGE;
> +                               break;
> +                       }
> +                       strncpy(buffer, xattr->name, strlen(xattr->name) + 1);
>+                        buffer += strlen(xattr->name) + 1;

Why are you doing a strncpy here?  strcpy() isn't going to copy more
than strlen(xattr->name) + 1 bytes, and you know buffer is large
enough to hold that because of the previous if (size < used) check?

If you assigned the first strlen(xattr->name) + 1 to a temporary
variable, you could use memcpy here, and avoid the 3 repeated
strlen(xattr->name) calls.

Phillip
