Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2AGQOE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 11:14:04 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:60473 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2AGQOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 11:14:02 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH] prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process supervision
In-Reply-To: Your message of "Sat, 07 Jan 2012 16:56:37 +0100."
             <1325951797.860.10.camel@mop>
From: Valdis.Kletnieks@vt.edu
References: <1325951797.860.10.camel@mop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1325952830_3358P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Jan 2012 11:13:50 -0500
Message-ID: <124669.1325952830@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4F086F42.00B8,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1325952830_3358P
Content-Type: text/plain; charset=us-ascii

On Sat, 07 Jan 2012 16:56:37 +0100, Kay Sievers said:
> Resending this, it got lost last year's September.
>
> We still need it to properly implement init-like service managers.

> From: Lennart Poettering <lennart@poettering.net>
> Subject: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process supervision

> Users of this will be the systemd per-user instance, which provides
> init-like functionality for the user's login session and D-Bus, which
> activates bus services on-demand. Both need init-like capabilities
> to be able to properly keep track of the services they start.

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -552,6 +552,18 @@ struct signal_struct {
>  	int			group_stop_count;
>  	unsigned int		flags; /* see SIGNAL_* flags below */
>
> +	/*
> +	 * PR_SET_CHILD_SUBREAPER marks a process, like a service
> +	 * manager, to re-parent orphan (double-forking) child processes
> +	 * to this process instead of 'init'. The service manager is
> +	 * able to receive SIGCHLD signals and is able to investigate
> +	 * the process until it calls wait(). All children of this
> +	 * process will inherit a flag if they should look for a
> +	 * child_subreaper process at exit.
> +	 */
> +	unsigned int		is_child_subreaper:1;
> +	unsigned int		has_child_subreaper:1;

Is there someplace we can stick these two fields where they won't expand the
signal_struct?  Can we stick them in signal_struct->flags instead? Looks like we've
only burned 3 bits of that unsigned int.  Yes, I know that would complicate the
prctl get/set code.

> +		/* find the first ancestor marked as child_subreaper */
> +		for (reaper = father->real_parent;
> +		     reaper != &init_task;
> +		     reaper = reaper->real_parent) {

I admit being insufficiently caffienated - does this DTRT in a PID namespace? That
&init_task looks fishy to me...

--==_Exmh_1325952830_3358P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFPCG8+cC3lWbTT17ARAhyrAKCNwfDCNUxFQtYhv1lo+iQ+5t6VKwCeOZVJ
J/EwKQmWA9rRuX7K1xsqlI8=
=BAGu
-----END PGP SIGNATURE-----

--==_Exmh_1325952830_3358P--

