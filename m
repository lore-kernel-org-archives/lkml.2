Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab1COVOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:14:42 -0400
Received: from ist.d-labs.de ([213.239.218.44]:59740 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab1COVOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:14:40 -0400
Date: Tue, 15 Mar 2011 22:14:34 +0100
From: Florian Mickler <florian@mickler.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: oliver@neukum.org, jwjstone@fastmail.fm, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, Patrick Boettcher <pboettcher@dibcom.fr>
Subject: Re: [PATCH 01/16] [media] dib0700: get rid of on-stack dma buffers
Message-ID: <20110315221434.7b0dc2a8@schatten.dmk.lab>
In-Reply-To: <4D7F5538.6080907@infradead.org>
References: <20110315093632.5fc9fb77@schatten.dmk.lab>
	<1300178655-24832-1-git-send-email-florian@mickler.org>
	<4D7F5538.6080907@infradead.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 09:02:00 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
> You're allocating a buffer for URB control messages. IMO, this is a good idea, as
> this way, allocating/freeing on each urb call is avoided. However, on most places,
> you're not using it. The better would be to just use this buffer on all
> the above places.
> 
> You should just take care of protecting such buffer with a mutex, to avoid concurrency.
> Such kind of protection is generally ok, as dvb applications generally serialize
> the calls anyway.
> 

I didn't do so already, because I had/have no overview over the big
picture operation of the dvb framework and thus feared to introduce
deadlocks or massive serializations where concurrency is needed. But if
you suggest it, I guess it should be benign. I'm wondering about the
purpose of the usb_mutex and the i2c_mutex ... 

Should I introduce new driver specific mutexes to protect the buffer or
is it possible to reuse one of the 2? 

vp702x_usb_inout_op takes the usb_mutex, 
but vp702x_usb_out_op and vp702x_usb_in_op get called without that
mutex hold. That makes me wonder what that mutex purpose is in that
driver?

Other drivers like the az6027 introduce a driver specific mutex and
also use the usb_mutex. That make conceptually (to my inexperienced
mind) more sense. (each layer does it's own locking) but the idea of
operation is not yet clear in my mind...

Can you perhaps shed some light on what the purpose of those locks is
and if it is sufficient to use the usb_mutex to serialize all
usb_control_msg calls (which would probably protect the buffer
sufficiently but may be too much if the dvb-usb framework uses that
mutex for different purposes). 

In the meantime I will respin this series using preallocated buffers and
will hopefully work out stuff that is unclear to me yet ...

Regards,
Flo


