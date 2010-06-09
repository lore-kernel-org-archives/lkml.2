Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab0FILfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:35:20 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:10083
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754475Ab0FILfT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:35:19 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz542N1432P1764mzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
From: "Vijay R. Iyengar" <Vijay.Iyengar@kpitcummins.com>
To: "jic23@hermes.cam.ac.uk" <jic23@hermes.cam.ac.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       David Dajun Chen <Dajun.Chen@diasemi.com>,
       "Ashish P. Chavan" <Ashish.Chavan@kpitcummins.com>,
       Nitin Shah <Nitin.Shah@kpitcummins.com>
Date: Wed, 9 Jun 2010 17:04:09 +0530
Subject: RE: [PATCH] MFD of DA9052 Linux device drivers (1/9)
Thread-Topic: [PATCH] MFD of DA9052 Linux device drivers (1/9)
Thread-Index: Acr3RQBKTizuIaHYSaOHcfDBCBcDIwAAXE3QAAD3OuAEHw2nsA==
Message-ID: <371569CBCFB2E745B891DBB88B2DFDDD19CAEABB32@KCINPUNHJCMS01.kpit.com>
In-Reply-To: <F56EA673D3E56E48804FE2B0D23EFD2D217420461E@KCINPUNHJCMS01.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Reverse-DNS: Kcinpunhjhc01.kpit.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> -----Original Message-----
> From: J.I. Cameron [mailto:jic23@hermes.cam.ac.uk] On Behalf 
> Of Jonathan
> Cameron
> Sent: 19 May 2010 12:22
> To: David Dajun Chen
> Cc: linux-kernel@vger.kernel.org; sameo@linux.intel.com
> Subject: Re: [PATCH] MFD of DA9052 Linux device drivers (1/9)
> 
> Hi David,
> 
> Below is an initial review. Please take a look at more code 
> for similar
> drivers
> in the various subsystems as it will give you an idea how how much of
> this should
> be done.
> 
> I've run out of time, so I'm afraid I didn't get quite to the 
> bottom of
> this patch.
> Still plenty of stuff still to do in the bit I did look at!
> 
> Jonathan
> > +
> > +/**
> > + * da9052_eh_unregister_nb:	Function to de-register 
> a notifier block
> > + *
> > + * Caller must not pass any non-existing notifier block or 
> notifiler
> block
> > + * that has already been de-registered. Its caller's responsibility
> to 
> > + * allocate/deallocate memory associated with notifier 
> block. EH will
> only 
> > + * Link/De-Link passed notifier blocks.
> > + *
> > + * @param nb	: Notifier block to unregister
> > + * @return s32	: Status of unregistration
> > + */
> > +s32 da9052_eh_unregister_nb(da9052_eh_nb* nb){
> > +	
> > +	if(nb == NULL)
> > +		return (INVALID_NB);
> > +	
> > +	DA9052_DEBUG("%s() called for event %d \n", __FUNCTION__,
> nb->eve_type);
> > +	
> > +	/* Acqurie nb array lock */
> > +	if(down_interruptible(&eh_info.eve_nb_array_lock))
> > +		return (FAILURE);
> > +	
> > +	/* Remove passed NB from list */
> > +	list_del_init(&(nb->nb_list));
> > +	
> > +	/* Release NB array lock */
> > +	up(&eh_info.eve_nb_array_lock);
> > +	
> > +	return (SUCCESS);
> > +}
> > +
> 
> These are looking pretyt touch screen specific.  What are 
> they doing in
> this patch?

We have designed the EH (interrupt handler driver) and the TSI (touch screen driver) in a manner that the EH reads raw co-ordinates from the touch control registers of the DA9052 hardware in response to sampling ready interrupt requests and stores them in a FIFO for TSI further processing.

We are implementing a common Event handler module for processing all the interrupt events from the DA9052 devices like battery, regulator, RTC etc. Fetching the TSI samples on touch events by EH rather than notifying the TSI driver through a call-back routine helps us to get a good amount of filtered touch samples from the TSI driver. 

Hence we intend to keep the TSI raw co-ordinate reading in the event handling module, which is a part of the MFD driver.

> > +/**
> > + * da9052_tsi_start_sampling:	Called by TSI driver to indicate
> start of data
> > + * sampling
> > + * @param void
> > + * @return int status
> > + */
> > +s32 da9052_tsi_start_sampling(void){
> > +	
> > +	/* This request is only valid when we are waiting for one */
> > +	if(tsi_info.tsi_state == WAIT_FOR_SAMPLING){
> > +		DA9052_DEBUG("__%s__ \n", __FUNCTION__);
> > +		tsi_info.tsi_state =  SAMPLING_ACTIVE;
> > +		return (SUCCESS);
> > +	}
> > +	else{
> > +		DA9052_DEBUG("Invalid request for
> da9052_tsi_start_sampling() \n");
> > +		return (FAILURE);
> > +	}	
> > +}
> > +
> > +/**
> > + * da9052_tsi_stop_sampling:	Called by TSI driver to 
> indicate end of
> data
> > + * sampling
> > + * @param void
> > + * @return int status
> > + */
> > +s32 da9052_tsi_stop_sampling(void){
> > +	
> > +	/* Irrespective of current state, move to initial state */
> > +	DA9052_DEBUG("__%s__ \n", __FUNCTION__);
> > +	tsi_info.tsi_state =  WAIT_FOR_PEN_DOWN;
> > +
> > +	return (SUCCESS);
> > +}

