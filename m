Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2HPGZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:25:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46182 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab2HPGZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:25:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com,
        mszeredi@suse.cz
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
	<1345045700-9062-5-git-send-email-miklos@szeredi.hu>
Date: Wed, 15 Aug 2012 23:24:48 -0700
In-Reply-To: <1345045700-9062-5-git-send-email-miklos@szeredi.hu> (Miklos
	Szeredi's message of "Wed, 15 Aug 2012 17:48:11 +0200")
Message-ID: <87zk5v5p73.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19PxrGNwkC7Q0a1rxvDf4n28hcK9VWu9WE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 04/13] overlay filesystem
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

Minor nits below.

> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> new file mode 100644
> index 0000000..6b50823
> --- /dev/null
> +++ b/fs/overlayfs/dir.c
> @@ -0,0 +1,598 @@
> +/*
> + *
> + * Copyright (C) 2011 Novell Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/namei.h>
> +#include <linux/xattr.h>
> +#include <linux/security.h>
> +#include <linux/cred.h>
> +#include "overlayfs.h"
> +
> +static const char *ovl_whiteout_symlink = "(overlay-whiteout)";
> +
> +static int ovl_whiteout(struct dentry *upperdir, struct dentry *dentry)
> +{
> +	int err;
> +	struct dentry *newdentry;
> +	const struct cred *old_cred;
> +	struct cred *override_cred;
> +
> +	/* FIXME: recheck lower dentry to see if whiteout is really
>  	needed */

Is that FIXME still valid?

> +	err = -ENOMEM;
> +	override_cred = prepare_creds();
> +	if (!override_cred)
> +		goto out;
> +
> +	/*
> +	 * CAP_SYS_ADMIN for setxattr
> +	 * CAP_DAC_OVERRIDE for symlink creation
> +	 * CAP_FOWNER for unlink in sticky directory
> +	 */
> +	cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
> +	cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
> +	cap_raise(override_cred->cap_effective, CAP_FOWNER);
> +	override_cred->fsuid = 0;
> +	override_cred->fsgid = 0;

Could you please make these GLOBAL_ROOT_UID and GLOBAL_ROOT_GID
instead of 0?  Otherwise this code won't compile with the usernamespace
bits enabled.

> +	old_cred = override_creds(override_cred);

Eric
