Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1AJV7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:59:48 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:57573 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab1AJV7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:59:45 -0500
Date: Mon, 10 Jan 2011 22:59:37 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 6/7] user namespaces: convert all capable checks in
 kernel/sys.c
Message-ID: <20110110215937.GB21351@wavehammer.waldi.eu.org>
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
 <20110110211406.GF22564@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110110211406.GF22564@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 09:14:07PM +0000, Serge E. Hallyn wrote:
> -	if (pcred->uid  != cred->euid &&
> -	    pcred->euid != cred->euid && !capable(CAP_SYS_NICE)) {
> +	if (pcred->user->user_ns != cred->user->user_ns &&
> +	    pcred->uid  != cred->euid &&
> +	    pcred->euid != cred->euid &&
> +	    !ns_capable(pcred->user->user_ns, CAP_SYS_NICE)) {

I don't think this is correct. This would not error out if the both
userns are the same. Because the same patern (check uid if same userns,
otherwise only capability) shows up in several parts of the code, maybe
this should be factored out.

> @@ -496,7 +498,7 @@ SYSCALL_DEFINE2(setregid, gid_t, rgid, gid_t, egid)
>  	if (rgid != (gid_t) -1) {
>  		if (old->gid == rgid ||
>  		    old->egid == rgid ||
> -		    capable(CAP_SETGID))
> +		    ns_capable(current_user_ns(), CAP_SETGID))

Would it not possible to add another function (nsown_capable?) that
checks against the own userns?

Bastian

-- 
Change is the essential process of all existence.
		-- Spock, "Let That Be Your Last Battlefield", stardate 5730.2
