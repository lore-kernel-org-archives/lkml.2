Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1GVLBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 07:01:08 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:46747 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917Ab1GVLBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 07:01:06 -0400
Date: Fri, 22 Jul 2011 14:01:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: ext Sjur BRENDELAND <sjur.brandeland@stericsson.com>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCHv5 1/7] HSI: hsi: Introducing HSI framework
Message-ID: <20110722110102.GR32058@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
 <1308769914-15440-1-git-send-email-sjur.brandeland@stericsson.com>
 <1308834524.27256.3247.camel@groo>
 <81C3A93C17462B4BBD7E272753C105791A64C2735E@EXDCVYMBSTM005.EQ1STM.local>
 <1311331416.32639.34.camel@groo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5xr6Gr0irOxp3+3c"
Content-Disposition: inline
In-Reply-To: <1311331416.32639.34.camel@groo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5xr6Gr0irOxp3+3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 22, 2011 at 01:43:36PM +0300, Carlos Chinea wrote:
> > > > >+/**
> > > > >+ * hsi_flush - Flush all pending transactions on the client's port
> > > > >+ * @cl: Pointer to the HSI client
> > > > >+ *
> > > > >+ * This function will destroy all pending hsi_msg in the port and
> > > reset
> > > > >+ * the HW port so it is ready to receive and transmit from a clean
> > > state.
> > > > >+ *
> > > > >+ * Return -errno on failure, 0 on success  */ static inline int=
=20
> > > > >+hsi_flush(struct hsi_client *cl) {
> > > > >+	if (!hsi_port_claimed(cl))
> > > > >+		return -EACCES;
> > > > >+	return hsi_get_port(cl)->flush(cl); }
> > > >
> > > > For CAIF we need to have independent RX and TX flush operations.
> > > >
> > >=20
> > > The current framework assumes that in the unlikely case of an error o=
r=20
> > > whenever you need to to do some cleanup, you will end up cleaning up=
=20
> > > the two sides anyway. Moreover, you will reset the state of the HW=20
> > > also.
> > >=20
> > > Exactly, in which case CAIF will only need to cleanup the TX path but=
=20
> > > not the RX or vice versa ?
> > >=20
> > > > Flushing the TX FIFO can be long duration operation due to HSI flow
> > > control,
> > > > if counterpart is not receiving data. I would prefer to see a
> > > callback here.
> > > >
> > >=20
> > > No, flush should not wait for an ongoing TX transfer to finish. You=
=20
> > > should stop all ongoing transfers, call the destructor callback on al=
l=20
> > > the requests (queued and ongoing) and clean up the HW state.
> > ...
> > > > *Missing function*: hsi_reset()
> > > > I would also like to see a hsi_reset function.
> > >=20
> > > This is currently done also in the hsi_flush. See my previous comment.
> >=20
> > Sorry, I misunderstood your API description here. hsi_flush() seems to =
work
> > like the hsi_reset I was looking for. I would prefer if you rename this
> > function to hsi_reset for clarity (see flush_work() in workqueue.c, whe=
re
> > flush wait for the work to finish).
> >=20
> > Anyway, I still see a need for ensuring fifos are empty or reading the
> > number of bytes in the fifos.
> >=20
> > CAIF is using the wake lines for controlling when the Modem and Host can
> > power down the HSI blocks. In order to go to low power mode, the Host s=
et
> > AC_WAKE low, and wait for modem to respond by setting CA_WAKE low. The =
host
> > cannot set AC_WAKE high again before modem has done CA_WAKE low (in ord=
er
> > to avoid races).
> >=20
> > When going up from low power anyone could set the WAKE line high, and w=
ait for
> > the other side to respond by setting WAKE line high.
> >=20
> > So CAIF implements the following protocol for handshaking before going =
to
> > low-power mode:
> > 1. Inactivity timeout expires on Host, i.e the host has nothing to send=
 and no
> >    RX has happened the last couple of seconds.
> > 2. Host request low-power state by setting AC_WAKE low. In this state H=
ost
> >    side can still receive data, but is not allowed to send data.
> > 3. Modem responds with setting CA_WAKE low, and cannot send data either.
> > 4. When both AC_WAKE and CA_WAKE are low, the host must set AC_FLAG, AC=
_DATA
> >    and AC_READY low.
> > 5. When Host side RX-fifo is empty and DMA jobs are completed,
> >    ongoing RX requests are cancelled.
> > 6. HSI block can be powered down.
> > =20
> > After AC_WAKE is set low the Host must guarantee that the modem does no=
t receive
> > data until AC_WAKE is high again. This implies that the Host must know =
that the
> > TX FIFO is empty before setting the AC_WAKE low. So we need some way to=
 know that
