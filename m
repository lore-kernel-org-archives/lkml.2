Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab1LOGuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:50:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40139 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab1LOGuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:50:17 -0500
Date: Thu, 15 Dec 2011 07:48:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2011.2] fs: symlink restrictions on sticky directories
Message-ID: <20111215064817.GB14237@elte.hu>
References: <20111215004311.GA11049@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215004311.GA11049@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> +	/* Check parent directory mode and owner. */
> +	spin_lock(&dentry->d_lock);
> +	parent = dentry->d_parent->d_inode;
> +	if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
> +	    parent->i_uid != inode->i_uid) {
> +		error = -EACCES;
> +	}
> +	spin_unlock(&dentry->d_lock);
> +
> +#ifdef CONFIG_AUDIT
> +	if (error) {
> +		struct audit_buffer *ab;
> +
> +		ab = audit_log_start(current->audit_context,
> +				     GFP_ATOMIC, AUDIT_AVC);
> +		audit_log_format(ab, "op=follow_link action=denied");
> +		audit_log_d_path(ab, "path=", &nameidata->path);
> +		audit_log_format(ab, " name=");
> +		audit_log_untrustedstring(ab, dentry->d_name.name);
> +		audit_log_format(ab, " dev=%s ino=%lu",
> +				 inode->i_sb->s_id,
> +				 inode->i_ino);
> +		audit_log_end(ab);
> +	}
> +#endif

Hm, is GFP_ATOMIC really necessary here? Why not GFP_KERNEL? 
This is in VFS process context, not in some atomic context that 
has to be careful about allocations, right?

Thanks,

	Ingo
