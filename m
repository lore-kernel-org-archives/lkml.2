Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab2BHXLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:11:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757524Ab2BHXLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:11:13 -0500
Date: Thu, 9 Feb 2012 10:10:54 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <greg@linuxfoundation.org>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/8] PM / Sleep: Use wait queue to signal "no wakeup
 events in progress"
Message-ID: <20120209101054.2b2cb2ab@notabene.brown>
In-Reply-To: <201202070204.19615.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<201202070204.19615.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tzrD3Gx9mQjY3GVMpBCjsYM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tzrD3Gx9mQjY3GVMpBCjsYM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Feb 2012 02:04:19 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> The current wakeup source deactivation code doesn't do anything when
> the counter of wakeup events in progress goes down to zero, which
> requires pm_get_wakeup_count() to poll that counter periodically.
> Although this reduces the average time it takes to deactivate a
> wakeup source, it also may lead to a substantial amount of unnecessary
> polling if there are extended periods of wakeup activity.  Thus it
> seems reasonable to use a wait queue for signaling the "no wakeup
> events in progress" condition and remove the polling.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/wakeup.c |   18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>=20
> Index: linux/drivers/base/power/wakeup.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/base/power/wakeup.c
> +++ linux/drivers/base/power/wakeup.c
> @@ -17,8 +17,6 @@
> =20
>  #include "power.h"
> =20
> -#define TIMEOUT		100
> -
>  /*
>   * If set, the suspend/hibernate code will abort transitions to a sleep =
state
>   * if wakeup events are registered during or immediately before the tran=
sition.
> @@ -52,6 +50,8 @@ static void pm_wakeup_timer_fn(unsigned
> =20
>  static LIST_HEAD(wakeup_sources);
> =20
> +static DECLARE_WAIT_QUEUE_HEAD(wakeup_count_wait_queue);
> +
>  /**
>   * wakeup_source_create - Create a struct wakeup_source object.
>   * @name: Name of the new wakeup source.
> @@ -84,7 +84,7 @@ void wakeup_source_destroy(struct wakeup
>  	while (ws->active) {
>  		spin_unlock_irq(&ws->lock);
> =20
> -		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
> +		schedule_timeout_interruptible(msecs_to_jiffies(100));
> =20
>  		spin_lock_irq(&ws->lock);
>  	}
> @@ -411,6 +411,7 @@ EXPORT_SYMBOL_GPL(pm_stay_awake);
>   */
>  static void wakeup_source_deactivate(struct wakeup_source *ws)
>  {
> +	unsigned int cnt, inpr;
>  	ktime_t duration;
>  	ktime_t now;
> =20
> @@ -444,6 +445,10 @@ static void wakeup_source_deactivate(str
>  	 * couter of wakeup events in progress simultaneously.
>  	 */
>  	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
> +
> +	split_counters(&cnt, &inpr);
> +	if (!inpr)
> +		wake_up_all(&wakeup_count_wait_queue);
>  }

Would it be worth making this:

     if (!inpr && waitqueue_active(&wakeup_count_wait_queue))
		wake_up_all(&wakeup_count_wait_queue);

??
It would often save a spinlock.

Also was there a reason you used wake_up_all().  That is only really needed
were EXCLUSIVE waits are happening, and there aren't any of those.

Thanks,
NeilBrown


> =20
>  /**
> @@ -624,14 +629,19 @@ bool pm_wakeup_pending(void)
>  bool pm_get_wakeup_count(unsigned int *count)
>  {
>  	unsigned int cnt, inpr;
> +	DEFINE_WAIT(wait);
> =20
>  	for (;;) {
> +		prepare_to_wait(&wakeup_count_wait_queue, &wait,
> +				TASK_INTERRUPTIBLE);
>  		split_counters(&cnt, &inpr);
>  		if (inpr =3D=3D 0 || signal_pending(current))
>  			break;
>  		pm_wakeup_update_hit_counts();
> -		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
> +
> +		schedule();
>  	}
> +	finish_wait(&wakeup_count_wait_queue, &wait);
> =20
>  	split_counters(&cnt, &inpr);
>  	*count =3D cnt;


--Sig_/tzrD3Gx9mQjY3GVMpBCjsYM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzMA/znsnt1WYoG5AQLzXg/5AcrK9XyQo3ESXCPHG0U2Z0LNqsryPP2j
PVt1zLJwND9UlfY8fBzklOfjRfdAuqALcDDmqIpty6j1zrLmidmnfDcXm+I+cxD9
cN3qhC2DnHAumonNQNfvlm8+a+98zFdZD8PUodmKxj0f7QmtaoydSbK58bB9LVH1
tSImlyR+dL1uRshAjsCofwmpukrTaNisZBv2pp7vbYgzyxqPQjciKtwD1+UvjeQB
gx0G8ZRvM8WJj/adZWGIGmzzQn2X/E+jTWjIyX+rFDl9VShzj3LViYqooVQhuodq
Q7ekFOSQrabTvMPbGrxwgIWZPyuznR9/ul5zmah0Y7rxQtWMAUJ9vUFSPYp2rkHo
c2ld9Xzv+HEAIq6JfAn07h8b4+cn1KdGTx6zhiUrGTLreuIzbs1L4/HuLrvd/zMN
ZbnGI0eVt6rNA6c/rfv0cbQ5irwuQt3HvXRmOib8tf5coQRxcyBRWavwREe0FBwM
g9KU7wPN2Pi93/mwBIacSDrRduDjym9UjjARteB9vdXTsmWFWh+R0EKc3GJqlmyA
tO83reF8vhmruebE34qkmKEyZs/OVzSNXK/TVT7hHE3k7XyxV6VMRVCsTox9pmOD
YERmyu++c8G7WgA4WMygdD2yo0XCbYPPRfaMMA0Iu9RN1ktycbL2orUMWYZzh7d6
lBDuxme4lOo=
=Puz7
-----END PGP SIGNATURE-----

--Sig_/tzrD3Gx9mQjY3GVMpBCjsYM--
