Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab1CSKnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 06:43:41 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47424 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1CSKng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 06:43:36 -0400
From: Richard Weinberger <richard@nod.at>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
Date: Sat, 19 Mar 2011 11:43:28 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Kees Cook <kees.cook@canonical.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        serge@hallyn.com, eparis@redhat.com, jmorris@namei.org,
        eugeneteo@kernel.org, drosenberg@vsecurity.com
References: <1300303907-22627-1-git-send-email-richard@nod.at> <20110316211911.GA13715@p183.telecom.by> <m1mxktbsgy.fsf@fess.ebiederm.org>
In-Reply-To: <m1mxktbsgy.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103191143.28499.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 17 März 2011, 17:51:41 schrieb Eric W. Biederman:
> Alexey Dobriyan <adobriyan@gmail.com> writes:
> > On Wed, Mar 16, 2011 at 09:08:16PM +0100, Richard Weinberger wrote:
> >> Kees,
> >> 
> >> Am Mittwoch 16 März 2011, 20:55:49 schrieb Kees Cook:
> >> > Hi Richard,
> >> > 
> >> > On Wed, Mar 16, 2011 at 08:31:47PM +0100, Richard Weinberger wrote:
> >> > > When containers like LXC are used a unprivileged and jailed
> >> > > root user can still write to critical files in /proc/.
> >> > > E.g: /proc/sys/kernel/{sysrq, panic, panic_on_oops, ... }
> >> > > 
> >> > > This new restricted attribute makes it possible to protect such
> >> > > files. When restricted is set to true root needs CAP_SYS_ADMIN
> >> > > to into the file.
> >> > 
> >> > I was thinking about this too. I'd prefer more fine-grained control
> >> > in this area, since some sysctl entries aren't strictly controlled by
> >> > CAP_SYS_ADMIN (e.g. mmap_min_addr is already checking CAP_SYS_RAWIO).
> >> > 
> >> > How about this instead?
> >> 
> >> Good Idea.
> >> May we should also consider a per-directory restriction.
> >> Every file in /proc/sys/{kernel/, vm/, fs/, dev/} needs a protection.
> >> It would be much easier to set the protection on the parent directory
> >> instead of protecting file by file...
> > 
> > Of course, not.
> > 
> > You should _enable_ them one by one, not the other way around.
> > 
> > 	"default deny"
> 
> Right.
> 
> Since the primary problem here is containers we can use the
> user_namespace to add the default deny policy.
> 
> Something like the trivial patch below should make /proc/sys safe,
> and the technique applies in general.
> 
> Richard is that a good enough example to get you started?

Yes. Thanks.

> Eric
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 0f1bd83..a172a9d 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1674,10 +1674,12 @@ void register_sysctl_root(struct ctl_table_root
> *root)
> 
>  static int test_perm(int mode, int op)
>  {
> -	if (!current_euid())
> -		mode >>= 6;
> -	else if (in_egroup_p(0))
> -		mode >>= 3;
> +	if (current_user_ns() == &init_user_ns) {
> +		if (!current_euid())
> +			mode >>= 6;
> +		else if (in_egroup_p(0))
> +			mode >>= 3;
> +	}
>  	if ((op & ~mode & (MAY_READ|MAY_WRITE|MAY_EXEC)) == 0)
>  		return 0;
>  	return -EACCES;

