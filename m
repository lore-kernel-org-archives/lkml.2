Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab2HPKYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:24:02 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47089 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab2HPKX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:23:58 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com
Subject: Re: [PATCH 04/13] overlay filesystem
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
	<1345045700-9062-5-git-send-email-miklos@szeredi.hu>
	<87zk5v5p73.fsf@xmission.com>
Date: Thu, 16 Aug 2012 12:25:14 +0200
In-Reply-To: <87zk5v5p73.fsf@xmission.com> (Eric W. Biederman's message of
	"Wed, 15 Aug 2012 23:24:48 -0700")
Message-ID: <87wr0zcewl.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Miklos Szeredi <miklos@szeredi.hu> writes:
>
> Minor nits below.
>
>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>> new file mode 100644
>> index 0000000..6b50823
>> --- /dev/null
>> +++ b/fs/overlayfs/dir.c
>> @@ -0,0 +1,598 @@
>> +/*
>> + *
>> + * Copyright (C) 2011 Novell Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + */
>> +
>> +#include <linux/fs.h>
>> +#include <linux/namei.h>
>> +#include <linux/xattr.h>
>> +#include <linux/security.h>
>> +#include <linux/cred.h>
>> +#include "overlayfs.h"
>> +
>> +static const char *ovl_whiteout_symlink = "(overlay-whiteout)";
>> +
>> +static int ovl_whiteout(struct dentry *upperdir, struct dentry *dentry)
>> +{
>> +	int err;
>> +	struct dentry *newdentry;
>> +	const struct cred *old_cred;
>> +	struct cred *override_cred;
>> +
>> +	/* FIXME: recheck lower dentry to see if whiteout is really
>>  	needed */
>
> Is that FIXME still valid?

It is, but it's not an important feature.  Lacking this will mean once a
file/directory is marked whiteout or opaque on the upper filesystem it
will remain so forever even after the file/directory it is masking out
has been removed from the lower filesystem.

However this cannot be observed by looking at the overlay, only by
looking at the underlying filesystems.


>
>> +	err = -ENOMEM;
>> +	override_cred = prepare_creds();
>> +	if (!override_cred)
>> +		goto out;
>> +
>> +	/*
>> +	 * CAP_SYS_ADMIN for setxattr
>> +	 * CAP_DAC_OVERRIDE for symlink creation
>> +	 * CAP_FOWNER for unlink in sticky directory
>> +	 */
>> +	cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
>> +	cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
>> +	cap_raise(override_cred->cap_effective, CAP_FOWNER);
>> +	override_cred->fsuid = 0;
>> +	override_cred->fsgid = 0;
>
> Could you please make these GLOBAL_ROOT_UID and GLOBAL_ROOT_GID
> instead of 0?  Otherwise this code won't compile with the usernamespace
> bits enabled.

Okay.

Thanks for the review.

Miklos
