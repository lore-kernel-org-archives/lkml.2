Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab1CRPMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:12:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47157 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752724Ab1CRPMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:12:14 -0400
Date: Fri, 18 Mar 2011 15:12:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <Waldemar.Rymarkiewicz@tieto.com>
Cc: <linux-i2c@vger.kernel.org>, <arnd@arndb.de>, <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hthebaud@insidefr.com>,
        <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Message-ID: <20110318151219.7aedc765@lxorguk.ukuu.org.uk>
In-Reply-To: <99B09243E1A5DA4898CDD8B7001114481085881963@EXMB04.eu.tieto.com>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
	<1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
	<20110318110348.728f6036@lxorguk.ukuu.org.uk>
	<99B09243E1A5DA4898CDD8B7001114481085881963@EXMB04.eu.tieto.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Would it not be lighter to use atomic bit ops ?
> 
> Do you mean  in order to remove rx_mutex? 
> 
> mutex_lock(&info->rx_mutex);
> atomic_set(info->irq_state ,1);
> mutex_unlock(&info->rx_mutex);
> 
> looks a bit strange. I still need the rx_mutex to protect irq_state while reading i2c.
> 
> 	mutex_lock(&info->rx_mutex);
> 	ret = i2c_master_recv(client, info->buf, info->buflen);
> 	info->irq_state = 0;
> 	mutex_unlock(&info->rx_mutex);
> 

I was thinking clear_bit/test_and_set_bit rather than atomic_t operations.

ie in the IRQ

	clear_bit(0, &info->irq_state);


in the main path

	if (test_and_set_bit(0, &info->state))
		i2c_master_recv(...)

but if the mutex is needed anyway it doesn't help make the code saner.
