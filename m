Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2EAG2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:28:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab2EAG2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:28:32 -0400
Date: Tue, 1 May 2012 16:28:11 +1000
From: NeilBrown <neilb@suse.de>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] epoll: Add a flag, EPOLLWAKEUP, to prevent suspend
 while epoll events are ready
Message-ID: <20120501162811.26261d1d@notabene.brown>
In-Reply-To: <1335850428-30883-1-git-send-email-arve@android.com>
References: <CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com>
	<1335850428-30883-1-git-send-email-arve@android.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8nJphjyknRJWFg+BQVUBT6g"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8nJphjyknRJWFg+BQVUBT6g
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Apr 2012 22:33:48 -0700 Arve Hj=C3=B8nnev=C3=A5g <arve@android.c=
om> wrote:

> When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
> wakeup_source will be active to prevent suspend. This can be used to
> handle wakeup events from a driver that support poll, e.g. input, if
> that driver wakes up the waitqueue passed to epoll before allowing
> suspend.
>=20
> Signed-off-by: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Thanks.
 Reviewed-by: NeilBrown <neilb@suse.de>

However:
1/ I think all references to "automatic system suspend" can be replaced with
   "system suspend" as an active wakeup_source disables any suspend, no mat=
ter
   it's source
2/ I reserve to right to submit for discussion a later patch which removes
   the ep->ws in favour or some other exclusion mechanism :-)

NeilBrown



