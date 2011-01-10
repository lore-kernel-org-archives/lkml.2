Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1AJV6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:58:55 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:57564 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1AJV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:58:53 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jan 2011 16:58:52 EST
Date: Mon, 10 Jan 2011 22:52:40 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 4/7] allow killing tasks in your own or child userns
Message-ID: <20110110215240.GA21351@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	containers@lists.linux-foundation.org,
	kernel list <linux-kernel@vger.kernel.org>,
	LSM <linux-security-module@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Kees Cook <kees.cook@canonical.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Michael Kerrisk <mtk.manpages@gmail.com>
References: <20110110211135.GA22446@mail.hallyn.com>
 <20110110211334.GD22564@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110110211334.GD22564@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 09:13:34PM +0000, Serge E. Hallyn wrote:
> +	const struct cred *cred = current_cred();
> +	const struct cred *tcred = __task_cred(t);
> +
> +	if (cred->user->user_ns != tcred->user->user_ns) {
> +		/* userids are not equivalent - either you have the
> +		   capability to the target user ns or you don't */
> +		if (ns_capable(tcred->user->user_ns, CAP_KILL))
> +			return 1;
> +		return 0;
> +	}
> +
> +	/* same user namespace - usual credentials checks apply */
> +	if ((cred->euid ^ tcred->suid) &&
> +	    (cred->euid ^ tcred->uid) &&
> +	    (cred->uid  ^ tcred->suid) &&
> +	    (cred->uid  ^ tcred->uid) &&
> +	    !ns_capable(tcred->user->user_ns, CAP_KILL))
> +		return 0;
> +
> +	return 1;

Isn't that equal to this?

	if (ns_capable(tcred->user->user_ns, CAP_KILL))
		return 1;

	if (cred->user->user_ns == tcred->user->user_ns &&
	    (cred->euid == tcred->suid ||
	     cred->euid == tcred->uid ||
	     cred->uid == tcred->suid ||
	     cred->uid == tcred->uid))
		return 1;

	return 0;

I would consider this much easier to read.

Bastian

-- 
I'm a soldier, not a diplomat.  I can only tell the truth.
		-- Kirk, "Errand of Mercy", stardate 3198.9
