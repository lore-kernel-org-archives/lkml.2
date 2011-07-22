Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1GVKso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 06:48:44 -0400
Received: from smtp.nokia.com ([147.243.1.48]:36406 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab1GVKsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:48:42 -0400
Subject: RE: [RFC PATCHv5 1/7] HSI: hsi: Introducing HSI framework
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: "sjurbren@gmail.com" <sjurbren@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <81C3A93C17462B4BBD7E272753C105791A64C2735E@EXDCVYMBSTM005.EQ1STM.local>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	 <1308769914-15440-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1308834524.27256.3247.camel@groo>
	 <81C3A93C17462B4BBD7E272753C105791A64C2735E@EXDCVYMBSTM005.EQ1STM.local>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 13:43:36 +0300
Message-ID: <1311331416.32639.34.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

Sorry for the long delay. My comments below:

On Tue, 2011-06-28 at 15:05 +0200, ext Sjur BRENDELAND wrote:
-- cut--
> > 
> > > Will multiple read queued operations result in chained DMA
> > operations, or single read operations?
> > >
> > 
> > Well, it is up to you, but my initial idea is that the complete 
> > callback is called right after the request has been fulfilled. This 
> > may be not possible if you chain several read requests.
> 
> I think our concern is to squeeze every bit of bandwidth out of the link.
> Perhaps we can utilize bandwidth better by chaining the DMA jobs.
> But due to latency we need the complete callback for each DMA job.
> If the DMA cannot handle this, the HSI controller should handle the queuing
> of IO requests.
> 

Exactly.

> > > ...
> > > >+/**
> > > >+ * hsi_flush - Flush all pending transactions on the client's port
> > > >+ * @cl: Pointer to the HSI client
> > > >+ *
> > > >+ * This function will destroy all pending hsi_msg in the port and
> > reset
> > > >+ * the HW port so it is ready to receive and transmit from a clean
> > state.
> > > >+ *
> > > >+ * Return -errno on failure, 0 on success  */ static inline int 
> > > >+hsi_flush(struct hsi_client *cl) {
> > > >+	if (!hsi_port_claimed(cl))
> > > >+		return -EACCES;
> > > >+	return hsi_get_port(cl)->flush(cl); }
> > >
> > > For CAIF we need to have independent RX and TX flush operations.
> > >
> > 
> > The current framework assumes that in the unlikely case of an error or 
> > whenever you need to to do some cleanup, you will end up cleaning up 
> > the two sides anyway. Moreover, you will reset the state of the HW 
> > also.
> > 
> > Exactly, in which case CAIF will only need to cleanup the TX path but 
> > not the RX or vice versa ?
> > 
> > > Flushing the TX FIFO can be long duration operation due to HSI flow
> > control,
> > > if counterpart is not receiving data. I would prefer to see a
> > callback here.
> > >
> > 
> > No, flush should not wait for an ongoing TX transfer to finish. You 
> > should stop all ongoing transfers, call the destructor callback on all 
> > the requests (queued and ongoing) and clean up the HW state.
> ...
> > > *Missing function*: hsi_reset()
> > > I would also like to see a hsi_reset function.
> > 
> > This is currently done also in the hsi_flush. See my previous comment.
> 
> Sorry, I misunderstood your API description here. hsi_flush() seems to work
> like the hsi_reset I was looking for. I would prefer if you rename this
> function to hsi_reset for clarity (see flush_work() in workqueue.c, where
> flush wait for the work to finish).
> 
> Anyway, I still see a need for ensuring fifos are empty or reading the
> number of bytes in the fifos.
> 
> CAIF is using the wake lines for controlling when the Modem and Host can
> power down the HSI blocks. In order to go to low power mode, the Host set
> AC_WAKE low, and wait for modem to respond by setting CA_WAKE low. The host
> cannot set AC_WAKE high again before modem has done CA_WAKE low (in order
> to avoid races).
> 
> When going up from low power anyone could set the WAKE line high, and wait for
> the other side to respond by setting WAKE line high.
> 
> So CAIF implements the following protocol for handshaking before going to
> low-power mode:
> 1. Inactivity timeout expires on Host, i.e the host has nothing to send and no
>    RX has happened the last couple of seconds.
> 2. Host request low-power state by setting AC_WAKE low. In this state Host
>    side can still receive data, but is not allowed to send data.
> 3. Modem responds with setting CA_WAKE low, and cannot send data either.
> 4. When both AC_WAKE and CA_WAKE are low, the host must set AC_FLAG, AC_DATA
>    and AC_READY low.
> 5. When Host side RX-fifo is empty and DMA jobs are completed,
>    ongoing RX requests are cancelled.
> 6. HSI block can be powered down.
>  
> After AC_WAKE is set low the Host must guarantee that the modem does not receive
> data until AC_WAKE is high again. This implies that the Host must know that the
> TX FIFO is empty before setting the AC_WAKE low. So we need some way to know that
> the TX fifo is empty.
> 
> I think the cleanest design here is that hsi_stop_tx() handles this.
> So his_stop_tx() should wait for any pending TX jobs and wait for the TX
> FIFO to be empty, and then set the AC_WAKE low. 

Hmmm, I don't like this.  My initial idea is that you could call this
functions on interrupt context. This will prevent this. However, nothing
prevents you from schedule a delayed work, which will be in charge of
checking that the last frame has gone through the wire and then bring
down the AC_WAKE line.

> 
> As described above, when going down to low power mode the host has set AC_WAKE low.
> The Host should then set AC_FLAG, AC_DATA and AC_READY low.
> 
> >...I think also the
> >workaround of setting the DATA and FLAG lines low can be implemented
> >just in the hsi_controller without hsi_client intervention. 
> 
> Great :-) Perhaps a function hsi_stop_rx()?

No need for a new function. The hsi_controller driver knows when it goes
to "low power mode" so it can set the DATA and FLAG lines down just righ
before that.

> 
> > > *Missing function*: hsi_rx_fifo_occupancy()
> > > Before putting the link asleep we need to know if the fifo is empty
> > > or not.
> > > So we would like to have a way to read out the number of bytes in the
> > > RX fifo.
> > 
> > This should be handled only by hsi_controller. Clients should not care
> > about this.
> 
> There is a corner case when going to low power mode and both side has put the WAKE line low,
> but a RX DMA job is ongoing or the RX-fifo is not empty.
> In this case the host side must wait for the DMA job to complete and RX-
> fifo to be empty, before canceling any pending RX jobs. 
> 
> One option would be to provide a function hsi_rx_sync() that guarantees that any ongoing
> RX-job is completed and that the RX FIFO is empty. Another option could be to be
> able to provide API for reading RX-job states and RX-fifo occupancy.
> 

I think we don't need another function to do this neither. The
hsi_controller driver should implement a usecount scheme to know when
the HW can be switch off. IMO it is not a good idea to relay just on the
wakelines to power on/off the device, exactly because of this kind of
issues.

Br,
-- 
Carlos Chinea <carlos.chinea@nokia.com>