> ---
>  fs/eventpoll.c             |   90 ++++++++++++++++++++++++++++++++++++++=
++++-
>  include/linux/capability.h |    5 ++-
>  include/linux/eventpoll.h  |   12 ++++++
>  3 files changed, 103 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 739b098..1abed50 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -33,6 +33,7 @@
>  #include <linux/bitops.h>
>  #include <linux/mutex.h>
>  #include <linux/anon_inodes.h>
> +#include <linux/device.h>
>  #include <asm/uaccess.h>
>  #include <asm/io.h>
>  #include <asm/mman.h>
> @@ -87,7 +88,7 @@
>   */
> =20
>  /* Epoll private bits inside the event mask */
> -#define EP_PRIVATE_BITS (EPOLLONESHOT | EPOLLET)
> +#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET)
> =20
>  /* Maximum number of nesting allowed inside epoll sets */
>  #define EP_MAX_NESTS 4
> @@ -154,6 +155,9 @@ struct epitem {
>  	/* List header used to link this item to the "struct file" items list */
>  	struct list_head fllink;
> =20
> +	/* wakeup_source used when EPOLLWAKEUP is set */
> +	struct wakeup_source *ws;
> +
>  	/* The structure that describe the interested events and the source fd =
*/
>  	struct epoll_event event;
>  };
> @@ -194,6 +198,9 @@ struct eventpoll {
>  	 */
>  	struct epitem *ovflist;
> =20
> +	/* wakeup_source used when ep_scan_ready_list is running */
> +	struct wakeup_source *ws;
> +
>  	/* The user that created the eventpoll descriptor */
>  	struct user_struct *user;
> =20
> @@ -588,8 +595,10 @@ static int ep_scan_ready_list(struct eventpoll *ep,
>  		 * queued into ->ovflist but the "txlist" might already
>  		 * contain them, and the list_splice() below takes care of them.
>  		 */
> -		if (!ep_is_linked(&epi->rdllink))
> +		if (!ep_is_linked(&epi->rdllink)) {
>  			list_add_tail(&epi->rdllink, &ep->rdllist);
> +			__pm_stay_awake(epi->ws);
> +		}
>  	}
>  	/*
>  	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
> @@ -602,6 +611,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
>  	 * Quickly re-inject items left on "txlist".
>  	 */
>  	list_splice(&txlist, &ep->rdllist);
> +	__pm_relax(ep->ws);
> =20
>  	if (!list_empty(&ep->rdllist)) {
>  		/*
> @@ -656,6 +666,8 @@ static int ep_remove(struct eventpoll *ep, struct epi=
tem *epi)
>  		list_del_init(&epi->rdllink);
>  	spin_unlock_irqrestore(&ep->lock, flags);
> =20
> +	wakeup_source_unregister(epi->ws);
> +
>  	/* At this point it is safe to free the eventpoll item */
>  	kmem_cache_free(epi_cache, epi);
> =20
> @@ -706,6 +718,7 @@ static void ep_free(struct eventpoll *ep)
>  	mutex_unlock(&epmutex);
>  	mutex_destroy(&ep->mtx);
>  	free_uid(ep->user);
> +	wakeup_source_unregister(ep->ws);
>  	kfree(ep);
>  }
> =20
> @@ -737,6 +750,7 @@ static int ep_read_events_proc(struct eventpoll *ep, =
struct list_head *head,
>  			 * callback, but it's not actually ready, as far as
>  			 * caller requested events goes. We can remove it here.
>  			 */
> +			__pm_relax(epi->ws);
>  			list_del_init(&epi->rdllink);
>  		}
>  	}
> @@ -927,13 +941,23 @@ static int ep_poll_callback(wait_queue_t *wait, uns=
igned mode, int sync, void *k
>  		if (epi->next =3D=3D EP_UNACTIVE_PTR) {
>  			epi->next =3D ep->ovflist;
>  			ep->ovflist =3D epi;
> +			if (epi->ws) {
> +				/*
> +				 * Activate ep->ws since epi->ws may get
> +				 * deactivated at any time.
> +				 */
> +				__pm_stay_awake(ep->ws);
> +			}
> +
>  		}
>  		goto out_unlock;
>  	}
> =20
>  	/* If this file is already in the ready list we exit soon */
> -	if (!ep_is_linked(&epi->rdllink))
> +	if (!ep_is_linked(&epi->rdllink)) {
>  		list_add_tail(&epi->rdllink, &ep->rdllist);
> +		__pm_stay_awake(epi->ws);
> +	}
> =20
>  	/*
>  	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
> @@ -1091,6 +1115,30 @@ static int reverse_path_check(void)
>  	return error;
>  }
> =20
> +static int ep_create_wakeup_source(struct epitem *epi)
> +{
> +	const char *name;
> +
> +	if (!epi->ep->ws) {
> +		epi->ep->ws =3D wakeup_source_register("eventpoll");
> +		if (!epi->ep->ws)
> +			return -ENOMEM;
> +	}
> +
> +	name =3D epi->ffd.file->f_path.dentry->d_name.name;
> +	epi->ws =3D wakeup_source_register(name);
> +	if (!epi->ws)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +static void ep_destroy_wakeup_source(struct epitem *epi)
> +{
> +	wakeup_source_unregister(epi->ws);
> +	epi->ws =3D NULL;
> +}
> +
>  /*
>   * Must be called with "mtx" held.
>   */
> @@ -1118,6 +1166,13 @@ static int ep_insert(struct eventpoll *ep, struct =
epoll_event *event,
>  	epi->event =3D *event;
>  	epi->nwait =3D 0;
>  	epi->next =3D EP_UNACTIVE_PTR;
> +	if (epi->event.events & EPOLLWAKEUP) {
> +		error =3D ep_create_wakeup_source(epi);
> +		if (error)
> +			goto error_create_wakeup_source;
> +	} else {
> +		epi->ws =3D NULL;
> +	}
> =20
>  	/* Initialize the poll table using the queue callback */
>  	epq.epi =3D epi;
> @@ -1164,6 +1219,7 @@ static int ep_insert(struct eventpoll *ep, struct e=
poll_event *event,
>  	/* If the file is already "ready" we drop it inside the ready list */
>  	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
>  		list_add_tail(&epi->rdllink, &ep->rdllist);
> +		__pm_stay_awake(epi->ws);
> =20
>  		/* Notify waiting tasks that events are available */
>  		if (waitqueue_active(&ep->wq))
> @@ -1204,6 +1260,9 @@ error_unregister:
>  		list_del_init(&epi->rdllink);
>  	spin_unlock_irqrestore(&ep->lock, flags);
> =20
> +	wakeup_source_unregister(epi->ws);
> +
> +error_create_wakeup_source:
>  	kmem_cache_free(epi_cache, epi);
> =20
>  	return error;
> @@ -1229,6 +1288,12 @@ static int ep_modify(struct eventpoll *ep, struct =
epitem *epi, struct epoll_even
>  	epi->event.events =3D event->events;
>  	pt._key =3D event->events;
>  	epi->event.data =3D event->data; /* protected by mtx */
> +	if (epi->event.events & EPOLLWAKEUP) {
> +		if (!epi->ws)
> +			ep_create_wakeup_source(epi);
> +	} else if (epi->ws) {
> +		ep_destroy_wakeup_source(epi);
> +	}
> =20
>  	/*
>  	 * Get current event bits. We can safely use the file* here because
> @@ -1244,6 +1309,7 @@ static int ep_modify(struct eventpoll *ep, struct e=
pitem *epi, struct epoll_even
>  		spin_lock_irq(&ep->lock);
>  		if (!ep_is_linked(&epi->rdllink)) {
>  			list_add_tail(&epi->rdllink, &ep->rdllist);
> +			__pm_stay_awake(epi->ws);
> =20
>  			/* Notify waiting tasks that events are available */
>  			if (waitqueue_active(&ep->wq))
> @@ -1282,6 +1348,18 @@ static int ep_send_events_proc(struct eventpoll *e=
p, struct list_head *head,
>  	     !list_empty(head) && eventcnt < esed->maxevents;) {
>  		epi =3D list_first_entry(head, struct epitem, rdllink);
> =20
> +		/*
> +		 * Activate ep->ws before deactivating epi->ws to prevent
> +		 * triggering auto-suspend here (in case we reactive epi->ws
> +		 * below).
> +		 *
> +		 * This could be rearranged to delay the deactivation of epi->ws
> +		 * instead, but then epi->ws would temporarily be out of sync
> +		 * with ep_is_linked().
> +		 */
> +		if (epi->ws && epi->ws->active)
> +			__pm_stay_awake(ep->ws);
> +		__pm_relax(epi->ws);
>  		list_del_init(&epi->rdllink);
> =20
>  		pt._key =3D epi->event.events;
> @@ -1298,6 +1376,7 @@ static int ep_send_events_proc(struct eventpoll *ep=
, struct list_head *head,
>  			if (__put_user(revents, &uevent->events) ||
>  			    __put_user(epi->event.data, &uevent->data)) {
>  				list_add(&epi->rdllink, head);
> +				__pm_stay_awake(epi->ws);
>  				return eventcnt ? eventcnt : -EFAULT;
>  			}
>  			eventcnt++;
> @@ -1317,6 +1396,7 @@ static int ep_send_events_proc(struct eventpoll *ep=
, struct list_head *head,
>  				 * poll callback will queue them in ep->ovflist.
>  				 */
>  				list_add_tail(&epi->rdllink, &ep->rdllist);
> +				__pm_stay_awake(epi->ws);
>  			}
>  		}
>  	}
> @@ -1629,6 +1709,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int=
, fd,
>  	if (!tfile->f_op || !tfile->f_op->poll)
>  		goto error_tgt_fput;
> =20
> +	/* Check if EPOLLWAKEUP is allowed */
> +	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_EPOLLWAKEUP))
> +		goto error_tgt_fput;
> +
>  	/*
>  	 * We have to check that the file structure underneath the file descrip=
tor
>  	 * the user passed to us _is_ an eventpoll file. And also we do not per=
mit
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 12d52de..222974a 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -360,8 +360,11 @@ struct cpu_vfs_cap_data {
> =20
>  #define CAP_WAKE_ALARM            35
> =20
> +/* Allow preventing automatic system suspends while epoll events are pen=
ding */
> =20
> -#define CAP_LAST_CAP         CAP_WAKE_ALARM
> +#define CAP_EPOLLWAKEUP      36
> +
> +#define CAP_LAST_CAP         CAP_EPOLLWAKEUP
> =20
>  #define cap_valid(x) ((x) >=3D 0 && (x) <=3D CAP_LAST_CAP)
> =20
> diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
> index 657ab55..5b591fb 100644
> --- a/include/linux/eventpoll.h
> +++ b/include/linux/eventpoll.h
> @@ -26,6 +26,18 @@
>  #define EPOLL_CTL_DEL 2
>  #define EPOLL_CTL_MOD 3
> =20
> +/*
> + * Request the handling of system wakeup events so as to prevent automat=
ic
> + * system suspends from happening while those events are being processed.
> + *
> + * Assuming neither EPOLLET nor EPOLLONESHOT is set, automatic system su=
spends
> + * will not be re-allowed until epoll_wait is called again after consumi=
ng the
> + * wakeup event(s).
> + *
> + * Requires CAP_EPOLLWAKEUP
> + */
> +#define EPOLLWAKEUP (1 << 29)
> +
>  /* Set the One Shot behaviour for the target file descriptor */
>  #define EPOLLONESHOT (1 << 30)
> =20


--Sig_/8nJphjyknRJWFg+BQVUBT6g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5+Ceznsnt1WYoG5AQKiwg//XzaSnM0TETPhAiAagcZ//WLi/Qcfu8gC
N5LklRpRPK173ARJvIHGGpUWb8zJ+yUgn++3Z8v+Pb0LxBQjETnSCyO8xlq2Jxff
ZNnLGMk79p4a4Xg4uymBzX784VvlVoqJppsZBR+HyLQwuDJSOeDtdHL6O44+1wJ1
JypNrONalHUUP8FMM08T9Oj74W/yuPwdhPP36jX30YdjZ4Hbee/UvjIb8FVzjnus
x9pXcrpuLcXokSF0PGmcNNGNJpNc7CBHecL7qZiXn6mDvRIp+6AySfH067IeNk/3
iUapHOU6ZcD1pBff1JjbkDZXG1qocPeypcRnwzJE7eZgSHthF+/FeS35er0a+Qgj
ghWOBRwLJGi8r9C0+6Vq7YRzvHyEK/BZ/SvviSg1Cz4u+XGK4MYD33X6mFYSOwdW
pqlZruKiphmOhz824HyE7lBWOPPxV/OTjQbfKgjqfJ6S/E1fqzm5u6d4QooEoNA6
e1XAeTf1ygFENzsZOZ3dHgBuithRGuRT4y6AXYPGDkoSIj7taiC4elscuht7l13R
v/DugVtXBJ8vEnTsbGfrj3CqnkA90kOnl+zbA+3EJOSSbd1/s2nCE0jnpPtI2Iml
ioSLfx4qxvFhU7xIr/TWU5jj35jrEF+e/WOAYw8r/jWWzjIulktCBuLOUwPfCDMx
NO4ss2qDD/k=
=X3v2
-----END PGP SIGNATURE-----

--Sig_/8nJphjyknRJWFg+BQVUBT6g--
