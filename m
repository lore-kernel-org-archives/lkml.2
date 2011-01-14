Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab1ANPCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:02:25 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:41356 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab1ANPCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:02:19 -0500
Date: Fri, 14 Jan 2011 16:02:17 +0100
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
Message-ID: <20110114150217.GC20945@wavehammer.waldi.eu.org>
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
 <20110110215937.GB21351@wavehammer.waldi.eu.org>
 <20110111052759.GA24970@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110111052759.GA24970@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 05:27:59AM +0000, Serge E. Hallyn wrote:
> Quoting Bastian Blank (bastian@waldi.eu.org):
> > On Mon, Jan 10, 2011 at 09:14:07PM +0000, Serge E. Hallyn wrote:
> > > -	if (pcred->uid  != cred->euid &&
> > > -	    pcred->euid != cred->euid && !capable(CAP_SYS_NICE)) {
> > > +	if (pcred->user->user_ns != cred->user->user_ns &&
> > > +	    pcred->uid  != cred->euid &&
> > > +	    pcred->euid != cred->euid &&
> > > +	    !ns_capable(pcred->user->user_ns, CAP_SYS_NICE)) {
> > 
> > I don't think this is correct. This would not error out if the both
> > userns are the same. Because the same patern (check uid if same userns,
> > otherwise only capability) shows up in several parts of the code, maybe
> > this should be factored out.
> 
> Yeah, I'd really like to factor this out because it shows up everywhere
> and I have to think about it every time I look at it.  But each time it
> shows up, the uids being compared slightly change.  There must be some
> clever way of doing it, hopefully it'll fall out soon.

Well, then make mostly identical (_inline_) functions in one location
(include/linux/cred.h comes in mind).  You can ask later why they have
to be different.

You are scaling the complexity up. So you need to make it somehow
manageable, and even slightly different versions in one place are much
easier to handle than the same in many different places.

kill_ok_by_cred would be:
cred_check_euid_suid(struct task_struct *p, X capable)

set_one_prio_perm would be:
cred_check_euid_euid(struct task_struct *p, X capable)

Bastian

-- 
	"Life and death are seldom logical."
	"But attaining a desired goal always is."
		-- McCoy and Spock, "The Galileo Seven", stardate 2821.7