> > the TX fifo is empty.
> >=20
> > I think the cleanest design here is that hsi_stop_tx() handles this.
> > So his_stop_tx() should wait for any pending TX jobs and wait for the TX
> > FIFO to be empty, and then set the AC_WAKE low.=20
>=20
> Hmmm, I don't like this.  My initial idea is that you could call this
> functions on interrupt context. This will prevent this. However, nothing
> prevents you from schedule a delayed work, which will be in charge of
> checking that the last frame has gone through the wire and then bring
> down the AC_WAKE line.

why don't you use threaded IRQ ? It's higher priority than a delayed
work and you would be able to use something like
wait_for_completion_timeout() to wait for TX FIFOs to become empty (??)

> > As described above, when going down to low power mode the host has set =
AC_WAKE low.
> > The Host should then set AC_FLAG, AC_DATA and AC_READY low.

but, if I read correctly, only when TX FIFO is known to be empty, right?

> > >...I think also the
> > >workaround of setting the DATA and FLAG lines low can be implemented
> > >just in the hsi_controller without hsi_client intervention.=20
> >=20
> > Great :-) Perhaps a function hsi_stop_rx()?
>=20
> No need for a new function. The hsi_controller driver knows when it goes
> to "low power mode" so it can set the DATA and FLAG lines down just righ
> before that.

are you already using pm_runtime ? You could put that logic grouped in
runtime_suspend()/runtime_resume() calls and from the driver, just call
pm_runtime_put()/pm_runtime_get_sync() whenever you want to
suspend/resume.

> > > > *Missing function*: hsi_rx_fifo_occupancy()
> > > > Before putting the link asleep we need to know if the fifo is empty
> > > > or not.
> > > > So we would like to have a way to read out the number of bytes in t=
he
> > > > RX fifo.
> > >=20
> > > This should be handled only by hsi_controller. Clients should not care
> > > about this.
> >=20
> > There is a corner case when going to low power mode and both side has p=
ut the WAKE line low,
> > but a RX DMA job is ongoing or the RX-fifo is not empty.
> > In this case the host side must wait for the DMA job to complete and RX-
> > fifo to be empty, before canceling any pending RX jobs.=20
> >=20
> > One option would be to provide a function hsi_rx_sync() that guarantees=
 that any ongoing
> > RX-job is completed and that the RX FIFO is empty. Another option could=
 be to be
> > able to provide API for reading RX-job states and RX-fifo occupancy.
> >=20
>=20
> I think we don't need another function to do this neither. The
> hsi_controller driver should implement a usecount scheme to know when
> the HW can be switch off. IMO it is not a good idea to relay just on the
> wakelines to power on/off the device, exactly because of this kind of
> issues.

true, but I'm not sure a usecount is a good way to go. Why don't you
just remove the sync API altogether and use only async, then the OMAP
HSI controller driver is supposed to know when it can go to sleep. If
you receive some data before a client queues a request, you just defer
processing of that data until a new request is queued, or something...

--=20
balbi

--5xr6Gr0irOxp3+3c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOKVhuAAoJEAv8Txj19kN1Pj8H/2WOCzdKKbGHIf8D3muwwudG
5M4G27g/jrcIbm4EjT6ZK8hliM9qPJUkukTyAspahNlVlkaZelkyWQZkolYRMjfq
678IbNY8ruC6LSmeRWrJn/i7i/VLrUJxgbXx0loG6kZFslnagFgrdoc395s7qtp6
/hsZU9htFKKL1aDhu7GFPnjML75ZPtOO8ZRs9mddAGfMm6D1chBiR7z7f/gaRI9f
/KDGbBmpgNI5oZJAFdYzjRQNNgJn6GoTw2hlnXd8EC6hDVn+JL2hIYC4QBIyr6a2
3kTqQZWynBGjy3HyUjuGll98m9ed2clOdJ8Yp1dXjQNq5kMhd2f7cFdbMAC4lyk=
=bfTX
-----END PGP SIGNATURE-----

--5xr6Gr0irOxp3+3c--
