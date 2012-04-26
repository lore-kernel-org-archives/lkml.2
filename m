Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2DZGb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:31:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab2DZGby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:31:54 -0400
Date: Thu, 26 Apr 2012 16:31:43 +1000
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: John Stultz <johnstul@us.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 8/8] PM / Sleep: Add user space interface for
 manipulating wakeup sources
Message-ID: <20120426163143.42f707b0@notabene.brown>
In-Reply-To: <201204242327.17626.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<201204222324.45586.rjw@sisk.pl>
	<4F960376.6040906@us.ibm.com>
	<201204242327.17626.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fVdwVaqVYRPpikcAB3n5EIp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fVdwVaqVYRPpikcAB3n5EIp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Apr 2012 23:27:17 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Sleep: Add user space interface for manipulating wakeup sou=
rces, v2
>=20
> Android allows user space to manipulate wakelocks using two
> sysfs file located in /sys/power/, wake_lock and wake_unlock.
> Writing a wakelock name and optionally a timeout to the wake_lock
> file causes the wakelock whose name was written to be acquired (it
> is created before is necessary), optionally with the given timeout.
> Writing the name of a wakelock to wake_unlock causes that wakelock
> to be released.
>=20
> Implement an analogous interface for user space using wakeup sources.
> Add the /sys/power/wake_lock and /sys/power/wake_unlock files
> allowing user space to create, activate and deactivate wakeup
> sources, such that writing a name and optionally a timeout to
> wake_lock causes the wakeup source of that name to be activated,
> optionally with the given timeout.  If that wakeup source doesn't
> exist, it will be created and then activated.  Writing a name to
> wake_unlock causes the wakeup source of that name, if there is one,
> to be deactivated.  Wakeup sources created with the help of
> wake_lock that haven't been used for more than 5 minutes are garbage
> collected and destroyed.  Moreover, there can be only WL_NUMBER_LIMIT
> wakeup sources created with the help of wake_lock present at a time.
>=20
> The data type used to track wakeup sources created by user space is
> called "struct wakelock" to indicate the origins of this feature.
>=20
> This version of the patch includes an rbtree manipulation fix from John S=
tultz.

Looks good.  Just a couple of minor suggestions.


> +ssize_t pm_show_wakelocks(char *buf, bool show_active)
> +{
> +	struct rb_node *node;
> +	struct wakelock *wl;
> +	char *str =3D buf;
> +	char *end =3D buf + PAGE_SIZE;
> +
> +	mutex_lock(&wakelocks_lock);
> +
> +	for (node =3D rb_first(&wakelocks_tree); node; node =3D rb_next(node)) {
> +		bool active;
> +
> +		wl =3D rb_entry(node, struct wakelock, node);
> +		spin_lock_irq(&wl->ws.lock);
> +		active =3D wl->ws.active;
> +		spin_unlock_irq(&wl->ws.lock);

I don't think the spin_lock is needed.  We are just reading one value and it
is either 0 or not.  So there is no possibility for any inconsistency.
                if (wl->ws.active =3D=3D show_active)
?

> +		if (active =3D=3D show_active)
> +			str +=3D scnprintf(str, end - str, "%s ", wl->name);

Arg.  Extra space on the end of the line!!  :-)

I would suggest the entries be terminated by '\n' rather than separate by
space.
one-item-per-line is much more common in Unix in general.  'grep' allows
you to find things more easily etc.
   while read a
   do echo $a > wake_unlock
   done < wake_lock



> +	}
> +	str +=3D scnprintf(str, end - str, "\n");
> +
> +	mutex_unlock(&wakelocks_lock);
> +	return (str - buf);
> +}
> +


Thanks,
NeilBrown

--Sig_/fVdwVaqVYRPpikcAB3n5EIp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5jrzznsnt1WYoG5AQIU1w/+JXcMniSDr5dSif4au1UmVlIIGI0cpqWc
fgt8qAPdKqDDuHwJ6vONXBiZxEgP/qI3HhjoMkfj8AHVQaFaSjA64eEhoJAOYjFV
Fe4s9WIOCldxcvF4C/vlDvmrx5fArvm4Ubqss1Z/8oD9hCgDw6PbBB6f6r6ZCeLN
biZOmg/79RjULqA+Ghkth8EaVNd5n+Mkp+F8cISYRcquP693gXBNZAG+55v8QFKT
js6HixhrG4kinmicXyhHsmmeoL9fQshiKYRjPs5uPJer1fCD5bbUX7A/romx8DbO
rMRmktlj5oSd5W9awpZJdp5wZbV2XMiVzsk+bBIYLa5yznIE7wi+bectke8RZzOW
RTPvJ8gVimwhTJ899Y8C40D0PIAwvIVAaXJjrU9ssd5+2iJ6XluUZAj0tgf9PxO2
s+9YwW7YB1aXTnMDhUrnBJjaY/4xDk7H2SKTzUqMxmOiikS0/4huzQlwqZwpUxsC
g0eR48FLAj6nZzTToydYSwDDPQwIkLQtFSXi3u8wJPJFrcZFhEzcJIQfgbMDnHvd
hyMZE5vqETzElyc2OLnwaU4o7wpkNpjzKDHuRu5rUm5JaXq/O0vmGOKlIlv6+pS8
uWyf2CjyrQI5XJpFw9G/xkQkUlbKBxrGgQbDeQ8AcQE/fQIXzLihcEkTk/h8sJhB
TA8kSdD5y+k=
=InFV
-----END PGP SIGNATURE-----

--Sig_/fVdwVaqVYRPpikcAB3n5EIp--
