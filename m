Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0HPP2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:28:38 -0400
Received: from mxout1.idt.com ([157.165.5.25]:49521 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab0HPP2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:28:37 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/9] RapidIO,  powerpc/85xx: modify RIO port-write interrupt handler
Date: Mon, 16 Aug 2010 08:27:34 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5F94@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C692B42.9050407@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 2/9] RapidIO,  powerpc/85xx: modify RIO port-write interrupt handler
thread-index: Acs9PU4SRQWtVnvwRDazECB2xQXaLwAF7eWA
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-3-git-send-email-alexandre.bounine@idt.com> <4C692B42.9050407@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>,
        "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> 
> Alexandre Bounine wrote:
> > - Rearranged RIO port-write interrupt handling to perform message
buffering
> > as soon as possible.
> 
> I don't understand this comment: you still schedule work to read the
> port-write queue; so how is this message buffering performed as soon
as
> possible?


Compared to the original code, I rearranged order of checking interrupt
status bits to check the queue status first. The 85xx PW controller is
capable to receive and keep only one PW message. Therefore, I copy it
into the driver's FIFO and re-enable HW Rx queue (it is called queue but
can accept only one entry) ASAP. I have a test setup that is capable
generate multiple PW messages and see many messages discarded by PW
controller
because of this single-entry HW queue.
 
> 
> > - Modified to disable port-write controller when clearing
Transaction Error (TE)
> > bit.
> >  	/* Schedule deferred processing if PW was received */
> > -	if (ipwsr & RIO_IPWSR_QFI) {
> > +	if ((ipwmr & RIO_IPWMR_QFIE) && (ipwsr & RIO_IPWSR_QFI)) {
> 
> Why check the QFIE bit also?

Oops! Leftover from some testing. Will clean it up.

> 
> > +pw_done:
> > +	if (epwisr & 0x80000000) {
> 
> Magic value.


Agree. Will correct.


